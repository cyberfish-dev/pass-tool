import 'package:flutter/material.dart';
import 'package:flutter_app/components/colored_password.dart';
import 'package:pass_tool_core/pass_tool_core.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

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
    final password = generatePassword(
      includeDigits: _useDigits,
      includeLower: _useLower,
      includeSymbols: _useSymbols,
      includeUpper: _useUpper,
      length: BigInt.from(_length.toInt()),
      minDigits: BigInt.from(_minDigits),
      minSymbols: BigInt.from(_minSymbols),
    );

    setState(() {
      _generated = password;
    });
  }

  void _settingsChanged() {
    if (_length < _getMinSliderValue()) {
      setState(() {
        _length = _getMinSliderValue();
      });
    }

    if (!_useDigits && !_useSymbols && !_useUpper && !_useLower) {
      setState(() {
        _useLower = true;
      });
    }

    // stub: handle settings changes if needed
    _generatePassword();
  }

  void _copyPassword() {
    // stub: copy to clipboard
  }

  _getMinSliderValue() {
    var minLength = 1;

    if (_useDigits) {
      minLength += _minDigits;
    }

    if (_useSymbols) {
      minLength += _minSymbols;
    }

    if (_useUpper) {
      minLength += 1;
    }

    if (_useLower) {
      minLength += 1;
    }

    return minLength.toDouble();
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
            margin: EdgeInsets.zero,
            child: Container(
              constraints: BoxConstraints(minHeight: 180),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    Expanded(child: ColoredPassword(_generated, 16.0)),
                    IconButton(
                      icon: Icon(Icons.refresh),
                      onPressed: _generatePassword,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(0, 48), // full width
              ),
              onPressed: _copyPassword,
              child: const Text('Copy'),
            ),
          ),
          const Divider(indent: 24, endIndent: 24),
          // Settings form
          Expanded(
            child: SingleChildScrollView(
              child: Card(
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: Row(
                          children: [
                            Text('Length:'),
                            Expanded(
                              child: Slider(
                                min: _getMinSliderValue(),
                                max: 128,
                                divisions: 124,
                                label: _length.toInt().toString(),
                                value: _length,
                                onChanged: (v) {
                                  setState(() => _length = v);
                                  _settingsChanged();
                                },
                              ),
                            ),
                            Text(
                              '${_length.toInt()}',
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ],
                        ),
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              height: 1,
                              indent: 15,
                              endIndent: 15,
                            ),
                          ),
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: Row(
                          children: [
                            Text('A-Z'),
                            Expanded(child: Container()),
                            Switch(
                              value: _useUpper,
                              onChanged: (v) {
                                setState(() => _useUpper = v);
                                _settingsChanged();
                              },
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              height: 1,
                              indent: 15,
                              endIndent: 15,
                            ),
                          ),
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: Row(
                          children: [
                            Text('a-z'),
                            Expanded(child: Container()),
                            Switch(
                              value: _useLower,
                              onChanged: (v) {
                                setState(() => _useLower = v);
                                _settingsChanged();
                              },
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              height: 1,
                              indent: 15,
                              endIndent: 15,
                            ),
                          ),
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: Row(
                          children: [
                            Text('0-9'),
                            Expanded(child: Container()),
                            Switch(
                              value: _useDigits,
                              onChanged: (v) {
                                setState(() => _useDigits = v);
                                _settingsChanged();
                              },
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              height: 1,
                              indent: 15,
                              endIndent: 15,
                            ),
                          ),
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                        child: Row(
                          children: [
                            Text('!@#\$%^&*'),
                            Expanded(child: Container()),
                            Switch(
                              value: _useSymbols,
                              onChanged: (v) {
                                setState(() => _useSymbols = v);
                                _settingsChanged();
                              },
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              height: 1,
                              indent: 15,
                              endIndent: 15,
                            ),
                          ),
                        ],
                      ),

                      // minimum numbers
                      AnimatedOpacity(
                        duration: Duration(milliseconds: 200),
                        opacity: _useDigits ? 1.0 : 0.4,
                        child: IgnorePointer(
                          ignoring: !_useDigits,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 8.0,
                              bottom: 8.0,
                            ),
                            child: Row(
                              children: [
                                Text('Minimum numbers'),
                                Expanded(child: Container()),
                                IconButton(
                                  icon: Icon(
                                    PhosphorIcons.minusCircle(
                                      PhosphorIconsStyle.thin,
                                    ),
                                  ),
                                  onPressed: _minDigits > 0
                                      ? () {
                                          setState(() => _minDigits--);
                                          _settingsChanged();
                                        }
                                      : null,
                                ),
                                Text(
                                  '$_minDigits',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.labelMedium,
                                ),
                                IconButton(
                                  icon: Icon(
                                    PhosphorIcons.plusCircle(
                                      PhosphorIconsStyle.thin,
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() => _minDigits++);
                                    _settingsChanged();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              height: 1,
                              indent: 15,
                              endIndent: 15,
                            ),
                          ),
                        ],
                      ),

                      // minimum symbols
                      AnimatedOpacity(
                        duration: Duration(milliseconds: 200),
                        opacity: _useSymbols ? 1.0 : 0.4,
                        child: IgnorePointer(
                          ignoring: !_useSymbols,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 8.0,
                              bottom: 8.0,
                            ),
                            child: Row(
                              children: [
                                Text('Minimum symbols'),
                                Expanded(child: Container()),
                                IconButton(
                                  icon: Icon(
                                    PhosphorIcons.minusCircle(
                                      PhosphorIconsStyle.thin,
                                    ),
                                  ),
                                  onPressed: _minSymbols > 0
                                      ? () {
                                          setState(() => _minSymbols--);
                                          _settingsChanged();
                                        }
                                      : null,
                                ),
                                Text(
                                  '$_minSymbols',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.labelMedium,
                                ),
                                IconButton(
                                  icon: Icon(
                                    PhosphorIcons.plusCircle(
                                      PhosphorIconsStyle.thin,
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() => _minSymbols++);
                                    _settingsChanged();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
