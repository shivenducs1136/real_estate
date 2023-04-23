import 'package:flutter/material.dart';
import 'package:real_estate/helper/my_date_util.dart';
import 'package:real_estate/model/activity_model.dart';

class RecentActivityWidget extends StatefulWidget {
  const RecentActivityWidget({super.key, required this.activityList});
  final List<ActivityModel> activityList;
  @override
  State<RecentActivityWidget> createState() => _RecentActivityWidgetState();
}

class _RecentActivityWidgetState extends State<RecentActivityWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(widget.activityList.length, (index) {
        return Card(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Row(children: [
              Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${widget.activityList[index].msg}",
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        MyDateUtil.getLastActiveTime(
                          context: context,
                          lastActive: widget.activityList[index].dateTime,
                        ),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ]),
              ),
            ]),
          ),
        );
      }),
    );
    ;
  }
}
