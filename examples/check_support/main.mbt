///|
fn main {
  println("clipboard supported: \{@clipboard.is_supported()}")
  match @clipboard.ensure_supported() {
    Ok(_) => println("clipboard backend is available on this platform")
    Err(error) => println("clipboard backend is unavailable: \{error}")
  }
}
