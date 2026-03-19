import { vi } from "vitest";
import { installChromeUserDataDirHooks } from "./chrome-user-data-dir.test-harness.js";

const chromeUserDataDir = { dir: "/tmp/openjordy" };
installChromeUserDataDirHooks(chromeUserDataDir);

vi.mock("./chrome.js", () => ({
  isChromeCdpReady: vi.fn(async () => true),
  isChromeReachable: vi.fn(async () => true),
  launchOpenJordyChrome: vi.fn(async () => {
    throw new Error("unexpected launch");
  }),
  resolveOpenJordyUserDataDir: vi.fn(() => chromeUserDataDir.dir),
  stopOpenJordyChrome: vi.fn(async () => {}),
}));
