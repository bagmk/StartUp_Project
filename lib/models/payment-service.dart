class StripleTransactionResponse {
  String message;
  bool success;
  StripleTransactionResponse({this.message, this.success});
}

class StripeService {
  static String apiBase = 'https://api.stripe.com//v1';
  static String secret = '';

  static init() {}

  static StripleTransactionResponse payViaExistingCard(
      {String amount, String currency, card}) {
    return new StripleTransactionResponse(
        message: 'Transaction sucessful', success: true);
  }

  static StripleTransactionResponse payWithNewCard(
      {String amount, String currency}) {
    return new StripleTransactionResponse(
        message: 'Transaction sucessful', success: true);
  }
}
