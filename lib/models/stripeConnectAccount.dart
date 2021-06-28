class StripeConnectAccount {
  final String id;
  final bool areChargesEnabled;

  StripeConnectAccount({this.id, this.areChargesEnabled});

  factory StripeConnectAccount.fromJson(Map<String, dynamic> json) {
    return StripeConnectAccount(
        id: json['id'], areChargesEnabled: json['charges_enabled']);
  }
}
