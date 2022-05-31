import 'package:flutter/material.dart';
import 'package:regexpo/src/components/logo.dart';


class TopBar extends StatelessWidget {
  const TopBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<IconData,Color> icons = {
      Icons.access_alarm_sharp:Colors.red,
      Icons.play_circle_outline_outlined:Colors.grey,
      Icons.nat:Colors.grey,
      Icons.navigation_outlined:Colors.grey,
      Icons.check:Colors.green,
      Icons.update:Colors.blue,
      Icons.settings_outlined:Colors.blue,
    };
    final Map<IconData,String> iconsText = {
      Icons.access_alarm_sharp:'Clock',
      Icons.play_circle_outline_outlined:'Session',
      Icons.nat: 'Nat',
      Icons.navigation_outlined:'Adress',
      Icons.check:'Checked',
      Icons.update:'Refresh',
      Icons.settings_outlined:'Settings',
    };

    return Container(
      height: 50,
      color: Color(0xffF2F2F2),
      child: Row(
          children: [
            const SizedBox(width: 20,),
            Expanded(
                flex: 3,
                child: RegexInput()),
            Spacer(
              flex: 2,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Logo(),
            )
          ]),
    );
  }

}

class RegexInput extends StatefulWidget {
  const RegexInput({Key? key}) : super(key: key);

  @override
  State<RegexInput> createState() => _RegexInputState();
}

class _RegexInputState extends State<RegexInput> {
  final TextEditingController regTextCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 28,
        child: TextField(
          controller: regTextCtrl,
          style: const TextStyle(fontSize: 12),
          maxLines: 1,
          decoration: const InputDecoration(
              filled: true,
              contentPadding: EdgeInsets.only(top: 0),
              fillColor: Colors.white,
              prefixIcon: Icon(Icons.edit, size: 18),
              border: UnderlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              hintText: "输入正则表达式...",
              hintStyle: TextStyle(fontSize: 12)),
        ));
  }
}
