import { Card, CardContent } from "@/src/components/card";
import Link from "next/link";
import { CheckSquare, SquareX } from "lucide-react";
import { Button } from "@/src/components/button";

export function AboutSection({ close }: SectionProps) {
  return (
    <Card className="rounded-2xl shadow-md">
      <CardContent className="space-y-4 p-6">
        <div className="flex items-center justify-between">
          <h3 className="text-md font-bold flex items-center gap-2">
            About PassTool
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

        <p className="text-sm">
          <strong>PassTool</strong> is an open-source password generator and
          vault that puts{" "}
          <span className="text-emerald-500 font-medium">
            your privacy first
          </span>
          .
        </p>

        <ul className="space-y-2 text-sm">
          <li className="flex items-start gap-2">
            <CheckSquare className="text-emerald-500  w-5 h-5" />
            Works 100% <strong>offline</strong>
          </li>
          <li className="flex items-start gap-2">
            <CheckSquare className="text-emerald-500 w-5 h-5" />
            Does <strong>not store your data</strong> on any server
          </li>
          <li className="flex items-start gap-2">
            <CheckSquare className="text-emerald-500 w-5 h-5" />
            Never sends your passwords, vault entries, or keys over the internet
          </li>
          <li className="flex items-start gap-2">
            <CheckSquare className="text-emerald-500 w-5 h-5" />
            Uses <strong>strong AES-GCM encryption</strong>
          </li>
          <li className="flex items-start gap-2">
            <CheckSquare className="text-emerald-500 w-5 h-5" />
            No account, no cloud, no tracking
          </li>
        </ul>

        <div>
          <h3 className="text-md font-medium mt-6 mb-2">
            Open Source for Transparency
          </h3>
          <p className="text-sm">
            PassTool is fully open source on GitHub. You can inspect the code,
            contribute, or host your own copy:
          </p>
          <Link
            href="https://github.com/cyberfish-dev/pass-tool"
            className="text-emerald-500 underline hover:text-emerald-400 text-sm"
            target="_blank"
            rel="noopener noreferrer"
          >
            github.com/cyberfish-dev/pass-tool
          </Link>
        </div>

        <div>
          <h3 className="text-md font-medium mt-6 mb-2">Why It Matters</h3>
          <p className="text-sm mb-4">We believe password tools should be:</p>
          <ul className="list-disc list-inside pl-4 space-y-1 text-sm">
            <li>Transparent in how they store and protect your data</li>
            <li>Secure without relying on cloud servers</li>
            <li>Simple, private, and under your control</li>
          </ul>
        </div>

        <p className="text-sm text-muted-foreground">
          Your secrets stay <strong>on your device</strong>. Always.
        </p>
      </CardContent>
    </Card>
  );
}
