export const passwordStrength = (pw) => {
    const length = pw.length;
    const hasUpper = /[A-Z]/.test(pw);
    const hasLower = /[a-z]/.test(pw);
    const hasNumber = /[0-9]/.test(pw);
    const hasSymbol = /[^A-Za-z0-9]/.test(pw);

    let score = 0;
    if (length >= 8) score += 1;
    if (length >= 12) score += 1;
    if (hasUpper) score += 1;
    if (hasLower) score += 1;
    if (hasNumber) score += 1;
    if (hasSymbol) score += 1;

    if (score >= 5) return "Very Strong";
    if (score === 4) return "Strong";
    if (score === 3) return "Moderate";
    if (score === 2) return "Weak";
    return "Very Weak";
  };

  export const generatePassword = (
    length,
    includeNumbers,
    includeSymbols,
    includeUppercase,
    customSymbols,
  ) => {
    let charset = "abcdefghijklmnopqrstuvwxyz";
    if (includeUppercase) charset += "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    if (includeNumbers) charset += "0123456789";
    if (includeSymbols) charset += customSymbols;

    let password = "";
    for (let i = 0; i < length; i++) {
      const randomIndex = Math.floor(Math.random() * charset.length);
      password += charset[randomIndex];
    }
    return password;
  };