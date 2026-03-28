///|
fn main {
  match @clipboard.read_text() {
    Ok(Some(text)) => println("clipboard text: \{text}")
    Ok(None) => println("clipboard is empty")
    Err(error) => println("failed to read clipboard text: \{error}")
  }
}
