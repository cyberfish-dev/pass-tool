import { useEffect, useState } from "react";
import GeneratorView from "../features/generator/generator";
import VaultView from "../features/vault/vault";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/src/components/tabs";
import Footer from "@/src/layout/footer";
import { Button } from "@/src/components/button";
import { Moon, Sun } from "lucide-react";

export default function MainPage() {
  const [defaultValue, setDefaultValue] = useState(() => {
    const saved = localStorage.getItem("defValue");
    return saved ?? "generator";
  });

  const handleTabChange = (newTab: string) => {
    localStorage.setItem("defValue", newTab);
  };

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
    <>

      <Tabs
        defaultValue={defaultValue}
        onValueChange={handleTabChange}
        className="w-full"
      >

        <div className="flex justify-between items-center">

          <TabsList className="mb-2">
            <TabsTrigger value="generator">Password Generator</TabsTrigger>
            <TabsTrigger value="vault">Password Vault</TabsTrigger>
          </TabsList>

          <Button
            onClick={() => setDarkMode(!darkMode)}
            variant="ghost"
            size="icon"
            className="btn-ico hover:bg-gray-300 dark:hover:bg-gray-700"
          >
            {darkMode ? <Sun /> : <Moon />}
          </Button>
        </div>

        <TabsContent value="generator">
          <GeneratorView></GeneratorView>
        </TabsContent>

        <TabsContent value="vault">
          <VaultView></VaultView>
        </TabsContent>
      </Tabs>

      <Footer />
    </>
  );
}
