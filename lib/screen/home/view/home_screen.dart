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


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<NetworkProvider>().checkConnection();
    context.read<HomeProvider>().getBookMarks();
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
        title: SizedBox(
          height: 45,
          child: SearchBar(
              elevation: MaterialStateProperty.resolveWith((states) => 0.5),
              controller: txtWeb,
              hintText: "Search your web address",
              leading: const Icon(Icons.search),
              onTap: () {
                inAppWebViewController?.loadUrl(
                    urlRequest: URLRequest(
                        url: WebUri(
                            "${providerW!.sSearch}${txtWeb
                                .text}")));
              }),
        ),
        actions: [
          PopupMenuButton(itemBuilder: (context) {
            return [
              PopupMenuItem(child: const Row(
                children: [
                  Icon(Icons.bookmark),
                  Text("BookMark"),
                ],
              ),onTap: () {showBookMark();},),
              PopupMenuItem(child: const Row(
                children: [
                  Icon(Icons.screen_search_desktop_outlined),
                  Text("Search Engine"),
                ],
              ),onTap: () {SearchBox();},),
            ];
          },),
        ],
      ),
      body: context.watch<NetworkProvider>().isInternet == false
          ? const Network_Widget()
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
                    url: WebUri("https://www.google.com/")),
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
                    url: WebUri("https://www.google.com/")));
          },icon: const Icon(Icons.home,size: 25,),),
          const Spacer(),
          IconButton(onPressed: () async{
            var link = await inAppWebViewController!.getOriginalUrl();
            providerR!.setBookMarks(link.toString());
            providerR!.bookMark!.add(link.toString());
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
              itemCount: providerW!.bookMark!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    inAppWebViewController!.
                    loadUrl(
                        urlRequest:
                        URLRequest(url: WebUri(providerW!.bookMark![index])));
                    Navigator.pop(context);
                  },
                  title: Text(providerW!.bookMark![index],style: const TextStyle(overflow: TextOverflow.ellipsis),),
                );
              },
            ),
          );
        },);
      },
    );
  }
  void SearchBox()
  {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actions: [
              Column(
                children: [
                  RadioListTile(
                      value: "Google",
                      groupValue: providerW!.isCheck,
                      onChanged: (value) {
                        providerW!.changeSearch("https://www.google.co.in", "https://www.google.com/search?q=");
                        providerW!.Check(value);
                        inAppWebViewController!.loadUrl(
                            urlRequest: URLRequest(
                              url: WebUri("https://www.google.com/")
                            ),
                        );
                        Navigator.pop(context);
                      },title: const Text("Google"),),
                  RadioListTile(
                      value: "Yahoo",
                      groupValue: providerW!.isCheck,
                      onChanged: (value) {
                        providerW!.changeSearch("https://in.search.yahoo.com", "https://in.search.yahoo.com/search;_ylt=AwrKAJPgOX5mIQcFSC.6HAx.;_ylc=X1MDMjExNDcyMzAwMgRfcgMyBGZyAwRmcjIDcDpzLHY6c2ZwLG06c2ItdG9wBGdwcmlkA0ZZSFVWWG04UWhHeVhkNkdXMzJuYkEEbl9yc2x0AzAEbl9zdWdnAzEwBG9yaWdpbgNpbi5zZWFyY2gueWFob28uY29tBHBvcwMwBHBxc3RyAwRwcXN0cmwDMARxc3RybAMzBHF1ZXJ5A2NhcgR0X3N0bXADMTcxOTU1NjUwOQ--?p=");
                        providerW!.Check(value);
                        inAppWebViewController!.loadUrl(
                            urlRequest: URLRequest(
                              url: WebUri("https://in.search.yahoo.com/")
                            ),
                        );
                        Navigator.pop(context);
                      },title: const Text("Yahoo"),),
                  RadioListTile(
                      value: "Bing",
                      groupValue: providerW!.isCheck,
                      onChanged: (value) {
                        providerW!.changeSearch("https://www.bing.com/", "https://www.bing.com/search?q=");
                        providerW!.Check(value);
                        inAppWebViewController!.loadUrl(
                            urlRequest: URLRequest(
                              url: WebUri("https://www.bing.com/")
                            ),
                        );
                        Navigator.pop(context);
                      },title: const Text("Bing"),),
                  RadioListTile(
                      value: "Duck Duck Go",
                      groupValue: providerW!.isCheck,
                      onChanged: (value) {
                        providerW!.changeSearch("https://duckduckgo.com/", "https://duckduckgo.com/?t=h_&q=");
                        providerW!.Check(value);
                        inAppWebViewController!.loadUrl(
                            urlRequest: URLRequest(
                              url: WebUri("https://duckduckgo.com/")
                            ),
                        );
                        Navigator.pop(context);
                      },title: const Text("Duck Duck Go"),),
                ],
              )
            ],
          );
        },);
  }
}

