import 'package:artech_ui_kit/components/image_error_widget.dart';
import 'package:artech_ui_kit/components/image_place_holder.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

enum SliderType {
  withIndicator,
  fullScreen,
  normal,
  multiple,
}

class SliderWidget extends StatefulWidget {
  final bool autoPlay;
  final Axis scrollDirection;
  final Duration autoPlayInterval;
  final List<String> urls;
  final SliderType type;
  final ValueChanged<String>? onClicked;

  const SliderWidget(
      {Key? key,
      this.scrollDirection = Axis.horizontal,
      required this.urls,
      required this.type,
      this.onClicked,
      this.autoPlay = true,
      this.autoPlayInterval = const Duration(seconds: 4)})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _SliderWidgetState();
  }
}

class _SliderWidgetState extends State<SliderWidget> {
  int _current = 0;

  // TODO: default image
  Widget? get _defaultImage => null;

  Widget _fullScreen() {
    return Builder(
      builder: (context) {
        final double height = MediaQuery.of(context).size.height;
        return CarouselSlider(
          options: CarouselOptions(
            autoPlayInterval: widget.autoPlay
                ? widget.autoPlayInterval
                : Duration(seconds: 4),
            height: height,
            viewportFraction: 1.0,
            enlargeCenterPage: false,
            autoPlay: widget.autoPlay,
          ),
          items: widget.urls
              .map((item) => InkWell(
                    onTap: () {
                      if (widget.onClicked != null) widget.onClicked!(item);
                    },
                    child: Container(
                      child: Center(
                          child: Image.network(
                        item,
                        errorBuilder: (BuildContext context, Object error,
                            StackTrace? stackTrace) {
                          return ImageErrorHolder();
                        },
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null)
                            return child;
                          else {
                            if (loadingProgress.expectedTotalBytes !=
                                loadingProgress.cumulativeBytesLoaded)
                              return ImagePlaceHolder();
                            return child;
                          }
                        },
                        fit: BoxFit.fitHeight,
                        height: height,
                      )),
                    ),
                  ))
              .toList(),
        );
      },
    );
  }

  List<Widget> get imageSliders => widget.urls
      .map((item) => InkWell(
            onTap: () {
              if (widget.onClicked != null) widget.onClicked!(item);
            },
            child: Container(
              child: Container(
                margin: EdgeInsets.all(5.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    child: Stack(
                      children: <Widget>[
                        Image.network(item, errorBuilder: (BuildContext context,
                            Object error, StackTrace? stackTrace) {
                          return ImageErrorHolder();
                        }, loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null)
                            return child;
                          else {
                            if (loadingProgress.expectedTotalBytes !=
                                loadingProgress.cumulativeBytesLoaded)
                              return ImagePlaceHolder();
                            return child;
                          }
                        }, fit: BoxFit.cover, width: 1000.0),
                        Positioned(
                          bottom: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(200, 0, 0, 0),
                                  Color.fromARGB(0, 0, 0, 0)
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            ),
          ))
      .toList();

  Widget _multipleItem() {
    return CarouselSlider.builder(
      options: CarouselOptions(
        aspectRatio: 2.0,
        enlargeCenterPage: false,
        viewportFraction: 1,
        autoPlay: widget.autoPlay,
      ),
      itemCount: (imageSliders.length / 2).round(),
      itemBuilder: (context, index, realIdx) {
        final int first = index * 2;
        final int second = first + 1;
        return Row(
          children: [first, second].map((idx) {
            return Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  if (widget.onClicked != null)
                    widget.onClicked!(widget.urls[idx]);
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: idx < imageSliders.length
                      ? Image.network(widget.urls[idx], errorBuilder:
                          (BuildContext context, Object error,
                              StackTrace? stackTrace) {
                          return ImageErrorHolder();
                        }, loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null)
                            return child;
                          else {
                            if (loadingProgress.expectedTotalBytes !=
                                loadingProgress.cumulativeBytesLoaded)
                              return ImagePlaceHolder();
                            return child;
                          }
                        }, fit: BoxFit.cover)
                      : _defaultImage,
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _normal() {
    return Container(
      child: CarouselSlider(
        items: imageSliders,
        options: CarouselOptions(
            autoPlayInterval: widget.autoPlay
                ? widget.autoPlayInterval
                : Duration(seconds: 4),
            scrollDirection: widget.scrollDirection,
            autoPlay: widget.autoPlay,
            enlargeCenterPage: true,
            aspectRatio: 2.0,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            }),
      ),
    );
  }

  Widget _withIndicator() {
    return Column(
      children: [
        CarouselSlider(
          items: imageSliders,
          options: CarouselOptions(
              autoPlayInterval: widget.autoPlay
                  ? widget.autoPlayInterval
                  : Duration(seconds: 4),
              scrollDirection: widget.scrollDirection,
              autoPlay: widget.autoPlay,
              enlargeCenterPage: true,
              aspectRatio: 2.0,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.urls.map((url) {
            int index = widget.urls.indexOf(url);
            return InkWell(
              onTap: () {
                if (widget.onClicked != null) widget.onClicked!(url);
              },
              child: Container(
                width: 8.0,
                height: 8.0,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _current == index
                      ? Color.fromRGBO(0, 0, 0, 0.9)
                      : Color.fromRGBO(0, 0, 0, 0.4),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (widget.type) {
      case SliderType.fullScreen:
        return _fullScreen();
      case SliderType.withIndicator:
        return _withIndicator();
      case SliderType.multiple:
        return _multipleItem();
      default:
        return _normal();
    }
  }
}
