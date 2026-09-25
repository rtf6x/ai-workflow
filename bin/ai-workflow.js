#!/usr/bin/env node
// ai-workflow installer. No dependencies, Node 18+.
//
//   npx -y github:rtf6x/ai-workflow            # install for the harness it finds
//   npx -y github:rtf6x/ai-workflow --dry-run  # show what it would do
//
// Copies the skills into the harness skills directory and merges the rules into
// the harness rules file between markers, so a second run updates the block
// instead of appending a second copy.

const fs = require("fs");
const os = require("os");
const path = require("path");

const START = "<!-- ai-workflow:start -->";
const END = "<!-- ai-workflow:end -->";

const HARNESSES = {
  claude: { skills: ".claude/skills", rules: ".claude/CLAUDE.md" },
  omp: { skills: ".omp/agent/skills", rules: ".omp/agent/AGENTS.md" },
  pi: { skills: ".pi/agent/skills", rules: ".pi/agent/AGENTS.md" },
  opencode: { skills: ".config/opencode/skills", rules: ".config/opencode/AGENTS.md" },
  zed: { skills: ".config/zed/skills", rules: ".config/zed/AGENTS.md" },
  hermes: { skills: ".hermes/skills", rules: ".hermes/SOUL.md" },
  agents: { skills: ".agents/skills", rules: ".agents/AGENTS.md" },
};

const ROOT = path.resolve(__dirname, "..");
const SKILLS_SRC = path.join(ROOT, "skills");
const RULES_DIR = path.join(ROOT, "rules");

function usage(exitCode) {
  const out = exitCode === 0 ? console.log : (m) => console.error(m);
  out(`ai-workflow - rules and skills for agent-assisted development

Usage
  npx -y github:rtf6x/ai-workflow [options]
  ai-workflow <command> [options]

Commands
  install (default)   copy the skills and merge the rules
  rules               print the rules to stdout (no changes)
  list                print the skill names
  help                this text

Options
  --harness <name>    ${Object.keys(HARNESSES).join(" | ")}
                      uses that harness's skills directory and rules file
  --dest <dir>        skills directory (overrides --harness)
  --rules-file <path> rules file to merge into (overrides --harness)
  --lang <en|ru>      rules language (default en)
  --link              symlink the skills instead of copying them
  --no-rules          skills only
  --dry-run           print the plan, change nothing
  --yes               do not ask anything

Nothing else is ever touched: skills are copied as their own folders, and the
rules go in between ${START} and ${END}.`);
  process.exit(exitCode);
}

function parseArgs(argv) {
  const opts = { command: "install", harness: null, dest: null, rulesFile: null, lang: "en", link: false, rules: true, dryRun: false, yes: false };
  const args = argv.slice();
  if (args[0] && !args[0].startsWith("-")) opts.command = args.shift();
  while (args.length) {
    const a = args.shift();
    switch (a) {
      case "--harness": opts.harness = args.shift(); break;
      case "--dest": opts.dest = args.shift(); break;
      case "--rules-file": opts.rulesFile = args.shift(); break;
      case "--lang": opts.lang = args.shift(); break;
      case "--link": opts.link = true; break;
      case "--no-rules": opts.rules = false; break;
      case "--dry-run": opts.dryRun = true; break;
      case "--yes": case "-y": opts.yes = true; break;
      case "--help": case "-h": usage(0); break;
      default:
        console.error(`unknown option: ${a}`);
        usage(1);
    }
  }
  if (opts.harness && !HARNESSES[opts.harness]) {
    console.error(`unknown harness: ${opts.harness} (known: ${Object.keys(HARNESSES).join(", ")})`);
    process.exit(1);
  }
  return opts;
}

function skillNames() {
  return fs.readdirSync(SKILLS_SRC, { withFileTypes: true })
    .filter((e) => e.isDirectory() && fs.existsSync(path.join(SKILLS_SRC, e.name, "SKILL.md")))
    .map((e) => e.name)
    .sort();
}

function detectHarnesses() {
  return Object.keys(HARNESSES).filter((name) => fs.existsSync(path.join(os.homedir(), path.dirname(HARNESSES[name].skills))));
}

async function ask(question) {
  if (!process.stdin.isTTY) return null;
  const readline = require("readline");
  const rl = readline.createInterface({ input: process.stdin, output: process.stdout });
  return new Promise((resolve) => rl.question(question, (answer) => { rl.close(); resolve(answer.trim()); }));
}

function copySkill(name, destDir, link) {
  const src = path.join(SKILLS_SRC, name);
  const target = path.join(destDir, name);
  if (fs.existsSync(target)) {
    const stat = fs.lstatSync(target);
    if (!stat.isSymbolicLink() && !stat.isDirectory()) return "kept (not a directory)";
    fs.rmSync(target, { recursive: true, force: true });
  }
  if (link) fs.symlinkSync(src, target, "dir");
  else fs.cpSync(src, target, { recursive: true });
  return link ? "linked" : "copied";
}

