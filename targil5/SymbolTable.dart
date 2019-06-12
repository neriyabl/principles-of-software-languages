class SymbolEntry {
  final String name;
  final String type;
  final String segment;
  final int offset;

  SymbolEntry(this.name, this.type, this.segment, this.offset);
}

class SymbolTable {
  final List<SymbolEntry> table = [];

  exist(name) {
    return table.any((entry) => entry.name == name);
  }

  SymbolEntry findByName(name) {
    return table.firstWhere((entry) => entry.name == name);
  }

  add(name, type, segment) {
    int offset = table.any((entry) => entry.segment == segment)
        ? table.lastWhere((entry) => entry.segment == segment).offset + 1
        : 0;
    table.add(SymbolEntry(name, type, segment, offset));
  }

  clear() {
    table.clear();
  }

  segmentLength(segment) {
    return table.any((entry) => entry.segment == segment)
        ? table.lastWhere((entry) => entry.segment == segment).offset + 1
        : 0;
  }
}
