import 'package:browser_app/component/network/provider/network_provider.dart';
import 'package:browser_app/component/network/view/network_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';

import '../provider/home_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  HomeProvider? providerR;
  HomeProvider? providerW;
  InAppWebViewController? inAppWebViewController;
  PullToRefreshController? pcontroller;
  TextEditingController txtWeb = TextEditingController();
  String? link2;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<NetworkProvider>().checkConnection();
    context.read<HomeProvider>().getBookMarks().then((value) {
      link2 =context.read<HomeProvider>().link.toString();
    });
    pcontroller = PullToRefreshController(
      onRefresh: () {
        inAppWebViewController!.reload();
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    providerR = context.read<HomeProvider>();
    providerW = context.watch<HomeProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Browser"),
        centerTitle: true,
        actions: [
          PopupMenuButton(itemBuilder: (context) {
            return [
              PopupMenuItem(child: const Row(
                children: [
                  Icon(Icons.bookmark),
                  Text("BookMark"),
                ],
              ),onTap: () {
                showBookMark();
              },),
            ];
          },),
        ],
      ),
      body: context.watch<NetworkProvider>().isInternet == false
          ? Network_Widget()
          : Column(
        children: [

          const SizedBox(
            height: 10,
          ),
          LinearProgressIndicator(
            value: providerW!.progress,
          ),
          Expanded(
            child: InAppWebView(
                initialUrlRequest: URLRequest(
                    url: WebUri("https://playhop.com/")),
                onProgressChanged: (controller, progress) {
                  providerR!.ProgressIndicator(progress / 100);
                  inAppWebViewController = controller;
                  if (progress == 100) {
                    pcontroller?.endRefreshing();
                  }
                },
                onLoadStart: (controller, url) {
                  inAppWebViewController = controller;
                },
                onLoadStop: (controller, url) {
                  pcontroller?.endRefreshing();
                  inAppWebViewController = controller;
                },
                pullToRefreshController: pcontroller),
          ),
        ],
      ),
      bottomNavigationBar: Row(
        children: [
          IconButton(onPressed: () {
            inAppWebViewController?.loadUrl(
                urlRequest: URLRequest(
                    url: WebUri("https://playhop.com/")));
          },icon: const Icon(Icons.home,size: 25,),),
          const Spacer(),
          IconButton(onPressed: () async{
            var link = await inAppWebViewController!.getOriginalUrl();
            providerR!.setBookMarks(link.toString());
            providerR!.bookMark.add(link.toString());
            // providerR!.bookMark.add(link.toString());
            print(link!.toString());
          },icon: const Icon(Icons.bookmark_add),),
          const Spacer(),
          IconButton(onPressed: () {
            inAppWebViewController!.goBack();
          },icon: const Icon(Icons.arrow_back),),
          const Spacer(),
          IconButton(onPressed: () {
            inAppWebViewController!.reload();
          },icon: const Icon(Icons.refresh),),
          const Spacer(),
          IconButton(onPressed: () {
            inAppWebViewController!.goForward();
          },icon: const Icon(Icons.arrow_forward,size: 25,),),

        ],
      ),

    );
  }
  void showBookMark()
  {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(onClosing: () {}, builder: (context) {
          return Expanded(
            child: ListView.builder(
              itemCount: providerW!.bookMark.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    inAppWebViewController!.
                    loadUrl(
                        urlRequest:
                        URLRequest(url: WebUri(providerW!.bookMark[index])));
                    Navigator.pop(context);
                  },
                  title: Text(providerW!.bookMark[index],style: const TextStyle(overflow: TextOverflow.ellipsis),),
                );
              },
            ),
          );
        },);
      },
    );
  }
}

