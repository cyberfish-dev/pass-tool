const isProd = process.env.NODE_ENV === "production";

const devCSP = `
  default-src 'self';
  script-src 'self' 'unsafe-eval';
  style-src 'self' 'unsafe-inline';
  img-src 'self' data:;
  connect-src 'self';
  font-src 'self';
  manifest-src 'self';
  worker-src 'self';
  object-src 'none';
  frame-src 'none';
  base-uri 'self';
`;

const prodCSP = `
  default-src 'self';
  script-src 'self';
  style-src 'self' 'unsafe-inline';
  img-src 'self' data:;
  connect-src 'self';
  font-src 'self';
  manifest-src 'self';
  worker-src 'self';
  base-uri 'self';
  object-src 'none';
  frame-src 'none';
`;

const securityHeaders = [
  {
    key: "Content-Security-Policy",
    value: (isProd ? prodCSP : devCSP).replace(/\s{2,}/g, " ").trim(),
  },
];

/** @type {import('next').NextConfig} */

const withPWA = require("next-pwa")({
  dest: "public",
  register: true,
  skipWaiting: true,
  disable: process.env.NODE_ENV === "development", // only enable in prod
  buildExcludes: [/dynamic-css-manifest\.json$/],
});

const nextConfig = {
  async headers() {
    return [
      {
        source: "/(.*)",
        headers: securityHeaders,
      },
    ];
  },
  reactStrictMode: true,
};

module.exports = withPWA(nextConfig);
