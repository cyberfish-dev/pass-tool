import { useState, useEffect } from "react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Card, CardContent } from "@/components/ui/card";
import { Copy, Lock, Unlock, Trash2, LucideVault } from "lucide-react";

async function encryptData(data: string, password: string): Promise<{ iv: string; data: string }> {
  const enc = new TextEncoder();
  const salt = crypto.getRandomValues(new Uint8Array(16));
  const iv = crypto.getRandomValues(new Uint8Array(12));

  const keyMaterial = await getKeyMaterial(password);
  const key = await deriveKey(keyMaterial, salt);

  const encoded = enc.encode(data);
  const cipherText = await crypto.subtle.encrypt(
    { name: "AES-GCM", iv },
    key,
    encoded
  );

  return {
    iv: btoa(String.fromCharCode(...iv)),
    data: btoa(String.fromCharCode(...salt, ...new Uint8Array(cipherText))),
  };
}

async function decryptData(encrypted: { iv: string; data: string }, password: string): Promise<string> {
  const dec = new TextDecoder();
  const iv = Uint8Array.from(atob(encrypted.iv), c => c.charCodeAt(0));
  const combined = Uint8Array.from(atob(encrypted.data), c => c.charCodeAt(0));
  const salt = combined.slice(0, 16);
  const data = combined.slice(16);

  const keyMaterial = await getKeyMaterial(password);
  const key = await deriveKey(keyMaterial, salt);

  const plainBuffer = await crypto.subtle.decrypt(
    { name: "AES-GCM", iv },
    key,
    data
  );

  return dec.decode(plainBuffer);
}

async function getKeyMaterial(password: string) {
  const enc = new TextEncoder();
  return crypto.subtle.importKey(
    "raw",
    enc.encode(password),
    { name: "PBKDF2" },
    false,
    ["deriveKey"]
  );
}

async function deriveKey(keyMaterial: CryptoKey, salt: Uint8Array) {
  return crypto.subtle.deriveKey(
    {
      name: "PBKDF2",
      salt,
      iterations: 100000,
      hash: "SHA-256",
    },
    keyMaterial,
    { name: "AES-GCM", length: 256 },
    false,
    ["encrypt", "decrypt"]
  );
}

