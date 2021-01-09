import 'package:Monitoring/Tampilan/tambahekatalog.dart';
import 'package:flutter/material.dart';
import 'package:Monitoring/Model/Ekatalog.dart';
import 'package:Monitoring/Model/ServiceEkatalog.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class MonEkatalog extends StatefulWidget {
  MonEkatalog() : super();
  final String title = 'Monitoring Ekatalog';

  @override
  _MonEkatalogState createState() => _MonEkatalogState();
}

class _MonEkatalogState extends State<MonEkatalog> {
  List<Ekatalog> _ekatalogs;
  List<Ekatalog> _filterEkatalog;
  GlobalKey<ScaffoldState> _scaffoldKey;
  TextEditingController _namaUnitController;
  TextEditingController _jumlahTransaksiController;
  // TextEditingController _tanggalController;
  Ekatalog _selectedEkatalog;
  bool _isUpdating;
  String _titleProgress;
  bool onSearch = false;
  // String searchedYear;
  var selectedYear;
  var searchYear 
  // = '2020'
  ;

  
List<DropdownMenuItem> dropDownMenu(Map input) {
    List<DropdownMenuItem> output = [];
    input.forEach((key, value) {
      output.add(DropdownMenuItem<int>(
        child: Text(value),
        value: key,
      ));
    });
    return output;
  }


  @override
  void initState() {
    super.initState();
    _getEkatalog();
    _ekatalogs = [];
    _filterEkatalog = [];
    _isUpdating = false;
    _titleProgress = widget.title;
    _scaffoldKey = GlobalKey();
    _namaUnitController = TextEditingController();
    // _tanggalController = TextEditingController();
    _jumlahTransaksiController = TextEditingController();
  }
  // _showSnackBar(context,message){
  //   _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message),),);

  // }
  _showProgress(String message){
    setState(() {
      _titleProgress = message;
    });
  }

  // _createEkatalog() {
  //   // print("berhasil");
  //   _showProgress('Creating Table...');
  //   ServiceEkat.createTable1().then((result){
  //     if  ('success' == result){
  //       _showSnackBar(context, result);
  //     }
  //   });
  // }
 _showSnackBar(context, message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
   _createEkatalog() {
    _showProgress('Creating Table...');
    ServiceEkat.createTable1().then((result){
      if  ('success' == result){
        _showSnackBar(context, result);

      }
    });
  }
  //  _addEkatalog() {
  //   //  print("berhasil");
  //      if (_namaUnitController.text.trim().isEmpty ||
  //       _jumlahTransaksiController.text.trim().isEmpty) {
  //       print("Empty fields");
  //      return;
       
  //   }
  //   _showProgress('Adding Ekatalog...');
  //     ServiceEkat.addEkatalog(_namaUnitController.text, selectedYear, _jumlahTransaksiController.text).then((result){ // controller integer
  //        if  ('success' == result){
  //          _showSnackBar(context, result);
  //          _getEkatalog();//
  //        }
  //        _clearValue();

  //    });

  // }
_getEkatalog() {
  _showProgress('Loading Ekatalog...');
    ServiceEkat.getEkatalog().then((List<Ekatalog> listEkatalog) {
      if (listEkatalog.isNotEmpty) {
        setState(() {
          _ekatalogs = listEkatalog;
          _filterEkatalog = listEkatalog;
        });
        _showProgress(widget.title);
        print("Length: ${listEkatalog.length}");
      }
    });
  }
   



  _updateEkatalog(Ekatalog ekatalog) {
    _showProgress('Updating Ekatalog...');
    ServiceEkat.updateEkatalog(
            ekatalog.id, _namaUnitController.text, selectedYear, _jumlahTransaksiController.text) //controller integer
        .then((result) {
      if ('success' == result) {
        _showSnackBar(context, result);
        _getEkatalog();
        setState(() {
          _isUpdating = false;
        });
        _namaUnitController.text = '';
        _jumlahTransaksiController.text = '';
      }
    });

  }
  _deleteEkatalog(Ekatalog ekatalog) {
    _showProgress('Deleting Employee...');
    ServiceEkat.deleteEkatalog(ekatalog.id).then((result) {
      if ('success' == result) {
        setState(() {
          _ekatalogs.remove(ekatalog);
        });
        _getEkatalog();
      }
    });
  }
   _showValues(Ekatalog ekatalog) {
    _namaUnitController.text = ekatalog.namaUnit;
    selectedYear = ekatalog.tanggal;
    _jumlahTransaksiController.text = ekatalog.jumlahTransaksi; 
    setState(() {
      _isUpdating = true;
    });
  }
  _clearValue(){
    _namaUnitController.text = '';
    _jumlahTransaksiController.text = '';
  }

SingleChildScrollView _databody(){
  _filterEkatalog.forEach((Ekatalog e) { 
      print(e.id);
      print(e.namaUnit);
      print(e.jumlahTransaksi);
      print(e.tanggal);

    });
  return SingleChildScrollView(
    scrollDirection: Axis.vertical,
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(columns: [
  
         DataColumn(
          label: Text('Nama Unit'),
        
        ),
         DataColumn(
          label: Text('Jumlah Transaksi'),
        
        ),
         DataColumn(
          label: Text('Hapus'),
        
        ),
      ],
      rows: _filterEkatalog
      .map(
        (ekatalog) => 
        DataRow(cells: [
          
  
            DataCell(
            Text(ekatalog.namaUnit.toString()),
            onTap: (){
              _showValues(ekatalog);
              _selectedEkatalog = ekatalog;
            }
            ),
            DataCell(
            Text(
              NumberFormat.currency(locale: 'id', symbol: 'Rp ').format(int.parse(ekatalog.jumlahTransaksi)),),
            onTap: (){
              _showValues(ekatalog);
              _selectedEkatalog = ekatalog;
            }
            ),
            DataCell(IconButton(icon: Icon(Icons.delete),
            onPressed: (){
              _deleteEkatalog(ekatalog);
            },
            ))
        ]

      )).toList(),
      ),
    ),
      

  );

}

Widget searchedYear(){
return
Padding( padding : EdgeInsets.all(10.0),

child: DropdownButtonHideUnderline(
                      child: DropdownButton(
                        hint: Text("Year"),
                          isExpanded: true,
                          dropdownColor: Colors.white,
                          value: searchYear,
                          items: Ekatalog.listYear
                              .map((e) => DropdownMenuItem<String>(
                                    child: Text(e),
                                    value: e,
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              searchYear = value;
                              
                            });
                          }),
                    )
                    );

}

