import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegexDetailPage extends StatelessWidget {
  final String title;
  final String pattern;
  final String description;

  const RegexDetailPage({
    super.key,
    required this.title,
    required this.pattern,
    required this.description,
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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '描述：',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 24),
            Text(
              '正则表达式：',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: SelectableText(
                pattern,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _copyToClipboard(context),
                icon: const Icon(Icons.copy),
                label: const Text('复制正则表达式'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  iconColor: Colors.white,
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: pattern));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('正则表达式已复制到剪贴板')),
    );
  }
}
