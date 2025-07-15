import js from "@eslint/js";
import pluginJest from "eslint-plugin-jest";

export default [
  js.configs.recommended,
  {
    files: ["tests/**/*.js"], // Scopes les fichiers JS dans le dossier tests
    ignores: ["node_modules", "dist"],
    plugins: {
      jest: pluginJest
    },
    languageOptions: {
      globals: {
        ...pluginJest.environments.globals.globals
      }
    },
    rules: {
      semi: ["error", "always"],
      quotes: ["error", "double"]
    }
  }
];
