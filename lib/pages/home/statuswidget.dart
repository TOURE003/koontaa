import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';

import 'package:flutter/material.dart';
import 'package:flutter_instagram_storyboard/flutter_instagram_storyboard.dart';

Widget KoontaaStoryApp(List<List<dynamic>> vendeurStories) {
  final StoryTimelineController storyController = StoryTimelineController();
  const double radius = 100;

  StoryPageScaffold _wrapAsStoryPage(Widget widget) {
    return StoryPageScaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        child: Center(child: widget),
      ),
    );
  }

  return Scaffold(
    appBar: AppBar(title: const Text("Stories Koontaa")),
    body: Column(
      children: [
        StoryListView(
          listHeight: 160,
          pageTransform: const StoryPage3DTransform(),
          buttonDatas: List.generate(vendeurStories.length, (index) {
            final List<dynamic> vendeur = vendeurStories[index];
            final List<Widget> storyWidgets = vendeur[0];
            final Widget buttonWidget = vendeur[1];
            final String label = vendeur[2];
            final String storyId = "vendeur_$index";

            return StoryButtonData(
              storyId: storyId,
              storyController: storyController,
              buttonDecoration: BoxDecoration(),
              borderDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(radius),
                border: Border.all(color: Colors.deepOrange, width: 2),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),

                  GestureDetector(
                    onTap: () {
                      //storyController.play();
                    },
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: buttonWidget,
                    ),
                  ),

                  const SizedBox(height: 5),
                  Text(label, style: const TextStyle(fontSize: 12)),
                ],
              ),
              storyPages: storyWidgets.map(_wrapAsStoryPage).toList(),
              segmentDuration: List.generate(
                storyWidgets.length,
                (_) => const Duration(seconds: 5),
              ),
            );
          }),
        ),
      ],
    ),
  );
}
