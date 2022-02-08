import 'package:customer_portal/pages/auth/loginPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rive/rive.dart';

class OnBoardingScreen extends StatefulWidget {
  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen>
    with TickerProviderStateMixin {
  RiveAnimationController? _controller;
  Artboard? _testArt;
  SMIInput<double>? _testPerc;
  List _intros = [
    {
      "title": "MONITOR\n ACTIVITIES",
      "subtitle": "Monitor every event in your property through activity log",
      "image": "assets/intro/intro1.png",
    },
    {
      "title": "MANAGE\n FINANCES",
      "subtitle": "Track your property expenses with ease",
      "image": "assets/intro/intro2.png",
    },
    {
      "title": "ACCESS\n DOCUMENTS",
      "subtitle": "Effectively organise property docs & receipts",
      "image": "assets/intro/intro1.png",
    },
    {
      "title": "MAKE\n PAYMENTS",
      "subtitle": "Pay instantly property bills & payments",
      "image": "assets/intro/intro1.png",
    },
    // {
    //   "image": "assets/intro/intro1.png",
    // },
  ];

  final _introController = new PageController();

  int _current = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _introController.addListener(() {
      setState(() {
        _current = _introController.page!.toInt();
      });
      // //print(_introController.position.maxScrollExtent);
      double perc = (_introController.offset /
              _introController.position.maxScrollExtent) *
          100;
      print(perc);
      _testPerc!.change(perc);
      if (_introController.page == _current + 0.0) {
        // _controllers[_current].duration = Duration(seconds: 1);
        // _controllers[_current].value = 22;
        // _controllers[_current].animateTo(22);
        //print(perc);
      }
    });

    rootBundle.load("assets/rive/enrix_intro.riv").then((value) {
      final file = RiveFile.import(value);
      final artboard = file.artboards[0];
      var controller = StateMachineController.fromArtboard(artboard, "sm1");
      if (controller != null) {
        artboard.addController(controller);
        _testPerc =
            controller.findInput<double>("progress") as SMIInput<double>;
        //print("Hjshdsjdhsjdhsj");
        //print(_testPerc);
        _testPerc?.change(0.0);
      }
      setState(() {
        _testArt = artboard;
        _opcty = 1.00;
      });
    });
  }

  double _opcty = 0.00;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (bc) => LoginPage(),
                  ),
                );
                // _testPerc.change(100);
              },
              child: Text("Skip"))
        ],
      ),
      body: Stack(
        children: [
          Positioned(
              left: 0,
              right: 0,
              top: (MediaQuery.of(context).size.height / 2) -
                  (MediaQuery.of(context).size.height / 2.8) -
                  50,
              child: Container(
                height: MediaQuery.of(context).size.height / 2.8,
                child: _testArt != null
                    ? Container(
                        width: 100,
                        child: AnimatedOpacity(
                          opacity: _opcty,
                          duration: Duration(seconds: 10),
                          child: Rive(
                            artboard: _testArt!,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      )
                    : Container(),
              )),
          Positioned.fill(
            child: PageView.builder(
                controller: _introController,
                itemCount: _intros.length,
                // physics: NeverScrollableScrollPhysics(),
                itemBuilder: (bc, i) {
                  // _controllers[i] = GifController(vsync: this);
                  return Container(
                    // height: 400,
                    child: Stack(
                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                      // mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Positioned(
                          top: (MediaQuery.of(context).size.height / 1.8) - 20,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.90,
                                  child: Text(
                                    _intros[i]['title'] ?? "",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.raleway(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Center(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.80,
                                    child: Text(
                                      _intros[i]["subtitle"],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                        fontFamily:
                                            GoogleFonts.raleway().fontFamily,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        // SizedBox(
                        //   height: 150,
                        // ),
                      ],
                    ),
                  );
                }),
          ),
          Positioned(
            bottom: 20,
            left: 10,
            right: 10,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 55,
                    height: 12,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.50),
                      // color: Color(0x23c4c4c4),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: _intros.map((e) {
                        return Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(21),
                            color: _current != _intros.indexOf(e)
                                ? Color(0xffe0e0e0)
                                : Color(0xffc4c4c4),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          //print(_introController.page);
                          //print(_intros.length);
                          if (_introController.page == _intros.length - 1.0) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (bc) => LoginPage(),
                              ),
                            );
                          }
                          // controller.repeat(
                          //     min: 0, max: 22, period: Duration(seconds: 5));

                          // controller.forward(from: 0);
                          // _introController.nextPage(
                          //   duration: Duration(
                          //     seconds: 1,
                          //   ),
                          //   curve: Curves.ease,
                          // );
                          _introController.animateToPage(
                              _introController.page!.toInt() + 1,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeInOut);
                          setState(() {
                            _current = _introController.page!.toInt();
                          });
                        },
                        child: Text("Next"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class SpeedController extends SimpleAnimation {
  final double speedMultiplier;

  SpeedController(
    String animationName, {
    double mix = 1,
    this.speedMultiplier = 1,
  }) : super(animationName, mix: mix);

  @override
  void apply(RuntimeArtboard artboard, double elapsedSeconds) {
    if (instance == null || !instance!.keepGoing) {
      isActive = false;
    }
    instance!
      ..animation.apply(instance!.time, coreContext: artboard, mix: mix)
      ..advance(elapsedSeconds * speedMultiplier);
  }
}
