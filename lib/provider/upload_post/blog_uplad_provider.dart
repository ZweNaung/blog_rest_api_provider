import 'package:blog_rest_api_provider/data/model/blog_upload_response.dart';
import 'package:blog_rest_api_provider/data/service/blog_api_service.dart';
import 'package:blog_rest_api_provider/provider/upload_post/upload_ui_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class BlogUploadNotifier extends ChangeNotifier{
  UploadUiState uploadUiState=UpLoadingUi(0);
  final BlogApiService _blogApiService =BlogApiService();

  void upLoad({required String title,required String body,required FormData data})async{
    try{
      uploadUiState = UpLoadingUi(0);
      BlogUploadResponse blogUploadResponse=await _blogApiService.uploadPost(title: title, body: body, data: data,sendProgress: (int send,int size){
        int progress = ((size/send)*100).toInt();
        uploadUiState = UpLoadingUi(progress);
      });
      uploadUiState = UploadSuccess(blogUploadResponse);
    }catch(e){
      uploadUiState =UploadFailed("Something Wrong");
    }
  }
}