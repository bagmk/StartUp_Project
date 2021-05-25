import 'package:flutter/widgets.dart';
import 'package:fluttershare/models/payment-service.dart';
import 'package:fluttershare/pages/existing-card.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:flutter/material.dart';

class Payment extends StatefulWidget {
  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  onItemPress(BuildContext context, int index) {
    switch (index) {
      case 0:
        var response =
            StripeService.payWithNewCard(amount: '150', currency: 'USD');
        if (response.success == true) {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(response.message),
            duration: new Duration(microseconds: 3200),
          ));
        }
        break;
      case 1:
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ExistingCardsPage()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Choose existing card'),
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
              itemCount: 2),
        ),
      ),
    );
  }
}
