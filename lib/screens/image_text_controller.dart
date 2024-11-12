import 'dart:io';

import 'package:flutter/material.dart';

class ImageTextEditingController extends TextEditingController {
  String? imagePath; // Store the image path once inserted

  // Insert the image at the current cursor position
  void insertImage(String imageUrl) {
    if (!selection.isValid) return;
    final cursorPos = selection.baseOffset;

    // Insert placeholder text for image (or an actual image tag) at cursor
    text = text.substring(0, cursorPos) + '[image]' + text.substring(cursorPos);
    selection = TextSelection.collapsed(offset: cursorPos + '[image]'.length);

    imagePath = imageUrl; // Store the image URL or path
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final children = <InlineSpan>[];

    // Split the content by the image placeholder
    final parts = text.split('[image]');

    // Add the text parts before and after the image
    for (var i = 0; i < parts.length; i++) {
      children.add(TextSpan(text: parts[i], style: style));

      if (i == 1 && imagePath != null) {
        // Add the image only once, when the placeholder '[image]' is encountered
        children.add(WidgetSpan(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Image.file(File(imagePath!), width: 100, height: 100, fit: BoxFit.cover),
          ),
        ));
        break;  // Exit the loop after adding the first image
      }
    }

    return TextSpan(children: children);
  }
}
