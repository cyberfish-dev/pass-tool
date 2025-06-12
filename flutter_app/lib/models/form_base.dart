abstract class FormBase<T> {
  /// Returns true if the form’s current data is valid.
  bool validate();

  /// Extracts the current form data (of type T).
  T getFormData();
}
