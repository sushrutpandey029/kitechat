import 'package:flutter/material.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../size_config.dart';
import 'web_view_screen.dart';

enum MenuItem {
  item1,
  item2,
  item3,
  item4,
  item5,
  item6,
  item7,
}

class WebSearchPage extends StatefulWidget {
  const WebSearchPage({Key? key}) : super(key: key);

  @override
  State<WebSearchPage> createState() => _WebSearchPageState();
}

class _WebSearchPageState extends State<WebSearchPage>
    with SingleTickerProviderStateMixin {
  String search = '';
  TabController? _tabController;
  TextEditingController _textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(
              height: 8.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back)),
                  PopupMenuButton<MenuItem>(
                      onSelected: (value) {
                        if (value == MenuItem.item1) {}
                        if (value == MenuItem.item2) {}
                        if (value == MenuItem.item3) {}
                        if (value == MenuItem.item4) {}
                        if (value == MenuItem.item5) {}
                        if (value == MenuItem.item6) {}
                        if (value == MenuItem.item7) {}
                      },
                      itemBuilder: (context) => [
                            const PopupMenuItem(
                              child: Text('View contact'),
                            ),
                            const PopupMenuItem(
                              child: Text('Media, links and docs'),
                            ),
                            const PopupMenuItem(
                              child: Text('Search'),
                            ),
                            const PopupMenuItem(
                              child: Text('mute notification'),
                            ),
                            const PopupMenuItem(
                              child: Text('Disappearing messages'),
                            ),
                            const PopupMenuItem(
                              value: MenuItem.item6,
                              child: Text('Wallpaper'),
                            ),
                            const PopupMenuItem(
                              child: Text('More'),
                            ),
                          ]),
                ],
              ),
            ),
            SizedBox(
              height: 70,
              child: Image.asset('assets/images/people_logo.png'),
            ),
            const SizedBox(
              height: 60,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 80.w,
                  child: TextField(
                    onChanged: (text) {
                      search = text;
                    },
                    textInputAction: TextInputAction.go,
                    controller: _textEditingController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color.fromARGB(255, 220, 233, 255),
                      hintText: 'Web Search by Kite',
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(100)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WebViewScreen(
                          url: 'https://www.google.com/search?q=$search',
                          name: "Results",
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.search,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: DefaultTabController(
                initialIndex: 0,
                length: 2,
                child: Scaffold(
                  body: Padding(
                    padding: const EdgeInsets.all(16.1),
                    child: ListView(
                      children: <Widget>[
                        TabBar(
                          controller: _tabController,
                          tabs: const <Widget>[
                            Tab(
                              child: Text(
                                'EXPLORE',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            Tab(
                              child: Text(
                                'FAVORITES',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: getProportionateScreenHeight(25),
                        ),
                        SizedBox(
                          height: 435,
                          width: 400,
                          child: TabBarView(
                            controller: _tabController,
                            children: <Widget>[
                              SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 590,
                                      width: 390,
                                      child: Column(
                                        children: <Widget>[
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const WebViewScreen(
                                                    url:
                                                        'https://www.google.com/search?q=decentralized+finance&rlz=1C1CHWL_enIN895IN895&oq=decentralized+finance&aqs=chrome..69i57j0i20i263i512j0i512l8.11760j1j15&sourceid=chrome&ie=UTF-8',
                                                    name:
                                                        "Decentralized finance",
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Card(
                                              elevation: 2,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: const <Widget>[
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 30.0),
                                                    child: CircleAvatar(),
                                                  ),
                                                  SizedBox(
                                                    width: 250,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(25.0),
                                                      child: Text(
                                                        'Decentralized finance',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const WebViewScreen(
                                                    url:
                                                        'https://www.google.com/search?q=decentralized+exchange&rlz=1C1CHWL_enIN895IN895&sxsrf=ALiCzsZnW-rI_5L2_YNDDMPjam0cK-Rbbg%3A1663230653735&ei=veIiY9G3LMjb4-EP99S5SA&ved=0ahUKEwiRiq6CsZb6AhXI7TgGHXdqDgkQ4dUDCA4&uact=5&oq=decentralized+exchange&gs_lcp=Cgdnd3Mtd2l6EAMyCggAEIAEEIcCEBQyBQgAEIAEMgUIABCABDIFCAAQgAQyBQgAEIAEMgUIABCABDIFCAAQgAQyBQgAEIAEMgUIABCABDIFCAAQgAQ6CggAEEcQ1gQQsAM6BwgAELADEEM6DQgAEOQCENYEELADGAE6EgguEMcBENEDEMgDELADEEMYAjoPCC4Q1AIQyAMQsAMQQxgCSgQIQRgASgQIRhgBUJ0MWJoeYLEhaAJwAXgAgAHGAYgB8gqSAQMwLjiYAQCgAQHIARLAAQHaAQYIARABGAnaAQYIAhABGAg&sclient=gws-wiz',
                                                    name:
                                                        "Decentralized Exchange",
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Card(
                                              elevation: 2,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: const <Widget>[
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 30.0),
                                                    child: CircleAvatar(),
                                                  ),
                                                  SizedBox(
                                                    width: 250,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(25.0),
                                                      child: Text(
                                                        'Decentralized Exchange',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const WebViewScreen(
                                                    url:
                                                        'https://www.google.com/search?rlz=1C1CHWL_enIN895IN895&sxsrf=ALiCzsY5A39bPTgEPgttrV9dJbswhzbBTA:1663231329941&q=art+and+collectible+nft&spell=1&sa=X&ved=2ahUKEwj6vObEs5b6AhWJ4TgGHeGYC7IQBSgAegQIAxA2&biw=1353&bih=590&dpr=1.42',
                                                    name: "Art and Collectible",
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Card(
                                              elevation: 2,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: const <Widget>[
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 30.0),
                                                    child: CircleAvatar(),
                                                  ),
                                                  SizedBox(
                                                    width: 250,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(25.0),
                                                      child: Text(
                                                        'Art and Collectibles',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const WebViewScreen(
                                                    url:
                                                        'https://www.google.com/search?rlz=1C1CHWL_enIN895IN895&sxsrf=ALiCzsY5A39bPTgEPgttrV9dJbswhzbBTA:1663231329941&q=art+and+collectible+nft&spell=1&sa=X&ved=2ahUKEwj6vObEs5b6AhWJ4TgGHeGYC7IQBSgAegQIAxA2&biw=1353&bih=590&dpr=1.42',
                                                    name: "Earn crypto",
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Card(
                                              elevation: 2,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: const <Widget>[
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 30.0),
                                                    child: CircleAvatar(),
                                                  ),
                                                  SizedBox(
                                                    width: 250,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(25.0),
                                                      child: Text(
                                                        'Earn crypto',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const WebViewScreen(
                                                    url:
                                                        'https://www.google.com/search?q=Developer+tool&rlz=1C1CHWL_enIN895IN895&biw=1353&bih=590&sxsrf=ALiCzsbpWBCRcttOX-mfYq1aXdd3jBqEpQ%3A1663231489624&ei=AeYiY-_dJdi12roP6teliA0&ved=0ahUKEwiv4viQtJb6AhXYmlYBHeprCdEQ4dUDCA4&uact=5&oq=Developer+tool&gs_lcp=Cgdnd3Mtd2l6EAMyCwgAEIAEELEDEIMBMgUIABCABDIFCAAQgAQyBQgAEIAEMgUIABCABDIFCAAQgAQyBQgAEIAEMgUIABCABDIFCAAQgAQyBQgAEIAEOgcIIxDqAhAnSgQIQRgASgQIRhgAUIINWIINYJ8UaAJwAXgAgAHMAYgBzAGSAQMyLTGYAQCgAQGgAQKwAQrAAQE&sclient=gws-wiz',
                                                    name: "Developer Tool",
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Card(
                                              elevation: 2,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: const <Widget>[
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 30.0),
                                                    child: CircleAvatar(),
                                                  ),
                                                  SizedBox(
                                                    width: 250,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(25.0),
                                                      child: Text(
                                                        'Developer Tool',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const WebViewScreen(
                                                    url:
                                                        'https://www.google.com/search?q=Developer+tool&rlz=1C1CHWL_enIN895IN895&biw=1353&bih=590&sxsrf=ALiCzsbpWBCRcttOX-mfYq1aXdd3jBqEpQ%3A1663231489624&ei=AeYiY-_dJdi12roP6teliA0&ved=0ahUKEwiv4viQtJb6AhXYmlYBHeprCdEQ4dUDCA4&uact=5&oq=Developer+tool&gs_lcp=Cgdnd3Mtd2l6EAMyCwgAEIAEELEDEIMBMgUIABCABDIFCAAQgAQyBQgAEIAEMgUIABCABDIFCAAQgAQyBQgAEIAEMgUIABCABDIFCAAQgAQyBQgAEIAEOgcIIxDqAhAnSgQIQRgASgQIRhgAUIINWIINYJ8UaAJwAXgAgAHMAYgBzAGSAQMyLTGYAQCgAQGgAQKwAQrAAQE&sclient=gws-wiz',
                                                    name: "Social",
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Card(
                                              elevation: 2,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: const <Widget>[
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 30.0),
                                                    child: CircleAvatar(),
                                                  ),
                                                  SizedBox(
                                                    width: 250,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(25.0),
                                                      child: Text(
                                                        'Social',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const WebViewScreen(
                                                    url:
                                                        'https://www.google.com/search?q=crypto+market&rlz=1C1CHWL_enIN895IN895&biw=1353&bih=590&sxsrf=ALiCzsb3qAtL4lZNeusvF-1WsSgPNRdlYg%3A1663232829427&ei=PesiY6zaGbDz4-EPuqyuYA&ved=0ahUKEwjs7OePuZb6AhWw-TgGHTqWCwwQ4dUDCA4&uact=5&oq=crypto+market&gs_lcp=Cgdnd3Mtd2l6EAMyDggAEIAEELEDEIMBEIsDMhMIABCABBCHAhCxAxCDARAUEIsDMhAIABCABBCHAhCxAxAUEIsDMg4IABCABBCxAxCDARCLAzIOCAAQgAQQsQMQgwEQiwMyCAgAEIAEEIsDMgsIABCABBCxAxCLAzIICAAQgAQQiwMyCAgAEIAEEIsDMggIABCABBCLAzoKCAAQRxDWBBCwAzoHCAAQsAMQQzoHCCMQ6gIQJzoECCMQJzoKCAAQsQMQgwEQQzoECAAQQzoLCAAQgAQQsQMQgwE6EQguEIAEELEDEIMBEMcBENEDOggIABCABBCxAzoFCAAQgAQ6CAguELEDEIMBOgUIABCRAjoUCC4QxwEQ0QMQkQIQiwMQqAMQ0gM6BwgAEEMQiwM6DQguEMcBENEDEEMQiwM6CAgAEJECEIsDOgcILhBDEIsDOg0IABCxAxCDARBDEIsDOgoIABCxAxBDEIsDOg4IABCxAxCDARCRAhCLAzoLCAAQsQMQgwEQiwM6CggAEMkDEEMQiwNKBAhBGABKBAhGGABQttQPWJ33D2DH_A9oA3ABeACAAdkBiAH2EpIBBjAuMTEuMpgBAKABAbABCsgBCrgBA8ABAQ&sclient=gws-wiz',
                                                    name: "Market",
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Card(
                                              elevation: 2,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: const <Widget>[
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 30.0),
                                                    child: CircleAvatar(),
                                                  ),
                                                  SizedBox(
                                                    width: 250,
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(25.0),
                                                      child: Text(
                                                        'Market',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    const Text(
                                      '   Collectables will appear here',
                                    ),
                                    SizedBox(
                                      height: getProportionateScreenHeight(25),
                                    ),
                                    Column(
                                      children: <Widget>[
                                        IconButton(
                                          onPressed: () {},
                                          icon: const Icon(
                                            Icons.download,
                                            size: 50,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        SizedBox(
                                          height:
                                              getProportionateScreenHeight(15),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(left: 24.0),
                                          child: Text(
                                            'Recieve',
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: getProportionateScreenHeight(25),
                                    ),
                                    const Text(
                                      '       Open on OpenSea.io',
                                      style: TextStyle(
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ]),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
