import 'dart:io';

import 'package:blog_rest_api_provider/provider/upload_post/blog_upload_provider.dart';
import 'package:blog_rest_api_provider/provider/upload_post/upload_ui_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class BlogUploadScreen extends StatefulWidget {
  const BlogUploadScreen({super.key});

  @override
  State<BlogUploadScreen> createState() => _BlogUploadScreenState();
}

class _BlogUploadScreenState extends State<BlogUploadScreen> {
  final TextEditingController _titleEditingController = TextEditingController();
  final TextEditingController _bodyEditingController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  File? _image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Screen'),
        centerTitle: true,
      ),
      body: Consumer<BlogUploadNotifier>(
        builder: (_,blogUploadNotifier,__){
          UploadUiState uploadUiState = blogUploadNotifier.uploadUiState;
          if(uploadUiState is UpLoadingUi) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 Text("Uploading Please Wait.....${uploadUiState.progress} %"),
                const Divider(),
                LinearProgressIndicator(
                  value: uploadUiState.progress,
                ),

              ],
            );
          }else if(uploadUiState is UploadSuccess){
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(uploadUiState.blogUploadResponse.result ?? " "),
                const Divider(),
                ElevatedButton(onPressed: (){
                  Navigator.pop(context,'success');
                  blogUploadNotifier.uploadUiState = UploadFormState();
                }, child: const Text("Ok")),
              ],
            );
          }else if(uploadUiState is UploadFailed){
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(uploadUiState.errorMessage),
                const Divider(),
                ElevatedButton(onPressed: (){
                   blogUploadNotifier.tryAgain();
                }, child: const Text("Try Again")),
              ],
            );
          }
          return Form(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextField(
                        controller: _titleEditingController,
                        decoration: const InputDecoration(
                          labelText: "Title",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const Divider(),
                      TextField(
                        controller: _bodyEditingController,
                        minLines: 3,
                        maxLines: 10,
                        decoration: const InputDecoration(
                          labelText: "Body",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const Divider(),
                      FilledButton(onPressed: ()async{
                      XFile? file =await _imagePicker.pickImage(source: ImageSource.gallery);
                      if(file != null){
                        setState(() {
                          _image = File(file.path);
                        });
                      }

                      }, child: const Text("Select Photo")),
                      const Divider(),
                      if(_image != null)
                      Image.file(_image!,height: 200,),
                      ElevatedButton(onPressed: ()async{
                        if(_titleEditingController.text.isNotEmpty && _bodyEditingController.text.isNotEmpty){
                          String title = _titleEditingController.text;
                          String body  =_bodyEditingController.text;
                          FormData? formData;
                          if(_image !=null) {
                            formData = FormData.fromMap({
                              "photo":await MultipartFile.fromFile(_image!.path)
                            });
                          }
                          if(mounted){
                            Provider.of<BlogUploadNotifier>(context,listen: false).upLoad(title: title, body: body, data: formData);

                          }
                        }else{
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please Enter Title & Context")));
                        }
                      }, child: const Text("Upload"))
                    ],
                  ),
                ),
              ));
        },
      ),
    );
  }
}
