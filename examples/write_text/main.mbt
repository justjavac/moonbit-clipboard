///|
fn main {
  let text = "Hello from justjavac/clipboard!"
  match @clipboard.write_text(text) {
    Ok(_) => println("wrote clipboard text: \{text}")
    Err(error) => println("failed to write clipboard text: \{error}")
  }
}
