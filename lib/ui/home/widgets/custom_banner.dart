import 'package:flutter/material.dart';
import 'package:nursery/utils/colors.dart';

class CustomBanner extends StatelessWidget {
  const CustomBanner({
    super.key,
    this.onTap,
    required this.image,
    required this.title,
    required this.subTitle,
    this.backgroundColor
  });

  final VoidCallback? onTap;
  final String image; 
  final Color? backgroundColor;
  final String title;
  final String subTitle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: kPrimaryColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 16,
                    top: 16,
                    bottom: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 2,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: kWhiteColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            subTitle,
                            style: const TextStyle(
                          color: kWhiteColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 90,
                height: 80,
                child: Image.asset(image),
              ),
            ],
          ),
        ),
      ),
    );
  }
}