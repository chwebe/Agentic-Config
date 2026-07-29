# Git Commit Preview

Before executing any commit, always show a preview using the format below. Do not run the commit until after displaying it.

```
╔══ COMMIT PREVIEW ════════════════════════════════════════╗
║                                                          ║
║  <type(scope): description>                              ║
║                                                          ║
║  Changes                                                 ║
║  ├─ [M] <modified file>                                  ║
║  ├─ [A] <added file>                                     ║
║  └─ [D] <deleted file>                                   ║
║                                                          ║
╚══════════════════════════════════════════════════════════╝
```

Legend: `[M]` modified · `[A]` added · `[D]` deleted

Then proceed with the commit immediately after — no need to ask for confirmation unless something looks wrong.
