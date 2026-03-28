# justjavac/clipboard

[![CI](https://github.com/justjavac/moonbit-clipboard/actions/workflows/ci.yml/badge.svg)](https://github.com/justjavac/moonbit-clipboard/actions/workflows/ci.yml) [![codecov](https://codecov.io/gh/justjavac/moonbit-clipboard/branch/main/graph/badge.svg)](https://codecov.io/gh/justjavac/moonbit-clipboard) [![Docs](https://img.shields.io/badge/docs-mooncakes.io-green)](https://mooncakes.io/docs/justjavac/clipboard)

Cross-platform native clipboard helpers for MoonBit.

`justjavac/clipboard` provides a small synchronous API for reading and writing
UTF-8 text on Windows, macOS, and Linux native builds. The package is focused
on plain text clipboard access and keeps the public surface intentionally small.

CI publishes a coverage summary for each workflow run. When Codecov is
configured, the coverage badge reflects the `main` branch coverage. Package
documentation is published at <https://mooncakes.io/docs/justjavac/clipboard>.

## Highlights

- Small public API: `is_supported`, `ensure_supported`, `read_text`, `write_text`
- Native-only package with platform-specific backends
- `read_text()` returns `Ok(None)` when the clipboard text is empty
- Linux support checks `wl-copy` / `wl-paste`, then `xclip`, then `xsel`
- Optional integration test that round-trips through the real system clipboard

## Install

```bash
moon add justjavac/clipboard
```

This module supports the `native` target only.

## Quick Start

```mbt check
///|
test "clipboard api can be called" {
  ignore(@clipboard.is_supported())
  ignore(@clipboard.ensure_supported())
  ignore(@clipboard.read_text())
  ignore(@clipboard.write_text("Hello from MoonBit!"))
}
```

## API Behavior

- `is_supported() -> Bool`
  Reports whether the current native platform has a backend implemented by this
  package.
- `ensure_supported() -> Result[Unit, String]`
  Returns `Ok(())` on supported platforms and a descriptive error otherwise.
- `read_text() -> Result[String?, String]`
  Returns `Ok(Some(text))` for clipboard text, `Ok(None)` for empty text, and
  `Err(String)` when clipboard access fails.
- `write_text(String) -> Result[Unit, String]`
  Replaces the current clipboard text and reports backend failures as
  `Err(String)`.

## Platform Backends

- Windows: Win32 clipboard API
- macOS: `pbcopy` and `pbpaste`
- Linux: tries `wl-copy` / `wl-paste`, then `xclip`, then `xsel`

On Linux, at least one of those command-line tools must be installed and
available on `PATH` at runtime.

## Examples

This repository ships three small runnable examples:

- `examples/check_support`: probe whether the current native platform is supported
- `examples/write_text`: write a fixed string into the system clipboard
- `examples/read_text`: read text from the system clipboard

Run them from the module root:

```bash
moon run examples/check_support
moon run examples/write_text
moon run examples/read_text
```

## Testing

Run the default test suite:

```bash
moon test --target native
```

To inspect coverage:

```bash
moon coverage analyze -p justjavac/clipboard -- -f summary
```

To publish coverage from GitHub Actions to the badge, configure the
`CODECOV_TOKEN` repository secret for Codecov uploads.

To run the optional integration test against the real clipboard:

```bash
$env:MOONBIT_CLIPBOARD_RUN_INTEGRATION_TESTS = "1"
moon test --target native --filter "integration*"
```

The integration test writes a probe string into the system clipboard, reads it
back, and then attempts to restore the previous clipboard text.

## Notes

- The package is designed for synchronous text clipboard operations only.
- Errors are surfaced as `Err(String)` to keep the API lightweight for callers.
- Unsupported targets return a consistent error message from both read and
  write operations.
