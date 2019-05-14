//
// Created by dyf on 2018/8/31.
// Copyright (c) 2018 dyf.
//

import 'package:flutter/material.dart';

import './crypto/crypto_provider.dart' as dtcrypt;

final publicKey =
    """"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCmPW2SwJFldGVB1SM82VYvSZYR
F1H5DREUiDK2SLnksxHAV/roC1uB44a4siUehJ9AKeV/g58pVrjhX3eSiBh9Khom
/S2hEWF2n/6+lqqiwQi1W5rjl86v+dI2F6NgbPFpfesrRjWD9uskT2VX/ZJuMRLz
8VPIyQOM9TW3PkMYBQIDAQAB""";

final privateKey =
    """MIICXAIBAAKBgQCmPW2SwJFldGVB1SM82VYvSZYRF1H5DREUiDK2SLnksxHAV/ro
C1uB44a4siUehJ9AKeV/g58pVrjhX3eSiBh9Khom/S2hEWF2n/6+lqqiwQi1W5rj
l86v+dI2F6NgbPFpfesrRjWD9uskT2VX/ZJuMRLz8VPIyQOM9TW3PkMYBQIDAQAB
AoGAK2VVuT1ztxxPYoQVEslZaja3afbAe1ch4k47jsIlZMIqHB/ba7+rP5j5jjVS
40iTmdhWBJeDcPMmiA631BSa74XW4RyZ8JDtu1qOYxH5tqhgsIEDbVAAqCB+t+y1
3z/Nb+SO3mbRGu5HzvAMaad3M7ztR3SAJTiPK1OI293wdXECQQDS4Hx3fwg66NYL
b061Hk8P5arClUnBoh5/qZk/kx3nen7SdjACVXC/9B/PnxTeZkcqQi+y0MjzuPHU
5n2PT26HAkEAyc/MWRqtgTQHd4EqzYt6vvkhMo0T8w36/ABiQSRfKrbJXEmK1Qf4
4z8f6jTZTMTqF56aMwaI81Uzt1IqzCf8EwJBAM2/d9GDoT0RBh58CJhQrSU+mWBn
FmKV0hoPGNXdrZS3gNvJssfkIzE2eH8zoMHpms/RagaXDSo3LcTi6mkUQCsCQFz2
cM524IfM3Meq43mtj4xbHHS50f+7Z+sfjiMtyvzVGGp/oglB099yW5Q6ZgLcDm10
7NkmYH2euOTwX7CNlqsCQBicZxvPsIgp8zdAiGbxverXzmZs9JZDODUhw8HQkm2o
CZWXHDraHaZ9NA88vpdLfqBXtF5t0QNFpD80F/7HjtE=""";

void main() => runApp(new MyApp());

void cryptoTest() {
  // final plainText = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit ........，当链接进行查询时，如果没有定义id，就有可能出现不同类别的内容，但是名字相同，例如某专辑的名字和某个app的名字重合。这时mt就起作用了';
  // final plainText = '{"status:": 1}';
  // final plainText = '{"status:": 1}, 本文基本上是将dart官网部分内容进行翻译。';
  final plainText = "Lorem ipsum dolor sit amet, consectetur adipiscing elit ........。本文基本上是将dart官网部分内容进行翻译，没兴趣的请出门左转至Dart的官网，有兴趣的同志请继续阅读本文。Flutter教程在这里通常，映射是一个有键和值的对象。 键和值都可以是任何类型的对象。 每个键只出现一次，但您可以多次使用相同的值。Dart的Map支持由映射文字和Map。int和double都是num的子类型。 num类型包括基本运算符，如+， - ，/和*，也是你可以找到abs()，ceil()和floor()以及其他方法的地方。 （按位运算符，如>>，在int类中有定义。）如果num及其子类没有您要想要内容，那dart：math库可能有您想要的。Dart字符串是一系列UTF-16代码单元。 您可以使用单引号或双引号来创建字符串：您可以使用{expression}将表达式的值放在字符串中。如果表达式是标识符，则可以跳过{}。 要获取对应于对象的字符串，Dart调用对象的toString()方法。为了表示布尔值，Dart有一个名为bool的类型。 只有两个对象具有bool类型：true和false，它们都是编译时常量。Dart的类型安全意味着您不能使用if（nonbooleanValue）或assert（nonbooleanValue）等代码。 相反，明确检查值，如下所示：也许几乎每种编程语言中最常见的集合是数组或有序的对象组。 在Dart中，数组是List对象，因此大多数人只是将它们称为列表。Dart列表文字看起来像JavaScript数组文字。 这是一个简单的Dart List：";
  debugPrint("plainText: " + plainText);

  try {
    final base64Encoded = dtcrypt.DYFCryptoProvider.aBase64Encode(plainText);
    debugPrint("[base64] encode: " + base64Encoded);
    final base64Decoded = dtcrypt.DYFCryptoProvider.aBase64Decode(base64Encoded);
    debugPrint("[base64] decode: " + base64Decoded);

    final md5Hash = dtcrypt.DYFCryptoProvider.md5Encode(plainText);
    debugPrint("[md5] Hash: " + md5Hash);
    final md5b16hash = dtcrypt.DYFCryptoProvider.bit16md5Enconde(plainText);
    debugPrint("[md5] 16 bit hash: " + md5b16hash);

    // final aesKey = "smMQI8dMK2nOMUR0TdpBYQUnLpbW8kjHrdy86WtU6eB1Ff6mYveYzezopmbjwBZEjPQmg";
    final aesKey = "smMQI8dMK2";
    debugPrint("[aes] key: " + aesKey);
    String aesEncryptedText = dtcrypt.DYFCryptoProvider.aesEncrypt(plainText, aesKey);
    debugPrint("[aes] encryptedText: " + aesEncryptedText);
    String aesDecryptedText = dtcrypt.DYFCryptoProvider.aesDecrypt(aesEncryptedText, aesKey);
    debugPrint("[aes] decryptedText: " + aesDecryptedText);

    String rsaEncryptedText = dtcrypt.DYFCryptoProvider.rsaEncrypt(plainText, publicKey);
    debugPrint("[rsa] encryptedText: " + rsaEncryptedText);
    String rsaDecryptedText = dtcrypt.DYFCryptoProvider.rsaDecrypt(rsaEncryptedText, privateKey);
    debugPrint("[rsa] decryptedText: " + rsaDecryptedText);
    
    String signature = dtcrypt.DYFCryptoProvider.rsaSign(plainText, privateKey);
    debugPrint("[rsa] signature: " + signature);
    bool ret = dtcrypt.DYFCryptoProvider.rsaVerify(signature, plainText, publicKey);
    debugPrint("[rsa] signature verification: " + ret.toString());
  } catch (e) {
    debugPrint("e: $e");
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    cryptoTest();

    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(widget.title),
      ),
      body: new Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: new Column(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug paint" (press "p" in the console where you ran
          // "flutter run", or select "Toggle Debug Paint" from the Flutter tool
          // window in IntelliJ) to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'You have pushed the button this many times:',
            ),
            new Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
