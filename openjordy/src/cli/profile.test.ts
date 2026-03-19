import path from "node:path";
import { describe, expect, it } from "vitest";
import { formatCliCommand } from "./command-format.js";
import { applyCliProfileEnv, parseCliProfileArgs } from "./profile.js";

describe("parseCliProfileArgs", () => {
  it("leaves gateway --dev for subcommands", () => {
    const res = parseCliProfileArgs([
      "node",
      "openjordy",
      "gateway",
      "--dev",
      "--allow-unconfigured",
    ]);
    if (!res.ok) {
      throw new Error(res.error);
    }
    expect(res.profile).toBeNull();
    expect(res.argv).toEqual(["node", "openjordy", "gateway", "--dev", "--allow-unconfigured"]);
  });

  it("still accepts global --dev before subcommand", () => {
    const res = parseCliProfileArgs(["node", "openjordy", "--dev", "gateway"]);
    if (!res.ok) {
      throw new Error(res.error);
    }
    expect(res.profile).toBe("dev");
    expect(res.argv).toEqual(["node", "openjordy", "gateway"]);
  });

  it("parses --profile value and strips it", () => {
    const res = parseCliProfileArgs(["node", "openjordy", "--profile", "work", "status"]);
    if (!res.ok) {
      throw new Error(res.error);
    }
    expect(res.profile).toBe("work");
    expect(res.argv).toEqual(["node", "openjordy", "status"]);
  });

  it("rejects missing profile value", () => {
    const res = parseCliProfileArgs(["node", "openjordy", "--profile"]);
    expect(res.ok).toBe(false);
  });

  it.each([
    ["--dev first", ["node", "openjordy", "--dev", "--profile", "work", "status"]],
    ["--profile first", ["node", "openjordy", "--profile", "work", "--dev", "status"]],
  ])("rejects combining --dev with --profile (%s)", (_name, argv) => {
    const res = parseCliProfileArgs(argv);
    expect(res.ok).toBe(false);
  });
});

describe("applyCliProfileEnv", () => {
  it("fills env defaults for dev profile", () => {
    const env: Record<string, string | undefined> = {};
    applyCliProfileEnv({
      profile: "dev",
      env,
      homedir: () => "/home/peter",
    });
    const expectedStateDir = path.join(path.resolve("/home/peter"), ".openjordy-dev");
    expect(env.OPENJORDY_PROFILE).toBe("dev");
    expect(env.OPENJORDY_STATE_DIR).toBe(expectedStateDir);
    expect(env.OPENJORDY_CONFIG_PATH).toBe(path.join(expectedStateDir, "openjordy.json"));
    expect(env.OPENJORDY_GATEWAY_PORT).toBe("19001");
  });

  it("does not override explicit env values", () => {
    const env: Record<string, string | undefined> = {
      OPENJORDY_STATE_DIR: "/custom",
      OPENJORDY_GATEWAY_PORT: "19099",
    };
    applyCliProfileEnv({
      profile: "dev",
      env,
      homedir: () => "/home/peter",
    });
    expect(env.OPENJORDY_STATE_DIR).toBe("/custom");
    expect(env.OPENJORDY_GATEWAY_PORT).toBe("19099");
    expect(env.OPENJORDY_CONFIG_PATH).toBe(path.join("/custom", "openjordy.json"));
  });

  it("uses OPENJORDY_HOME when deriving profile state dir", () => {
    const env: Record<string, string | undefined> = {
      OPENJORDY_HOME: "/srv/openjordy-home",
      HOME: "/home/other",
    };
    applyCliProfileEnv({
      profile: "work",
      env,
      homedir: () => "/home/fallback",
    });

    const resolvedHome = path.resolve("/srv/openjordy-home");
    expect(env.OPENJORDY_STATE_DIR).toBe(path.join(resolvedHome, ".openjordy-work"));
    expect(env.OPENJORDY_CONFIG_PATH).toBe(
      path.join(resolvedHome, ".openjordy-work", "openjordy.json"),
    );
  });
});

describe("formatCliCommand", () => {
  it.each([
    {
      name: "no profile is set",
      cmd: "openjordy doctor --fix",
      env: {},
      expected: "openjordy doctor --fix",
    },
    {
      name: "profile is default",
      cmd: "openjordy doctor --fix",
      env: { OPENJORDY_PROFILE: "default" },
      expected: "openjordy doctor --fix",
    },
    {
      name: "profile is Default (case-insensitive)",
      cmd: "openjordy doctor --fix",
      env: { OPENJORDY_PROFILE: "Default" },
      expected: "openjordy doctor --fix",
    },
    {
      name: "profile is invalid",
      cmd: "openjordy doctor --fix",
      env: { OPENJORDY_PROFILE: "bad profile" },
      expected: "openjordy doctor --fix",
    },
    {
      name: "--profile is already present",
      cmd: "openjordy --profile work doctor --fix",
      env: { OPENJORDY_PROFILE: "work" },
      expected: "openjordy --profile work doctor --fix",
    },
    {
      name: "--dev is already present",
      cmd: "openjordy --dev doctor",
      env: { OPENJORDY_PROFILE: "dev" },
      expected: "openjordy --dev doctor",
    },
  ])("returns command unchanged when $name", ({ cmd, env, expected }) => {
    expect(formatCliCommand(cmd, env)).toBe(expected);
  });

  it("inserts --profile flag when profile is set", () => {
    expect(formatCliCommand("openjordy doctor --fix", { OPENJORDY_PROFILE: "work" })).toBe(
      "openjordy --profile work doctor --fix",
    );
  });

  it("trims whitespace from profile", () => {
    expect(formatCliCommand("openjordy doctor --fix", { OPENJORDY_PROFILE: "  jbopenjordy  " })).toBe(
      "openjordy --profile jbopenjordy doctor --fix",
    );
  });

  it("handles command with no args after openjordy", () => {
    expect(formatCliCommand("openjordy", { OPENJORDY_PROFILE: "test" })).toBe(
      "openjordy --profile test",
    );
  });

  it("handles pnpm wrapper", () => {
    expect(formatCliCommand("pnpm openjordy doctor", { OPENJORDY_PROFILE: "work" })).toBe(
      "pnpm openjordy --profile work doctor",
    );
  });
});
