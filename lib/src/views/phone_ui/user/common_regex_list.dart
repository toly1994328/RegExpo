import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'regex_detail_page.dart';

class CommonRegexList extends StatelessWidget {
  const CommonRegexList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        _buildSection('基础验证', [
          _RegexItem('邮箱地址',
              r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$', '验证邮箱格式'),
          _RegexItem(
              '手机号码',
              r'^[1](([3][0-9])|([4][0,1,4-9])|([5][0-3,5-9])|([6][2,5,6,7])|([7][0-8])|([8][0-9])|([9][0-3,5-9]))[0-9]{8}$',
              '验证中国大陆手机号'),
          _RegexItem('身份证号', r'^\d{17}[\dXx]$', '验证18位身份证号'),
          _RegexItem(
              '密码强度',
              r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d@$!%*?&]{8,}$',
              '至少8位，包含大小写字母和数字'),
        ]),
        _buildSection('数字匹配', [
          _RegexItem('整数', r'^-?\d+$', '匹配正负整数'),
          _RegexItem('小数', r'^-?\d+\.\d+$', '匹配小数'),
          _RegexItem('正数', r'^\d*\.?\d+$', '匹配正数（整数或小数）'),
          _RegexItem('价格格式', r'^\d+(\.\d{1,2})?$', '匹配价格（最多两位小数）'),
        ]),
        _buildSection('日期时间', [
          _RegexItem('日期 YYYY-MM-DD', r'^\d{4}-\d{2}-\d{2}$', '标准日期格式'),
          _RegexItem('时间 HH:MM', r'^([01]\d|2[0-3]):[0-5]\d$', '24小时制时间'),
          _RegexItem('日期时间',
              r'^\d{4}-\d{2}-\d{2} ([01]\d|2[0-3]):[0-5]\d:[0-5]\d$', '完整日期时间'),
        ]),
        _buildSection('网络相关', [
          _RegexItem(
              'URL地址', r'^https?://[^\s/$.?#].[^\s]*$', '匹配HTTP/HTTPS链接'),
          _RegexItem(
              'IP地址',
              r'^((25[0-5]|2[0-4]\d|[01]?\d\d?)\.){3}(25[0-5]|2[0-4]\d|[01]?\d\d?)$',
              'IPv4地址'),
          _RegexItem(
              '域名',
              r'^[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(\.[a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$',
              '域名格式'),
        ]),
        _buildSection('文本处理', [
          _RegexItem('中文字符', r'[\u4e00-\u9fa5]', '匹配中文字符'),
          _RegexItem('英文单词', r'\b[a-zA-Z]+\b', '匹配英文单词'),
          _RegexItem('去除空格', r'^\s+|\s+$', '匹配首尾空格'),
          _RegexItem('HTML标签', r'<[^>]+>', '匹配HTML标签'),
        ]),
      ],
    );
  }

  Widget _buildSection(String title, List<_RegexItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        ...items.map((item) => _buildRegexCard(item)),
        // const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildRegexCard(_RegexItem item) {
    return Builder(
      builder: (context) => Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          title: Text(item.title,
              style: const TextStyle(fontWeight: FontWeight.w500)),
          subtitle:
              Text(item.description, style: const TextStyle(fontSize: 12)),
          trailing:
              Icon(Icons.chevron_right, color: Theme.of(context).primaryColor),
          onTap: () => _navigateToDetail(context, item),
        ),
      ),
    );
  }

  void _navigateToDetail(BuildContext context, _RegexItem item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegexDetailPage(
          title: item.title,
          pattern: item.pattern,
          description: item.description,
        ),
      ),
    );
  }
}

class _RegexItem {
  final String title;
  final String pattern;
  final String description;

  _RegexItem(this.title, this.pattern, this.description);
}
