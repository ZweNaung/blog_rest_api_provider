import 'package:blog_rest_api_provider/data/model/get_all_post_response.dart';
import 'package:blog_rest_api_provider/provider/get_all_post/get_all_post_state.dart';
import 'package:blog_rest_api_provider/provider/get_all_post/get_all_provider.dart';
import 'package:blog_rest_api_provider/ui/screen/blog_upload_screen.dart';
import 'package:blog_rest_api_provider/ui/screen/blogpost_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _getAllPost(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Blog API"),
      ),
      body: Consumer<GetAllNotifier>(builder: (_, getAllNotifier, __) {
        GetAllPostState getAllPostState = getAllNotifier.getAllPostState;
        if (getAllPostState is GetAllPostSuccess) {
          List<GetAllPostResponse> getAllPostResponse =
              getAllPostState.getAllPostList;
          return ListView.builder(
              itemCount: getAllPostResponse.length,
              itemBuilder: (_, index) {
                GetAllPostResponse postList = getAllPostResponse[index];
                return InkWell(
                  onTap: () {
                    if (postList.id != null) {
                       Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  BlogPostDetailScreen(id: postList.id!)));

                    }
                  },
                  child: Card(
                    child: ListTile(
                      title: Text('${postList.title}'),
                    ),
                  ),
                );
              });
        } else if (getAllNotifier is GetAllPostFailed) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    _getAllPost(context);
                  },
                  child: const Text("Try Again")),
              const Divider(),
              const Text('OOPs Something Worng'),
            ],
          );
        }
        return const Center(child: CircularProgressIndicator());
      }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: ()async {
          final result= await Navigator.push(context,
              MaterialPageRoute(builder: (_) {
            return const BlogUploadScreen();
          }));
          if(result != null && result =="success"){
            if(mounted){
            _getAllPost(context);}
          }
        },
      ),
    );
  }

  void _getAllPost(BuildContext ctx) {
    Provider.of<GetAllNotifier>(ctx, listen: false).getAllPost();
  }
}
