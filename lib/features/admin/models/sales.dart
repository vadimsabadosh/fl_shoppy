// ignore_for_file: public_member_api_docs, sort_constructors_first
class Sales {
  final String label;
  final int earning;

  Sales(this.label, this.earning);

  @override
  String toString() => 'Sales(label: $label, earning: $earning)';
}
