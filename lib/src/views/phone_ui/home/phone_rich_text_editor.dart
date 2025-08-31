import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:regexpo/src/blocs/blocs.dart';
import 'package:regexpo/src/repositories/impl/db/helper/default_data.dart';

class PhoneRichTextEditor extends StatefulWidget {
  const PhoneRichTextEditor({super.key});

  @override
  State<PhoneRichTextEditor> createState() => _PhoneRichTextEditorState();
}

class _PhoneRichTextEditorState extends State<PhoneRichTextEditor> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  
  // 文本样式状态
  bool _isBold = false;
  bool _isItalic = false;
  bool _isUnderline = false;
  Color _textColor = Colors.black;
  double _fontSize = 16.0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
    
    // 从MatchBloc获取初始内容
    final state = context.read<MatchBloc>().state;
    if (state.content.isNotEmpty) {
      _controller.text = state.content;
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    context.read<MatchBloc>().add(ChangeContent(content: _controller.text));
  }

  void _toggleBold() {
    setState(() {
      _isBold = !_isBold;
    });
  }

  void _toggleItalic() {
    setState(() {
      _isItalic = !_isItalic;
    });
  }

  void _toggleUnderline() {
    setState(() {
      _isUnderline = !_isUnderline;
    });
  }

  void _setTextColor(Color color) {
    setState(() {
      _textColor = color;
    });
  }

  void _setFontSize(double size) {
    setState(() {
      _fontSize = size;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('富文本编辑器'),
        actions: [
          // 样式按钮
          IconButton(
            icon: Icon(Icons.format_bold, color: _isBold ? Colors.blue : null),
            onPressed: _toggleBold,
          ),
          IconButton(
            icon: Icon(Icons.format_italic, color: _isItalic ? Colors.blue : null),
            onPressed: _toggleItalic,
          ),
          PopupMenuButton<Color>(
            icon: Icon(Icons.color_lens, color: _textColor),
            itemBuilder: (context) => [
              Colors.black,
              Colors.red,
              Colors.blue,
              Colors.green,
            ].map((color) => PopupMenuItem(
              value: color,
              child: Container(
                width: 24,
                height: 24,
                color: color,
              ),
            )).toList(),
            onSelected: _setTextColor,
          ),
        ],
      ),
      body: BlocBuilder<MatchBloc, MatchState>(
        builder: (context, state) {
          if (state.content.isEmpty) {
            return const Center(
              child: Text('请输入内容...'),
            );
          }
          
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              maxLines: null,
              expands: true,
              style: TextStyle(
                color: _textColor,
                fontWeight: _isBold ? FontWeight.bold : FontWeight.normal,
                fontStyle: _isItalic ? FontStyle.italic : FontStyle.normal,
                decoration: _isUnderline 
                  ? TextDecoration.underline 
                  : TextDecoration.none,
                fontSize: _fontSize,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: '在此输入文本...',
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.format_size),
              onPressed: () => _showFontSizeDialog(context),
            ),
            IconButton(
              icon: const Icon(Icons.format_clear),
              onPressed: () {
                setState(() {
                  _isBold = false;
                  _isItalic = false;
                  _isUnderline = false;
                  _textColor = Colors.black;
                  _fontSize = 16.0;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showFontSizeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('选择字体大小'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Slider(
              value: _fontSize,
              min: 12,
              max: 32,
              divisions: 5,
              label: _fontSize.round().toString(),
              onChanged: (value) {
                setState(() {
                  _fontSize = value;
                });
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
}