function mergeRules(rulesFile, body, lang, dryRun) {
  const block = `${START}\n<!-- generated from rules/agent-rules.${lang}.md - edit there, not here -->\n\n${body.trim()}\n\n${END}\n`;
  let existing = "";
  try { existing = fs.readFileSync(rulesFile, "utf8"); } catch {}
  let next;
  if (existing.includes(START) && existing.includes(END)) {
    const head = existing.slice(0, existing.indexOf(START));
    const tail = existing.slice(existing.indexOf(END) + END.length);
    next = head + block + tail.replace(/^\n+/, "");
  } else {
    next = existing ? `${existing.trimEnd()}\n\n${block}` : block;
  }
  if (!dryRun) {
    fs.mkdirSync(path.dirname(rulesFile), { recursive: true });
    fs.writeFileSync(rulesFile, next);
  }
  return existing ? (existing.includes(START) ? "updated block" : "merged into existing file") : "created";
}

async function main() {
  const opts = parseArgs(process.argv.slice(2));

  if (opts.command === "help") usage(0);

  if (opts.command === "rules") {
    const file = path.join(RULES_DIR, `agent-rules.${opts.lang}.md`);
    if (!fs.existsSync(file)) { console.error(`no rules for language: ${opts.lang}`); process.exit(1); }
    process.stdout.write(fs.readFileSync(file, "utf8"));
    return;
  }

  if (opts.command === "list") {
    console.log(skillNames().join("\n"));
    return;
  }

  if (opts.command !== "install") {
    console.error(`unknown command: ${opts.command}`);
    usage(1);
  }

  const names = skillNames();
  if (!names.length) { console.error(`no skills found in ${SKILLS_SRC}`); process.exit(1); }

  let harness = opts.harness;
  if (!harness && !opts.dest) {
    const found = detectHarnesses();
    if (found.length === 1) {
      harness = found[0];
    } else if (found.length > 1) {
      const answer = await ask(`Which harness? ${found.join(", ")} [${found[0]}]: `);
      harness = (answer || found[0]).toLowerCase();
      if (!HARNESSES[harness]) { console.error(`unknown harness: ${harness}`); process.exit(1); }
    } else {
      console.error("No harness found in your home directory. Point me at one:\n" +
        `  npx -y github:rtf6x/ai-workflow --dest ~/skills --rules-file ~/AGENTS.md\n\nKnown harnesses: ${Object.keys(HARNESSES).join(", ")}`);
      process.exit(1);
    }
  }

  const home = os.homedir();
  const skillsDir = opts.dest ? path.resolve(opts.dest.replace(/^~/, home)) : path.join(home, HARNESSES[harness].skills);
  const rulesFile = opts.rulesFile
    ? path.resolve(opts.rulesFile.replace(/^~/, home))
    : harness ? path.join(home, HARNESSES[harness].rules) : null;

  const rulesPath = path.join(RULES_DIR, `agent-rules.${opts.lang}.md`);
  if (opts.rules && !fs.existsSync(rulesPath)) { console.error(`no rules for language: ${opts.lang}`); process.exit(1); }

  console.log(`ai-workflow -> ${harness || "custom"}${opts.dryRun ? " (dry run)" : ""}`);
  console.log(`  skills: ${names.length} into ${skillsDir}${opts.link ? " (symlinked)" : ""}`);
  if (opts.rules) console.log(`  rules:  agent-rules.${opts.lang}.md into ${rulesFile}`);

  if (opts.dryRun) return;
  if (!opts.yes) {
    const answer = await ask("Proceed? [y/N]: ");
    if (answer !== null && !/^y(es)?$/i.test(answer)) { console.log("nothing changed"); return; }
  }

  fs.mkdirSync(skillsDir, { recursive: true });
  const tally = {};
  for (const name of names) {
    const outcome = copySkill(name, skillsDir, opts.link);
    tally[outcome] = (tally[outcome] || 0) + 1;
  }
  console.log(`  skills: ${Object.entries(tally).map(([k, v]) => `${v} ${k}`).join(", ")}`);

  if (opts.rules && rulesFile) {
    const body = fs.readFileSync(rulesPath, "utf8");
    console.log(`  rules:  ${mergeRules(rulesFile, body, opts.lang, false)} at ${rulesFile}`);
  }
  console.log(`\nDone. Restart your agent so it reads ${rulesFile || "the new rules"} and ${skillsDir}.`);
}

main().catch((err) => { console.error(err.message || err); process.exit(1); });
