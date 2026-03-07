# Riverpod Code Generation

## Standard Commands

### Development: watch -d (99% of time)

dart run build_runner watch -d

### CI/Production/Release: build -d

dart run build_runner build -d

### Nuclear option (resets everything)

dart run build_runner clean
dart run build_runner build -d

to set up the code the first time:
dart run build_runner build -d

If using code-generation, you can now run the code-generator with:
dart run build_runner watch -d

| Command                     | What it does                                                                                                                           | When to use                                   |
| --------------------------- | -------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------- |
| dart run build_runner build | One-time build. Generates all .g.dart files once, then exits.                                                                          | Initial setup, CI/CD, production builds       |
| dart run build_runner watch | Continuous watch mode. Runs a persistent server that watches file changes and auto-regenerates on save. Doesn't exit (Ctrl+C to stop). | Development workflow (save → instant codegen) |

## Build

### When to use -d with build

| Scenario                 | Use -d? | Reason                                                                             |
| ------------------------ | ------- | ---------------------------------------------------------------------------------  |
| CI/CD pipelines          | ✅ Yes   | One-time clean builds. Deletes conflicts automatically—no manual cleanup qiita+1. |
| Production builds        | ✅ Yes   | Ensures all .g.dart files are fresh before release.                               |
| Dependency updates       | ✅ Yes   | After pub get for new Riverpod/freezed versions—handles schema changes github​.    |
| After build_runner clean | ✅ Yes   | Standard follow-up: clean && build -d for complete regeneration.                  |
| First-time codegen       | ✅ Yes   | Generates everything cleanly from scratch.                                        |

### When Not to Use -d with build

| Scenario                   | Use -d?  | Reason                                                                                           |
| -------------------------- | -------- | ----------------------------------------------------------------------------------------------   |
| Debugging conflicts        | ❌ No     | Without -d, you'll see exactly which .g.dart files conflict—easier to diagnose generator bugs.  |
| Incremental builds         | ⚠️ Maybe | If you're confident no conflicts exist, skip -d for slightly faster builds (rare).               |
| Multiple concurrent builds | ❌ No     | Same race condition risk as watch -d—file locking errors github​.                              |

## Watch

### when to use -d with watch

| Scenario                 | Use -d? | Reason                                                                                                                   |
| ------------------------ | ------- | ------------------------------------------------------------------------------------------------------------------------ |
| Standard development     | ✅ Yes   | Deletes stale .g.dart files automatically. Prevents "conflicting outputs" errors during normal editing codewithandrea+1. |
| First time setup         | ✅ Yes   | Handles any existing generated files cleanly without prompts.                                                            |
| After dependency changes | ✅ Yes   | Ensures clean regeneration when generators change (Riverpod/freezed versions) mobx.netlify​.                             |
| Hot reload workflow      | ✅ Yes   | Fastest iteration—edits always trigger fresh builds bugsee​.                                                             |

When Not to Use -d with watch:

| Scenario                         | Use -d?                 | Reason                                                                                            |
| -------------------------------- | ----------------------- | ------------------------------------------------------------------------------------------------- |
| Multiple watch instances running | ❌ No                    | Concurrent deletes cause race conditions/file locking errors github​. Kill other processes first. |
| Manual file management           | ❌ Maybe                 | If you're manually editing .g.dart files (rare/unsupported), -d will delete your changes.         |
| CI/CD pipelines                  | ⚠️ Use build -d instead | watch doesn't fit CI; use one-time build --delete-conflicting-outputs.                            |
| Debugging generator issues       | ❌ No                    | Without -d, you'll see exactly which files conflict, helping diagnose generator problems.         |

✅ ALWAYS: dart run build_runner watch -d
❌ NEVER:  Run multiple watch instances simultaneously
🔄 FIRST:  dart run build_runner clean  (if errors persist)
