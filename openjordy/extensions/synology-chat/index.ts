import type { OpenJordyPluginApi } from "openjordy/plugin-sdk";
import { emptyPluginConfigSchema } from "openjordy/plugin-sdk";
import { createSynologyChatPlugin } from "./src/channel.js";
import { setSynologyRuntime } from "./src/runtime.js";

const plugin = {
  id: "synology-chat",
  name: "Synology Chat",
  description: "Native Synology Chat channel plugin for OpenJordy",
  configSchema: emptyPluginConfigSchema(),
  register(api: OpenJordyPluginApi) {
    setSynologyRuntime(api.runtime);
    api.registerChannel({ plugin: createSynologyChatPlugin() });
  },
};

export default plugin;
