class DropboxController {
  final List<Map<String, dynamic>> items;
  final String displayField;
  final Function? onSelect;
  List<Map<String, dynamic>> selectedItems = [];
  bool optionAllSelected = true;
  bool loading = true;

  DropboxController(
      {required this.items,
      required this.displayField,
      required this.onSelect});
}
