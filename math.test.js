import { add } from "./math.js";

test("additionne 2 + 3 = 5", () => {
  expect(add(2, 3)).toBe(5);
});
