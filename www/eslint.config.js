import js from "@eslint/js";
import pluginJest from "eslint-plugin-jest";

export default [
  js.configs.recommended,
  {
    ignores: ["node_modules", "dist"], // ✅ nouvelle façon d’ignorer des fichiers
    files: ["**/*.js", "**/*.ts"],
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