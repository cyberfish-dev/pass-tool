export type VaultEntry = {
  username: string;
  password: string;
  notes?: string;
};

export type Vault = {
  [key: string]: VaultEntry;
};