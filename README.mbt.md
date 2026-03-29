# justjavac/clipboard

[![CI](https://github.com/justjavac/moonbit-clipboard/actions/workflows/ci.yml/badge.svg)](https://github.com/justjavac/moonbit-clipboard/actions/workflows/ci.yml) [![codecov](https://codecov.io/gh/justjavac/moonbit-clipboard/branch/main/graph/badge.svg)](https://codecov.io/gh/justjavac/moonbit-clipboard) [![Docs](https://img.shields.io/badge/docs-mooncakes.io-green)](https://mooncakes.io/docs/justjavac/clipboard)

Cross-platform native clipboard helpers for MoonBit.

This package provides a small synchronous API for reading and writing UTF-8
text on Windows, macOS, and Linux native builds.

## Install

```bash
moon add justjavac/clipboard
```

This package supports the `native` target only.

## Example

```mbt check
///|
test "clipboard api can be called" {
  ignore(@clipboard.is_supported())
  ignore(@clipboard.ensure_supported())
  ignore(@clipboard.read_text())
  ignore(@clipboard.write_text("Hello from MoonBit!"))
}
```

## API

- `is_supported() -> Bool`
- `ensure_supported() -> Result[Unit, String]`
- `read_text() -> Result[String?, String]`
- `write_text(String) -> Result[Unit, String]`

`read_text()` returns `Ok(None)` when the clipboard text is empty. Read and
write failures are returned as `Err(String)`.

## Platforms

- Windows: Win32 clipboard API
- macOS: `pbcopy` and `pbpaste`
- Linux: `wl-copy` / `wl-paste`, then `xclip`, then `xsel`

On Linux, at least one supported clipboard tool must be available on `PATH`.

## Examples

```bash
moon run examples/check_support
moon run examples/write_text
moon run examples/read_text
```

## Testing

```bash
moon test --target native
moon coverage analyze -p justjavac/clipboard -- -f summary
```

Optional integration test:

```bash
$env:MOONBIT_CLIPBOARD_RUN_INTEGRATION_TESTS = "1"
moon test --target native --filter "integration*"
```

## License

MIT. See [LICENSE](LICENSE).
