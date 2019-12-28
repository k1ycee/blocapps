import 'package:equatable/equatable.dart';



class Unreal extends Equatable{
  final int id;
  final String title;
  final String body;

  const Unreal({this.id, this.title, this.body});

  @override
  List<Object> get props => [id, title, body];

  @override
  String toString() => 'Post{id: $id}';

//  Unreal.fromJson(Map<String, dynamic> json) {
//    userId = json['userId'];
//    id = json['id'];
//    title = json['title'];
//    body = json['body'];
//  }
//
//  Map<String, dynamic> toJson() {
//    final Map<String, dynamic> data = new Map<String, dynamic>();
//    data['userId'] = this.userId;
//    data['id'] = this.id;
//    data['title'] = this.title;
//    data['body'] = this.body;
//    return data;
//  }
}