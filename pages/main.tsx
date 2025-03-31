import { useState, useEffect } from "react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Switch } from "@/components/ui/switch";
import { Card, CardContent } from "@/components/ui/card";
import { Copy, Sun, Moon, Check, RotateCcw, KeyRound, ListRestart, ShieldCheck, ShieldAlert, Shield } from "lucide-react";

function generatePassword(length, includeNumbers, includeSymbols, includeUppercase, customSymbols) {
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
}

function passwordStrength(pw) {
  const length = pw.length;
  const hasUpper = /[A-Z]/.test(pw);
  const hasLower = /[a-z]/.test(pw);
  const hasNumber = /[0-9]/.test(pw);
  const hasSymbol = /[^A-Za-z0-9]/.test(pw);

  let score = 0;
  if (length >= 8) score += 1;
  if (length >= 12) score += 1;
  if (hasUpper) score += 1;
  if (hasLower) score += 1;
  if (hasNumber) score += 1;
  if (hasSymbol) score += 1;

  if (score >= 5) return "Very Strong";
  if (score === 4) return "Strong";
  if (score === 3) return "Moderate";
  if (score === 2) return "Weak";
  return "Very Weak";
}

function encryptData(data, password) {
  return window.crypto.subtle.importKey(
    "raw",
    new TextEncoder().encode(password),
    { name: "PBKDF2" },
    false,
    ["deriveKey"]
  ).then(baseKey => {
    return window.crypto.subtle.deriveKey(
      {
        name: "PBKDF2",
        salt: new TextEncoder().encode("vault-salt"),
        iterations: 100000,
        hash: "SHA-256"
      },
      baseKey,
      { name: "AES-GCM", length: 256 },
      false,
      ["encrypt"]
    );
  }).then(key => {
    const iv = window.crypto.getRandomValues(new Uint8Array(12));
    return window.crypto.subtle.encrypt(
      { name: "AES-GCM", iv },
      key,
      new TextEncoder().encode(data)
    ).then(encrypted => {
      return {
        iv: Array.from(iv),
        data: Array.from(new Uint8Array(encrypted))
      };
    });
  });
}

function decryptData(encryptedObj, password) {
  return window.crypto.subtle.importKey(
    "raw",
    new TextEncoder().encode(password),
    { name: "PBKDF2" },
    false,
    ["deriveKey"]
  ).then(baseKey => {
    return window.crypto.subtle.deriveKey(
      {
        name: "PBKDF2",
        salt: new TextEncoder().encode("vault-salt"),
        iterations: 100000,
        hash: "SHA-256"
      },
      baseKey,
      { name: "AES-GCM", length: 256 },
      false,
      ["decrypt"]
    );
  }).then(key => {
    const iv = new Uint8Array(encryptedObj.iv);
    const data = new Uint8Array(encryptedObj.data);
    return window.crypto.subtle.decrypt(
      { name: "AES-GCM", iv },
      key,
      data
    ).then(decrypted => new TextDecoder().decode(decrypted));
  });
}

if (typeof window !== "undefined" && "serviceWorker" in navigator) {
  window.addEventListener("load", () => {
    navigator.serviceWorker.register("/sw.js").catch(err => {
      console.error("Service Worker registration failed:", err);
    });
  });
}

