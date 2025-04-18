export const handleCopy = (pw, idx, callback) => {
  if (navigator.clipboard && window.isSecureContext) {
    navigator.clipboard
      .writeText(pw)
      .then(() => {
        callback(idx);
        setTimeout(() => callback(null), 1500);
      })
      .catch(() => fallbackCopy(pw, idx, callback));
  } else {
    fallbackCopy(pw, idx, callback);
  }
};

export const fallbackCopy = (text, idx, callback) => {
  const textarea = document.createElement("textarea");
  textarea.value = text;
  textarea.style.position = "fixed";
  textarea.style.opacity = "0";
  document.body.appendChild(textarea);
  textarea.focus();
  textarea.select();
  try {
    document.execCommand("copy");
    callback(idx);
    setTimeout(() => callback(null), 1500);
  } catch (err) {
    console.error("Fallback copy failed", err);
  }
  document.body.removeChild(textarea);
};
