import { useEffect, useState } from "react";
import MainPage from "@/pageParts/main";
import Head from "next/head";

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

  return (<>
    <Head>
      <title>PassTool - Secure Password Manager & Generator</title>

      <meta name="description" content="Generate strong passwords and store them securely — all offline. No tracking. No accounts." />
      <meta name="keywords" content="password manager, password generator, offline vault, AES encryption" />
      <meta name="robots" content="index, follow" />
      <link rel="canonical" href="https://pass-tool.com/" />

      {/* OpenGraph / Facebook */}
      <meta property="og:title" content="Secure Password Manager & Generator" />
      <meta property="og:description" content="Generate strong passwords and store them securely — all offline." />
      <meta property="og:image" content="/og-image.png" />
      <meta property="og:url" content="https://pass-tool.com/" />
      <meta property="og:type" content="website" />

      {/* Twitter Card */}
      <meta name="twitter:card" content="summary_large_image" />
      <meta name="twitter:title" content="Secure Password Manager & Generator" />
      <meta name="twitter:description" content="No tracking, no accounts — just local encryption." />
      <meta name="twitter:image" content="/og-image.png" />

      <link rel="manifest" href="/manifest.json?v=1.0.1" />
      <meta name="theme-color" content="#0f172a" />
      <link rel="apple-touch-icon" href="/web-app-manifest-192x192.png" />
      <meta name="apple-mobile-web-app-title" content="PassTool" />
      <link rel="icon" href="/favicon.ico" sizes="any" />
    </Head>

    <main className="min-h-screen p-4 md:p-8 space-y-6">
      <div className="max-w-xl mx-auto space-y-6">
        {mounted && <MainPage></MainPage>}
      </div>
    </main>
  </>);
}
