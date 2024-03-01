import 'package:flutter/material.dart';

class TextBox extends StatelessWidget {
  final String text;
  final String sectionName;
  final void Function()? onPressed;
  const TextBox(
      {super.key,
      required this.text,
      required this.sectionName,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 15, bottom: 15, top: 15),
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      decoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
                offset: Offset(3, 3),
                blurRadius: 10,
                color: Colors.black,
                blurStyle: BlurStyle.normal)
          ],
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                sectionName,
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
              // IconButton(
              //   onPressed: onPressed,
              //   icon: const Icon(
              //     Icons.edit,
              //     color: Color.fromARGB(255, 117, 117, 117),
              //   ),
              // )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(text),
        ],
      ),
    );
  }
}
