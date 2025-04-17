export async function encryptData(
  data: string,
  password: string,
): Promise<{ iv: string; data: string }> {
  const enc = new TextEncoder();
  const salt = crypto.getRandomValues(new Uint8Array(16));
  const iv = crypto.getRandomValues(new Uint8Array(12));

  const keyMaterial = await getKeyMaterial(password);
  const key = await deriveKey(keyMaterial, salt);

  const encoded = enc.encode(data);
  const cipherText = await crypto.subtle.encrypt(
    { name: "AES-GCM", iv },
    key,
    encoded,
  );

  const combined = new Uint8Array(salt.length + cipherText.byteLength);
  combined.set(salt);
  combined.set(new Uint8Array(cipherText), salt.length);

  return {
    iv: uint8ArrayToBase64(iv),
    data: uint8ArrayToBase64(combined),
  };
}

function uint8ArrayToBase64(arr: Uint8Array) {
  return btoa(String.fromCharCode(...arr));
}

export async function decryptData(
  encrypted: { iv: string; data: string },
  password: string,
): Promise<string> {
  const dec = new TextDecoder();
  const iv = Uint8Array.from(atob(encrypted.iv), (c) => c.charCodeAt(0));
  const combined = Uint8Array.from(atob(encrypted.data), (c) =>
    c.charCodeAt(0),
  );
  const salt = combined.slice(0, 16);
  const data = combined.slice(16);

  const keyMaterial = await getKeyMaterial(password);
  const key = await deriveKey(keyMaterial, salt);

  const plainBuffer = await crypto.subtle.decrypt(
    { name: "AES-GCM", iv },
    key,
    data,
  );

  return dec.decode(plainBuffer);
}

async function getKeyMaterial(password: string) {
  const enc = new TextEncoder();
  return crypto.subtle.importKey(
    "raw",
    enc.encode(password),
    { name: "PBKDF2" },
    false,
    ["deriveKey"],
  );
}

async function deriveKey(keyMaterial: CryptoKey, salt: Uint8Array) {
  return crypto.subtle.deriveKey(
    {
      name: "PBKDF2",
      salt,
      iterations: 100000,
      hash: "SHA-256",
    },
    keyMaterial,
    { name: "AES-GCM", length: 256 },
    false,
    ["encrypt", "decrypt"],
  );
}