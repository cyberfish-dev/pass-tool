import { useState, useEffect } from "react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Switch } from "@/components/ui/switch";
import { Card, CardContent } from "@/components/ui/card";
import {
  Copy,
  Check,
  RotateCcw,
  KeyRound,
  ListRestart,
  ShieldCheck,
  ShieldAlert,
  Shield,
} from "lucide-react";

export default function GeneratorView() {
  const [copiedIndex, setCopiedIndex] = useState(null);

  const passwordStrength = (pw) => {
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
  };

  const generatePassword = (
    length,
    includeNumbers,
    includeSymbols,
    includeUppercase,
    customSymbols,
  ) => {
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

  const handleCopy = (pw, idx) => {
    if (navigator.clipboard && window.isSecureContext) {
      navigator.clipboard
        .writeText(pw)
        .then(() => {
          setCopiedIndex(idx);
          setTimeout(() => setCopiedIndex(null), 1500);
        })
        .catch(() => fallbackCopy(pw, idx));
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

  const [length, setLength] = useState(() => {
    const saved = localStorage.getItem("passwordSettings");
    return saved ? (JSON.parse(saved).length ?? 22) : 22;
  });

  const [includeNumbers, setIncludeNumbers] = useState(() => {
    const saved = localStorage.getItem("passwordSettings");
    return saved ? (JSON.parse(saved).includeNumbers ?? true) : true;
  });

  const [includeSymbols, setIncludeSymbols] = useState(() => {
    const saved = localStorage.getItem("passwordSettings");
    return saved ? (JSON.parse(saved).includeSymbols ?? true) : true;
  });

  const [customSymbols, setCustomSymbols] = useState(() => {
    const customSymbols = "!\";#$%&'()*+,-./:;<=>?@[]^_`{|}~";

    const saved = localStorage.getItem("passwordSettings");
    return saved
      ? (JSON.parse(saved).customSymbols ?? customSymbols)
      : customSymbols;
  });

  const [includeUppercase, setIncludeUppercase] = useState(() => {
    const saved = localStorage.getItem("passwordSettings");
    return saved ? (JSON.parse(saved).includeUppercase ?? true) : true;
  });

  const [passwordCount, setPasswordCount] = useState(() => {
    const saved = localStorage.getItem("passwordSettings");
    return saved ? (JSON.parse(saved).passwordCount ?? 3) : 3;
  });

  const [generatedPasswords, setGeneratedPasswords] = useState([]);

  useEffect(() => {
    const settings = {
      length,
      includeNumbers,
      includeSymbols,
      includeUppercase,
      customSymbols,
      passwordCount,
    };
    localStorage.setItem("passwordSettings", JSON.stringify(settings));
    generatePasswords();
  }, [
    length,
    includeNumbers,
    includeSymbols,
    includeUppercase,
    customSymbols,
    passwordCount,
  ]);

  const generatePasswords = () => {
    const newPasswords = Array.from({ length: passwordCount }, () =>
      generatePassword(
        length,
        includeNumbers,
        includeSymbols,
        includeUppercase,
        customSymbols,
      ),
    );
    setGeneratedPasswords(newPasswords);
  };

  return (
    <>
      <Card className="rounded-2xl shadow-md">
        <CardContent className="space-y-4 p-6">
          <div className="flex items-center justify-between">
            <h2 className="text-xl font-bold flex items-center gap-2">
              <KeyRound></KeyRound>
            </h2>
            <div className="flex items-center gap-2">
              <Button
                title="Regenerate Passwords"
                variant="ghost"
                size="icon"
                onClick={generatePasswords}
                className="btn-ico hover:bg-gray-300 dark:hover:bg-gray-700"
              >
                <RotateCcw className="w-5 h-5"></RotateCcw>
              </Button>
              <Button
                title="Restore Default Settings"
                variant="ghost"
                size="icon"
                className="btn-ico hover:bg-gray-300 dark:hover:bg-gray-700"
                onClick={() => {
                  setLength(22);
                  setIncludeNumbers(true);
                  setIncludeSymbols(true);
                  setIncludeUppercase(true);
                  setCustomSymbols("!\";#$%&'()*+,-./:;<=>?@[]^_`{|}~");
                  setPasswordCount(3);
                }}
              >
                <ListRestart className="w-5 h-5"></ListRestart>
              </Button>
            </div>
          </div>

          <div className="col-span-2">
            <hr className="border-t my-2" />
          </div>

          <div className="mt-6 space-y-2">
            {generatedPasswords.map((pw, idx) => (
              <div
                key={idx}
                className="pt-1 pb-1 rounded-md flex items-center gap-2"
              >
                <Input readOnly value={pw} className="w-full" />

                {(() => {
                  const strength = passwordStrength(pw);
                  const colorMap = {
                    "Very Weak": "text-red-500",
                    Weak: "text-orange-500",
                    Moderate: "text-yellow-500",
                    Strong: "text-green-500",
                    "Very Strong": "text-emerald-500",
                  };
                  return (
                    <Button
                      variant="ghost"
                      size="icon"
                      onClick={() => {}}
                      title={strength}
                      className=""
                    >
                      {(strength == "Very Strong" || strength == "Strong") && (
                        <ShieldCheck
                          className={`w-4 h-4 ${colorMap[strength] || "text-gray-500"}`}
                        ></ShieldCheck>
                      )}

                      {strength == "Moderate" && (
                        <Shield
                          className={`w-4 h-4 ${colorMap[strength] || "text-gray-500"}`}
                        ></Shield>
                      )}

                      {(strength == "Weak" || strength == "Very Weak") && (
                        <ShieldAlert
                          className={`w-4 h-4 ${colorMap[strength] || "text-gray-500"}`}
                        ></ShieldAlert>
                      )}
                    </Button>
                  );
                })()}

                <Button
                  title="Copy to Clipboard"
                  variant="ghost"
                  size="icon"
                  onClick={() => handleCopy(pw, idx)}
                  className="btn-ico hover:bg-gray-300 dark:hover:bg-gray-700"
                >
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
            <Input
              type="number"
              value={passwordCount}
              onChange={(e) => setPasswordCount(Number(e.target.value))}
              className="w-full"
            />

            <span className="text-sm items-center">Password Length:</span>
            <Input
              type="number"
              value={length}
              onChange={(e) => setLength(Number(e.target.value))}
              className="w-full"
            />

            <span className="text-sm items-center">Include Numbers:</span>
            <Switch
              checked={includeNumbers}
              onCheckedChange={setIncludeNumbers}
            />

            <span className="text-sm items-center">Include Symbols:</span>
            <Switch
              checked={includeSymbols}
              onCheckedChange={setIncludeSymbols}
            />

            {includeSymbols && (
              <>
                <span className="text-sm items-center">Custom Symbols:</span>
                <Input
                  value={customSymbols}
                  onChange={(e) => setCustomSymbols(e.target.value)}
                  className="text-sm"
                />
              </>
            )}

            <span className="text-sm items-center">Include Uppercase:</span>
            <Switch
              checked={includeUppercase}
              onCheckedChange={setIncludeUppercase}
            />
          </div>
        </CardContent>
      </Card>
    </>
  );
}
