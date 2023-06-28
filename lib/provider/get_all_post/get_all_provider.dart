import 'package:blog_rest_api_provider/data/model/get_all_post_response.dart';
import 'package:blog_rest_api_provider/data/service/blog_api_service.dart';
import 'package:blog_rest_api_provider/provider/get_all_post/get_all_post_state.dart';
import 'package:flutter/material.dart';

class GetAllNotifier extends ChangeNotifier{
  GetAllPostState getAllPostState = GetAllPostLoading();
  final BlogApiService _blogApiService = BlogApiService();

  Future<void> getAllPost()async{
    getAllPostState = GetAllPostLoading();
    notifyListeners();
    try{
      List<GetAllPostResponse> postList=await _blogApiService.getAllPost();
      getAllPostState=GetAllPostSuccess(postList);
      notifyListeners();

    }catch(e){
      GetAllPostFailed(
        e.toString(),
      );
    }

  }
}