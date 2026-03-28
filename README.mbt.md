# justjavac/clipboard [![CI](https://github.com/justjavac/moonbit-clipboard/actions/workflows/ci.yml/badge.svg)](https://github.com/justjavac/moonbit-clipboard/actions/workflows/ci.yml) [![Coverage](https://img.shields.io/badge/coverage-artifacts-blue)](https://github.com/justjavac/moonbit-clipboard/actions/workflows/ci.yml) [![Docs](https://img.shields.io/badge/docs-mooncakes.io-green)](https://mooncakes.io/docs/justjavac/clipboard)

Cross-platform native clipboard helpers for MoonBit.

This package provides a synchronous text clipboard API for Windows, macOS, and
Linux native builds.

CI uploads coverage artifacts for each workflow run. You can view the package
documentation at <https://mooncakes.io/docs/justjavac/clipboard>.

## Features

- `read_text() -> Result[String?, String]`
- `write_text(String) -> Result[Unit, String]`
- `is_supported()` and `ensure_supported()`
- Native-only package with platform-specific backends

## Platform Backends

- Windows: Win32 clipboard API
- macOS: `pbcopy` and `pbpaste`
- Linux: tries `wl-copy` / `wl-paste`, then `xclip`, then `xsel`

On Linux, at least one clipboard backend tool must be available at runtime.

## Install

```bash
moon add justjavac/clipboard
```

## Example

```mbt nocheck
///|
fn copy_message() -> Result[Unit, String] {
  @clipboard.write_text("Hello from MoonBit!")
}

///|
fn load_message() -> Result[String?, String] {
  @clipboard.read_text()
}
```

## Examples Directory

- `examples/check_support`: probe whether the current native platform is supported
- `examples/write_text`: write a fixed string into the system clipboard
- `examples/read_text`: read text from the system clipboard

Run them with:

```bash
moon run examples/check_support
moon run examples/write_text
moon run examples/read_text
```

## Testing

Run the default test suite and coverage summary:

```bash
moon test --target native
moon coverage analyze -p justjavac/clipboard -- -f summary
```

Run the optional clipboard integration test:

```bash
$env:MOONBIT_CLIPBOARD_RUN_INTEGRATION_TESTS = "1"
moon test --target native --filter "integration*"
```

The integration test writes a probe string into the system clipboard and then
tries to restore the previous text content.

## API Surface

```mbt check
///|
test "clipboard api is available" {
  ignore(@clipboard.is_supported)
  ignore(@clipboard.ensure_supported)
  ignore(@clipboard.read_text)
  ignore(@clipboard.write_text)
}
```

## Notes

- The package targets `native` only.
- Empty clipboard text is returned as `Ok(None)`.
- Backend failures are returned as `Err(String)`.
