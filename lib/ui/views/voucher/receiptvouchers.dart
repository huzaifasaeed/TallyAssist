import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tassist/core/models/vouchers.dart';
import 'package:tassist/theme/dimensions.dart';
import 'package:tassist/ui/widgets/detailcard.dart';
import 'package:intl/intl.dart';

var formatter = new DateFormat('dd-MM-yyyy');

 _formatDate(DateTime date) {
  if (date != null) {
    return formatter.format(date);
  }
  else {
    return 'NA';
  }

}



class ReceiptVoucherScreen extends StatelessWidget {



  @override
  Widget build(BuildContext context) {

  // final user = Provider.of<FirebaseUser>(context);

    return ListView(
          children: <Widget>[
          ReceiptVoucherList()

  ],
    );
  }
}

class ReceiptVoucherList extends StatefulWidget {
  @override
  _ReceiptVoucherListState createState() => _ReceiptVoucherListState();
}

class _ReceiptVoucherListState extends State<ReceiptVoucherList> {

  TextEditingController editingController = TextEditingController();

  Iterable<Voucher> receiptVoucherData;
  List<Voucher> receiptVoucherDataforDisplay= List<Voucher>();

  @override
  void initState() {
    receiptVoucherData = Provider.of<List<Voucher>>(context, listen: false).where((voucher) => voucher.primaryVoucherType == 'Receipt');
    receiptVoucherDataforDisplay.addAll(receiptVoucherData);

    super.initState();
  }

  void filterSearchResults(String query) {
    List<Voucher> dummySearchList = List<Voucher>();
    dummySearchList.addAll(receiptVoucherData);
    if (query.isNotEmpty) {
      List<Voucher> dummyListData = List<Voucher>();
      dummySearchList.forEach((item) {
        if (item.partyname.toLowerCase().contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        receiptVoucherDataforDisplay.clear();
        receiptVoucherDataforDisplay.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        receiptVoucherDataforDisplay.clear();
        receiptVoucherDataforDisplay.addAll(receiptVoucherData);
      });
    }
  }







  @override
  Widget build(BuildContext context) {
    // final receiptVoucherData = Provider.of<List<ReceiptVoucher>>(context);

    return Container(
        height: MediaQuery.of(context).size.height / 1.1,
        child: Column(
          children: <Widget>[
            Padding(
              padding: spacer.all.xxs,
              child: Text('Total Receipt Vouchers: ${receiptVoucherDataforDisplay.length}'),
            ),
             Container(
                padding: spacer.bottom.xs,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 50.0,
                    child: TextField(
                      onChanged: (value) {
                        filterSearchResults(value.toLowerCase());
                      },
                      controller: editingController,
                      style: Theme.of(context).textTheme.bodyText2,
                      enableSuggestions: true,
                      decoration: InputDecoration(
                        labelText: "Search",
                        hintText: "Search by party name...",
                        hintStyle: Theme.of(context).textTheme.bodyText2,
                        labelStyle: Theme.of(context).textTheme.bodyText2,
                        counterStyle: Theme.of(context).textTheme.bodyText2,
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(25.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: receiptVoucherDataforDisplay?.length ?? 0,
                itemBuilder: (context, index) {
                  return ReceiptVoucherTile(receiptVoucher: receiptVoucherDataforDisplay[index]);
                },
              ),
            ),
          ],
        ));
  }
}



class ReceiptVoucherTile extends StatelessWidget {

  final Voucher receiptVoucher;

  ReceiptVoucherTile({this.receiptVoucher});


  @override
  Widget build(BuildContext context) {
    return  DetailCard(receiptVoucher.partyname, 
    '# ${receiptVoucher.masterid}',
     receiptVoucher.iscancelled, 
     'Rs ${receiptVoucher.amount}', 
     _formatDate(receiptVoucher.date));
  }
}

