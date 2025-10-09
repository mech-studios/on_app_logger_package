import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

part 'log_reader.dart';

class AppLoggerWrapper extends StatefulWidget {
  const AppLoggerWrapper({
    super.key,
    this.isEnabled = kDebugMode,
    required this.child,
  });

  final bool isEnabled;
  final Widget child;

  @override
  State<AppLoggerWrapper> createState() => _AppLoggerWrapperState();

  static final ValueNotifier<String> _logNotifier = ValueNotifier<String>('');
  static final ValueNotifier<bool> _autoScrollNotifier = ValueNotifier<bool>(
    true,
  );

  static void log(String message) {
    _logNotifier.value += 'Log: $message\n';
  }
}

class _AppLoggerWrapperState extends State<AppLoggerWrapper> {
  bool isSmallLogReaderVisible = false;
  bool isBigReaderVisible = false;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Overlay(
      initialEntries: [
        OverlayEntry(
          builder: (_) => Scaffold(
            body: Column(
              children: [
                if (widget.isEnabled)
                  Container(
                    height: 80,
                    width: mediaQuery.size.width,
                    color: Colors.white,
                    alignment: Alignment.centerLeft,
                    child: SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Material(
                          color: Colors.transparent,
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: isBigReaderVisible
                                        ? Colors.grey.shade300
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    borderRadius: BorderRadius.circular(16),
                                    onTap: () {
                                      setState(() {
                                        isSmallLogReaderVisible = false;
                                        isBigReaderVisible =
                                            !isBigReaderVisible;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0,
                                        vertical: 8.0,
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.document_scanner_rounded,
                                            color: Colors.grey.shade800,
                                          ),
                                          const SizedBox(width: 8),
                                          const Text("Full Log Page"),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 24),
                                Container(
                                  decoration: BoxDecoration(
                                    color: isSmallLogReaderVisible
                                        ? Colors.grey.shade300
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    borderRadius: BorderRadius.circular(16),
                                    onTap: () {
                                      setState(() {
                                        isBigReaderVisible = false;
                                        isSmallLogReaderVisible =
                                            !isSmallLogReaderVisible;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0,
                                        vertical: 8.0,
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.document_scanner_rounded,
                                            color: Colors.grey.shade800,
                                          ),
                                          const SizedBox(width: 8),
                                          const Text("Toggle Small Log Reader"),
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
                  ),
                SizedBox(
                  width: mediaQuery.size.width,
                  height: mediaQuery.size.height - (widget.isEnabled ? 80 : 0),
                  child: Stack(
                    children: [
                      Positioned.fill(child: widget.child),
                      if (isSmallLogReaderVisible)
                        Positioned(
                          left: mediaQuery.size.width * 0.1,
                          right: mediaQuery.size.width * 0.1,
                          top: 30,
                          child: Material(
                            elevation: 6,
                            borderRadius: BorderRadius.circular(32),
                            color: Colors.white,
                            child: Container(
                              clipBehavior: Clip.hardEdge,
                              padding: const EdgeInsets.all(12),
                              width: mediaQuery.size.width * 0.8,
                              height: mediaQuery.size.width * 0.8,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(32),
                              ),
                              child: const _LogReader(),
                            ),
                          ),
                        ),
                      if (isBigReaderVisible)
                        const Positioned.fill(
                          child: Material(
                            elevation: 0,
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.all(12),
                              child: _LogReader(),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
