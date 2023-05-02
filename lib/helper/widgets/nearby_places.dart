import 'package:flutter/material.dart';
import 'package:real_estate/apis/api.dart';
import 'package:real_estate/helper/cost_util.dart';
import 'package:real_estate/helper/dialogs.dart';
import 'package:real_estate/helper/widgets/distance.dart';
import 'package:real_estate/screens/common/property_view.dart';

import '../../model/property_model.dart';

class NearbyPlaces extends StatelessWidget {
  const NearbyPlaces({
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
    return nearbyPlaces.length != 0
        ? Column(
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
                        isUpdate
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PropertyDetailScreen(
                                    mproperty: nearbyPlaces[index],
                                    isUpdate: true,
                                    email: email,
                                  ),
                                ))
                            : Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PropertyDetailScreen(
                                    mproperty: nearbyPlaces[index],
                                    isUpdate: false,
                                    email: email,
                                  ),
                                ));
                      },
                      onLongPress: () {
                        if (isUpdate) {
                          Dialogs.showInputDialog(
                              context: context,
                              title: "Delete",
                              hint:
                                  "Are you sure want to delete agent ${nearbyPlaces[index].property_name}?",
                              onOk: () {
                                APIs.deleteProperty(nearbyPlaces[index].id)
                                    .then((value) {
                                  APIs.activityDeleteProperty(
                                      propertyId: nearbyPlaces[index].id,
                                      msg:
                                          "Property - ${nearbyPlaces[index].property_name} is deleted by admin.");
                                });
                              },
                              onCancel: () {});
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  height: double.maxFinite,
                                  width: 130,
                                  child: FittedBox(
                                    fit: BoxFit.cover,
                                    child: Dialogs.showImage(
                                        nearbyPlaces[index].showImg),
                                  ),
                                )),
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
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.place,
                                        color: Theme.of(context).primaryColor,
                                        size: 18,
                                      ),
                                      Expanded(
                                        child: Text(
                                          nearbyPlaces[index]
                                              .address
                                              .toString(),
                                          maxLines: 1,
                                          style: const TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.construction,
                                        color: Theme.of(context).primaryColor,
                                        size: 18,
                                      ),
                                      Text(" " +
                                          nearbyPlaces[index]
                                              .yearBuilt
                                              .toString()),
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
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            text: "₹" +
                                                CostConverter
                                                    .convertToIndianCurrencyFormat(
                                                        int.parse(
                                                            nearbyPlaces[index]
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
          )
        : const SizedBox(
            height: 150,
            child: Center(
              child: Text("No data to display"),
            ),
          );
  }
}
