import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:fluttershare/models/payment-service.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:progress_dialog/progress_dialog.dart';

class ExistingCardsPage extends StatefulWidget {
  ExistingCardsPage({Key key}) : super(key: key);

  @override
  _ExistingCardsPageState createState() => _ExistingCardsPageState();
}

class _ExistingCardsPageState extends State<ExistingCardsPage> {
  @override
  Widget build(BuildContext context) {
    List cards = [
      {
        'cardNumber': '4242424242424242',
        'expiryDate': '01/25',
        'cardHolderName': 'Saesun Kim',
        'cvvCode': '424',
        'showBackView': false,
      },
      {
        'cardNumber': '4000056655665556',
        'expiryDate': '03/22',
        'cardHolderName': 'Saeyoun Kim',
        'cvvCode': '114',
        'showBackView': false,
      }
    ];

    payViaExistingCard(BuildContext context, card) async {
      ProgressDialog dialog = new ProgressDialog(context);
      dialog.style(message: 'Please wait...');
      await dialog.show();
      var expiryArr = card['expiryDate'].split('/');
      CreditCard stripeCard = CreditCard(
        number: card['cardNumber'],
        expMonth: int.parse(expiryArr[0]),
        expYear: int.parse(expiryArr[1]),
      );

      var response = await StripeService.payViaExistingCard(
          amount: '15000', currency: 'USD', card: stripeCard);
      await dialog.hide();
      Scaffold.of(context)
          .showSnackBar(SnackBar(
            content: Text(response.message),
            duration: new Duration(milliseconds: 3200),
          ))
          .closed
          .then((_) {
        Navigator.pop(context);
      });
    }

    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Choose existing card'),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: ListView.builder(
              itemCount: cards.length,
              itemBuilder: (BuildContext context, int index) {
                var card = cards[index];
                return InkWell(
                    onTap: () {
                      payViaExistingCard(context, card);
                    },
                    child: CreditCardWidget(
                      cardNumber: card['cardNumber'],
                      expiryDate: card['expiryDate'],
                      cardHolderName: card['cardHolderName'],
                      cvvCode: card['cvvCode'],
                      showBackView:
                          false, //true when you want to show cvv(back) view
                    ));
              }),
        ),
      ),
    );
  }
}
