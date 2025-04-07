import { useEffect, useState } from "react";
import GeneratorView from "../pageParts/generator";
import VaultView from "../pageParts/vault";
import Header from "../pageParts/header";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import Footer from "@/pageParts/footer";

export default function MainPage() {
  const [defaultValue, setDefaultValue] = useState(() => {
    const saved = localStorage.getItem("defValue");
    return saved ?? "generator";
  });

  const handleTabChange = (newTab: string) => {
    localStorage.setItem("defValue", newTab);
  };

  return (
    <main className="min-h-screen p-4 md:p-8 space-y-6">
      <div className="max-w-xl mx-auto space-y-6">
        <Header />

        <Tabs
          defaultValue={defaultValue}
          onValueChange={handleTabChange}
          className="w-full"
        >
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

        <Footer />
      </div>
    </main>
  );
}
