import 'package:flutter/material.dart';
import 'package:nursery/utils/buttons.dart';
import 'package:nursery/utils/colors.dart';

class IpAddressPage extends StatefulWidget {
  final String? ipAddress;
  const IpAddressPage({super.key, this.ipAddress});

  @override
  State<IpAddressPage> createState() => _IpAddressPageState();
}

class _IpAddressPageState extends State<IpAddressPage> {
  final TextEditingController ipController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  initState() {
    super.initState();
    ipController.text = widget.ipAddress ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        centerTitle: true,
        title: const Text("IP Address"),
      ),
      body: Center(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 18.0),
                child: TextFormField(
                  controller: ipController,
                  decoration: const InputDecoration(
                    labelText: 'IP Address',
                    hintText: '192.168.....',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    // Simple regex to validate IP address
                    const ipPattern = r'^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$';
                    if (value == null || value.isEmpty) {
                      return 'Please enter an IP address';
                    }
                    if (!RegExp(ipPattern).hasMatch(value)) {
                      return 'Please enter a valid IP address';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 18.0),
                child: Row(
                  children: [
                    Expanded(
                        child: QPrimaryButton(
                      label: "Ok",
                      onPressed: () {
                        Navigator.pop(context, ipController.text);
                      },
                    ))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
