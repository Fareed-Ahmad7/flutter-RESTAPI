import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:restapi/models/post_model.dart';

import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    PostModel postModel;
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              FutureBuilder(
                future: fetchData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else {
                    postModel = snapshot.data!;
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          Text(postModel.id.toString()),
                          Text(postModel.title),
                        ],
                      );
                    } else {
                      return const Text("error");
                    }
                  }
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  await addPost(
                    PostModel(id: 2, title: 'mysecondpost'),
                  );
                },
                child: const Text("Add Post"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<PostModel> fetchData() async {
    final uri = Uri.parse(
        "https://my-json-server.typicode.com/Fareed-Ahmad7/Json-placeholder/posts/1");
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      return PostModel.fromJson(response.body);
    } else {
      throw Exception("failed to fetch data");
    }
  }

  Future<void> addPost(PostModel postModel) async {
    final uri = Uri.parse(
        "https://my-json-server.typicode.com/Fareed-Ahmad7/Json-placeholder/posts");

    Map<String, dynamic> request = {
      'id': 2,
      'title': "23",
    };
    final response = await http.post(uri, body: json.encode(request));

    if (response.statusCode == 201) {
      print(json.decode(response.body));
      return;
    } else {
      throw Exception("failed to add data");
    }
  }

  Future<PostModel> updatePost(String postID, PostModel postModel) async {
    final uri = Uri.parse(
        "https://my-json-server.typicode.com/Fareed-Ahmad7/Json-placeholder/posts/$postID");
    final response = await http.put(uri, body: postModel);

    if (response.statusCode == 200) {
      return PostModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("failed to update data");
    }
  }

  Future<PostModel?>? deletePost(String postID) async {
    final uri = Uri.parse(
        "https://my-json-server.typicode.com/Fareed-Ahmad7/Json-placeholder/posts/$postID");
    final response = await http.delete(uri);

    if (response.statusCode == 200) {
      return null;
    } else {
      throw Exception("failed to delete data");
    }
  }
}
