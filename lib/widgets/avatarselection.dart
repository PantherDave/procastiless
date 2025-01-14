import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:procastiless/components/dashboard/screen/dashboardscreen.dart';
import 'package:procastiless/components/login/bloc/login_block.dart';
import 'package:procastiless/components/login/bloc/login_state.dart';

class AvatarSelector extends StatefulWidget {
  AvatarSelector();
  @override
  State<StatefulWidget> createState() => AvatarSelectorState();
}

class AvatarSelectorState extends State<AvatarSelector>
    with SingleTickerProviderStateMixin {
  int? selectedAvatar;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  AnimationController? animation;
  late Animation sizeAnimation;
  CarouselController? carouselController;

  @override
  void initState() {
    super.initState();
    // Rebuilding the screen when animation goes ahead
    //For single time
    //controller.forward()
    animation = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1800));
    sizeAnimation = Tween<double>(begin: 10, end: 20).animate(animation!);
    animation?.repeat();
    carouselController = CarouselController();
    animation?.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {},
      child: SafeArea(
        child: Scaffold(
          body: Container(
            decoration: BoxDecoration(
              color: Color(0xff243C51),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Time to pick your Procraimon',
                    style: Theme.of(context).textTheme.bodyLarge?.apply(
                        color: Colors.white,
                        fontSizeFactor: 2.8,
                        fontWeightDelta: 50),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'This action is irrivertable. Once you pick your avatar you can not change it',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.apply(color: Colors.white, fontSizeFactor: 1.0),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Stack(
                  children: [
                    Positioned(
                      top: 60,
                      left: MediaQuery.of(context).size.width * .06 +
                          (-sizeAnimation.value),
                      child: GestureDetector(
                          onTap: () {
                            print("Hello");
                            carouselController
                                ?.animateToPage(selectedAvatar! + 1);
                          },
                          child: Icon(Icons.keyboard_arrow_left_rounded,
                              size: 60)),
                    ),
                    Positioned(
                      top: 60,
                      right: MediaQuery.of(context).size.width * .06 +
                          -sizeAnimation.value,
                      child: Icon(Icons.keyboard_arrow_right_rounded, size: 60),
                    ),
                    CarouselSlider(
                      carouselController: carouselController,
                      items: [
                        Image.asset('assets/images/char2.png'),
                        Image.asset(
                          'assets/images/char1.png',
                          height: 100,
                        ),
                        Image.asset('assets/images/char3.png'),
                      ],
                      options: CarouselOptions(
                          onPageChanged: (index, reason) {
                            selectedAvatar = index;
                          },
                          enableInfiniteScroll: false,
                          enlargeStrategy: CenterPageEnlargeStrategy.height,
                          initialPage: 1,
                          disableCenter: false),
                    ),
                  ],
                ),
                SizedBox(
                  height: 100,
                ),
                BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
                  return GestureDetector(
                    onTap: () async {
                      if (state is LoggedIn) {
                        if (selectedAvatar == 0) {
                          state.accountUser?.avatarUrl =
                              'https://firebasestorage.googleapis.com/v0/b/procastiless-6c5f4.appspot.com/o/Group.png?alt=media&token=f5dd18ed-1a3b-403a-aeb0-4db2d1785e3a';
                        } else if (selectedAvatar == 1) {
                          state.accountUser?.avatarUrl =
                              'https://firebasestorage.googleapis.com/v0/b/procastiless-6c5f4.appspot.com/o/icon-vezt-character-map%204.png?alt=media&token=902126c5-21ba-41cb-b551-9d7a213d3c18';
                        } else {
                          state.accountUser?.avatarUrl =
                              'https://firebasestorage.googleapis.com/v0/b/procastiless-6c5f4.appspot.com/o/g10.png?alt=media&token=4c8d6f7d-4c26-42cb-ae94-e7b035f3a475';
                        }
                      }
                      if ((state as LoggedIn).auth.currentUser?.uid != null) {
                        await firestore
                            .collection('users')
                            .doc(state.auth.currentUser!.uid)
                            .update({
                          'avatarUrl': state.accountUser?.avatarUrl,
                        });
                      }
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Dashboard()));
                    },
                    child: Image.asset('assets/images/next.png'),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
