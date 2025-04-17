import { useEffect, useState } from "react";
import TermsSection from "./sections/terms";
import PrivacySection from "./sections/privacy";
import { AboutSection } from "./sections/about";

export default function Footer() {
  const [currentDate, _setCurrentDate] = useState(new Date());
  const [currentPage, _setCurrentPage] = useState("about");

  useEffect(() => {
    _setCurrentDate(new Date());
  }, []);

  return (
    <>
      {currentPage === "about" && (
        <AboutSection close={() => _setCurrentPage("")} />
      )}

      {currentPage === "terms" && (
        <TermsSection close={() => _setCurrentPage("")} />
      )}

      {currentPage === "privacy" && (
        <PrivacySection close={() => _setCurrentPage("")} />
      )}

      <div className="flex justify-between items-center text-xs">
        © {currentDate.getFullYear()} PassTool v1.0.4
        <div className="flex gap-2">
          <span
            className="cursor-pointer hover:underline"
            onClick={() => _setCurrentPage("about")}
          >
            About
          </span>
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
