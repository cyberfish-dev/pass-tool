import { useEffect, useState } from "react";
import GeneratorView from "./generator";
import VaultView from "./vault";
import Header from "./header";

if (typeof window !== "undefined" && "serviceWorker" in navigator) {
  window.addEventListener("load", () => {
    navigator.serviceWorker.register("/sw.js").catch(err => {
      console.error("Service Worker registration failed:", err);
    });
  });
}

export default function App() {

  const [mounted, setMounted] = useState<boolean>()

  useEffect(() => {
    setMounted(true);
  }, []);

  if (!mounted) {
    return (<></>);
  }

  return (
    <main className="min-h-screen p-4 md:p-8 space-y-6">
      <div className="max-w-xl mx-auto space-y-6">

        <Header />

        <GeneratorView></GeneratorView><VaultView></VaultView></div></main>)
}
