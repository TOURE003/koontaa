import 'dart:async';
import 'package:flutter/material.dart';
import 'package:koontaa/functions/fonctions.dart';

class KoontaaStoryApp extends StatefulWidget {
  final List<List<dynamic>> vendeurStories;

  const KoontaaStoryApp(this.vendeurStories, {super.key});

  @override
  State<KoontaaStoryApp> createState() => _KoontaaStoryAppState();
}

class _KoontaaStoryAppState extends State<KoontaaStoryApp> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: SizedBox(
        height: long(context, ratio: 1 / 4),
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: widget.vendeurStories.asMap().entries.map((entry) {
            int index = entry.key;
            List<dynamic> vendeur = entry.value;
            List<Widget> storyWidgets = vendeur[0];
            Widget bouton = vendeur[1];
            Widget widgetIndication = vendeur[2];
            String label = vendeur[3];

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => MultiStoryViewer(
                            vendeurStories: widget.vendeurStories,
                            initialVendeurIndex: index,
                          ),
                        ),
                      );
                    },
                    child: bouton,
                  ),
                  const SizedBox(height: 8),
                  Text(label, style: const TextStyle(fontSize: 12)),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class MultiStoryViewer extends StatefulWidget {
  final List<List<dynamic>> vendeurStories;
  final int initialVendeurIndex;

  const MultiStoryViewer({
    super.key,
    required this.vendeurStories,
    this.initialVendeurIndex = 0,
  });

  @override
  State<MultiStoryViewer> createState() => _MultiStoryViewerState();
}

class _MultiStoryViewerState extends State<MultiStoryViewer> {
  late PageController _vendeurController;

  @override
  void initState() {
    super.initState();
    _vendeurController = PageController(
      initialPage: widget.initialVendeurIndex,
    );
  }

  @override
  void dispose() {
    _vendeurController.dispose();
    super.dispose();
  }

  void _handleStoryComplete(int currentIndex) {
    if (currentIndex < widget.vendeurStories.length - 1) {
      _vendeurController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).maybePop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _vendeurController,
      itemCount: widget.vendeurStories.length,
      itemBuilder: (context, index) {
        final vendeur = widget.vendeurStories[index];
        return StoryViewer(
          storyWidgets: vendeur[0],
          indicationWidget: vendeur[2],
          durationPerStory: const Duration(seconds: 5),
          onComplete: () => _handleStoryComplete(index),
        );
      },
    );
  }
}

class StoryViewer extends StatefulWidget {
  final List<Widget> storyWidgets;
  final Widget indicationWidget;
  final Duration durationPerStory;
  final VoidCallback? onComplete;

  const StoryViewer({
    super.key,
    required this.storyWidgets,
    required this.indicationWidget,
    this.durationPerStory = const Duration(seconds: 5),
    this.onComplete,
  });

  @override
  State<StoryViewer> createState() => _StoryViewerState();
}

class _StoryViewerState extends State<StoryViewer>
    with SingleTickerProviderStateMixin {
  late PageController _storyController;
  late AnimationController _animationController;
  late int _currentIndex;
  Timer? _timer;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    _storyController = PageController(initialPage: _currentIndex);
    _animationController = AnimationController(
      vsync: this,
      duration: widget.durationPerStory,
    )..addListener(() => setState(() {}));
    _startStory();
  }

  void _startStory() {
    _animationController.forward(from: 0);
    _timer?.cancel();
    _timer = Timer(widget.durationPerStory, _nextPage);
  }

  void _nextPage() {
    if (_currentIndex < widget.storyWidgets.length - 1) {
      _storyController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      widget.onComplete?.call();
    }
  }

  void _previousPage() {
    if (_currentIndex > 0) {
      _storyController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _pause() {
    _isPaused = true;
    _timer?.cancel();
    _animationController.stop();
  }

  void _resume() {
    if (_isPaused) {
      _isPaused = false;
      _animationController.forward();
      _startTimer();
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer(
      widget.durationPerStory * (1 - _animationController.value),
      _nextPage,
    );
  }

  @override
  void dispose() {
    _storyController.dispose();
    _timer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  Widget _buildProgressBar() {
    return Row(
      children: List.generate(widget.storyWidgets.length, (index) {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 2),
            height: 4,
            decoration: BoxDecoration(
              color: index < _currentIndex
                  ? Colors.white
                  : Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(4),
            ),
            child: index == _currentIndex
                ? LinearProgressIndicator(
                    value: _animationController.value,
                    backgroundColor: Colors.transparent,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                  )
                : null,
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onLongPress: _pause,
        onLongPressUp: _resume,
        onTapDown: (_) => _pause(),
        onTapUp: (_) => _resume(),
        onTapCancel: _resume,
        child: Stack(
          children: [
            PageView(
              controller: _storyController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                  _animationController.reset();
                  _startStory();
                });
              },
              children: widget.storyWidgets
                  .map((w) => Center(child: w))
                  .toList(),
            ),
            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 10,
                    ),
                    child: _buildProgressBar(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        widget.indicationWidget,
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: _previousPage,
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.7,
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: _nextPage,
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.7,
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



/*exemple
KoontaaStoryApp([
        [
          [
            h1(context, texte: "lkjlkjljljkljlj", couleur: Colors.white),
            VideoWidget(
              url:
                  "https://res.cloudinary.com/ddjkeamgh/video/upload/v1751459961/istockphoto-2187117127-640_adpp_is_kwf4cg.mp4",
            ),
          ],
          //h1(context, texte: "lkjlkjljljkljlj", couleur: Colors.white),
          gifDepuisVideo(
            context,
            "https://res.cloudinary.com/ddjkeamgh/video/upload/v1751459961/istockphoto-2187117127-640_adpp_is_kwf4cg.mp4",
          ), //CircleAvatar(backgroundColor: Colors.orange),
          CircleAvatar(backgroundColor: Colors.orange),
          "Alice",
        ],
        [
          [
            Text("Story 2A"),
            Text("Story 2B"),
            Container(
              color: Colors.yellow,
              width: larg(context),
              height: long(context),
            ),
            VideoWidget(
              url:
                  "https://res.cloudinary.com/ddjkeamgh/video/upload/v1751459961/istockphoto-2187117127-640_adpp_is_kwf4cg.mp4",
            ),
          ],
          gifDepuisVideo(
            context,
            "https://res.cloudinary.com/ddjkeamgh/video/upload/v1751459961/istockphoto-2187117127-640_adpp_is_kwf4cg.mp4",
          ), //Icon(Icons.store, size: 60),
          Icon(Icons.store, size: 60, color: Colors.white),
          "Boutique B",
        ],
      ])*/