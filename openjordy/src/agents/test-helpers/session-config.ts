import type { OpenJordyConfig } from "../../config/config.js";

export function createPerSenderSessionConfig(
  overrides: Partial<NonNullable<OpenJordyConfig["session"]>> = {},
): NonNullable<OpenJordyConfig["session"]> {
  return {
    mainKey: "main",
    scope: "per-sender",
    ...overrides,
  };
}
