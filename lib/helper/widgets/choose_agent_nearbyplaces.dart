import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_estate/apis/api.dart';
import 'package:real_estate/helper/cost_util.dart';
import 'package:real_estate/helper/widgets/distance.dart';
import 'package:real_estate/main.dart';
import 'package:real_estate/model/agent_model.dart';
import 'package:real_estate/providers/agent_provider.dart';
import 'package:real_estate/screens/admin/interested_customer_screen.dart';
import 'package:real_estate/screens/agent/agent_screen.dart';
import 'package:real_estate/screens/agent/generate_otp.dart';
import 'package:real_estate/screens/common/property_view.dart';

import '../../model/property_model.dart';

class ChooseAgentNearbyPlaces extends StatelessWidget {
  const ChooseAgentNearbyPlaces({
    Key? key,
    required this.nearbyPlaces,
    required this.isUpdate,
    required this.email,
    required this.agentModel,
  }) : super(key: key);
  final List<Property> nearbyPlaces;
  final bool isUpdate;
  final AgentModel agentModel;
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
              child: Consumer<AgentProvider>(
                builder: (context, value, key) {
                  return Card(
                    elevation: 0.4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        value.setProperty(nearbyPlaces[index]);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GenerateOtpScreen(
                                agentModel: agentModel,
                                propertyModel: nearbyPlaces[index],
                              ),
                            ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: FadeInImage(
                                  placeholder: AssetImage("images/picture.png"),
                                  image: NetworkImage(
                                    nearbyPlaces[index].showImg,
                                  ),
                                  imageErrorBuilder:
                                      (context, error, stackTrace) {
                                    return Image.asset('images/picture.png',
                                        fit: BoxFit.fitWidth);
                                  },
                                  height: double.maxFinite,
                                  width: 130,
                                  fit: BoxFit.cover,
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
                                  const SizedBox(height: 10),
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
                  );
                },
              )),
        );
      }),
    );
  }
}
