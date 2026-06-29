## Compatibility Matrix

`agent-rigor` acts as an intercepting harness. Here is what it works with out of the box:

| Agent / Harness | Compatibility | Notes |
|-----------------|---------------|-------|
| **Claude Code** | ✅ Full | Natively supports custom rules and lifecycle hooks |
| **Cursor** | ✅ Full | Enforced via `.cursorrules` and workspace sync |
| **Gemini CLI** | ✅ Full | Natively wraps the execution loop |
| **Aider** | 🚧 Partial | Custom architect mode required |