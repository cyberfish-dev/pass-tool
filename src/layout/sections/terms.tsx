import { Button } from "@/src/components/button";
import { Card, CardContent } from "@/src/components/card";
import { SquareX } from "lucide-react";

export default function TermsSection({ close }: SectionProps) {

  return (
    <>

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
              onClick={() => close()}
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




    </>
  );
}
