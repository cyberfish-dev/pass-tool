import { Button } from "@/src/components/button";
import { Card, CardContent } from "@/src/components/card";
import { SquareX } from "lucide-react";

export default function PrivacySection({ close }: SectionProps) {

    return (
        <>
            <Card className="rounded-2xl shadow-md">
                <CardContent className="space-y-4 p-6">
                    <div className="flex items-center justify-between">
                        <h3 className="text-md font-bold flex items-center gap-2">
                            Privacy Policy
                        </h3>

                        <Button
                            title="Close"
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

        </>
    );
}
