import 'package:flutter/material.dart';
import 'package:flutter_paypal_checkout/flutter_paypal_checkout.dart';
import 'package:get_it/get_it.dart';
import 'package:nursery/services/auth_store.dart';
import 'package:nursery/ui/home/payment_page/payment_provider.dart';
import 'package:nursery/ui/home/widgets/loader.dart';
import 'package:nursery/utils/buttons.dart';
import 'package:nursery/utils/colors.dart';
import 'package:nursery/utils/icons.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..loadRequest(
        Uri.parse('https://www.paypal.com'),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: const Text("Payment Information"),
          centerTitle: true,
        ),
        body: ChangeNotifierProvider(
          create: (context) => PaymentProvider(
            authStore: GetIt.I<AuthStore>(),
          ),
          builder: (context, snapshot) {
            PaymentProvider provider = context.watch();
            return provider.isLoading
                ? const LoaderWidget()
                : SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        provider.userData?.hasPayment == true
                            ? const Text("You Have Payment")
                            : Column(
                                children: [
                                  Image.asset(
                                    kPaypal,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 30, horizontal: 18.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: QPrimaryButton(
                                            label: "Checkout",
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        PaypalCheckout(
                                                      sandboxMode: true,
                                                      clientId:
                                                          "AeU8glEGdZLrZVWuzKbKHfRp3DXlJED-u19FSrHyz8pqXpa8h9WSLAZ5pTg6a4NprM2iBWw13vfm5O75",
                                                      secretKey:
                                                          "EP04O8VL7Yn5YxHnq4dOEKiQt6gIAseyOIKrYCh9dqA0TpFX4ksdIyLwJL2-d685v1ci8vlB2Ex2FbaY",
                                                      returnURL:
                                                          "success.snippetcoder.com",
                                                      cancelURL:
                                                          "cancel.snippetcoder.com",
                                                      transactions: [
                                                        {
                                                          "amount": const {
                                                            "total": "30",
                                                            "currency": "USD",
                                                          },
                                                          "description":
                                                              "The payment transaction for the booking in nursery is 30 USD.",
                                                          "item_list": {
                                                            "items": [
                                                              {
                                                                "name":
                                                                    '${provider.userData?.fullname}',
                                                                "quantity": 1,
                                                                "price": "30",
                                                                "currency":
                                                                    "USD"
                                                              },
                                                            ],
                                                          }
                                                        }
                                                      ],
                                                      note:
                                                          "Contact us for any questions on your payment.",
                                                      onSuccess:
                                                          (Map params) async {},
                                                      onError: (error) {
                                                        print(error);
                                                        Navigator.pop(context);
                                                      },
                                                      onCancel: () {},
                                                    ),
                                                  ));
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                      ],
                    ),
                  );
          },
        ));
  }
}
