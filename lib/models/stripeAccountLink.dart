class StripeAccountLink {
  final String url;

  StripeAccountLink({this.url});

  factory StripeAccountLink.fromJson(Map<String, dynamic> json) {
    return StripeAccountLink(url: json['url']);
  }
}
