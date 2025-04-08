import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { SquareX } from "lucide-react";
import { useEffect, useState } from "react";

if (typeof window !== "undefined" && "serviceWorker" in navigator) {
  window.addEventListener("load", () => {
    navigator.serviceWorker.register("/sw.js").catch((err) => {
      console.error("Service Worker registration failed:", err);
    });
  });
}

export default function Footer() {
  const [currentDate, _setCurrentDate] = useState(new Date());
  const [currentPage, _setCurrentPage] = useState("");

  useEffect(() => {
    _setCurrentDate(new Date());
  }, []);

  return (
    <>
      {currentPage === "terms" && (
        <Card className="rounded-2xl shadow-md">
          <CardContent className="space-y-4 p-6">
            <div className="flex items-center justify-between">
              <h3 className="text-md font-bold flex items-center gap-2">
                Terms of Use
              </h3>

              <Button
                title="Regenerate Passwords"
                variant="ghost"
                size="icon"
                onClick={() => _setCurrentPage("")}
                className="btn-ico hover:bg-gray-300 dark:hover:bg-gray-700"
              >
                <SquareX className="w-5 h-5"></SquareX>
              </Button>
            </div>

            <div className="col-span-2">
              <hr className="border-t my-2" />
            </div>

            <div className="text-sm">
              Last updated: [April 1, 2025]
              <br />
              <br />
              Welcome to PassTool! These Terms of Use ("Terms") govern your
              access to and use of our website, including the password generator
              and vault features.
              <br />
              <br />
              By using our services, you agree to be bound by these Terms.
              <br />
              <br />
              1. Use of the Service
              <br />
              You may use our website solely for lawful purposes and in
              accordance with these Terms. You are responsible for securing any
              data you store or generate.
              <br />
              <br />
              2. No Account or Server Storage
              <br />
              We do not require user accounts. All vault data is encrypted and
              stored locally in your browser. We do not transmit or store
              passwords on our servers.
              <br />
              <br />
              3. Data Security
              <br />
              While we use client-side encryption (AES-GCM) to protect your
              vault, you are responsible for safeguarding your master password.
              We cannot recover lost vaults.
              <br />
              <br />
              4. Intellectual Property
              <br />
              All content, design, and code are the property of PassTool. You
              may not reproduce, modify, or distribute it without permission.
              <br />
              <br />
              5. No Warranty
              <br />
              This service is provided “as is” without warranties of any kind.
              We do not guarantee availability, accuracy, or security beyond our
              client-side implementation.
              <br />
              <br />
              6. Limitation of Liability
              <br />
              We are not liable for any loss, damage, or misuse of data
              generated or stored using this tool.
              <br />
              <br />
              7. Changes to Terms
              <br />
              We may update these Terms occasionally. Continued use after
              changes indicates your acceptance.
              <br />
            </div>
          </CardContent>
        </Card>
      )}

      {currentPage === "privacy" && (
        <Card className="rounded-2xl shadow-md">
          <CardContent className="space-y-4 p-6">
            <div className="flex items-center justify-between">
              <h3 className="text-md font-bold flex items-center gap-2">
                Privacy Policy
              </h3>

              <Button
                title="Regenerate Passwords"
                variant="ghost"
                size="icon"
                onClick={() => _setCurrentPage("")}
                className="btn-ico hover:bg-gray-300 dark:hover:bg-gray-700"
              >
                <SquareX className="w-5 h-5"></SquareX>
              </Button>
            </div>

            <div className="col-span-2">
              <hr className="border-t my-2" />
            </div>

            <div className="text-sm">
              Last updated: April 1, 2025
              <br />
              <br />
              At PassTool, we respect your privacy and are committed to
              protecting it. This Privacy Policy explains what information we
              collect and how we use it.
              <br />
              <br />
              1. No Account Required
              <br />
              Our app does not require user registration. We do not collect
              personal information such as your name, email address, or IP
              address.
              <br />
              <br />
              2. No Server-Side Data Storage
              <br />
              All data you generate or store, including passwords and vault
              entries, remains entirely on your device. We do not store,
              transmit, or access this data.
              <br />
              <br />
              3. Local Storage
              <br />
              Your password vault is encrypted and saved in your browser’s
              localStorage. Only you have access to this data, and it never
              leaves your device.
              <br />
              <br />
              4. Analytics (If Enabled)
              <br />
              We may use privacy-friendly, anonymous analytics to understand
              general usage trends (e.g., page visits). No personally
              identifiable information is collected.
              <br />
              <br />
              5. Cookies
              <br />
              We do not use cookies for tracking or advertising purposes.
              <br />
              <br />
              6. Third-Party Services
              <br />
              This app does not rely on external services or APIs that collect
              user data.
              <br />
              <br />
              7. Data Security
              <br />
              We use client-side encryption (AES-GCM) to protect vault data.
              However, it is your responsibility to safeguard your master
              password.
              <br />
              <br />
              8. Changes to This Policy
              <br />
              We may update this Privacy Policy. If we do, the “last updated”
              date at the top will reflect the latest revision.
              <br />
              <br />
            </div>
          </CardContent>
        </Card>
      )}

      <div className="flex justify-between items-center text-xs">
        © {currentDate.getFullYear()} PassTool v1.0.1
        <div className="flex gap-2">
          <span
            className="cursor-pointer hover:underline"
            onClick={() => _setCurrentPage("terms")}
          >
            Terms
          </span>
          <span
            className="cursor-pointer hover:underline"
            onClick={() => _setCurrentPage("privacy")}
          >
            Privacy
          </span>
        </div>
      </div>
    </>
  );
}
