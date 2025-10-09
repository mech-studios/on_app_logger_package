part of 'on_app_logger.dart';

class _LogReader extends StatefulWidget {
  const _LogReader();

  @override
  State<_LogReader> createState() => _LogReaderState();
}

class _LogReaderState extends State<_LogReader> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    AppLoggerWrapper._logNotifier.addListener(_onLogChanged);
  }

  @override
  void dispose() {
    AppLoggerWrapper._logNotifier.removeListener(_onLogChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onLogChanged() {
    if (AppLoggerWrapper._autoScrollNotifier.value) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_controller.hasClients) {
          _controller.jumpTo(_controller.position.maxScrollExtent);
        }
      });
    }
  }

  List<TextSpan> _parseTextWithLinks(String text, TextStyle baseStyle) {
    final RegExp linkRegex = RegExp(
      r'(?:http[s]?:\/\/)?(?:[a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}(?:\/[^\s<>]*)?',
    );

    final List<TextSpan> spans = [];
    int start = 0;

    for (final match in linkRegex.allMatches(text)) {
      if (match.start > start) {
        spans.add(TextSpan(text: text.substring(start, match.start)));
      }

      final String url = match.group(0)!;
      final String normalizedUrl =
          url.startsWith(RegExp(r'http', caseSensitive: false))
          ? url
          : 'https://$url';

      final Uri uri = Uri.parse(normalizedUrl);

      spans.add(
        TextSpan(
          text: url,
          style: baseStyle.copyWith(
            color: Colors.blue,
            decoration: TextDecoration.underline,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () async {
              await launchUrl(uri, mode: LaunchMode.externalApplication);
            },
        ),
      );

      start = match.end;
    }

    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start)));
    }

    return spans;
  }

  @override
  Widget build(BuildContext context) {
    const baseStyle = TextStyle(fontSize: 12, color: Colors.black);

    return Stack(
      children: [
        ValueListenableBuilder<String>(
          valueListenable: AppLoggerWrapper._logNotifier,
          builder: (context, value, child) {
            return Scrollbar(
              controller: _controller,
              thumbVisibility: true,
              child: SingleChildScrollView(
                controller: _controller,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: SelectableText.rich(
                      TextSpan(
                        style: baseStyle,
                        children: _parseTextWithLinks(value, baseStyle),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),

        ValueListenableBuilder<bool>(
          valueListenable: AppLoggerWrapper._autoScrollNotifier,
          builder: (context, autoScroll, child) {
            return Positioned(
              top: 12,
              right: 12,
              child: Material(
                color: autoScroll ? Colors.grey.shade300 : Colors.transparent,
                shape: const CircleBorder(),
                child: IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  icon: Icon(
                    autoScroll
                        ? Icons.arrow_downward
                        : Icons.arrow_downward_outlined,
                    color: Colors.grey.shade800,
                  ),
                  onPressed: () {
                    AppLoggerWrapper._autoScrollNotifier.value = !autoScroll;
                    if (!autoScroll && _controller.hasClients) {
                      _controller.jumpTo(_controller.position.maxScrollExtent);
                    }
                  },
                ),
              ),
            );
          },
        ),

        Positioned(
          top: 76,
          right: 12,
          child: IconButton(
            icon: Icon(
              Icons.delete_outline_rounded,
              color: Colors.grey.shade800,
            ),
            onPressed: () {
              AppLoggerWrapper._logNotifier.value = "";
            },
          ),
        ),
      ],
    );
  }
}
