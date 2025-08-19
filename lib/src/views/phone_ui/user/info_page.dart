import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InfoPage extends StatelessWidget {
  final String title;
  final String content;
  final String? url;

  const InfoPage({
    super.key,
    required this.title,
    required this.content,
    this.url,
  });

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).colorScheme.surface;
    Color? titleColor = Theme.of(context).textTheme.displayMedium?.color;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: true,
        backgroundColor: color,
        title: Text(
          title,
          style: TextStyle(color: titleColor, fontSize: 16),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              content,
              style: const TextStyle(fontSize: 16, height: 1.6),
            ),
            if (url != null) ...[
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () => _copyUrl(context, url!),
                icon: const Icon(Icons.copy),
                label: const Text('复制链接'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  iconColor: Colors.white,
                  shape: const StadiumBorder(),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _copyUrl(BuildContext context, String url) async {
    await Clipboard.setData(ClipboardData(text: url));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('链接已复制到剪贴板')),
    );
  }
}
