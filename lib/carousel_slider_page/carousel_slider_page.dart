import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

final List<String> imgList = [
  'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
];

class CarouselSliderPage extends StatelessWidget {
  final Map<String, String> argument;
  const CarouselSliderPage({super.key, required this.argument});

  @override
  Widget build(BuildContext context) {
    final arg1 = argument["arg1"];
    final arg2 = argument["arg2"];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carousel Slider Page'),
      ),
      body: SizedBox.expand(
        child: ListView(
          children: [
            Text('$arg1'),
            const SizedBox(
              height: 12,
            ),
            Text('$arg2'),
            const SizedBox(
              height: 12,
            ),
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text("Multiple item in one slide demo"),
            ),
            const CarouselSliderContent(),
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text("EnlargeStrategyZoomDemo"),
            ),
            const EnlargeStrategyZoomDemo()
          ],
        ),
      ),
    );
  }
}

class CarouselSliderContent extends StatefulWidget {
  const CarouselSliderContent({super.key});

  @override
  State<CarouselSliderContent> createState() => _CarouselSliderContentState();
}

class _CarouselSliderContentState extends State<CarouselSliderContent> {
  @override
  void initState() {
    // WidgetsBinding.instance.addPersistentFrameCallback((timeStamp) {
    //   imgList.forEach((element) {
    //     precacheImage(NetworkImage(element), context);
    //   });
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: (imgList.length / 2).round(),
          itemBuilder: (context, index, realIdx) {
            final int first = index * 2;
            final int second = first + 1;
            return Row(
              children: [first, second].map((idx) {
                return Expanded(
                  flex: 1,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Image.network(imgList[idx], fit: BoxFit.cover),
                  ),
                );
              }).toList(),
            );
          },
          options: CarouselOptions(
            aspectRatio: 2.0,
            enlargeCenterPage: false,
            viewportFraction: 1,
          ),
        )
      ],
    );
  }
}

final List<Widget> imageSliders = imgList
    .map((item) => Container(
          margin: const EdgeInsets.all(5.0),
          child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
              child: Stack(
                children: <Widget>[
                  Image.network(item, fit: BoxFit.cover, width: 1000.0),
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(200, 0, 0, 0),
                            Color.fromARGB(0, 0, 0, 0)
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      child: Text(
                        'No. ${imgList.indexOf(item)} image',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        ))
    .toList();

class EnlargeStrategyZoomDemo extends StatelessWidget {
  const EnlargeStrategyZoomDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        Colors.black.withOpacity(0.2),
        Colors.black.withOpacity(0.4),
      ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: CarouselSlider(
        options: CarouselOptions(
          aspectRatio: 2.0,
          enlargeCenterPage: true,
          enlargeStrategy: CenterPageEnlargeStrategy.zoom,
          enlargeFactor: 0.4,
        ),
        items: imageSliders,
      ),
    );
  }
}
