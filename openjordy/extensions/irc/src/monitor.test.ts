import { describe, expect, it } from "vitest";
import { resolveIrcInboundTarget } from "./monitor.js";

describe("irc monitor inbound target", () => {
  it("keeps channel target for group messages", () => {
    expect(
      resolveIrcInboundTarget({
        target: "#openjordy",
        senderNick: "alice",
      }),
    ).toEqual({
      isGroup: true,
      target: "#openjordy",
      rawTarget: "#openjordy",
    });
  });

  it("maps DM target to sender nick and preserves raw target", () => {
    expect(
      resolveIrcInboundTarget({
        target: "openjordy-bot",
        senderNick: "alice",
      }),
    ).toEqual({
      isGroup: false,
      target: "alice",
      rawTarget: "openjordy-bot",
    });
  });

  it("falls back to raw target when sender nick is empty", () => {
    expect(
      resolveIrcInboundTarget({
        target: "openjordy-bot",
        senderNick: " ",
      }),
    ).toEqual({
      isGroup: false,
      target: "openjordy-bot",
      rawTarget: "openjordy-bot",
    });
  });
});
