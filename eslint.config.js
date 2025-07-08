import js from "@eslint/js";

export default [
  js.configs.recommended,
  {
    ignores: ["node_modules", "dist"], // ✅ nouvelle façon d’ignorer des fichiers
    files: ["**/*.js", "**/*.ts"],
    rules: {
      semi: ["error", "always"],
      quotes: ["error", "double"]
    }
  }
];

