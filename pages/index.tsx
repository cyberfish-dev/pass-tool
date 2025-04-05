import { useEffect, useState } from "react";
import GeneratorView from "../pageParts/generator";
import VaultView from "../pageParts/vault";
import Header from "../pageParts/header";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";

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

        <Tabs defaultValue="generator" className="w-full">

          <TabsList className="mb-2">
            <TabsTrigger value="generator">Password Generator</TabsTrigger>
            <TabsTrigger value="vault">Password Vault</TabsTrigger>
          </TabsList>

          <TabsContent value="generator">

            <GeneratorView></GeneratorView>

          </TabsContent>

          <TabsContent value="vault">
            <VaultView></VaultView>
          </TabsContent>
        </Tabs>

      </div></main>)
}
