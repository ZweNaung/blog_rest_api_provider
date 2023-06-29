import 'package:blog_rest_api_provider/data/model/blog_upload_response.dart';

abstract class UploadUiState{}

class UpLoadingUi extends UploadUiState{
  final int progress;
  UpLoadingUi(this.progress);
}


class UploadSuccess extends UploadUiState{
  final BlogUploadResponse blogUploadResponse;
  UploadSuccess(this.blogUploadResponse);
}

class UploadFailed extends UploadUiState{
  final String errorMessage;
  UploadFailed(this.errorMessage);
}