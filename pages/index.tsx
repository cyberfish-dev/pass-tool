import { useEffect, useState } from "react";
import MainPage from "@/pageParts/main";

if (typeof window !== "undefined" && "serviceWorker" in navigator) {
  window.addEventListener("load", () => {
    navigator.serviceWorker.register("/sw.js").catch((err) => {
      console.error("Service Worker registration failed:", err);
    });
  });
}

export default function App() {
  const [mounted, setMounted] = useState<boolean>();

  useEffect(() => {
    setMounted(true);
  }, []);

  if (!mounted) {
    return <></>;
  }

  return <MainPage></MainPage>;
}
