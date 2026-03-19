import { describe, expect, it } from "vitest";
import { shortenText } from "./text-format.js";

describe("shortenText", () => {
  it("returns original text when it fits", () => {
    expect(shortenText("openjordy", 16)).toBe("openjordy");
  });

  it("truncates and appends ellipsis when over limit", () => {
    expect(shortenText("openjordy-status-output", 10)).toBe("openjordy-…");
  });

  it("counts multi-byte characters correctly", () => {
    expect(shortenText("hello🙂world", 7)).toBe("hello🙂…");
  });
});
