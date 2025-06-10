import 'package:flutter/material.dart';

void showCustomBottomSheet(BuildContext context, String title, Widget child) {
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
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Text(title, 
                    //style: Theme.of(context).textTheme.headlineSmall,
                    ),
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
                          // e.g. re-upload
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
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                    child
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
