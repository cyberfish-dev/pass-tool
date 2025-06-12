import 'package:flutter/material.dart';
import 'package:flutter_app/models/form_base_state.dart';

abstract class BottomSheetAction<
  TData,
  T extends FormBaseState<StatefulWidget, TData>
> {
  final String title;
  final GlobalKey<T> formKey;

  const BottomSheetAction({required this.title, required this.formKey});

  Widget buildBody(BuildContext context);
  void onAction(BuildContext context, TData data);

  void showCustomBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.9,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(title),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          child: Text('Close'),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              final data = formKey.currentState!.getFormData();
                              onAction(context, data);
                            }
                          },
                          child: Text('Save'),
                        ),
                      ),
                    ],
                  ),
                ),

                // Body content
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [buildBody(context)],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
