// ignore_for_file: file_names

class ImageApi {
  String? file;
  String? fileCode;
  String? isScale;
  String? fileDetaill;
  String? fileRemark;

  ImageApi(
      {this.file,
      this.fileCode,
      this.isScale,
      this.fileDetaill,
      this.fileRemark});

  factory ImageApi.fromJson(Map<String, dynamic> json) {
    return ImageApi(
      file: json['file'],
      fileCode: json['file_code'],
      isScale: json['is_scale'],
      fileDetaill: json['file_detail'],
      fileRemark: json['file_remark'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'file': file,
      'file_code': fileCode,
      'is_scale': isScale,
      'file_detail': fileDetaill,
      'file_remark': fileRemark,
    };
  }
}
