library html5animatorserver;

import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:math' as Math;
import 'dart:json' as JSON;
import 'dart:io';

String basePath="./";

void _sendNotFound(HttpResponse response) {
  response.statusCode = HttpStatus.NOT_FOUND;
  response.close();
}

void main() {
  HttpServer.bind('127.0.0.1', 8080).then((server) {
    server.listen((HttpRequest request) {
      print("GOT REQUEST " + request.uri.path);
      
      if (request.uri.path.contains("___IMAGE___")) {
        print("GOT IMAGE REQUEST");
        String imageUrl = request.uri.path.substring((request.uri.path.indexOf('___IMAGE___') + "___IMAGE___".length));
        
        http.get(imageUrl).then((response) {
          print(response);
          request.response.write(response.body);
          request.response.close();
        }).catchError(print);
        return;
      }
      
      final String path =
          request.uri.path == '/out/' ? '/out/html5animator.html' : request.uri.path;
      print("PATH: " + basePath + path);
      final File file = new File('${basePath}${path}');
      file.exists().then((bool found) {
        if (found) {
          file.fullPath().then((String fullPath) {
            print("FULL PATH: " + fullPath);
              print("READING FILE");
              file.openRead()
                  .pipe(request.response)
                  .catchError((e) {
                    print("GOT ERROR: " + e);
                    });
          });
          print("FOUND");
        } else {
          print(basePath + path + " NOT FOUND");
          _sendNotFound(request.response);
        }
      });
      
      
      /*
    request.listen((List<int> reqData) {
      String s = new String.fromCharCodes(reqData.sublist(1));
      print('GOT IMAGE REQUEST ' + s);
      print(request.method);
      print(request.uri);
      request.response.write("${request.method} ${request.uri}");
      request.response.close();
    },
    onError: (AsyncError error) {
      print("ERROR: " + error);
    },
    onDone: () {
      print("DONE");
      print(request.method);
      print(request.uri);
      request.response.write("${request.method} ${request.uri}");
      request.response.close();
    }
    );
    */
  });
  });
}
