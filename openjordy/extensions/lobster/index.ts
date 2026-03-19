import type {
  AnyAgentTool,
  OpenJordyPluginApi,
  OpenJordyPluginToolFactory,
} from "../../src/plugins/types.js";
import { createLobsterTool } from "./src/lobster-tool.js";

export default function register(api: OpenJordyPluginApi) {
  api.registerTool(
    ((ctx) => {
      if (ctx.sandboxed) {
        return null;
      }
      return createLobsterTool(api) as AnyAgentTool;
    }) as OpenJordyPluginToolFactory,
    { optional: true },
  );
}
