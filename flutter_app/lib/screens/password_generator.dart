import 'package:flutter/material.dart';
import 'package:flutter_app/components/colored_password.dart';
import 'package:pass_tool_core/pass_tool_core.dart';

class PasswordGenerator extends StatefulWidget {
  const PasswordGenerator({super.key});

  @override
  PasswordGeneratorState createState() => PasswordGeneratorState();
}

class PasswordGeneratorState extends State<PasswordGenerator>
    with SingleTickerProviderStateMixin {
  // Form state
  double _length = 20;
  bool _useUpper = true;
  bool _useLower = true;
  bool _useDigits = true;
  bool _useSymbols = true;
  int _minDigits = 1;
  int _minSymbols = 1;

  // Generated password placeholder
  String _generated = '';

  @override
  void initState() {
    super.initState();
    // optionally generate initial password
    _generatePassword();
  }

  void _generatePassword() {

    final password = generatePassword(includeDigits: _useDigits, includeLower: _useLower,
        includeSymbols: _useSymbols, includeUpper: _useUpper, length: BigInt.from(_length.toInt()), minDigits: BigInt.from(_minDigits), minSymbols: BigInt.from(_minSymbols));  
    
    setState(() {
      _generated = password;
    });
  }

  void _copyPassword() {
    // stub: copy to clipboard
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 12),

          // Generated password display
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: ColoredPassword(_generated),
                  ),
                  IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: _generatePassword,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
            ),
            child: ElevatedButton(
              onPressed: _copyPassword,
              child: const Text('Copy'),
            ),
          ),
          const Divider(indent: 24, endIndent: 24),
          // Settings form
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Length slider
                  Text('Length: ${_length.toInt()}'),
                  Slider(
                    min: 4,
                    max: 64,
                    divisions: 60,
                    label: _length.toInt().toString(),
                    value: _length,
                    onChanged: (v) => setState(() => _length = v),
                  ),
                  // toggles
                  SwitchListTile(
                    title: const Text('A-Z'),
                    value: _useUpper,
                    onChanged: (v) => setState(() => _useUpper = v),
                  ),
                  SwitchListTile(
                    title: const Text('a-z'),
                    value: _useLower,
                    onChanged: (v) => setState(() => _useLower = v),
                  ),
                  SwitchListTile(
                    title: const Text('0-9'),
                    value: _useDigits,
                    onChanged: (v) => setState(() => _useDigits = v),
                  ),
                  SwitchListTile(
                    title: const Text('!@#\$%^&*'),
                    value: _useSymbols,
                    onChanged: (v) => setState(() => _useSymbols = v),
                  ),
                  // minimum numbers
                  const SizedBox(height: 8),
                  Text('Minimum numbers'),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove_circle_outline),
                        onPressed: _minDigits > 0
                            ? () => setState(() => _minDigits--)
                            : null,
                      ),
                      Text('$_minDigits'),
                      IconButton(
                        icon: Icon(Icons.add_circle_outline),
                        onPressed: () => setState(() => _minDigits++),
                      ),
                    ],
                  ),
                  // minimum symbols
                  const SizedBox(height: 8),
                  Text('Minimum symbols'),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove_circle_outline),
                        onPressed: _minSymbols > 0
                            ? () => setState(() => _minSymbols--)
                            : null,
                      ),
                      Text('$_minSymbols'),
                      IconButton(
                        icon: Icon(Icons.add_circle_outline),
                        onPressed: () => setState(() => _minSymbols++),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
