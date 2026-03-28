///|
#borrow(name)
extern "C" fn test_getenv_ffi(name : Bytes) -> Bytes = "mb_clipboard_test_getenv"

///|
fn test_getenv(name : String) -> String? {
  let value = @utf8.decode_lossy(test_getenv_ffi(@utf8.encode(name))[:])
  if value.is_empty() {
    None
  } else {
    Some(value)
  }
}

///|
fn integration_tests_enabled() -> Bool {
  match test_getenv("MOONBIT_CLIPBOARD_RUN_INTEGRATION_TESTS") {
    Some("1") => true
    Some("true") => true
    Some("yes") => true
    Some("on") => true
    _ => false
  }
}

///|
fn restore_clipboard_text(original : String?) -> Result[Unit, String] {
  match original {
    Some(text) => @clipboard.write_text(text)
    None => @clipboard.write_text("")
  }
}

///|
test "integration write and read roundtrip" {
  guard integration_tests_enabled() else { return }

  guard @clipboard.is_supported() else {
    fail("integration tests were enabled on an unsupported platform")
  }

  let original = match @clipboard.read_text() {
    Ok(value) => value
    Err(error) => fail("failed to read clipboard before test: " + error)
  }

  let probe = "justjavac/clipboard integration probe"

  match @clipboard.write_text(probe) {
    Ok(_) => ()
    Err(error) => fail("failed to write clipboard probe text: " + error)
  }

  let roundtrip_result = @clipboard.read_text()

  match restore_clipboard_text(original) {
    Ok(_) => ()
    Err(error) => fail("failed to restore original clipboard text: " + error)
  }

  match roundtrip_result {
    Ok(value) => assert_eq(value, Some(probe))
    Err(error) => fail("failed to read clipboard probe text: " + error)
  }
}
