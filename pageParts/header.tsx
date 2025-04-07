import { useEffect, useState } from "react";
import { Button } from "@/components/ui/button";
import { Moon, Sun } from "lucide-react";

if (typeof window !== "undefined" && "serviceWorker" in navigator) {
  window.addEventListener("load", () => {
    navigator.serviceWorker.register("/sw.js").catch((err) => {
      console.error("Service Worker registration failed:", err);
    });
  });
}

export default function Header() {
  const [darkMode, setDarkMode] = useState(() => {
    const stored = localStorage.getItem("darkMode");
    return stored !== null ? stored === "true" : true;
  });

  useEffect(() => {
    const root = document.documentElement;
    root.classList.remove("dark");
    root.classList.remove("light");

    if (darkMode) {
      root.classList.add("dark");
    } else {
      root.classList.add("light");
    }

    localStorage.setItem("darkMode", darkMode.toString());
  }, [darkMode]);

  return (
    <div className="flex justify-between items-center">
      <Button
        onClick={() => setDarkMode(!darkMode)}
        variant="ghost"
        size="icon"
        className="btn-ico hover:bg-gray-300 dark:hover:bg-gray-700"
      >
        {darkMode ? <Sun /> : <Moon />}
      </Button>
      <label className="flex items-center gap-2">
        <span className="text-xs color-emerald">Offline Mode</span>
      </label>
    </div>
  );
}
