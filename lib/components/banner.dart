import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:simple_shark/utils/api.dart';

class BannerWidget extends StatefulWidget {
  int currentIndex = 0;

  BannerWidget({Key? key}) : super(key: key);

  // const BannerWidget(this.currentIndex, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return BannerState();
  }
}

class BannerState extends State<BannerWidget> {
  List _banners = [];

  @override
  void initState() {
    super.initState();

    _getData();
  }

  _getData() async {
    var banners = await Api.getBanners();
    setState(() {
      _banners = banners;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: _banners.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(10),
              child: Swiper(
                autoplay: true,
                autoplayDelay: 3000,
                itemBuilder: (BuildContext context, int index) {
                  var item = _banners[index];
                  return Listener(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(item["image"], fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                        //#f6f6f6
                        return Container(
                          decoration: BoxDecoration(color: HexColor("#f6f6f6")),
                          child: Image.asset("assets/images/error.png"),
                        );
                      }),
                    ),
                    onPointerDown: (e) {
                      print(e);
                    },
                  );
                },
                itemCount: _banners.length,
                pagination: const SwiperPagination(),
                control: const SwiperControl(),
              ),
            )
          : const SizedBox(
              height: 10,
            ),
    );
  }
}
