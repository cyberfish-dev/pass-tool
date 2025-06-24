class RecordBase<T> {
  
  String itemName;
  String? folder;
  String? icon;
  bool isTrashed;

  T data;

  RecordBase({    
    required this.itemName,
    required this.folder,
    required this.data,
    required this.icon,    
    required this.isTrashed,
  });
}
