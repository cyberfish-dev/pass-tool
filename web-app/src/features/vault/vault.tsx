import { useState, useEffect } from "react";
import { Button } from "@/src/components/button";
import { Input } from "@/src/components/input";
import { Card, CardContent } from "@/src/components/card";
import {
  Copy,
  LockKeyhole,
  LucideVault,
  Download,
  Eye,
  EyeClosed,
  RotateCcw,
  ListRestart,
  KeyRound,
  Trash,
  Check,
  Search,
} from "lucide-react";
import {
  Tabs,
  TabsContent,
  TabsList,
  TabsTrigger,
} from "@/src/components/tabs";
import { ConfirmDialog } from "@/src/components/confirmDialog";
import { decryptData, encryptData } from "@/src/lib/encryption";
import { generatePassword } from "@/src/lib/password";
import { usePasswordSettings } from "../common/usePasswordSettings";
import { Vault } from "../generator/types";
import { handleCopy } from "@/src/lib/clipboard";

export default function VaultView() {
  const [showPassword, setShowPassword] = useState(true);
  const [vault, setVault] = useState<Vault>({});
  const [master, setMaster] = useState("");
  const [confirmMaster, setConfirmMaster] = useState("");
  const [isVaultPresent, setIsVaultPresent] = useState(() => {
    if (typeof window !== "undefined") {
      return !!localStorage.getItem("vault");
    }
    return false;
  });

  const [isCreatingVault, setIsCreatingVault] = useState(!isVaultPresent);
  const [vaultUnlocked, setVaultUnlocked] = useState(false);

  const [vaultError, setVaultError] = useState("");
  const [addError, setAddError] = useState("");

  const [defaultUsername, setDefaultUsername] = useState(() => {
    const saved = localStorage.getItem("defUsername");
    return saved ?? "";
  });

  const {
    length,
    includeNumbers,
    includeSymbols,
    includeUppercase,
    customSymbols,
  } = usePasswordSettings();

  const [visibleMap, setVisibleMap] = useState({});

  const [copiedIndex, setCopiedIndex] = useState(null);
  const [source, setSource] = useState("");
  const [username, setUsername] = useState(defaultUsername);
  const [password, setPassword] = useState(
    generatePassword(
      length,
      includeNumbers,
      includeSymbols,
      includeUppercase,
      customSymbols,
    ),
  );

  const [notes, setNotes] = useState("");
  const [search, setSearch] = useState("");

  const [delConfirm, setDelConfirm] = useState("");
  const [importMaster, setImportMaster] = useState("");
  const [importError, setImportError] = useState("");
  const [importFileBlob, setImportFileBlob] = useState(null);

  const PASSWORD_REGEXP =
    /^(?=.*[0-9])(?=.*[!@#$%^&*])[a-zA-Z0-9!@#$%^&*]{6,30}$/;

  const createVault = async () => {
    if (master !== confirmMaster)
      return setVaultError("Passwords do not match");

    const isValid = PASSWORD_REGEXP.test(master);
    if (!isValid)
      return setVaultError(
        "Password should be more than 6, less than 30 chars, include a digit and one special character ! @ # $ % ^ & *",
      );

    const encrypted = await encryptData(JSON.stringify({}), master);
    localStorage.setItem("vault", JSON.stringify(encrypted));
    setVault({});
    setVaultUnlocked(true);
    setIsVaultPresent(true);
    setVaultError("");

    if (defaultUsername) {
      localStorage.setItem("defUsername", defaultUsername);
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

  const importFile = (event: React.ChangeEvent<HTMLInputElement>) => {
    const file = event.target.files?.[0];
    if (!file) return;

    setImportFileBlob(file);
  };

  const importVault = () => {
    setImportError("");

    if (!importFileBlob) {
      setImportError("Select vault file to import");
      return;
    }

    const reader = new FileReader();
    reader.onload = async (e) => {
      try {
        const content = e.target?.result as string;
        const parsed = JSON.parse(content);
        const decrypted = await decryptData(parsed, importMaster);

        const json = JSON.parse(decrypted);

        let newVault = { ...vault };

        Object.entries(json).forEach(([key, value]) => {
          let realKey = key;

          if (vault[key]) {
            let num = 1;
            realKey = `${key}-${num}`;

            while (vault[realKey]) {
              num++;
              realKey = `${key}-${num}`;
            }
          }

          const jsonRec = value as any;
          newVault[realKey] = {
            username: jsonRec.username,
            password: jsonRec.password,
            notes: jsonRec.notes,
          };
        });

        setVault(newVault);

        const encrypted = await encryptData(JSON.stringify(newVault), master);
        localStorage.setItem("vault", JSON.stringify(encrypted));

        setSource("");
        setUsername("");
        setPassword("");
        setNotes("");
        setImportFileBlob(null);
        setImportMaster("");
      } catch (err) {
        setImportError("Failed to import vault");
      }
    };

    reader.readAsText(importFileBlob);
  };

  const addPasswordRecord = async () => {
    setAddError("");

    if (!source || !username || !password) {
      setAddError("Please enter required fields");
      return;
    }

    if (vault[source]) {
      setAddError("Source already exists, please enter another one");
      return;
    }

    const newVault = {
      ...vault,
      [source]: { username, password, notes },
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
    if (delConfirm === master) {
      localStorage.removeItem("vault");
      setVault({});
      setVaultUnlocked(false);
      setIsVaultPresent(false);
      setMaster("");
      setConfirmMaster("");
      setDelConfirm("");
      setSearch("");
      setIsCreatingVault(true);
    }
  };

  const filteredVault = Object.entries(vault).filter(([key]) =>
    key.toLowerCase().includes(search.toLowerCase()),
  );

  const regeneratePassword = () => {
    const pass = generatePassword(
      length,
      includeNumbers,
      includeSymbols,
      includeUppercase,
      customSymbols,
    );
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

  const setDefaultUsernameLocal = (defaultUsername: string) => {
    defaultUsername = defaultUsername ?? "";

    localStorage.setItem("defUsername", defaultUsername);
    setUsername(defaultUsername);
    setDefaultUsername(defaultUsername);
  };

  return (
    <Card className="rounded-2xl shadow-md">
      <CardContent className="space-y-4 p-6">
        <div className="flex items-center justify-between">
          <h2 className="text-2xl font-bold">
            <LucideVault></LucideVault>
          </h2>

          <div className="flex items-center gap-2">
            {isVaultPresent && vaultUnlocked && (
              <>
                <Button
                  title="Set Defaults"
                  variant="ghost"
                  size="icon"
                  className="btn-ico hover:bg-gray-300 dark:hover:bg-gray-700"
                  onClick={setDefaults}
                >
                  <ListRestart className="w-5 h-5" />
                </Button>

                <Button
                  title="Export Vault"
                  variant="ghost"
                  size="icon"
                  className="btn-ico hover:bg-gray-300 dark:hover:bg-gray-700"
                  onClick={exportVault}
                >
                  <Download className="w-5 h-5" />
                </Button>

                <Button
                  title="Lock Vault"
                  variant="ghost"
                  size="icon"
                  className="btn-ico hover:bg-gray-300 dark:hover:bg-gray-700"
                  onClick={() => {
                    setMaster("");
                    setVaultUnlocked(false);
                  }}
                >
                  {" "}
                  <LockKeyhole className="w-5 h-5" />{" "}
                </Button>
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
              <Input
                type="password"
                placeholder="Master Password"
                className={vaultError && "border-red-500 border-dashed"}
                value={master}
                onChange={(e) => setMaster(e.target.value)}
              />
              {isCreatingVault && (
                <div className="mt-2">
                  <Input
                    type="password"
                    className={vaultError && "border-red-500 border-dashed"}
                    placeholder="Confirm Password"
                    value={confirmMaster}
                    onChange={(e) => setConfirmMaster(e.target.value)}
                  />
                  <Input
                    placeholder="Default Username"
                    className="mt-4"
                    value={defaultUsername}
                    onChange={(e) => setDefaultUsername(e.target.value)}
                  />
                </div>
              )}
              {vaultError && (
                <p className="text-xs text-red-500 mt-2">{vaultError}</p>
              )}
            </div>
            <div className="flex flex-wrap gap-2 mt-4 justify-end">
              <Button onClick={isCreatingVault ? createVault : unlockVault}>
                {isCreatingVault ? "Create Vault" : "Unlock Vault"}
              </Button>
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
                  <Input
                    placeholder="Source"
                    className={
                      addError && !source && "border-red-500 border-dashed"
                    }
                    value={source}
                    onChange={(e) => setSource(e.target.value)}
                    required
                  />
                  <Input
                    placeholder="Notes (optional)"
                    value={notes}
                    onChange={(e) => setNotes(e.target.value)}
                  />

                  <Input
                    placeholder="Username"
                    className={
                      addError && !username && "border-red-500 border-dashed"
                    }
                    value={username}
                    onChange={(e) => setUsername(e.target.value)}
                    required
                  />
                  <div className="relative w-full">
                    <Input
                      type={showPassword ? "text" : "password"}
                      placeholder="Password"
                      value={password}
                      onChange={(e) => setPassword(e.target.value)}
                      required
                      className={`pr-20 ${addError && !password && "border-red-500 border-dashed"}`}
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
                      onClick={() =>
                        handleCopy(password, "addpass", setCopiedIndex)
                      }
                      className="absolute right-8 top-1/2 -translate-y-1/2 text-xs"
                    >
                      {copiedIndex === "addpass" ? (
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
                      {showPassword ? (
                        <EyeClosed className="w-4 h-4" />
                      ) : (
                        <Eye className="w-4 h-4" />
                      )}
                    </button>
                  </div>
                </div>

                {addError && (
                  <p className="text-xs text-red-500 mt-2">{addError}</p>
                )}

                <div className="flex flex-wrap gap-2 mt-4 justify-end">
                  <Button onClick={addPasswordRecord}>Add Password</Button>
                </div>
              </TabsContent>

              <TabsContent value="settings">
                <Input
                  placeholder="Default Username"
                  value={defaultUsername}
                  onChange={(e) => setDefaultUsernameLocal(e.target.value)}
                />

                <Input
                  type="password"
                  placeholder="Enter master password for import"
                  className="mt-8"
                  value={importMaster}
                  onChange={(e) => setImportMaster(e.target.value)}
                />

                <Input
                  type="file"
                  onChange={importFile}
                  className="mt-4 text-xs"
                />

                {importError && (
                  <p className="text-xs text-red-500 mt-2">{importError}</p>
                )}

                <Button className="mt-4" onClick={importVault}>
                  Import Vault
                </Button>

                <Input
                  type="password"
                  placeholder="Enter master password to delete vault"
                  className="mt-8"
                  value={delConfirm}
                  onChange={(e) => setDelConfirm(e.target.value)}
                />

                <div className="flex flex-wrap gap-2 mt-4 justify-end">
                  <Button className="btn-danger" onClick={deleteVault}>
                    Delete Vault
                  </Button>
                </div>
              </TabsContent>
            </Tabs>

            <div className="col-span-2">
              <hr className="border-t my-2" />
            </div>

            <div className="relative w-full">
              <Input
                placeholder="Search by source"
                value={search}
                onChange={(e) => setSearch(e.target.value)}
              />

              <button
                type="button"
                className="absolute btn-ico right-2 top-1/2 -translate-y-1/2 text-xs"
                onClick={() => {}}
              >
                <Search className="w-4 h-4" />
              </button>
            </div>

            <div className="grid gap-4">
              {filteredVault.map(([key, entry]: [string, any]) => (
                <div key={key} className="rounded-xl card-pass p-4">
                  <div className="mb-4 flex items-center justify-between text-sm font-semibold">
                    <span className="text-sm font-bold">
                      <KeyRound className="size-4 inline mr-2" /> {key}
                    </span>

                    <div>
                      <Button
                        title="Copy Source"
                        variant="ghost"
                        size="icon"
                        className="btn-ico hover:bg-gray-300 dark:hover:bg-gray-700"
                        onClick={() =>
                          handleCopy(key, `source-${key}`, setCopiedIndex)
                        }
                      >
                        {copiedIndex === `source-${key}` ? (
                          <Check className="w-4 h-4 text-emerald-500" />
                        ) : (
                          <Copy className="w-4 h-4" />
                        )}
                      </Button>

                      <ConfirmDialog
                        onConfirm={() => {
                          deleteRecord(key);
                        }}
                        title="Delete Record"
                        message={`Are you sure you want to delete '${key}' password record?`}
                      >
                        <Button
                          title="Lock Vault"
                          variant="ghost"
                          size="icon"
                          className="btn-ico hover:bg-gray-300 dark:hover:bg-gray-700"
                          onClick={() => {}}
                        >
                          <Trash className="w-5 h-5" />{" "}
                        </Button>
                      </ConfirmDialog>
                    </div>
                  </div>

                  <div className="grid grid-cols-1 sm:grid-cols-2 gap-2 mb-2">
                    <div className="relative">
                      <Input
                        readOnly
                        value={entry.username}
                        className="pr-10"
                      />
                      <button
                        type="button"
                        title="Copy Username"
                        onClick={() =>
                          handleCopy(
                            entry.username,
                            `user-${key}`,
                            setCopiedIndex,
                          )
                        }
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
                      <Input
                        type={visibleMap[key] ? "text" : "password"}
                        readOnly
                        value={entry.password}
                        className="pr-10"
                      />

                      <button
                        type="button"
                        title="Copy Password"
                        onClick={() =>
                          handleCopy(
                            entry.password,
                            `pass-${key}`,
                            setCopiedIndex,
                          )
                        }
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
                        {visibleMap[key] ? (
                          <EyeClosed className="w-4 h-4" />
                        ) : (
                          <Eye className="w-4 h-4" />
                        )}
                      </button>
                    </div>
                  </div>

                  {entry.notes && (
                    <div className="grid grid-cols-1 gap-2">
                      <div className="relative">
                        <Input
                          readOnly
                          value={entry.notes || ""}
                          placeholder="Notes"
                          className="pr-10"
                        />

                        <button
                          type="button"
                          title="Copy Notes"
                          onClick={() =>
                            handleCopy(
                              entry.notes,
                              `notes-${key}`,
                              setCopiedIndex,
                            )
                          }
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
                  )}
                </div>
              ))}
            </div>
          </>
        )}
      </CardContent>
    </Card>
  );
}
