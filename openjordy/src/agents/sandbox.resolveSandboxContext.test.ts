import { describe, expect, it } from "vitest";
import type { OpenJordyConfig } from "../config/config.js";
import { ensureSandboxWorkspaceForSession, resolveSandboxContext } from "./sandbox/context.js";

describe("resolveSandboxContext", () => {
  it("does not sandbox the agent main session in non-main mode", async () => {
    const cfg: OpenJordyConfig = {
      agents: {
        defaults: {
          sandbox: { mode: "non-main", scope: "session" },
        },
        list: [{ id: "main" }],
      },
    };

    const result = await resolveSandboxContext({
      config: cfg,
      sessionKey: "agent:main:main",
      workspaceDir: "/tmp/openjordy-test",
    });

    expect(result).toBeNull();
  }, 15_000);

  it("does not create a sandbox workspace for the agent main session in non-main mode", async () => {
    const cfg: OpenJordyConfig = {
      agents: {
        defaults: {
          sandbox: { mode: "non-main", scope: "session" },
        },
        list: [{ id: "main" }],
      },
    };

    const result = await ensureSandboxWorkspaceForSession({
      config: cfg,
      sessionKey: "agent:main:main",
      workspaceDir: "/tmp/openjordy-test",
    });

    expect(result).toBeNull();
  }, 15_000);

  it("treats main session aliases as main in non-main mode", async () => {
    const cfg: OpenJordyConfig = {
      session: { mainKey: "work" },
      agents: {
        defaults: {
          sandbox: { mode: "non-main", scope: "session" },
        },
        list: [{ id: "main" }],
      },
    };

    expect(
      await resolveSandboxContext({
        config: cfg,
        sessionKey: "main",
        workspaceDir: "/tmp/openjordy-test",
      }),
    ).toBeNull();

    expect(
      await resolveSandboxContext({
        config: cfg,
        sessionKey: "agent:main:main",
        workspaceDir: "/tmp/openjordy-test",
      }),
    ).toBeNull();

    expect(
      await ensureSandboxWorkspaceForSession({
        config: cfg,
        sessionKey: "work",
        workspaceDir: "/tmp/openjordy-test",
      }),
    ).toBeNull();

    expect(
      await ensureSandboxWorkspaceForSession({
        config: cfg,
        sessionKey: "agent:main:main",
        workspaceDir: "/tmp/openjordy-test",
      }),
    ).toBeNull();
  }, 15_000);
});
