import type { Command } from "commander";
import { formatDocsLink } from "../terminal/links.js";
import { theme } from "../terminal/theme.js";
import { registerQrCli } from "./qr-cli.js";

export function registerJordybotCli(program: Command) {
  const jordybot = program
    .command("jordybot")
    .description("Legacy jordybot command aliases")
    .addHelpText(
      "after",
      () =>
        `\n${theme.muted("Docs:")} ${formatDocsLink("/cli/jordybot", "docs.openjordy.ai/cli/jordybot")}\n`,
    );
  registerQrCli(jordybot);
}
