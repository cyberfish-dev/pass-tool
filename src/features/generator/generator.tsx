import { useState, useEffect } from "react";
import { Button } from "@/src/components/button";
import { Input } from "@/src/components/input";
import { Switch } from "@/src/components/switch";
import { Card, CardContent } from "@/src/components/card";
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
import { generatePassword, passwordStrength } from "@/src/lib/password";
import { usePasswordSettings } from "../common/usePasswordSettings";
import { handleCopy } from "@/src/lib/clipboard";

export default function GeneratorView() {
  const [copiedIndex, setCopiedIndex] = useState(null);

  const {
    length,
    setLength,
    includeNumbers,
    setIncludeNumbers,
    includeSymbols,
    setIncludeSymbols,
    includeUppercase,
    setIncludeUppercase,
    customSymbols,
    setCustomSymbols,
    passwordCount,
    setPasswordCount
  } = usePasswordSettings();
  
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
                  onClick={() => handleCopy(pw, idx, setCopiedIndex)}
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
