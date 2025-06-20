class RecordBase<T> {
  String itemName;
  String? folder;
  String? icon;

  T data;

  RecordBase({
    required this.itemName,
    required this.folder,
    required this.data,
    required this.icon,
  });
}
