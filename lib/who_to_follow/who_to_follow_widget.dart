import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_reactive_programming/who_to_follow/who_to_follow_data.dart';
import 'package:flutter_reactive_programming/util/image.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:stream_transform/stream_transform.dart' show CombineLatest;

const primaryThemeColor = Color.fromRGBO(244, 101, 40, 1);

class WhoToFollowWidget extends StatefulWidget {
  static const String routeName = '/who-to-follow';
  const WhoToFollowWidget({super.key});

  @override
  State<WhoToFollowWidget> createState() => _WhoToFollowWidgetState();
}

class _WhoToFollowWidgetState extends State<WhoToFollowWidget> {
  StreamController<String> refreshClickController = StreamController.broadcast();

  Stream<http.Response> responseStream = const Stream<http.Response>.empty();
  Stream<String> requestStream = const Stream<String>.empty();

  Stream<WhoToFollow?> follow1 = Stream<WhoToFollow?>.value(null);
  Stream<WhoToFollow?> follow2 = Stream<WhoToFollow?>.value(null);
  Stream<WhoToFollow?> follow3 = Stream<WhoToFollow?>.value(null);
  Stream<WhoToFollow?> follow4 = Stream<WhoToFollow?>.value(null);
  Stream<WhoToFollow?> follow5 = Stream<WhoToFollow?>.value(null);

  StreamController<String?> closeFollow1ClickController = StreamController.broadcast();
  StreamController<String?> closeFollow2ClickController = StreamController.broadcast();
  StreamController<String?> closeFollow3ClickController = StreamController.broadcast();
  StreamController<String?> closeFollow4ClickController = StreamController.broadcast();
  StreamController<String?> closeFollow5ClickController = StreamController.broadcast();

  StreamController<WhoToFollow> follow1ClickController = StreamController.broadcast();
  StreamController<WhoToFollow> follow2ClickController = StreamController.broadcast();
  StreamController<WhoToFollow> follow3ClickController = StreamController.broadcast();
  StreamController<WhoToFollow> follow4ClickController = StreamController.broadcast();
  StreamController<WhoToFollow> follow5ClickController = StreamController.broadcast();

  var random = math.Random();

  BehaviorSubject<Map<String, WhoToFollow>> following = BehaviorSubject.seeded({});

  @override
  void initState() {
    super.initState();

    requestStream = refreshClickController.stream.map((event) {
      var randomOffset = random.nextInt(200);

      return 'https://api.github.com/users?since=$randomOffset';
    }).startWith('https://api.github.com/users');

    responseStream = requestStream.asyncMap(
      (event) {
        print("Got request stream");
        return http.get(Uri.parse(event));
      },
    );

    responseStream.listen((event) {
      var data = jsonDecode(event.body);
      print(data);
    });

    follow1 = closeFollow1ClickController.stream.startWith(null).combineLatest<http.Response, WhoToFollow?>(responseStream, (t, s) {
      var data = jsonDecode(s.body);

      return getRandomUser(data, index: random.nextInt(5));
    }).mergeWith([
      refreshClickController.stream.map((event) => null),
      follow1ClickController.stream.map((user) => followUser(user)),
    ]);

    follow2 = closeFollow2ClickController.stream.startWith(null).combineLatest<http.Response, WhoToFollow?>(responseStream, (t, s) {
      var data = jsonDecode(s.body);

      return getRandomUser(data, index: random.nextInt(5) + 6);
    }).mergeWith([
      refreshClickController.stream.map((event) => null),
      follow2ClickController.stream.map((user) => followUser(user)),
    ]);

    follow3 = closeFollow3ClickController.stream.startWith(null).combineLatest<http.Response, WhoToFollow?>(responseStream, (t, s) {
      var data = jsonDecode(s.body);

      return getRandomUser(data, index: random.nextInt(5) + 12);
    }).mergeWith([
      refreshClickController.stream.map((event) => null),
      follow3ClickController.stream.map((user) => followUser(user)),
    ]);

    follow4 = closeFollow4ClickController.stream.startWith(null).combineLatest<http.Response, WhoToFollow?>(responseStream, (t, s) {
      var data = jsonDecode(s.body);

      return getRandomUser(data, index: random.nextInt(5) + 18);
    }).mergeWith([
      refreshClickController.stream.map((event) => null),
      follow4ClickController.stream.map((user) => followUser(user)),
    ]);

    follow5 = closeFollow5ClickController.stream.startWith(null).combineLatest<http.Response, WhoToFollow?>(responseStream, (t, s) {
      var data = jsonDecode(s.body);

      return getRandomUser(data, index: random.nextInt(5) + 24);
    }).mergeWith([
      refreshClickController.stream.map((event) => null),
      follow5ClickController.stream.map((user) => followUser(user)),
    ]);
  }

