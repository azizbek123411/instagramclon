import 'package:flutter/material.dart';
import 'package:instagram_clon/utility/app_padding.dart';
class BioBox extends StatelessWidget {
  final String text;
  const BioBox({super.key,required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: Dis.all(25),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).colorScheme.inversePrimary,
      ),
      child: Text(text.isNotEmpty?text:'Empty bio..'),
    );
  }
}
