const js = require("@eslint/js");
const pluginJest = require("eslint-plugin-jest");

module.exports = [
  js.configs.recommended,
  {
    ignores: ["node_modules", "dist"],
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