void filterYear() {
  
    var initialList = _ekatalogs;
    if(onSearch){
      initialList = _filterEkatalog;
    }
    switch (searchYear) {
      case '2018':
        _filterEkatalog = initialList
            .where((element) => element.tanggal
                .toLowerCase()
                .trim()
                .contains('2018'.toLowerCase()))
            .toList();
        break;
      case '2019':
        _filterEkatalog= initialList
            .where((element) => element.tanggal
                .toLowerCase()
                .trim()
                .contains('2019'.toLowerCase()))
            .toList();
        break;
      case '2020':
        _filterEkatalog = initialList
            .where((element) => element.tanggal
                .toLowerCase()
                .trim()
                .contains('2020'.toLowerCase()))
            .toList();
        break;
      case '2021':
        _filterEkatalog = initialList
            .where((element) =>
                element.tanggal.toLowerCase().trim() ==
                ('2021'.toLowerCase())
                )
            .toList();
        break;
      default:
        _filterEkatalog = initialList;
    }
  }



  //UI
  @override
  Widget build(BuildContext context) {
    filterYear();
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(_titleProgress),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                 _createEkatalog();
                }),
                IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  _getEkatalog();
                }),
          ],
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [
              Padding(
                padding: EdgeInsets.all(20.0),
              
                child: TextField(
                  controller: _namaUnitController,
                  decoration: InputDecoration.collapsed(hintText: 'Nama Unit',

                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: TextField(
                   inputFormatters: <TextInputFormatter>[
        // ignore: deprecated_member_use
        WhitelistingTextInputFormatter.digitsOnly
    ],
                  controller: _jumlahTransaksiController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration.collapsed(hintText: 'Jumlah Transaksi',

                  ),
                ),
              ),

              _isUpdating? 
              Row(children: <Widget>[
                OutlineButton(
                  child: Text('Update'),
                  onPressed: (){
                    _updateEkatalog(_selectedEkatalog);
                  },
                  ),
                  OutlineButton(
                    child: Text('Cancel'),
                    onPressed: (){
                      setState((){
                        _isUpdating = false;
                      });
                      _clearValue();
                  },
                  )
              ],
              )
              :Container(),
              searchedYear(),
              Expanded(child: 
              _databody(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
              children : [
                RaisedButton(
                  color: Colors.greenAccent,
                  child: Text("Tambah Ekatalog"),
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => TambahEkatalog()));
            
                  },)
                  
                  ]
            )
              
            ],
          ),
        ),
          
        );
  }
}
