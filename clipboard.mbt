///|
extern "C" fn platform_supported_ffi() -> Bool = "mb_clipboard_platform_supported"

///|
extern "C" fn read_text_ffi() -> Bytes = "mb_clipboard_read_text"

///|
#borrow(text)
extern "C" fn write_text_ffi(text : Bytes) -> Int = "mb_clipboard_write_text"

///|
extern "C" fn last_error_code_ffi() -> Int = "mb_clipboard_last_error_code"

///|
extern "C" fn last_error_message_ffi() -> Bytes = "mb_clipboard_last_error_message"

///|
fn decode_optional_text(bytes : Bytes) -> String? {
  let value = @utf8.decode_lossy(bytes[:])
  if value.is_empty() {
    None
  } else {
    Some(value)
  }
}

///|
fn decode_error_message(bytes : Bytes, default : String) -> String {
  let value = @utf8.decode_lossy(bytes[:])
  if value.is_empty() {
    default
  } else {
    value
  }
}

///|
fn unsupported_error_message() -> String {
  "clipboard package currently supports Windows, macOS, and Linux native builds only"
}

///|
fn ensure_supported_result(supported : Bool) -> Result[Unit, String] {
  if supported {
    Ok(())
  } else {
    Err(unsupported_error_message())
  }
}

///|
fn read_text_result(
  supported : Bool,
  bytes : Bytes,
  error_code : Int,
  error_message : Bytes,
) -> Result[String?, String] {
  if !supported {
    Err(unsupported_error_message())
  } else if error_code == 0 {
    Ok(decode_optional_text(bytes))
  } else {
    Err(decode_error_message(error_message, "clipboard read failed"))
  }
}

///|
fn write_text_result(
  supported : Bool,
  status : Int,
  error_message : Bytes,
) -> Result[Unit, String] {
  if !supported {
    Err(unsupported_error_message())
  } else if status == 0 {
    Ok(())
  } else {
    Err(decode_error_message(error_message, "clipboard write failed"))
  }
}

///|
fn read_text_with(
  supported : Bool,
  read : () -> Bytes,
  get_error_code : () -> Int,
  get_error_message : () -> Bytes,
) -> Result[String?, String] {
  if supported {
    read_text_result(true, read(), get_error_code(), get_error_message())
  } else {
    read_text_result(false, @utf8.encode(""), 0, @utf8.encode(""))
  }
}

///|
fn write_text_with(
  supported : Bool,
  text : String,
  write : (Bytes) -> Int,
  get_error_message : () -> Bytes,
) -> Result[Unit, String] {
  if supported {
    write_text_result(true, write(@utf8.encode(text)), get_error_message())
  } else {
    write_text_result(false, 1, @utf8.encode(""))
  }
}

///|
pub fn is_supported() -> Bool {
  platform_supported_ffi()
}

///|
pub fn ensure_supported() -> Result[Unit, String] {
  ensure_supported_result(is_supported())
}

///|
pub fn read_text() -> Result[String?, String] {
  read_text_with(
    is_supported(),
    read_text_ffi,
    last_error_code_ffi,
    last_error_message_ffi,
  )
}

///|
pub fn write_text(text : String) -> Result[Unit, String] {
  write_text_with(is_supported(), text, write_text_ffi, last_error_message_ffi)
}
