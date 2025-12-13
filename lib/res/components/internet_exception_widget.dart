import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class InternetExceptionWidget extends StatefulWidget {
  const InternetExceptionWidget({super.key});

  @override
  State<InternetExceptionWidget> createState() =>
      _InternetExceptionWidgetState();
}

class _InternetExceptionWidgetState extends State<InternetExceptionWidget> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(children: [
        SizedBox(height: height * 0.16),
        const Icon(Icons.cloud_off, size: 48),
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Center(
              child: Text(
            'internet_exception'.tr,
            style: Theme.of(context).textTheme.titleMedium,
          )),
        ),
        SizedBox(height: height * 0.16),
        Container(
          height: 44,
          width: 160,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            // color: AppColors.blackColor,

          ),
          child: Center(
              child: Text(
            'try_again'.tr,
            style: Theme.of(context).textTheme.titleMedium,
          )),
        )
      ]),
    );
  }
}
