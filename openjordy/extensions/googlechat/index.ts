import type { OpenJordyPluginApi } from "openjordy/plugin-sdk";
import { emptyPluginConfigSchema } from "openjordy/plugin-sdk";
import { googlechatDock, googlechatPlugin } from "./src/channel.js";
import { setGoogleChatRuntime } from "./src/runtime.js";

const plugin = {
  id: "googlechat",
  name: "Google Chat",
  description: "OpenJordy Google Chat channel plugin",
  configSchema: emptyPluginConfigSchema(),
  register(api: OpenJordyPluginApi) {
    setGoogleChatRuntime(api.runtime);
    api.registerChannel({ plugin: googlechatPlugin, dock: googlechatDock });
  },
};

export default plugin;
