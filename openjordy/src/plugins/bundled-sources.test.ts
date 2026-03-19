import { beforeEach, describe, expect, it, vi } from "vitest";
import { findBundledPluginSource, resolveBundledPluginSources } from "./bundled-sources.js";

const discoverOpenJordyPluginsMock = vi.fn();
const loadPluginManifestMock = vi.fn();

vi.mock("./discovery.js", () => ({
  discoverOpenJordyPlugins: (...args: unknown[]) => discoverOpenJordyPluginsMock(...args),
}));

vi.mock("./manifest.js", () => ({
  loadPluginManifest: (...args: unknown[]) => loadPluginManifestMock(...args),
}));

describe("bundled plugin sources", () => {
  beforeEach(() => {
    discoverOpenJordyPluginsMock.mockReset();
    loadPluginManifestMock.mockReset();
  });

  it("resolves bundled sources keyed by plugin id", () => {
    discoverOpenJordyPluginsMock.mockReturnValue({
      candidates: [
        {
          origin: "global",
          rootDir: "/global/feishu",
          packageName: "@openjordy/feishu",
          packageManifest: { install: { npmSpec: "@openjordy/feishu" } },
        },
        {
          origin: "bundled",
          rootDir: "/app/extensions/feishu",
          packageName: "@openjordy/feishu",
          packageManifest: { install: { npmSpec: "@openjordy/feishu" } },
        },
        {
          origin: "bundled",
          rootDir: "/app/extensions/feishu-dup",
          packageName: "@openjordy/feishu",
          packageManifest: { install: { npmSpec: "@openjordy/feishu" } },
        },
        {
          origin: "bundled",
          rootDir: "/app/extensions/msteams",
          packageName: "@openjordy/msteams",
          packageManifest: { install: { npmSpec: "@openjordy/msteams" } },
        },
      ],
      diagnostics: [],
    });

    loadPluginManifestMock.mockImplementation((rootDir: string) => {
      if (rootDir === "/app/extensions/feishu") {
        return { ok: true, manifest: { id: "feishu" } };
      }
      if (rootDir === "/app/extensions/msteams") {
        return { ok: true, manifest: { id: "msteams" } };
      }
      return {
        ok: false,
        error: "invalid manifest",
        manifestPath: `${rootDir}/openjordy.plugin.json`,
      };
    });

    const map = resolveBundledPluginSources({});

    expect(Array.from(map.keys())).toEqual(["feishu", "msteams"]);
    expect(map.get("feishu")).toEqual({
      pluginId: "feishu",
      localPath: "/app/extensions/feishu",
      npmSpec: "@openjordy/feishu",
    });
  });

  it("finds bundled source by npm spec", () => {
    discoverOpenJordyPluginsMock.mockReturnValue({
      candidates: [
        {
          origin: "bundled",
          rootDir: "/app/extensions/feishu",
          packageName: "@openjordy/feishu",
          packageManifest: { install: { npmSpec: "@openjordy/feishu" } },
        },
      ],
      diagnostics: [],
    });
    loadPluginManifestMock.mockReturnValue({ ok: true, manifest: { id: "feishu" } });

    const resolved = findBundledPluginSource({
      lookup: { kind: "npmSpec", value: "@openjordy/feishu" },
    });
    const missing = findBundledPluginSource({
      lookup: { kind: "npmSpec", value: "@openjordy/not-found" },
    });

    expect(resolved?.pluginId).toBe("feishu");
    expect(resolved?.localPath).toBe("/app/extensions/feishu");
    expect(missing).toBeUndefined();
  });

  it("finds bundled source by plugin id", () => {
    discoverOpenJordyPluginsMock.mockReturnValue({
      candidates: [
        {
          origin: "bundled",
          rootDir: "/app/extensions/diffs",
          packageName: "@openjordy/diffs",
          packageManifest: { install: { npmSpec: "@openjordy/diffs" } },
        },
      ],
      diagnostics: [],
    });
    loadPluginManifestMock.mockReturnValue({ ok: true, manifest: { id: "diffs" } });

    const resolved = findBundledPluginSource({
      lookup: { kind: "pluginId", value: "diffs" },
    });
    const missing = findBundledPluginSource({
      lookup: { kind: "pluginId", value: "not-found" },
    });

    expect(resolved?.pluginId).toBe("diffs");
    expect(resolved?.localPath).toBe("/app/extensions/diffs");
    expect(missing).toBeUndefined();
  });
});
