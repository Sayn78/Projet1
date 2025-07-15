import js from "@eslint/js";
import pluginJest from "eslint-plugin-jest";

export default [
  js.configs.recommended,
  pluginJest.configs.recommended,
  {
    ignores: ["node_modules", "dist"],
    files: ["**/*.js", "**/*.ts"],
    rules: {
      semi: ["error", "always"],
      quotes: ["error", "double"]
    }
  }
];
