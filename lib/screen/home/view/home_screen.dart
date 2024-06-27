import 'package:browser_app/component/network/provider/network_provider.dart';
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

  String? get url => null;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<NetworkProvider>().checkConnection();
    context.read<HomeProvider>().getBookMarks().then((value) {
     // var link2 =context.read<HomeProvider>().link.toString();
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

                context.read<HomeProvider>().getBookMarks();
                showBookMark();
              },),
            ];
          },),
        ],
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: context.watch<HomeProvider>().progress,
          ),
          Expanded(
            child: InAppWebView(
                initialUrlRequest: URLRequest(
                    url: WebUri("https://www.google.com/")),
                onProgressChanged: (controller, progress) {
                  context.read<HomeProvider>().ProgressIndicator(progress / 100);
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
                    url: WebUri("https://www.google.com/")));
          },icon: const Icon(Icons.home,size: 25,),),
          Spacer(),
          IconButton(onPressed: () {
            context.read<HomeProvider>().addbookmark(context);
            showBookMark();
          },icon: const Icon(Icons.bookmark_add),),
          Spacer(),
          IconButton(onPressed: () {
            inAppWebViewController!.goBack();
          },icon: const Icon(Icons.arrow_back),),
          Spacer(),
          IconButton(onPressed: () {
            inAppWebViewController!.reload();
          },icon: const Icon(Icons.refresh),),
          Spacer(),
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
            return Container(
              child: Expanded(
                child: ListView.builder(
                  itemCount: providerR!.bookMark.length,
                  itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(providerW!.bookMark[index]) ,onTap: () {
                    inAppWebViewController!.loadUrl(
                        urlRequest: URLRequest(url: WebUri("https://www.google.com/")));
                    },
                  );
                },),
              ),
            );
          },);
        },
    );
  }
}
