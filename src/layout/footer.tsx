import { useEffect, useState } from "react";
import TermsSection from "./sections/terms";
import PrivacySection from "./sections/privacy";
import { AboutSection } from "./sections/about";

export default function Footer() {
  const [currentDate, _setCurrentDate] = useState(new Date());

  const [currentPage, _setCurrentPage] = useState(() => {
    const stored = localStorage.getItem("sectionPage");
    return stored ?? "about";
  });

  const setCurrentPage = (page: string) => {
    _setCurrentPage(page);
    localStorage.setItem("sectionPage", page);
  };

  useEffect(() => {
    _setCurrentDate(new Date());
  }, []);

  return (
    <>
      {currentPage === "about" && (
        <AboutSection close={() => setCurrentPage("")} />
      )}

      {currentPage === "terms" && (
        <TermsSection close={() => setCurrentPage("")} />
      )}

      {currentPage === "privacy" && (
        <PrivacySection close={() => setCurrentPage("")} />
      )}

      <div className="flex justify-between items-center text-xs">
        © {currentDate.getFullYear()} PassTool v1.0.4
        <div className="flex gap-2">
          <span
            className="cursor-pointer hover:underline"
            onClick={() => setCurrentPage("about")}
          >
            About
          </span>
          <span
            className="cursor-pointer hover:underline"
            onClick={() => setCurrentPage("terms")}
          >
            Terms
          </span>
          <span
            className="cursor-pointer hover:underline"
            onClick={() => setCurrentPage("privacy")}
          >
            Privacy
          </span>
        </div>
      </div>
    </>
  );
}