export default function VaultView() {
  const [showPassword, setShowPassword] = useState(false);
  const [vault, setVault] = useState({});
  const [master, setMaster] = useState("");
  const [confirmMaster, setConfirmMaster] = useState("");
  const [isVaultPresent, setIsVaultPresent] = useState(() => {
    if (typeof window !== 'undefined') {
      return !!localStorage.getItem("vault");
    }
    return false;
  });
  const [isCreatingVault, setIsCreatingVault] = useState(!isVaultPresent);
  const [vaultUnlocked, setVaultUnlocked] = useState(false);
  const [vaultError, setVaultError] = useState("");
  const [source, setSource] = useState("");
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [notes, setNotes] = useState("");
  const [search, setSearch] = useState("");

  const createVault = async () => {
    if (master !== confirmMaster) return setVaultError("Passwords do not match");
    const encrypted = await encryptData(JSON.stringify({}), master);
    localStorage.setItem("vault", JSON.stringify(encrypted));
    setVault({});
    setVaultUnlocked(true);
    setIsVaultPresent(true);
    setVaultError("");
  };

  const unlockVault = async () => {
    const data = localStorage.getItem("vault");
    if (!data) return;
    try {
      const decrypted = await decryptData(JSON.parse(data), master);
      setVault(JSON.parse(decrypted));
      setVaultUnlocked(true);
      setVaultError("");
    } catch (err) {
      setVaultError("Invalid master password");
    }
  };

  const exportVault = () => {
    const blob = new Blob([JSON.stringify(vault, null, 2)], { type: "application/json" });
    const url = URL.createObjectURL(blob);
    const a = document.createElement("a");
    a.href = url;
    a.download = "vault.json";
    a.click();
    URL.revokeObjectURL(url);
  };

  const importVault = (event: React.ChangeEvent<HTMLInputElement>) => {
    const file = event.target.files?.[0];
    if (!file) return;
    const reader = new FileReader();
    reader.onload = async (e) => {
      try {
        const content = e.target?.result as string;
        const parsed = JSON.parse(content);
        const decrypted = await decryptData(parsed, master);
        setVault(JSON.parse(decrypted));
        setVaultUnlocked(true);
        setVaultError("");
      } catch (err) {
        setVaultError("Failed to import vault");
      }
    };
    reader.readAsText(file);
  };

  const addPasswordRecord = async () => {
    if (!source || !username || !password) return;
    const newVault = {
      ...vault,
      [source]: { username, password, notes }
    };
    setVault(newVault);
    const encrypted = await encryptData(JSON.stringify(newVault), master);
    localStorage.setItem("vault", JSON.stringify(encrypted));
    setSource("");
    setUsername("");
    setPassword("");
    setNotes("");
  };

  const deleteRecord = async (key: string) => {
    const { [key]: _, ...rest } = vault;
    setVault(rest);
    const encrypted = await encryptData(JSON.stringify(rest), master);
    localStorage.setItem("vault", JSON.stringify(encrypted));
  };

  const deleteVault = () => {
    localStorage.removeItem("vault");
    setVault({});
    setVaultUnlocked(false);
    setIsVaultPresent(false);
    setMaster("");
    setConfirmMaster("");
  };

  const filteredVault = Object.entries(vault).filter(([key]) =>
    key.toLowerCase().includes(search.toLowerCase())
  );

  const handleCopyText = (text: string) => {
    if (navigator.clipboard) navigator.clipboard.writeText(text);
  };

  useEffect(() => {
    const saveVault = async () => {
      if (vaultUnlocked && master && Object.keys(vault).length > 0) {
        const encrypted = await encryptData(JSON.stringify(vault), master);
        localStorage.setItem("vault", JSON.stringify(encrypted));
      }
    };
    saveVault();
  }, [vault, vaultUnlocked, master]);

  return (
    <Card className="rounded-2xl shadow-md">
      <CardContent className="space-y-4 p-6">
        <div className="flex items-center justify-between">
          <h2 className="text-2xl font-bold"><LucideVault></LucideVault></h2>
          {isVaultPresent && (
            vaultUnlocked ? <Unlock className="text-green-500" /> : <Lock className="text-red-500" />
          )}
        </div>

        <div className="col-span-2">
            <hr className="border-t my-2" />
          </div>

        {!vaultUnlocked ? (
          <>
            <Input type="password" placeholder="Master Password" value={master} onChange={(e) => setMaster(e.target.value)} />
            {isCreatingVault && (
              <Input type="password" placeholder="Confirm Password" value={confirmMaster} onChange={(e) => setConfirmMaster(e.target.value)} />
            )}
            {vaultError && <p className="text-sm text-red-500">{vaultError}</p>}
            <Button onClick={isCreatingVault ? createVault : unlockVault}>{isCreatingVault ? "Create Vault" : "Unlock Vault"}</Button>
          </>
        ) : (
          <>
            <div className="grid grid-cols-2 gap-2">
              <Input placeholder="Source" value={source} onChange={(e) => setSource(e.target.value)} required />
              <Input placeholder="Username" value={username} onChange={(e) => setUsername(e.target.value)} required />
              <div className="relative w-full">
                <Input
                  type={showPassword ? 'text' : 'password'}
                  placeholder="Password"
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  required
                  className="pr-10"
                />
                <button
                  type="button"
                  className="absolute right-2 top-1/2 -translate-y-1/2 text-sm text-gray-500"
                  onClick={() => setShowPassword(!showPassword)}
                >
                  {showPassword ? '🙈' : '👁️'}
                </button>
              </div>
              <Input placeholder="Notes (optional)" value={notes} onChange={(e) => setNotes(e.target.value)} />
            </div>
            <div className="flex flex-wrap gap-2">
              <Button onClick={addPasswordRecord}>Add</Button>
              <Button onClick={exportVault}>Download Vault</Button>
              <Input type="file" onChange={importVault} className="flex-1" />
              <Button variant="destructive" onClick={deleteVault}>Delete Vault</Button>
            </div>
            <Input placeholder="Search by source..." value={search} onChange={(e) => setSearch(e.target.value)} />
            <div className="grid gap-4">
              {filteredVault.map(([key, entry]: [string, any]) => (
                <div key={key} className="bg-gray-100 dark:bg-gray-900 rounded-xl p-4 shadow">
                  <div className="mb-2 flex items-center justify-between text-sm font-semibold">
                    <span>🔑 Source: {key}</span>
                    <button
                      type="button"
                      onClick={() => deleteRecord(key)}
                      title="Delete Record"
                      className="text-red-500 hover:text-red-700"
                    >
                      <Trash2 className="w-4 h-4" />
                    </button>
                  </div>
                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-2 mb-2">
                    <div className="relative">
                      <Input readOnly value={key} className="opacity-60" />
                    </div>
                    <div className="relative">
                      <Input readOnly value={entry.notes || ""} className="opacity-60" />
                    </div>
                  </div>
                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-2">
                    <div className="relative">
                      <Input readOnly value={entry.username} className="pr-10" />
                      <button
                        type="button"
                        title="Copy Username"
                        onClick={() => handleCopyText(entry.username)}
                        className="absolute right-2 top-1/2 -translate-y-1/2 text-xs"
                      >
                        <Copy className="w-4 h-4" />
                      </button>
                    </div>
                    <div className="relative">
                      <Input readOnly value={entry.password} className="pr-10" />
                      <button
                        type="button"
                        title="Copy Password"
                        onClick={() => handleCopyText(entry.password)}
                        className="absolute right-2 top-1/2 -translate-y-1/2 text-xs"
                      >
                        <Copy className="w-4 h-4" />
                      </button>
                    </div>
                  </div>
                </div>
              ))}
            </div>
          </>
        )}
      </CardContent>
    </Card>
  );
}
