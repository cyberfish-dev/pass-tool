import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/components/colored_password.dart';
import 'package:flutter_app/preferences/password_prefs.dart';
import 'package:pass_tool_core/pass_tool_core.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class PasswordGenerator extends StatefulWidget {
  const PasswordGenerator({super.key});

  @override
  PasswordGeneratorState createState() => PasswordGeneratorState();
}

class PasswordGeneratorState extends State<PasswordGenerator>
    with SingleTickerProviderStateMixin {
  late PasswordPrefs _prefs;
  bool _initComplete = false;

  // Generated password placeholder
  String _generated = '';

  @override
  void initState() {
    super.initState();

    PasswordPrefs.loadPrefs().then((p) {
      setState(() {
        _prefs = p;
        _initComplete = true;
      });
      _generatePassword();
    });
  }

  void _generatePassword() {
    final password = generatePassword(
      includeDigits: _prefs.useDigits,
      includeLower: _prefs.useLower,
      includeSymbols: _prefs.useSymbols,
      includeUpper: _prefs.useUpper,
      length: BigInt.from(_prefs.length.toInt()),
      minDigits: BigInt.from(_prefs.minDigits),
      minSymbols: BigInt.from(_prefs.minSymbols),
    );

    setState(() {
      _generated = password;
    });
  }

  void _settingsChanged() {
    if (_prefs.length < _getMinSliderValue()) {
      setState(() {
        _prefs.length = _getMinSliderValue();
      });
    }

    if (!_prefs.useDigits &&
        !_prefs.useSymbols &&
        !_prefs.useUpper &&
        !_prefs.useLower) {
      setState(() {
        _prefs.useLower = true;
      });
    }

    // Save the updated preferences
    PasswordPrefs.savePrefs(_prefs).then((_) {
      _generatePassword();
    });
  }

  void _copyPassword() {
    Clipboard.setData(ClipboardData(text: _generated));

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Password copied to clipboard')));
  }

  _getMinSliderValue() {
    var minLength = 1;

    if (_prefs.useDigits) {
      minLength += _prefs.minDigits;
    }

    if (_prefs.useSymbols) {
      minLength += _prefs.minSymbols;
    }

    if (_prefs.useUpper) {
      minLength += 1;
    }

    if (_prefs.useLower) {
      minLength += 1;
    }

    return minLength.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initComplete) {
      return Container();
    }

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
                    const SizedBox(width: 16),
                    IconButton(
                      icon: Icon(PhosphorIcons.shuffle(
                        PhosphorIconsStyle.fill,
                      ), color: Theme.of(context).colorScheme.primary),
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
                                label: _prefs.length.toInt().toString(),
                                value: _prefs.length,
                                onChanged: (v) {
                                  setState(() => _prefs.length = v);
                                  _settingsChanged();
                                },
                              ),
                            ),
                            Text(
                              '${_prefs.length.toInt()}',
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
                              value: _prefs.useUpper,
                              onChanged: (v) {
                                setState(() => _prefs.useUpper = v);
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
                              value: _prefs.useLower,
                              onChanged: (v) {
                                setState(() => _prefs.useLower = v);
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
                              value: _prefs.useDigits,
                              onChanged: (v) {
                                setState(() => _prefs.useDigits = v);
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
                              value: _prefs.useSymbols,
                              onChanged: (v) {
                                setState(() => _prefs.useSymbols = v);
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
                        opacity: _prefs.useDigits ? 1.0 : 0.4,
                        child: IgnorePointer(
                          ignoring: !_prefs.useDigits,
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
                                  onPressed: _prefs.minDigits > 0
                                      ? () {
                                          setState(() => _prefs.minDigits--);
                                          _settingsChanged();
                                        }
                                      : null,
                                ),
                                Text(
                                  '${_prefs.minDigits}',
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
                                    setState(() => _prefs.minDigits++);
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
                        opacity: _prefs.useSymbols ? 1.0 : 0.4,
                        child: IgnorePointer(
                          ignoring: !_prefs.useSymbols,
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
                                  onPressed: _prefs.minSymbols > 0
                                      ? () {
                                          setState(() => _prefs.minSymbols--);
                                          _settingsChanged();
                                        }
                                      : null,
                                ),
                                Text(
                                  '${_prefs.minSymbols}',
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
                                    setState(() => _prefs.minSymbols++);
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
