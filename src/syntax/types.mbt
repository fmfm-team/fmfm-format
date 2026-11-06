///|
/// One attribute of a directive header, as written. Values are strings at this
/// level; the semantic stage interprets them.
#derive(ToJson, @debug.Debug)
pub(all) struct Attribute {
  key : String
  value : String
  key_range : @diagnostic.Range
  value_range : @diagnostic.Range
}

///|
/// A run of CommonMark prose. `source` keeps the original lines (joined with
/// `\n`, trailing newline included) so that a Markdown renderer sees exactly
/// what the author wrote.
#derive(ToJson, @debug.Debug)
pub(all) struct RawMarkdown {
  source : String
  range : @diagnostic.Range
}

///|
/// A `:::name{…}` … `:::` container before any interpretation of its name or
/// attributes.
#derive(ToJson, @debug.Debug)
pub(all) struct RawDirective {
  name : String
  attributes : Array[Attribute]
  body : Array[RawBlock]
  /// The whole directive, opening fence to closing fence (or end of file).
  range : @diagnostic.Range
  /// The opening fence line only; used for diagnostics about the header.
  header_range : @diagnostic.Range
  name_range : @diagnostic.Range
}

///|
#derive(ToJson, @debug.Debug)
pub(all) enum RawBlock {
  Markdown(RawMarkdown)
  Directive(RawDirective)
}

///|
/// The YAML text between the `---` fences (fences excluded), with the range of
/// that inner text.
#derive(ToJson, @debug.Debug)
pub(all) struct RawFrontMatter {
  source : String
  range : @diagnostic.Range
}

///|
#derive(ToJson, @debug.Debug)
pub(all) struct RawDocument {
  front_matter : RawFrontMatter?
  blocks : Array[RawBlock]
}

///|
#derive(ToJson, @debug.Debug)
pub(all) struct ParseResult {
  document : RawDocument
  diagnostics : Array[@diagnostic.Diagnostic]
}

///|
/// Look up an attribute by key (first occurrence).
pub fn RawDirective::attribute(self : RawDirective, key : String) -> Attribute? {
  for a in self.attributes {
    if a.key == key {
      return Some(a)
    }
  }
  None
}
