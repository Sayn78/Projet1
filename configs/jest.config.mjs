import { fileURLToPath } from 'url';
import { dirname, resolve } from 'path';

const __dirname = dirname(fileURLToPath(import.meta.url));

export default {
  rootDir: resolve(__dirname, '..'),
  testMatch: ['**/tests/**/*.test.js'],
  transform: {},
};
