import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_reactive_programming/twitter_who_to_follow/who_to_follow_data.dart';
import 'package:flutter_reactive_programming/util/image.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:stream_transform/stream_transform.dart' show CombineLatest;

class WhoToFollowWidget extends StatefulWidget {
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
      var randomOffset = random.nextInt(500);

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

      return getRandomUser(data);
    }).mergeWith([
      refreshClickController.stream.map((event) => null),
      follow1ClickController.stream.map((user) => followUser(user)),
    ]);

    follow2 = closeFollow2ClickController.stream.startWith(null).combineLatest<http.Response, WhoToFollow?>(responseStream, (t, s) {
      var data = jsonDecode(s.body);

      return getRandomUser(data);
    }).mergeWith([
      refreshClickController.stream.map((event) => null),
      follow2ClickController.stream.map((user) => followUser(user)),
    ]);

    follow3 = closeFollow3ClickController.stream.startWith(null).combineLatest<http.Response, WhoToFollow?>(responseStream, (t, s) {
      var data = jsonDecode(s.body);

      return getRandomUser(data);
    }).mergeWith([
      refreshClickController.stream.map((event) => null),
      follow3ClickController.stream.map((user) => followUser(user)),
    ]);

    follow4 = closeFollow4ClickController.stream.startWith(null).combineLatest<http.Response, WhoToFollow?>(responseStream, (t, s) {
      var data = jsonDecode(s.body);

      return getRandomUser(data);
    }).mergeWith([
      refreshClickController.stream.map((event) => null),
      follow4ClickController.stream.map((user) => followUser(user)),
    ]);

    follow5 = closeFollow5ClickController.stream.startWith(null).combineLatest<http.Response, WhoToFollow?>(responseStream, (t, s) {
      var data = jsonDecode(s.body);

      return getRandomUser(data);
    }).mergeWith([
      refreshClickController.stream.map((event) => null),
      follow5ClickController.stream.map((user) => followUser(user)),
    ]);
  }

  WhoToFollow getRandomUser(List<dynamic> data) {
    var randomUser = data[random.nextInt(data.length)];

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
                            color: Colors.blue,
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
                                        backgroundColor: Colors.green,
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

class UserCard extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return ListTile(
      leading: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(100.0),
            child: NewtworkImageWrapper(
              imageUrl: user.imageUrl,
              height: 48.0,
              width: 48.0,
              fit: BoxFit.cover,
            ),
          ),
          if (user.isFollowing)
            const Positioned(
              bottom: 2.0,
              right: 0.0,
              child: CircleAvatar(
                radius: 10.0,
                backgroundColor: Colors.green,
                child: Icon(
                  Icons.check_circle,
                  size: 12.0,
                  color: Colors.white,
                ),
              ),
            )
        ],
      ),
      title: Text(
        '@${user.name}',
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white),
      ),
      subtitle: Column(
        children: [
          const SizedBox(
            height: 4.0,
          ),
          Row(
            children: [
              Text(
                '#${user.id}',
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white54),
              ),
              if (user.isFollowing)
                Container(
                  margin: const EdgeInsets.only(left: 8.0),
                  padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
                  color: Colors.white30,
                  child: Text(
                    'following',
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(color: Colors.white60),
                  ),
                )
            ],
          ),
        ],
      ),
      onTap: () => onFollow(user.id),
      trailing: IconButton(
        splashRadius: 24.0,
        iconSize: 16.0,
        onPressed: onRemove,
        icon: const Icon(
          Icons.close,
          color: Colors.white54,
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