export default function AppMain() {
  const [copiedIndex, setCopiedIndex] = useState(null);

  const handleCopy = (pw, idx) => {
    if (navigator.clipboard && window.isSecureContext) {
      navigator.clipboard.writeText(pw).then(() => {
        setCopiedIndex(idx);
        setTimeout(() => setCopiedIndex(null), 1500);
      }).catch(() => fallbackCopy(pw, idx));
    } else {
      fallbackCopy(pw, idx);
    }
  };

  const fallbackCopy = (text, idx) => {
    const textarea = document.createElement("textarea");
    textarea.value = text;
    textarea.style.position = "fixed";
    textarea.style.opacity = "0";
    document.body.appendChild(textarea);
    textarea.focus();
    textarea.select();
    try {
      document.execCommand("copy");
      setCopiedIndex(idx);
      setTimeout(() => setCopiedIndex(null), 1500);
    } catch (err) {
      console.error("Fallback copy failed", err);
    }
    document.body.removeChild(textarea);
  };

  const [vault, setVault] = useState({});
  const [master, setMaster] = useState("");
  const [site, setSite] = useState("");
  const [sitePass, setSitePass] = useState("");
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

  const [passwordCount, setPasswordCount] = useState(() => {

    const saved = localStorage.getItem("passwordSettings");
    return saved ? JSON.parse(saved).passwordCount ?? 3 : 3;
  });

  const [generatedPasswords, setGeneratedPasswords] = useState([]);

  const [darkMode, setDarkMode] = useState(() => {

    const stored = localStorage.getItem("darkMode");
    return stored !== null ? stored === "true" : true;
  });

  const [offlineMode, setOfflineMode] = useState(false);

  useEffect(() => {

    const root = document.documentElement;
    if (darkMode) {
      root.classList.add("dark");
    } else {
      root.classList.remove("dark");
    }
    localStorage.setItem("darkMode", darkMode.toString());
  }, [darkMode]);

  useEffect(() => {

    const settings = {
      length,
      includeNumbers,
      includeSymbols,
      includeUppercase,
      customSymbols,
      passwordCount
    };
    localStorage.setItem("passwordSettings", JSON.stringify(settings));
    generatePasswords();
  }, [length, includeNumbers, includeSymbols, includeUppercase, customSymbols, passwordCount]);

  const generatePasswords = () => {
    const newPasswords = Array.from({ length: passwordCount }, () =>
      generatePassword(length, includeNumbers, includeSymbols, includeUppercase, customSymbols)
    );
    setGeneratedPasswords(newPasswords);
  };

  const addToVault = () => {
    const newVault = { ...vault, [site]: sitePass };
    setVault(newVault);
    setSite("");
    setSitePass("");
  };

  const exportVault = async () => {
    const encrypted = await encryptData(JSON.stringify(vault), master);
    const blob = new Blob([JSON.stringify(encrypted)], { type: "application/json" });
    const url = URL.createObjectURL(blob);
    const a = document.createElement("a");
    a.href = url;
    a.download = "vault.json";
    a.click();
  };

  const importVault = (e) => {
    const file = e.target.files[0];
    const reader = new FileReader();
    reader.onload = async (event) => {
      const encrypted = JSON.parse(event.target.result);
      const decrypted = await decryptData(encrypted, master);
      setVault(JSON.parse(decrypted));
    };
    reader.readAsText(file);
  };

  return (
    <main className="min-h-screen p-4 md:p-8 space-y-6">
      <div className="max-w-xl mx-auto space-y-6">
        <div className="flex justify-between items-center">
          <Button onClick={() => setDarkMode(!darkMode)} variant="ghost" size="icon" className="btn-ico hover:bg-gray-300 dark:hover:bg-gray-700">
            {darkMode ? <Sun /> : <Moon />}
          </Button>
          <label className="flex items-center gap-2">
            <span className="text-xs color-emerald">Offline Mode</span>
          </label>
        </div>

        <Card className="rounded-2xl shadow-md">
          <CardContent className="space-y-4 p-6">
            <div className="flex items-center justify-between">
              <h2 className="text-xl font-bold flex items-center gap-2"><KeyRound></KeyRound></h2>
              <div className="flex items-center gap-2">
                <Button title="Regenerate Passwords" variant="ghost" size="icon" onClick={generatePasswords} className="btn-ico hover:bg-gray-300 dark:hover:bg-gray-700">
                  <RotateCcw className="w-5 h-5"></RotateCcw>
                </Button>
                <Button title="Restore Default Settings" variant="ghost" size="icon" className="btn-ico hover:bg-gray-300 dark:hover:bg-gray-700" onClick={() => {
                  setLength(22);
                  setIncludeNumbers(true);
                  setIncludeSymbols(true);
                  setIncludeUppercase(true);
                  setCustomSymbols("!\";#$%&'()*+,-./:;<=>?@[]^_`{|}~");
                  setPasswordCount(3);
                }}>

                  <ListRestart className="w-5 h-5"></ListRestart>
                </Button>
              </div>
            </div>

            <div className="col-span-2">
              <hr className="border-t my-2" />
            </div>

            <div className="mt-6 space-y-2">
              {generatedPasswords.map((pw, idx) => (
                <div key={idx} className="pt-1 pb-1 rounded-md flex items-center gap-2">
                  <Input readOnly value={pw} className="w-full" />


                  {(() => {
                    const strength = passwordStrength(pw);
                    const colorMap = {
                      'Very Weak': 'text-red-500',
                      'Weak': 'text-orange-500',
                      'Moderate': 'text-yellow-500',
                      'Strong': 'text-green-500',
                      'Very Strong': 'text-emerald-500'
                    };
                    return (
                      <Button variant="ghost" size="icon" onClick={() => { }} title={strength} className="">

                        {
                          (strength == 'Very Strong' || strength == 'Strong') && <ShieldCheck className={`w-4 h-4 ${colorMap[strength] || 'text-gray-500'}`}></ShieldCheck>
                        }

                        {
                          strength == 'Moderate' && <Shield className={`w-4 h-4 ${colorMap[strength] || 'text-gray-500'}`}></Shield>
                        }

                        {
                          (strength == 'Weak' || strength == 'Very Weak') && <ShieldAlert className={`w-4 h-4 ${colorMap[strength] || 'text-gray-500'}`}></ShieldAlert>
                        }

                      </Button>
                    );
                  })()}

                  <Button title="Copy to Clipboard" variant="ghost" size="icon" onClick={() => handleCopy(pw, idx)} className="btn-ico hover:bg-gray-300 dark:hover:bg-gray-700">

                    {copiedIndex === idx ? (

                      <Check className="w-4 h-4 text-emerald-500" />

                    ) : (

                      <Copy className="w-4 h-4 hover:text-gray-900 dark:hover:text-gray-100" />

                    )}
                  </Button>

                </div>
              ))}
            </div>

            <div className="col-span-2">
              <hr className="border-t my-2" />
            </div>

            <div className="grid grid-cols-2 gap-y-3 gap-x-2 items-center [&>span]:h-10 [&>label]:h-10 [&>input]:h-10 [&>span]:flex [&>span]:items-center:h-10 [&>label]:h-10 [&>input]:h-10">

              <span className="text-sm items-center">Passwords to Generate:</span>
              <Input type="number" value={passwordCount} onChange={(e) => setPasswordCount(Number(e.target.value))} className="w-full" />

              <span className="text-sm items-center">Password Length:</span>
              <Input type="number" value={length} onChange={(e) => setLength(Number(e.target.value))} className="w-full" />

              <span className="text-sm items-center">Include Numbers:</span>
              <Switch checked={includeNumbers} onCheckedChange={setIncludeNumbers} />

              <span className="text-sm items-center">Include Symbols:</span>
              <Switch checked={includeSymbols} onCheckedChange={setIncludeSymbols} />

              {includeSymbols && (
                <>
                  <span className="text-sm items-center">Custom Symbols:</span>
                  <Input value={customSymbols} onChange={(e) => setCustomSymbols(e.target.value)} className="text-sm" />
                </>
              )}

              <span className="text-sm items-center">Include Uppercase:</span>
              <Switch checked={includeUppercase} onCheckedChange={setIncludeUppercase} />


            </div>

          </CardContent>
        </Card>

        {/* <Card className="rounded-2xl shadow-md">
          <CardContent className="space-y-4 p-6">
            <h2 className="text-2xl font-bold">🗄️ Password Vault</h2>
            <Input placeholder="Master Password" value={master} onChange={(e) => setMaster(e.target.value)} type="password" />
            <div className="grid grid-cols-2 gap-2">
              <Input placeholder="Site" value={site} onChange={(e) => setSite(e.target.value)} />
              <Input placeholder="Password" value={sitePass} onChange={(e) => setSitePass(e.target.value)} />
            </div>
            <div className="flex flex-wrap gap-2">
              <Button onClick={addToVault}>Add</Button>
              <Button onClick={exportVault}>Download Vault</Button>
              <Input type="file" onChange={importVault} className="flex-1" />
            </div>
            <pre className="text-sm bg-gray-200 dark:bg-gray-800 rounded-lg p-4 max-h-64 overflow-auto">
              {JSON.stringify(vault, null, 2)}
            </pre>
          </CardContent>
        </Card> */}

      </div>
    </main>
  );
}
