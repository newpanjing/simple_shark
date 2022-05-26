import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:simple_shark/utils/api.dart';
import 'package:macos_ui/macos_ui.dart';

class BannerWidget extends StatefulWidget {
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
      child: _banners.length > 0
          ? Padding(
              padding: EdgeInsets.all(10),
              child: Swiper(

                autoplay: true,
                autoplayDelay: 3000,
                itemBuilder: (BuildContext context, int index) {
                  var item = _banners[index];
                  return Listener(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        item["image"],
                        fit: BoxFit.cover,
                      ),
                    ),
                    onPointerDown: (e) {
                      print(e);
                    },
                  );
                },
                itemCount: _banners.length,
                pagination: new SwiperPagination(),
                control: new SwiperControl(),
              ),
            )
          : SizedBox(
              height: 10,
            ),
    );
  }
}
