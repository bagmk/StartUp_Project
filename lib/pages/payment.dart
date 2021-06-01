import 'package:flutter/widgets.dart';
import 'package:fluttershare/models/payment-service.dart';
import 'package:fluttershare/pages/existing-card.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:flutter/material.dart';

class Payment extends StatefulWidget {
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  onItemPress(BuildContext context, int index) async {
    switch (index) {
      case 0:
        payViaNewCard(context);
        break;
      case 1:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ExistingCardsPage()));
        break;
      case 2:
        print('In person payment');
        break;
    }
  }

  payViaNewCard(BuildContext context) async {
    ProgressDialog dialog = new ProgressDialog(context);
    dialog.style(message: 'Please wait...');
    await dialog.show();
    var response =
        await StripeService.payWithNewCard(amount: '150', currency: 'USD');
    await dialog.hide();
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(response.message),
      duration:
          new Duration(milliseconds: response.success == true ? 1200 : 3000),
    ));
  }

  @override
  void initState() {
    super.initState();
    StripeService.init();
  }

  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('How do you want to barter?'),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: ListView.separated(
              itemBuilder: (context, index) {
                Icon icon;
                Text text;

                switch (index) {
                  case 0:
                    icon = Icon(
                      Icons.add_circle,
                      color: Theme.of(context).primaryColor,
                    );
                    text = Text('Pay via new card');
                    break;
                  case 1:
                    icon = Icon(Icons.credit_card,
                        color: Theme.of(context).primaryColor);
                    text = Text('Pay via existing card');
                    break;
                  case 2:
                    icon = Icon(Icons.money,
                        color: Theme.of(context).primaryColor);
                    text = Text('Pay in person');
                    break;

                  case 3:
                    icon = Icon(Icons.nature,
                        color: Theme.of(context).primaryColor);
                    text = Text(
                        'We recommend using cash transaction to help the community. For each credit card transaction, we donate to contribute cardbon removal -Hot Place');
                    break;
                }

                return InkWell(
                  onTap: () {
                    onItemPress(context, index);
                  },
                  child: ListTile(
                    title: text,
                    leading: icon,
                  ),
                );
              },
              separatorBuilder: (context, index) => Divider(
                    color: Theme.of(context).primaryColor,
                  ),
              itemCount: 4),
        ),
      ),
    );
  }
}
