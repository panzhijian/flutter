import 'dart:convert';

class Message {
  final int? status;
  final Data? data;

  Message({
    this.status,
    this.data,
  });

  Message copyWith({
    int? status,
    Data? data,
  }) =>
      Message(
        status: status ?? this.status,
        data: data ?? this.data,
      );

  factory Message.fromRawJson(String str) => Message.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    status: json["status"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data?.toJson(),
  };
}

class Data {
  final String? sessionId;
  final String? sessionTitle;
  final List<MessageElement>? messages;

  Data({
    this.sessionId,
    this.sessionTitle,
    this.messages,
  });

  Data copyWith({
    String? sessionId,
    String? sessionTitle,
    List<MessageElement>? messages,
  }) =>
      Data(
        sessionId: sessionId ?? this.sessionId,
        sessionTitle: sessionTitle ?? this.sessionTitle,
        messages: messages ?? this.messages,
      );

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    sessionId: json["session_id"],
    sessionTitle: json["session_title"],
    messages: json["messages"] == null ? [] : List<MessageElement>.from(json["messages"]!.map((x) => MessageElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "session_id": sessionId,
    "session_title": sessionTitle,
    "messages": messages == null ? [] : List<dynamic>.from(messages!.map((x) => x.toJson())),
  };
}

class MessageElement {
  final String? id;
  final String? type;
  final String? role;
  final Content? content;
  final DateTime? timestamp;
  bool? isGenerating;


      MessageElement({
    this.id,
    this.type,
    this.role,
    this.content,
    this.timestamp,
        this.isGenerating,

      });

  MessageElement copyWith({
    String? id,
    String? type,
    String? role,
    Content? content,
    DateTime? timestamp,
    bool? isGenerating,

  }) =>
      MessageElement(
        id: id ?? this.id,
        type: type ?? this.type,
        role: role ?? this.role,
        content: content ?? this.content,
        timestamp: timestamp ?? this.timestamp,
        isGenerating: isGenerating ?? this.isGenerating,

      );

  factory MessageElement.fromRawJson(String str) => MessageElement.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory MessageElement.fromJson(Map<String, dynamic> json) => MessageElement(
    id: json["id"],
    type: json["type"],
    role: json["role"],
    content: json["content"] == null ? null : Content.fromJson(json["content"]),
    timestamp: json["timestamp"] == null ? null : DateTime.parse(json["timestamp"]),
    isGenerating: json["isGenerating"],

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "role": role,
    "content": content?.toJson(),
    "timestamp": timestamp?.toIso8601String(),
    "isGenerating": isGenerating,

  };
}

class Content {
  String? text;
  final List<ImageUrl>? images;

  Content({
    this.text,
    this.images,
  });

  Content copyWith({
    String? text,
    List<ImageUrl>? images,
  }) =>
      Content(
        text: text ?? this.text,
        images: images ?? this.images,
      );

  factory Content.fromRawJson(String str) => Content.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Content.fromJson(Map<String, dynamic> json) => Content(
    text: json["text"],
    images: json["images"] == null ? [] : List<ImageUrl>.from(json["images"]!.map((x) => ImageUrl.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "text": text,
    "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x.toJson())),
  };
}

class ImageUrl {
  final String? url;
  final String? thumbnail;

  ImageUrl({
    this.url,
    this.thumbnail,
  });

  ImageUrl copyWith({
    String? url,
    String? thumbnail,
  }) =>
      ImageUrl(
        url: url ?? this.url,
        thumbnail: thumbnail ?? this.thumbnail,
      );

  factory ImageUrl.fromRawJson(String str) => ImageUrl.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ImageUrl.fromJson(Map<String, dynamic> json) => ImageUrl(
    url: json["url"],
    thumbnail: json["thumbnail"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "thumbnail": thumbnail,
  };
}
