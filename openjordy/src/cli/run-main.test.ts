import { describe, expect, it } from "vitest";
import {
  rewriteUpdateFlagArgv,
  shouldEnsureCliPath,
  shouldRegisterPrimarySubcommand,
  shouldSkipPluginCommandRegistration,
} from "./run-main.js";

describe("rewriteUpdateFlagArgv", () => {
  it("leaves argv unchanged when --update is absent", () => {
    const argv = ["node", "entry.js", "status"];
    expect(rewriteUpdateFlagArgv(argv)).toBe(argv);
  });

  it("rewrites --update into the update command", () => {
    expect(rewriteUpdateFlagArgv(["node", "entry.js", "--update"])).toEqual([
      "node",
      "entry.js",
      "update",
    ]);
  });

  it("preserves global flags that appear before --update", () => {
    expect(rewriteUpdateFlagArgv(["node", "entry.js", "--profile", "p", "--update"])).toEqual([
      "node",
      "entry.js",
      "--profile",
      "p",
      "update",
    ]);
  });

  it("keeps update options after the rewritten command", () => {
    expect(rewriteUpdateFlagArgv(["node", "entry.js", "--update", "--json"])).toEqual([
      "node",
      "entry.js",
      "update",
      "--json",
    ]);
  });
});

describe("shouldRegisterPrimarySubcommand", () => {
  it("skips eager primary registration for help/version invocations", () => {
    expect(shouldRegisterPrimarySubcommand(["node", "openjordy", "status", "--help"])).toBe(false);
    expect(shouldRegisterPrimarySubcommand(["node", "openjordy", "-V"])).toBe(false);
    expect(shouldRegisterPrimarySubcommand(["node", "openjordy", "-v"])).toBe(false);
  });

  it("keeps eager primary registration for regular command runs", () => {
    expect(shouldRegisterPrimarySubcommand(["node", "openjordy", "status"])).toBe(true);
    expect(shouldRegisterPrimarySubcommand(["node", "openjordy", "acp", "-v"])).toBe(true);
  });
});

describe("shouldSkipPluginCommandRegistration", () => {
  it("skips plugin registration for root help/version", () => {
    expect(
      shouldSkipPluginCommandRegistration({
        argv: ["node", "openjordy", "--help"],
        primary: null,
        hasBuiltinPrimary: false,
      }),
    ).toBe(true);
  });

  it("skips plugin registration for builtin subcommand help", () => {
    expect(
      shouldSkipPluginCommandRegistration({
        argv: ["node", "openjordy", "config", "--help"],
        primary: "config",
        hasBuiltinPrimary: true,
      }),
    ).toBe(true);
  });

  it("skips plugin registration for builtin command runs", () => {
    expect(
      shouldSkipPluginCommandRegistration({
        argv: ["node", "openjordy", "sessions", "--json"],
        primary: "sessions",
        hasBuiltinPrimary: true,
      }),
    ).toBe(true);
  });

  it("keeps plugin registration for non-builtin help", () => {
    expect(
      shouldSkipPluginCommandRegistration({
        argv: ["node", "openjordy", "voicecall", "--help"],
        primary: "voicecall",
        hasBuiltinPrimary: false,
      }),
    ).toBe(false);
  });

  it("keeps plugin registration for non-builtin command runs", () => {
    expect(
      shouldSkipPluginCommandRegistration({
        argv: ["node", "openjordy", "voicecall", "status"],
        primary: "voicecall",
        hasBuiltinPrimary: false,
      }),
    ).toBe(false);
  });
});

describe("shouldEnsureCliPath", () => {
  it("skips path bootstrap for help/version invocations", () => {
    expect(shouldEnsureCliPath(["node", "openjordy", "--help"])).toBe(false);
    expect(shouldEnsureCliPath(["node", "openjordy", "-V"])).toBe(false);
    expect(shouldEnsureCliPath(["node", "openjordy", "-v"])).toBe(false);
  });

  it("skips path bootstrap for read-only fast paths", () => {
    expect(shouldEnsureCliPath(["node", "openjordy", "status"])).toBe(false);
    expect(shouldEnsureCliPath(["node", "openjordy", "--log-level", "debug", "status"])).toBe(false);
    expect(shouldEnsureCliPath(["node", "openjordy", "sessions", "--json"])).toBe(false);
    expect(shouldEnsureCliPath(["node", "openjordy", "config", "get", "update"])).toBe(false);
    expect(shouldEnsureCliPath(["node", "openjordy", "models", "status", "--json"])).toBe(false);
  });

  it("keeps path bootstrap for mutating or unknown commands", () => {
    expect(shouldEnsureCliPath(["node", "openjordy", "message", "send"])).toBe(true);
    expect(shouldEnsureCliPath(["node", "openjordy", "voicecall", "status"])).toBe(true);
    expect(shouldEnsureCliPath(["node", "openjordy", "acp", "-v"])).toBe(true);
  });
});
