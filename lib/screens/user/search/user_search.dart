import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outq/components/Services/service_card_long.dart';
import 'package:outq/components/placeholders/placeholder.dart';
import 'package:outq/screens/user/components/appbar/user_appbar.dart';
import 'package:outq/utils/color_constants.dart';
import 'package:outq/utils/constants.dart';
import 'package:outq/utils/sizes.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

String? userid;
Future getUserId(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  userid = prefs.getString("userid")!;
}

class UserSearchServicesPage extends StatefulWidget {
  var title;

  UserSearchServicesPage({super.key, required this.title});

  @override
  State<UserSearchServicesPage> createState() => _UserSearchServicesPageState();
}

class _UserSearchServicesPageState extends State<UserSearchServicesPage> {
  dynamic argumentData = Get.arguments;
  // @override
  // void initState() async {
  //   super.initState();
  // }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserId(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: UserAppBarWithBack(
          title: widget.title,
        ),
      ),
      body: Container(
        // padding: const EdgeInsets.symmetric(horizontal: tDefaultSize),
        color: ColorConstants.appbgclr,
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.only(top: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            FutureBuilder(
              future: http.get(Uri.parse(
                  '${apidomain}service/search/${argumentData[0]}/$userid')),
              builder: (BuildContext context,
                  AsyncSnapshot<http.Response> snapshot) {
                if (snapshot.hasData) {
                  var data = jsonDecode(snapshot.data!.body);
                  if (data.length == 0) {
                    return const Text('No services Found ');
                  }
                  return Expanded(
                    flex: 3,
                    child: ListView.builder(
                      padding:
                          const EdgeInsets.symmetric(horizontal: tDefaultSize),
                      physics: const BouncingScrollPhysics(),
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int i) {
                        return ServiceCardLong2(data: data[i]);
                      },
                    ),
                  );
                } else if (snapshot.hasError) {
                  return const Text('No services Found');
                } else {
                  return const Center(child: PlaceholderLong());
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
