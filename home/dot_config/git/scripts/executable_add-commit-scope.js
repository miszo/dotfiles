import { $, file, write } from 'bun';

async function isSpecialGitOperation() {
  try {
    const { stdout } = await $`git status`.nothrow();

    const specialOperations = [
      'rebase in progress',
      'You are currently merging',
      'All conflicts fixed',
      'Merging'
    ];

    return specialOperations.some(op => stdout.toLowerCase().includes(op.toLowerCase()));
  } catch {
    return false;
  }
}

async function runInGitRepo(callback) {
  const { exitCode } = await $`git rev-parse --is-inside-work-tree`.nothrow().quiet();

  if (exitCode === 0) {
    return await callback();
  } else {
    console.error('Not a git repository');
  }
}

async function getBranchName() {
  return await $`git rev-parse --abbrev-ref HEAD`.nothrow().text();
}

function getCommitMessageFile() {
  return process.argv[2];
}

async function getCommitMessage() {
  const commitMessageFile = getCommitMessageFile();

  if (!commitMessageFile) {
    console.error('Commit message is required');
    process.exit(1);
  }

  return await file(commitMessageFile).text();
}

function splitCommitMessage(message) {
  const conventionalCommitRegex = /^(feat|fix|docs|style|refactor|test|chore)(\(([^)]+)\))?:\s*(.+)$/m;

  const match = message.match(conventionalCommitRegex);

  if (match) {
    const [, type, , existingScope, description] = match;

    return {
      type,
      existingScope,
      description
    };
  }

  console.error('Invalid commit message');
  process.exit(1);
}

function transformCommitMessage(originalMessage, branchName) {
  const ticketKeyMatch = branchName.match(/([A-Z]+-\d+)/);
  const ticketKey = ticketKeyMatch ? ticketKeyMatch[1] : null;
  const { type, existingScope, description } = splitCommitMessage(originalMessage);

  const scope = existingScope || ticketKey;

  return `${type}(${scope}): ${description}`;
}

async function main() {
  if (await isSpecialGitOperation()) {
    console.log('Skipping commit-msg hook during merge/rebase');
    process.exit(0);
  }

  const commitMessageFile = getCommitMessageFile();
  const originalMessage = await getCommitMessage();
  const branchName = await getBranchName();
  const transformedMessage = transformCommitMessage(originalMessage, branchName);

  await write(commitMessageFile, transformedMessage);
}


await runInGitRepo(main);
