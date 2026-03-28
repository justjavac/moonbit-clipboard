# Project Agents.md Guide

This repository is a [MoonBit](https://docs.moonbitlang.com) module for a
native clipboard package.

You can browse and install extra skills here:
<https://github.com/moonbitlang/skills>

## Repository Layout

- The module root contains `moon.mod.json`.
- The root package is defined by `moon.pkg` and exports `justjavac/clipboard`.
- Public API lives in `clipboard.mbt`.
- Native FFI glue lives in `clipboard_native.c`.
- Blackbox tests live in `*_test.mbt` and whitebox tests live in
  `*_wbtest.mbt`.
- `clipboard_integration_test.mbt` is opt-in because it touches the real system
  clipboard.
- `examples/` contains runnable example packages.
- Edit `README.mbt.md`; `README.md` is the repository-facing mirror/symlink.

## Project Conventions

- MoonBit source is organized in `///|` blocks. Block order is irrelevant, so
  focused block-by-block edits are preferred.
- Keep the public API small and stable. If you change exported functions, run
  `moon info` and review `pkg.generated.mbti`.
- Add `///` Markdown doc comments to public APIs when behavior changes or new
  APIs are introduced.
- Keep README examples aligned with the exported API and current behavior.
- When touching platform behavior, preserve the documented backend order:
  Windows Win32 API, macOS `pbcopy`/`pbpaste`, Linux `wl-copy`/`wl-paste` then
  `xclip` then `xsel`.
- Prefer keeping deprecated code in `deprecated.mbt` if the package ever grows
  compatibility shims.

## Validation Workflow

Use this order unless the task requires something narrower:

```powershell
moon check
moon test --target native
moon info
moon fmt
```

Additional repo-specific checks:

- Run `moon test --target native --filter "integration*"` only when
  `MOONBIT_CLIPBOARD_RUN_INTEGRATION_TESTS` is intentionally enabled.
- If README examples or doc comments include MoonBit code blocks, make sure they
  still typecheck as documentation tests.
- Review `pkg.generated.mbti` after `moon info`; unexpected API drift is usually
  a mistake.

## Testing Guidance

- Prefer assertion-style tests for stable helper behavior.
- Keep unit coverage in `clipboard_test.mbt` and `clipboard_wbtest.mbt`.
- Use the integration test only for real clipboard roundtrips and restore the
  previous clipboard content when possible.
- If behavior changes user-facing output or documented examples, update the
  corresponding README sections in the same branch.

## Tooling Notes

- `moon ide` is available for navigation helpers such as `peek-def`, `outline`,
  and `find-references`.
- `moon coverage analyze > uncovered.log` is useful when expanding tests.
- This package supports the `native` target only; avoid suggesting JS/Wasm
  validation for normal changes.
