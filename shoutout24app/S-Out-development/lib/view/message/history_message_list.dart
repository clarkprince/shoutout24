import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoutout24/common/badge.dart';
import 'package:shoutout24/common/customAppbar.dart';
import 'package:shoutout24/model/contactModel.dart';
import 'package:shoutout24/model/messageMode.dart';
import 'package:shoutout24/utils/color.dart';
import 'package:shoutout24/utils/currencyUtil.dart';
import 'package:shoutout24/widgets/verticalSpacing.dart';

class SentMessageHistoryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<MessageModel> _messages = Provider.of<List<MessageModel>>(context);
    return SafeArea(
      child: Scaffold(
        appBar: customAppBar(title: 'Sent Messages'),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            VerticalSpacing(
              height: 10.0,
            ),
            Container(
                margin: EdgeInsets.symmetric(horizontal: 30.0),
                child: Row(
                  children: [
                    Text("Total sent messages"),
                    SizedBox(width: 16),
                    Badge(
                      count: _messages?.length ?? 0,
                      color: colorPrimary,
                    ),
                  ],
                )),
            VerticalSpacing(),
            Expanded(
                child: (_messages?.length ?? 0) > 0
                    ? ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (context, index) => ListTile(
                              leading: CircleAvatar(
                                  backgroundColor: colorAccent,
                                  child: Text('${index + 1}')),
                              title: Text(_messages[index].message),
                              subtitle: Text(CurrencyUtils.formatUtc(
                                  _messages[index].timeStamp)),
                            ),
                        separatorBuilder: (context, index) => Divider(),
                        itemCount: _messages?.length)
                    : Center(child: Text("You haven't sent any message")))
          ],
        ),
      ),
    );
  }
}
