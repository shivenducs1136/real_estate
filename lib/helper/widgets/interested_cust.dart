import 'package:flutter/material.dart';
import 'package:real_estate/helper/cost_util.dart';
import 'package:real_estate/helper/dialogs.dart';
import 'package:real_estate/helper/widgets/distance.dart';
import 'package:real_estate/screens/agent/generate_otp.dart';
import 'package:real_estate/screens/common/property_view.dart';

import '../../model/property_model.dart';

class InterestedPlaces extends StatelessWidget {
  const InterestedPlaces({
    Key? key,
    required this.nearbyPlaces,
    required this.isUpdate,
    required this.email,
  }) : super(key: key);
  final List<Property> nearbyPlaces;
  final bool isUpdate;
  final String? email;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(nearbyPlaces.length, (index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: SizedBox(
            height: 135,
            width: double.maxFinite,
            child: Card(
              elevation: 0.4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => GenerateOtpScreen(),
                  //     ));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child:
                              Dialogs.showImage(nearbyPlaces[index].showImg)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                nearbyPlaces[index].property_name,
                                maxLines: 1,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Icon(
                                  Icons.place,
                                  color: Theme.of(context).primaryColor,
                                  size: 18,
                                ),
                                Expanded(
                                  child: Text(
                                    nearbyPlaces[index].address.toString(),
                                    maxLines: 1,
                                    style: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Icon(
                                  Icons.construction,
                                  color: Theme.of(context).primaryColor,
                                  size: 18,
                                ),
                                Text(" " +
                                    nearbyPlaces[index].yearBuilt.toString()),
                              ],
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                Icon(
                                  Icons.area_chart,
                                  color: Colors.yellow.shade700,
                                  size: 14,
                                ),
                                Text(
                                  nearbyPlaces[index].area,
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                                const Spacer(),
                                RichText(
                                  text: TextSpan(
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      text: "₹" +
                                          CostConverter
                                              .convertToIndianCurrencyFormat(
                                                  int.parse(nearbyPlaces[index]
                                                      .cost)),
                                      children: const []),
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
