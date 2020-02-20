import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tassist/core/services/ledgerstock.dart';
import 'package:tassist/theme/theme.dart';
import 'package:tassist/ui/shared/drawer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tassist/core/models/ledgerstock.dart';
import 'package:tassist/ui/views/ledgersummary.dart';
import 'package:tassist/ui/views/ledgerstock.dart';
import 'package:tassist/ui/views/ledgervoucher.dart';
import 'package:firebase_auth/firebase_auth.dart';


class LedgerView extends StatefulWidget {

  final String ledgerId; 
  final String partyname;
  final String ledgerGuid;

  LedgerView({this.ledgerId, this.partyname, this.ledgerGuid});

  

  @override
  _LedgerViewState createState() => _LedgerViewState(ledgerId, partyname, ledgerGuid);
}

class _LedgerViewState extends State<LedgerView>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  bool showFab = true;
  final String ledgerId;
  final String partyname;
  final String ledgerGuid;

 _LedgerViewState(this.ledgerId, this.partyname, this.ledgerGuid);

 
  

  @override
  void initState() {
    super.initState();

    _tabController = TabController(vsync: this, initialIndex: 0, length: 3);
    _tabController.addListener(() {
      if (_tabController.index == 0) {
        showFab = true;
      } else {
        showFab = false;
      }
      setState(() {});
    });
  }

  
  
  @override
  Widget build(BuildContext context) {

  final user = Provider.of<FirebaseUser>(context);
  
   final GlobalKey<ScaffoldState> _drawerKey = new GlobalKey<ScaffoldState>();
  
    return MultiProvider(
          providers: [
            StreamProvider<List<LedgerStock>>.value(

            value: LedgerStockService(uid: user?.uid, ledgerId: ledgerGuid).ledgerStockData),
          ],
          child: WillPopScope (
                onWillPop: () async => false,
            child: Scaffold(
          key: _drawerKey,
          appBar: headerNavOther(_drawerKey, _tabController, context),
          drawer: tassistDrawer(context),
          body: 
          TabBarView(
            controller: _tabController,
            children: <Widget>[
             LedgerSummary(ledgerId: ledgerId),
             LedgerVoucher(ledgerId: ledgerId, partyname: partyname,),
             LedgerStockView(ledgerGuid: ledgerGuid)
            ],
          ),
        ),
      ),
    );
  }
}


AppBar headerNavOther(GlobalKey<ScaffoldState> _drawerkey, TabController _tabController, BuildContext context) {
  bool enabled = true;

  return AppBar(
      leading: Padding(
        padding: EdgeInsets.only(left: 12),
        child: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            if (enabled) {

              Navigator.of(context).pushReplacementNamed('/ledgers');
            }
          },
        ),
      ),
      elevation: 0.7,
      bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: <Widget>[
            Tab(text: 'Summary',),
            Tab(text: 'Vouchers'),
            Tab(
              text: 'Stock',
            ),
          ],
        ),
        
      title: Row(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                'TallyAssist',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              const Text(
                'Beta',
                style: TextStyle(
                  color: TassistWhite,
                  fontSize: 12,
                  letterSpacing: 1.0,
                ),
              ),
          ],
        ),
        Spacer(),
        Text('Help?', style: TextStyle(fontSize: 14.0, letterSpacing: 1.0),),
        IconButton(
        icon: Icon(FontAwesomeIcons.whatsapp),
        onPressed: () => _launchURL()
            )
        // DropDownMonths(),
      ],
    ),
    backgroundColor: TassistMenuBg
  );
}


_launchURL() async {
  const url = 'https://api.whatsapp.com/send?phone=+917759091029';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
