import { useState, useEffect } from "react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Card, CardContent } from "@/components/ui/card";
import { Copy, LockKeyhole, Trash2, LucideVault, UnlockKeyhole, Download, Eye, EyeClosed, RotateCcw, ListRestart, KeySquare, KeyRound, Trash, Check, Search } from "lucide-react";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import { ConfirmDialog } from "@/components/ui/confirmDialog";

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

  const combined = new Uint8Array(salt.length + cipherText.byteLength);
  combined.set(salt);
  combined.set(new Uint8Array(cipherText), salt.length);

  return {
    iv: uint8ArrayToBase64(iv),
    data: uint8ArrayToBase64(combined),
  };
}

function uint8ArrayToBase64(arr: Uint8Array) {
  return btoa(String.fromCharCode(...arr));
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
  const [showPassword, setShowPassword] = useState(true);
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

  const [addError, setAddError] = useState('');

  const [defaultUsername, setDefaultUsername] = useState(() => {

    const saved = localStorage.getItem("defUsername");
    return saved ?? '';
  });

  const [length, setLength] = useState(() => {

    const saved = localStorage.getItem("passwordSettings");
    return saved ? JSON.parse(saved).length ?? 22 : 22;
  });

  const [includeNumbers, setIncludeNumbers] = useState(() => {

    const saved = localStorage.getItem("passwordSettings");
    return saved ? JSON.parse(saved).includeNumbers ?? true : true;
  });

  const [includeSymbols, setIncludeSymbols] = useState(() => {

    const saved = localStorage.getItem("passwordSettings");
    return saved ? JSON.parse(saved).includeSymbols ?? true : true;
  });

  const [customSymbols, setCustomSymbols] = useState(() => {

    const customSymbols = '!\";#$%&\'()*+,-./:;<=>?@[]^_`{|}~';

    const saved = localStorage.getItem("passwordSettings");
    return saved ? JSON.parse(saved).customSymbols ?? customSymbols : customSymbols;
  });

  const [includeUppercase, setIncludeUppercase] = useState(() => {

    const saved = localStorage.getItem("passwordSettings");
    return saved ? JSON.parse(saved).includeUppercase ?? true : true;
  });

  const generatePassword = (length, includeNumbers, includeSymbols, includeUppercase, customSymbols) => {
    let charset = "abcdefghijklmnopqrstuvwxyz";
    if (includeUppercase) charset += "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    if (includeNumbers) charset += "0123456789";
    if (includeSymbols) charset += customSymbols;

    let password = "";
    for (let i = 0; i < length; i++) {
      const randomIndex = Math.floor(Math.random() * charset.length);
      password += charset[randomIndex];
    }
    return password;
  };


  const [visibleMap, setVisibleMap] = useState({});

  const [copiedIndex, setCopiedIndex] = useState(null);
  const [source, setSource] = useState("");
  const [username, setUsername] = useState(defaultUsername);
  const [password, setPassword] = useState(generatePassword(length, includeNumbers, includeSymbols, includeUppercase, customSymbols));
  const [notes, setNotes] = useState("");
  const [search, setSearch] = useState("");

  const PASSWORD_REGEXP =
    /^(?=.*[0-9])(?=.*[!@#$%^&*])[a-zA-Z0-9!@#$%^&*]{6,30}$/;

  const createVault = async () => {
    if (master !== confirmMaster) return setVaultError("Passwords do not match");

    const isValid = PASSWORD_REGEXP.test(master);
    if (!isValid) return setVaultError("Password should be more than 6, less than 30 chars, include a digit and one special character ! @ # $ % ^ & *");

    const encrypted = await encryptData(JSON.stringify({}), master);
    localStorage.setItem("vault", JSON.stringify(encrypted));
    setVault({});
    setVaultUnlocked(true);
    setIsVaultPresent(true);
    setVaultError("");

    if (defaultUsername) {
      localStorage.setItem('defUsername', defaultUsername);
      setUsername(defaultUsername);
    }
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

    const data = localStorage.getItem("vault");

    const blob = new Blob([data], { type: "application/x-vault" });
    const url = URL.createObjectURL(blob);
    const a = document.createElement("a");
    a.href = url;
    a.download = "pass-tool.vault";
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

    setAddError('');

    if (!source || !username || !password) {
      setAddError('Please enter required fields');
      return;
    }

    if (vault[source]) {
      setAddError('Source already exists, please enter another one');
      return;
    }

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

  const handleCopy = (pw, idx) => {
    if (navigator.clipboard && window.isSecureContext) {
      navigator.clipboard.writeText(pw).then(() => {
        setCopiedIndex(idx);
        setTimeout(() => setCopiedIndex(null), 1500);
      });
    }
  };

  const regeneratePassword = () => {
    const pass = generatePassword(length, includeNumbers, includeSymbols, includeUppercase, customSymbols);
    setPassword(pass);
  };

  const setDefaults = () => {
    setUsername(defaultUsername);
    regeneratePassword();
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

  const setVisiblePass = (source: string) => {
    visibleMap[source] = !visibleMap[source];
    setVisibleMap({ ...visibleMap });
  };

  return (
    <Card className="rounded-2xl shadow-md">
      <CardContent className="space-y-4 p-6">
        <div className="flex items-center justify-between">
          <h2 className="text-2xl font-bold"><LucideVault></LucideVault></h2>

          <div className="flex items-center gap-2">


            {isVaultPresent && (
              vaultUnlocked && <>

                <Button title="Set Defaults" variant="ghost" size="icon" className="btn-ico hover:bg-gray-300 dark:hover:bg-gray-700" onClick={setDefaults}><ListRestart className="w-5 h-5" /></Button>

                <Button title="Export Vault" variant="ghost" size="icon" className="btn-ico hover:bg-gray-300 dark:hover:bg-gray-700" onClick={exportVault}><Download className="w-5 h-5" /></Button>

                <Button title="Lock Vault" variant="ghost" size="icon" className="btn-ico hover:bg-gray-300 dark:hover:bg-gray-700" onClick={() => { setMaster(''); setVaultUnlocked(false); }}> <LockKeyhole className="w-5 h-5" /> </Button>

              </>
            )}

          </div>
        </div>

        <div className="col-span-2">
          <hr className="border-t my-2" />
        </div>

        {!vaultUnlocked ? (
          <>

            <div>
              <Input type="password" placeholder="Master Password" className={vaultError && 'border-red-500 border-dashed'} value={master} onChange={(e) => setMaster(e.target.value)} />
              {isCreatingVault && (
                <div className="mt-2">

                  <Input type="password" className={vaultError && 'border-red-500 border-dashed'} placeholder="Confirm Password" value={confirmMaster} onChange={(e) => setConfirmMaster(e.target.value)} />
                  <Input placeholder="Default Username" className="mt-4" value={defaultUsername} onChange={(e) => setDefaultUsername(e.target.value)} />

                </div>
              )}
              {vaultError && <p className="text-xs text-red-500 mt-2">{vaultError}</p>}

            </div>
            <div className="flex flex-wrap gap-2 mt-4 justify-end">
              <Button onClick={isCreatingVault ? createVault : unlockVault}>{isCreatingVault ? "Create Vault" : "Unlock Vault"}</Button>

            </div>
          </>
        ) : (
          <>

            <Tabs defaultValue="new" className="w-full">
              <TabsList className="mb-4">
                <TabsTrigger value="new">New Password</TabsTrigger>
                <TabsTrigger value="settings">Settings</TabsTrigger>
              </TabsList>

              <TabsContent value="new">

                <div className="grid grid-cols-1 sm:grid-cols-2 gap-2">
                  <Input placeholder="Source" className={addError && !source && 'border-red-500 border-dashed'} value={source} onChange={(e) => setSource(e.target.value)} required />
                  <Input placeholder="Notes (optional)" value={notes} onChange={(e) => setNotes(e.target.value)} />

                  <Input placeholder="Username" className={addError && !username && 'border-red-500 border-dashed'} value={username} onChange={(e) => setUsername(e.target.value)} required />
                  <div className="relative w-full">
                    <Input
                      type={showPassword ? 'text' : 'password'}
                      placeholder="Password"
                      value={password}
                      onChange={(e) => setPassword(e.target.value)}
                      required
                      className={`pr-20 ${addError && !password && 'border-red-500 border-dashed'}`}
                    />

                    <button
                      type="button"
                      className="absolute btn-ico right-14 top-1/2 -translate-y-1/2 text-xs"
                      onClick={() => regeneratePassword()}
                    >
                      <RotateCcw className="w-4 h-4" />
                    </button>

                    <button
                      type="button"
                      title="Copy Username"
                      onClick={() => handleCopy(password, 'addpass')}
                      className="absolute right-8 top-1/2 -translate-y-1/2 text-xs"
                    >

                      {copiedIndex === 'addpass' ? (

                        <Check className="w-4 h-4 text-emerald-500" />

                      ) : (

                        <Copy className="w-4 h-4" />

                      )}

                    </button>

                    <button
                      type="button"
                      className="absolute btn-ico right-2 top-1/2 -translate-y-1/2 text-xs"
                      onClick={() => setShowPassword(!showPassword)}
                    >
                      {showPassword ? <EyeClosed className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
                    </button>
                  </div>

                </div>

                {addError && <p className="text-xs text-red-500 mt-2">{addError}</p>}

                <div className="flex flex-wrap gap-2 mt-4 justify-end">
                  <Button onClick={addPasswordRecord}>Add Password</Button>

                  {/* <Button onClick={exportVault}>Download Vault</Button>
              <Input type="file" onChange={importVault} className="flex-1" />
               */}

                </div>

              </TabsContent>

              <TabsContent value="settings">

                <Input placeholder="Del" value={search} onChange={(e) => setSearch(e.target.value)} />

                <div className="flex flex-wrap gap-2 mt-4 justify-end">
                  <Button onClick={deleteVault}>Delete Vault</Button>
                </div>

              </TabsContent>
            </Tabs>


            <div className="col-span-2">
              <hr className="border-t my-2" />
            </div>


            <div className="relative w-full">

              <Input placeholder="Search by source" value={search} onChange={(e) => setSearch(e.target.value)} />

              <button
                type="button"
                className="absolute btn-ico right-2 top-1/2 -translate-y-1/2 text-xs"
                onClick={() => { }}
              >
                <Search className="w-4 h-4" />
              </button>

            </div>


            <div className="grid gap-4">
              {filteredVault.map(([key, entry]: [string, any]) => (
                <div key={key} className="rounded-xl card-pass p-4">
                  <div className="mb-4 flex items-center justify-between text-sm font-semibold">

                    <span className="text-sm font-bold"><KeyRound className="size-4 inline mr-2" /> {key}</span>
                    {/* <button
                      type="button"
                      onClick={() => deleteRecord(key)}
                      title="Delete Record"
                    >
                      <Trash className="w-4 h-4" />
                    </button> */}



<div>
                    <Button title="Copy Source" variant="ghost" size="icon" className="btn-ico hover:bg-gray-300 dark:hover:bg-gray-700" onClick={() => handleCopy(key, `source-${key}`)}>


                      {copiedIndex === `source-${key}` ? (

                        <Check className="w-4 h-4 text-emerald-500" />

                      ) : (

                        <Copy className="w-4 h-4" />

                      )}

                    </Button>

                    <ConfirmDialog
                      onConfirm={() => { deleteRecord(key); }}
                      title="Delete Record"
                      message={`Are you sure you want to delete '${key}' password record?`}
                    >
                      <Button title="Lock Vault" variant="ghost" size="icon" className="btn-ico hover:bg-gray-300 dark:hover:bg-gray-700" onClick={() => { }}>
                        <Trash className="w-5 h-5" /> </Button>
                    </ConfirmDialog>

                    </div>

                  </div>

                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-2 mb-2">
                    <div className="relative">
                      <Input readOnly value={entry.username} className="pr-10" />
                      <button
                        type="button"
                        title="Copy Username"
                        onClick={() => handleCopy(entry.username, `user-${key}`)}
                        className="absolute right-2 top-1/2 -translate-y-1/2 text-xs"
                      >

                        {copiedIndex === `user-${key}` ? (

                          <Check className="w-4 h-4 text-emerald-500" />

                        ) : (

                          <Copy className="w-4 h-4" />

                        )}

                      </button>
                    </div>
                    <div className="relative">
                      <Input type={visibleMap[key] ? 'text' : 'password'} readOnly value={entry.password} className="pr-10" />


                      <button
                        type="button"

                        title="Copy Password"
                        onClick={() => handleCopy(entry.password, `pass-${key}`)}
                        className="absolute right-8 top-1/2 -translate-y-1/2 text-xs"
                      >

                        {copiedIndex === `pass-${key}` ? (

                          <Check className="w-4 h-4 text-emerald-500" />

                        ) : (

                          <Copy className="w-4 h-4" />

                        )}

                      </button>

                      <button
                        type="button"
                        className="absolute btn-ico right-2 top-1/2 -translate-y-1/2 text-xs"
                        onClick={() => setVisiblePass(key)}
                      >
                        {visibleMap[key] ? <EyeClosed className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
                      </button>
                    </div>
                  </div>

                  {entry.notes &&
                    <div className="grid grid-cols-1 gap-2">
                      {/* <div className="relative">
                      <Input readOnly value={key} className="opacity-60" />
                    </div> */}
                      <div className="relative">
                        <Input readOnly value={entry.notes || ""} placeholder="Notes" className="pr-10" />

                        <button
                          type="button"

                          title="Copy Notes"
                          onClick={() => handleCopy(entry.notes, `notes-${key}`)}
                          className="absolute right-2 top-1/2 -translate-y-1/2 text-xs"
                        >

                          {copiedIndex === `notes-${key}` ? (

                            <Check className="w-4 h-4 text-emerald-500" />

                          ) : (

                            <Copy className="w-4 h-4" />

                          )}

                        </button>
                      </div>
                    </div>
                  }

                </div>
              ))}
            </div>
          </>
        )}
      </CardContent>
    </Card>
  );
}