  WhoToFollow getRandomUser(List<dynamic> data, {int? index}) {
    var randomUser = data[random.nextInt(data.length)];

    if (index != null) {
      randomUser = data[index];
    }

    return WhoToFollow(
      name: randomUser['login'],
      imageUrl: randomUser['avatar_url'],
      username: randomUser['login'],
      id: randomUser['id'],
    );
  }

  WhoToFollow followUser(WhoToFollow user) {
    Map<String, WhoToFollow> _following = following.value;

    bool isInFollow = _following['${user.id}'] != null;

    if (isInFollow) {
      _following.remove('${user.id}');

      following.sink.add(_following);

      return WhoToFollow(name: user.name, imageUrl: user.imageUrl, username: user.username, id: user.id, isFollowing: false);
    }

    if (!isInFollow) {
      var newUser = WhoToFollow(name: user.name, imageUrl: user.imageUrl, username: user.username, id: user.id, isFollowing: true);
      _following.putIfAbsent('${user.id}', () => newUser);

      following.sink.add(_following);

      return newUser;
    }

    return user;
  }

  // Future<List<WhoToFollow>> getUsers() async {
  //   var data = await http.get(Uri.parse('/'));

  //   var jsonData = jsonDecode(data.body);

  //   List<WhoToFollow> follows = [];

  //   for (var u in jsonData) {
  //     var follow = WhoToFollow(
  //       name: u["name"],
  //       imageUrl: u["name"],
  //       username: u["name"],
  //     );

  //     follows.add(follow);
  //   }

  //   return follows;
  // }

  void refreshUsers() {
    refreshClickController.sink.add('');
  }

