import 'package:flutter/material.dart';
import 'package:flutter_app/models/form_base_state.dart';
import 'package:pass_tool_core/pass_tool_core.dart';

abstract class BottomSheetAction<
  TData,
  T extends FormBaseState<StatefulWidget, TData>
> {
  final String title;
  final GlobalKey<T> formKey;

  const BottomSheetAction({required this.title, required this.formKey});

  Widget buildBody(BuildContext context, TData? data);
  void onAction(String? id, BuildContext context, TData data);
  TData? fetchData(VaultMetadataEntry? entry);

  void showCustomBottomSheet(BuildContext context, VaultMetadataEntry? vaultMetadataEntry) {
    
    final data = fetchData(vaultMetadataEntry);

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
                              onAction(vaultMetadataEntry?.id, context, data);
                            }
                          },
                          child: Text('Save'),
                        ),
                      ),
                    ],
                  ),
                ),

                Divider(height: 1, thickness: 1, color: Theme.of(context).dividerColor),
                
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      24,
                      24,
                      24,
                      // add bottom inset so content scrolls above the keyboard
                      24 + MediaQuery.of(context).viewInsets.bottom,
                    ),
                    child: SingleChildScrollView(child: buildBody(context, data)),
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
