import 'package:flutter/material.dart';

class TextCell extends StatelessWidget {
  const TextCell(this.text,{Key? key,}) : super(key: key);
  final String text;
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 300),
      child: Text(text,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
