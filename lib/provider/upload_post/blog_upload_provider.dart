import 'package:blog_rest_api_provider/data/model/blog_upload_response.dart';
import 'package:blog_rest_api_provider/data/service/blog_api_service.dart';
import 'package:blog_rest_api_provider/provider/upload_post/upload_ui_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class BlogUploadNotifier extends ChangeNotifier{
  UploadUiState uploadUiState=  UploadFormState();
  final BlogApiService _blogApiService =BlogApiService();

  void upLoad({required String title,required String body,required FormData? data})async{
    try{
      uploadUiState = UpLoadingUi(0);
      notifyListeners();
      BlogUploadResponse blogUploadResponse=await _blogApiService.uploadPost(title: title, body: body, data: data,sendProgress: (int send,int size){
        double progress = ((size/send)*100);
        uploadUiState = UpLoadingUi(progress);
        notifyListeners();
      });
      uploadUiState = UploadSuccess(blogUploadResponse);
      notifyListeners();
    }catch(e){
      uploadUiState =UploadFailed("Something Wrong");
      notifyListeners();
    }
  }
  void tryAgain (){
    uploadUiState =UploadFormState();
    notifyListeners();
  }
}