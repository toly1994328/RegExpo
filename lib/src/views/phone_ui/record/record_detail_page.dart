import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:regexpo/src/models/models.dart';
import 'package:regexpo/src/blocs/blocs.dart';

class RecordDetailPage extends StatefulWidget {
  final Record record;

  const RecordDetailPage({
    super.key,
    required this.record,
  });

  @override
  State<RecordDetailPage> createState() => _RecordDetailPageState();
}

class _RecordDetailPageState extends State<RecordDetailPage> {
  String? _activeRegex;

  @override
  void initState() {
    super.initState();
    context.read<LinkRegexBloc>().loadLinkRegex(recordId: widget.record.id);
  }

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
          widget.record.title,
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
              '关联正则：',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            BlocBuilder<LinkRegexBloc, LinkRegexState>(
              builder: (context, state) {
                if (state is LoadedLinkRegexState) {
                  return _buildRegexList(state.regexes);
                } else if (state is EmptyLinkRegexState) {
                  return const Text('暂无关联正则',
                      style: TextStyle(color: Colors.grey));
                }
                return const CircularProgressIndicator();
              },
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Text(
                  '内容：',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => _copyContent(context),
                  icon: const Icon(Icons.copy, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: BlocBuilder<MatchBloc, MatchState>(
                builder: (context, state) {
                  if (state is MatchSuccess &&
                      state.content == widget.record.content) {
                    return SelectableText.rich(
                      TextSpan(children: [state.inlineSpan]),
                      style: const TextStyle(fontSize: 14, height: 1.6),
                    );
                  }
                  return SelectableText(
                    widget.record.content,
                    style: const TextStyle(fontSize: 14, height: 1.6),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRegexList(List<LinkRegex> regexes) {
    return Column(
      children: regexes
          .map((regex) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                  side: BorderSide(
                    color: _activeRegex == regex.regex
                        ? Theme.of(context).primaryColor
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: ListTile(
                  title: Text(
                    regex.regex,
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 14,
                      color: _activeRegex == regex.regex
                          ? Theme.of(context).primaryColor
                          : null,
                      fontWeight:
                          _activeRegex == regex.regex ? FontWeight.bold : null,
                    ),
                  ),
                  onTap: () => _activateRegex(context, regex.regex),
                ),
              ))
          .toList(),
    );
  }

  void _copyContent(BuildContext context) {
    Clipboard.setData(ClipboardData(text: widget.record.content));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('内容已复制到剪贴板')),
    );
  }

  void _activateRegex(BuildContext context, String regex) {
    setState(() {
      _activeRegex = regex;
    });

    // 激活内容的富文本显示
    context.read<MatchBloc>().add(ChangeRegex(pattern: regex));
    context
        .read<MatchBloc>()
        .add(ChangeContent(content: widget.record.content));
    //
    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text('已激活正则: $regex')),
    // );
  }
}
