import type { OpenJordyConfig } from "./config.js";

export function ensurePluginAllowlisted(cfg: OpenJordyConfig, pluginId: string): OpenJordyConfig {
  const allow = cfg.plugins?.allow;
  if (!Array.isArray(allow) || allow.includes(pluginId)) {
    return cfg;
  }
  return {
    ...cfg,
    plugins: {
      ...cfg.plugins,
      allow: [...allow, pluginId],
    },
  };
}