  @override
  void dispose() {
    requestStream.drain();
    responseStream.drain();
    refreshClickController.close();

    follow1.drain();
    follow2.drain();
    follow3.drain();
    follow4.drain();
    follow5.drain();

    closeFollow1ClickController.close();
    closeFollow2ClickController.close();
    closeFollow3ClickController.close();
    closeFollow4ClickController.close();
    closeFollow5ClickController.close();

    follow1ClickController.close();
    follow2ClickController.close();
    follow3ClickController.close();
    follow4ClickController.close();
    follow5ClickController.close();

    following.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  const SizedBox(
                    height: 16.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Who \nto follow',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700, height: 1.21, color: Colors.white),
                        ),
                        IconButton(
                          onPressed: () => refreshUsers(),
                          icon: const Icon(
                            Icons.refresh,
                            color: primaryThemeColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 32.0,
                  ),
                  StreamBuilder(
                    stream: follow1,
                    builder: (BuildContext context, AsyncSnapshot<WhoToFollow?> snapshot) {
                      if (snapshot.hasData) {
                        final user = snapshot.data!;

                        return UserCard(
                          user: user,
                          onRemove: () {
                            print('removed on ${user.name}');
                            closeFollow1ClickController.sink.add('');
                          },
                          onFollow: (id) {
                            print('followed on ${user.name}');

                            follow1ClickController.sink.add(user);
                          },
                        );
                      } else {
                        return const UserCardLoading();
                      }
                    },
                  ),
                  StreamBuilder(
                    stream: follow2,
                    builder: (BuildContext context, AsyncSnapshot<WhoToFollow?> snapshot) {
                      if (snapshot.hasData) {
                        final user = snapshot.data!;

                        return UserCard(
                          user: user,
                          onRemove: () {
                            print('removed on ${user.name}');
                            closeFollow2ClickController.sink.add('');
                          },
                          onFollow: (id) {
                            print('followed on ${user.name}');

                            follow2ClickController.sink.add(user);
                          },
                        );
                      } else {
                        return const UserCardLoading();
                      }
                    },
                  ),
                  StreamBuilder(
                    stream: follow3,
                    builder: (BuildContext context, AsyncSnapshot<WhoToFollow?> snapshot) {
                      if (snapshot.hasData) {
                        final user = snapshot.data!;

                        return UserCard(
                          user: user,
                          onRemove: () {
                            print('removed on ${user.name}');
                            closeFollow3ClickController.sink.add('');
                          },
                          onFollow: (id) {
                            print('followed on ${user.name}');

                            follow3ClickController.sink.add(user);
                          },
                        );
                      } else {
                        return const UserCardLoading();
                      }
                    },
                  ),
                  StreamBuilder(
                    stream: follow4,
                    builder: (BuildContext context, AsyncSnapshot<WhoToFollow?> snapshot) {
                      if (snapshot.hasData) {
                        final user = snapshot.data!;

                        return UserCard(
                          user: user,
                          onRemove: () {
                            print('removed on ${user.name}');
                            closeFollow4ClickController.sink.add('');
                          },
                          onFollow: (id) {
                            print('followed on ${user.name}');

                            follow4ClickController.sink.add(user);
                          },
                        );
                      } else {
                        return const UserCardLoading();
                      }
                    },
                  ),
                  StreamBuilder(
                    stream: follow5,
                    builder: (BuildContext context, AsyncSnapshot<WhoToFollow?> snapshot) {
                      if (snapshot.hasData) {
                        final user = snapshot.data!;

                        return UserCard(
                          user: user,
                          onRemove: () {
                            print('removed on ${user.name}');
                            closeFollow5ClickController.sink.add('');
                          },
                          onFollow: (id) {
                            print('followed on ${user.name}');

                            follow5ClickController.sink.add(user);
                          },
                        );
                      } else {
                        return const UserCardLoading();
                      }
                    },
                  ),
                ],
              ),
            ),
            Divider(
              height: 1.0,
              thickness: 0.8,
              color: Colors.white.withOpacity(0.16),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StreamBuilder(
                    stream: following.stream,
                    builder: (context, AsyncSnapshot<Map<String, WhoToFollow>> snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.data!.isNotEmpty ? 'You followed ${snapshot.data?.length} people' : 'Follow a few people to \nget started',
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),
                            ),
                            if (snapshot.data!.isNotEmpty) ...[
                              const SizedBox(
                                height: 4.0,
                              ),
                              SizedBox(
                                height: 40.0,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    final user = snapshot.data?.entries.toList()[index].value;
                                    return Container(
                                      transform: Matrix4.translationValues((-8 * index).toDouble(), 0, 0),
                                      child: CircleAvatar(
                                        radius: 16.0,
                                        backgroundColor: primaryThemeColor,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(100.0),
                                          child: NewtworkImageWrapper(
                                            imageUrl: user!.imageUrl,
                                            height: 30.0,
                                            width: 30.0,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ]
                          ],
                        );
                      } else {
                        return Text(
                          'Follow a few people to \nget started',
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),
                        );
                      }
                    },
                  ),
                  StreamBuilder(
                      stream: following.stream,
                      builder: (context, AsyncSnapshot<Map<String, WhoToFollow>> snapshot) {
                        if (snapshot.hasData && snapshot.data!.length >= 3) {
                          return IconButton(
                            onPressed: () => {},
                            icon: const Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            ),
                          );
                        } else {
                          return IconButton(
                            onPressed: () => {},
                            icon: const Icon(
                              Icons.arrow_forward,
                              color: Colors.white30,
                            ),
                          );
                        }
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserCard extends StatefulWidget {
  final WhoToFollow user;

  final Function(int id) onFollow;
  final Function() onRemove;
  const UserCard({
    super.key,
    required this.user,
    required this.onFollow,
    required this.onRemove,
  });

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  Offset offset = const Offset(0, 0);
  Offset textOffset = const Offset(0, 0);
  Offset iconOffset = const Offset(0, 0);
  Offset dragStart = const Offset(0, 0);
  Offset dragPosition = const Offset(0, 0);

  bool isLeftOpen = false;
  bool isRightOpen = false;
  bool isPanRight = true;

  final maxDragDistance = 32.0;
  final openOffset = 80.0;

  void onDragUpdate(DragUpdateDetails details) {
    //Check if pan right or pan left
    if (details.localPosition.dx <= dragPosition.dx) {
      isPanRight = false;
    }

    if (details.localPosition.dx >= dragPosition.dx) {
      isPanRight = true;
    }

    var movedDistance = details.localPosition.dx - dragStart.dx;
    var ratio = movedDistance.abs() / maxDragDistance;
    var factor = 1 / (ratio + 1);

    var updatedOffset = Offset(offset.dx + (details.delta.dx * factor), 0);

    setState(() {
      dragPosition = details.localPosition;
      offset = updatedOffset;
    });
  }

  void onDragStart(DragStartDetails details) {
    dragStart = details.localPosition;
  }

  void reset() {
    setState(() {
      offset = Offset.zero;
      textOffset = Offset.zero;
      iconOffset = Offset.zero;
      isLeftOpen = false;
      isRightOpen = false;
    });
  }

  void onDragEnd(details) {
    print("drag ended");

    if (offset.dx.abs() <= maxDragDistance * 1.8) {
      reset();
    } else {
      if (isPanRight) {
        if (isLeftOpen || isRightOpen) {
          reset();
        } else {
          setState(() {
            offset = Offset(openOffset, 0.0);

            iconOffset = Offset(-openOffset, 0);

            isLeftOpen = true;
            isRightOpen = false;
          });
        }
      } else if (!isPanRight) {
        if (isLeftOpen || isRightOpen) {
          reset();
        } else {
          setState(() {
            offset = Offset(-openOffset, 0.0);

            textOffset = Offset(openOffset, 0);

            isLeftOpen = false;
            isRightOpen = true;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64.0,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onHorizontalDragStart: (details) {
          onDragStart(details);
        },
        onHorizontalDragUpdate: (details) {
          onDragUpdate(details);
        },
        onHorizontalDragEnd: (details) {
          onDragEnd(details);
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                color: primaryThemeColor,
                child: Stack(
                  children: [
                    AnimatedPositioned(
                      curve: Curves.ease,
                      duration: const Duration(milliseconds: 570),
                      left: 96 - offset.dx,
                      top: 0.0,
                      bottom: 0.0,
                      child: Material(
                        color: Colors.transparent,
                        child: IconButton(
                          splashRadius: 24.0,
                          iconSize: 24.0,
                          onPressed: () {
                            reset();

                            //Open profile in web
                          },
                          icon: const Icon(
                            Icons.open_in_new,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      curve: Curves.ease,
                      duration: const Duration(milliseconds: 570),
                      right: 96 - offset.dx.abs(),
                      top: 0.0,
                      bottom: 0.0,
                      child: Material(
                        color: Colors.transparent,
                        child: IconButton(
                          splashRadius: 24.0,
                          iconSize: 24.0,
                          onPressed: () {
                            reset();

                            //Open bottom sheet

                            // showModalBottomSheet(
                            //   // isDismissible: true,
                            //   isScrollControlled: true,

                            //   context: context,
                            //   backgroundColor: Colors.transparent,
                            //   builder: (_) {
                            //     return const CustomBottomSheet();
                            //   },
                            // );
                          },
                          icon: const Icon(
                            Icons.more_vert,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AnimatedPositioned(
              curve: Curves.ease,
              duration: const Duration(milliseconds: 400),
              left: offset.dx,
              top: 0.0,
              right: -offset.dx,
              bottom: 0.0,
              child: Stack(
                children: [
                  AnimatedContainer(
                    curve: Curves.ease,
                    duration: const Duration(milliseconds: 570),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: isLeftOpen || isRightOpen
                          ? Border.all(
                              color: Colors.white.withOpacity(0.16),
                              width: 1.0,
                            )
                          : null,
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        AnimatedPositioned(
                          curve: Curves.ease,
                          duration: const Duration(milliseconds: 570),
                          left: textOffset.dx,
                          top: 0.0,
                          right: -textOffset.dx,
                          bottom: 0.0,
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 24.0,
                                backgroundColor: widget.user.isFollowing ? primaryThemeColor : Colors.transparent,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100.0),
                                  child: NewtworkImageWrapper(
                                    imageUrl: widget.user.imageUrl,
                                    height: 43.0,
                                    width: 43.0,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 16.0,
                              ),
                              Flexible(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '@${widget.user.name}',
                                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white),
                                    ),
                                    const SizedBox(
                                      height: 4.0,
                                    ),
                                    Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            '#${widget.user.id}',
                                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white54),
                                            overflow: TextOverflow.ellipsis,
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
                      ],
                    ),
                  ),
                  Positioned.fill(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        highlightColor: Colors.white.withOpacity(0.04),
                        splashColor: Colors.white.withOpacity(0.06),
                        onTap: () {
                          if (isLeftOpen || isRightOpen) return;

                          reset();
                          widget.onFollow(widget.user.id);
                        },
                      ),
                    ),
                  ),
                  AnimatedPositioned(
                    curve: Curves.ease,
                    duration: const Duration(milliseconds: 570),
                    top: 0.0,
                    right: 16.0 - iconOffset.dx,
                    bottom: 0.0,
                    child: SizedBox(
                      width: 48.0,
                      height: 48.0,
                      child: widget.user.isFollowing
                          ? const UnconstrainedBox(
                              child: CircleAvatar(
                                radius: 12.0,
                                backgroundColor: primaryThemeColor,
                                child: Icon(
                                  Icons.check_circle,
                                  size: 16.0,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : Material(
                              color: Colors.transparent,
                              child: AnimatedOpacity(
                                curve: Curves.ease,
                                duration: const Duration(milliseconds: 570),
                                opacity: isLeftOpen || isRightOpen ? 0 : 1,
                                child: IconButton(
                                  splashRadius: 24.0,
                                  iconSize: 18.0,
                                  onPressed: () {
                                    reset();
                                    widget.onRemove();
                                  },
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.white54,
                                  ),
                                ),
                              ),
                            ),
                    ),
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

class UserCardLoading extends StatelessWidget {
  const UserCardLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(100.0),
        child: Container(
          height: 48.0,
          width: 48.0,
          color: Colors.white24,
        ),
      ),
      title: Row(
        children: [
          Container(
            width: 90.0,
            height: 4.0,
            color: Colors.white24,
          ),
        ],
      ),
      subtitle: Row(
        children: [
          Container(
            width: 160.0,
            height: 4.0,
            color: Colors.white.withOpacity(0.16),
          ),
        ],
      ),
    );
  }
}
