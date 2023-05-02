import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:real_estate/apis/api.dart';
import 'package:real_estate/helper/dialogs.dart';
import 'package:real_estate/model/property_model.dart';
import 'package:real_estate/screens/common/property_view.dart';

class RecommendedPlaces extends StatelessWidget {
  const RecommendedPlaces(
      {Key? key,
      required this.recommendedPlaces,
      required this.isUpdate,
      required this.email})
      : super(key: key);
  final bool isUpdate;
  final List<Property> recommendedPlaces;
  final String? email;

  @override
  Widget build(BuildContext context) {
    return recommendedPlaces.length != 0
        ? SizedBox(
            height: 235,
            child: ListView.separated(
              itemCount: recommendedPlaces.length,
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return SizedBox(
                  width: 220,
                  child: Card(
                    elevation: 0.4,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PropertyDetailScreen(
                                mproperty: recommendedPlaces[index],
                                isUpdate: isUpdate,
                                email: email,
                              ),
                            ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: Container(
                                  height: 130,
                                  width: 200,
                                  child: FittedBox(
                                    fit: BoxFit.fill,
                                    child: Dialogs.showImage(
                                        recommendedPlaces[index].showImg),
                                  )),
                            ),
                            const SizedBox(height: 5),
                            Expanded(
                              child: Row(
                                children: [
                                  Text(
                                    recommendedPlaces[index].property_name,
                                    maxLines: 1,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                  const Spacer(),
                                  Icon(
                                    Icons.area_chart,
                                    color: Colors.yellow.shade700,
                                    size: 14,
                                  ),
                                  Text(
                                    recommendedPlaces[index].area,
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Icon(
                                  Ionicons.location,
                                  color: Theme.of(context).primaryColor,
                                  size: 16,
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    recommendedPlaces[index].address,
                                    maxLines: 1,
                                    style: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      fontSize: 12,
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) => const Padding(
                padding: EdgeInsets.only(right: 10),
              ),
            ),
          )
        : const SizedBox(
            height: 235,
            child: Center(
              child: Text("Nothing to show"),
            ),
          );
  }
}
