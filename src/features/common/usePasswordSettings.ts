import { useState } from "react";

export function usePasswordSettings() {
    const saved = typeof window !== "undefined" ? localStorage.getItem("passwordSettings") : null;
    const parsed = saved ? JSON.parse(saved) : {};

    const [length, setLength] = useState(() => parsed.length ?? 22);
    const [includeNumbers, setIncludeNumbers] = useState(() => parsed.includeNumbers ?? true);
    const [includeSymbols, setIncludeSymbols] = useState(() => parsed.includeSymbols ?? true);
    const [includeUppercase, setIncludeUppercase] = useState(() => parsed.includeUppercase ?? true);

    const customSymbolsDefault = "!\";#$%&'()*+,-./:;<=>?@[]^_`{|}~";
    const [customSymbols, setCustomSymbols] = useState(() => parsed.customSymbols ?? customSymbolsDefault);

    const [passwordCount, setPasswordCount] = useState(() => {
        return parsed.passwordCount ?? 3;
    });

    return {
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
    };
}