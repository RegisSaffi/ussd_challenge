import 'package:flutter/material.dart';
import 'package:ussd_advanced/ussd_advanced.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _response="Press the button to get the banks";
  bool loading=false;
  bool error=false;
  String? errorMessage;

  //This request will run in the background and print the response
  backgroundRequest() async {
    int subscriptionId = -1;
    String code = "*182*4*3#";
    try {
      setState(() {
        loading = true;
      });
      String? _res = await UssdAdvanced.sendAdvancedUssd(
          code: code, subscriptionId: subscriptionId);
      setState(() {
        loading = false;
        _response = _res;
        error=_res==null;
      });
    }catch(e){
      setState(() {
        loading=false;
        _response="Error running USSD code";
        error=true;
      });
    }
  }

  //This request will run as a normal USSD code
  normalRequest() async {
    int subscriptionId = -1;
    String code = "*182*4*3#";
    try {
      setState(() {
        loading = true;
      });
      await UssdAdvanced.sendUssd(
          code: code, subscriptionId: subscriptionId);
      setState(() {
        loading = false;
        _response = "USSD code executed";
        error=false;
      });
    }catch(e){
      setState(() {
        loading=false;
        _response="Error running USSD code";
        error=true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('USSD challenge'),
        ),
        body: SizedBox.expand(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [

                loading?const Padding(
                  padding: EdgeInsets.all(18.0),
                  child: CircularProgressIndicator.adaptive(),
                ):Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: Text(_response!),
                ),

                ElevatedButton(
                  onPressed: ()=> backgroundRequest(),
                  child: const Text('Get the banks'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}