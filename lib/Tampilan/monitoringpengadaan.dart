// import 'dart:developer';

// import 'package:Monitoring/Model/lpse.dart';
import 'dart:async';

// import 'package:Monitoring/Model/datePicker.dart';
import 'package:Monitoring/Model/prosesKegiatan.dart';
import 'package:Monitoring/Model/ServicePengadaan.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:intl/intl.dart';


class MonPengadaan extends StatefulWidget {
MonPengadaan():super();
final String title = 'Monitoring Pengadaan';

  @override
  _MonPengadaanState createState() => _MonPengadaanState();
}

class Debouncerr{
    final int milliseconds;
    VoidCallback action;
    Timer _timer;

    Debouncerr({this.milliseconds});

    run(VoidCallback action){
      if (null != _timer){
        _timer.cancel();

      }
      _timer = Timer(Duration(milliseconds: milliseconds), action);
    }
}

class _MonPengadaanState extends State<MonPengadaan> {
  List<Proses> _prosess;
  List<Proses> _filterProses;
  GlobalKey<ScaffoldState> _scaffoldKey;
  TextEditingController _namaPengadaanController;
  TextEditingController _metodePengadaanController;
  TextEditingController _paguPengadaanController;
  TextEditingController _hpsPengadaanController;
  TextEditingController _tanggalPengadaanController;
  TextEditingController _usulanStatusController;
  Proses _selectedProses;
  bool _isUpdating;
  String _titleProgress;
  final _debouncer = Debouncerr(milliseconds: 1000);

//   String pilihTanggal,labelText;
//   DateTime tgl = DateTime.now();
//    final TextStyle valueStyle = TextStyle(fontSize: 16.0);
//   Future<Null> _selectedDate(BuildContext context) async{
//   final DateTime picked = await showDatePicker(context: context,
//    initialDate: tgl, firstDate: DateTime(1990), lastDate: DateTime(2099));
//   if (picked != null && picked != tgl){
//     setState(() {
//       tgl = picked;
//       pilihTanggal = new DateFormat.yMd().format(tgl);

//     });
   
//   }

// }

  @override
  void initState() {
    super.initState();
    _prosess = [];
    _isUpdating = false;
    _filterProses =[];
    _titleProgress = widget.title;
    _scaffoldKey = GlobalKey();
    _namaPengadaanController = TextEditingController();
    _metodePengadaanController = TextEditingController();
    _paguPengadaanController = TextEditingController();
    _hpsPengadaanController = TextEditingController();
    _tanggalPengadaanController = TextEditingController();
    _usulanStatusController = TextEditingController();
  }
  // _showSnackBar(context,message){
  //   _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message),),);

  // }
  _showProgress(String message){
    setState(() {
      _titleProgress = message;
    });
  }

 _createProses() {
    _showProgress('Creating Table...');
    ServicePengadaan.createTable().then((result){
      if  ('success' == result){
        _showSnackBar(context, result);

      }
    });
  }
  
 _showSnackBar(context, message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
   _addProses() {
       if (_namaPengadaanController.text.trim().isEmpty ||
        _metodePengadaanController.text.trim().isEmpty ||
           _paguPengadaanController.text.trim().isEmpty ||
           _hpsPengadaanController.text.trim().isEmpty ||
           _tanggalPengadaanController.text.trim().isEmpty ||
           _usulanStatusController.text.trim().isEmpty 
           
        ) {
        print("Empty fields");
       return;
    }
    _showProgress('Adding Proses...');
      ServicePengadaan.addProses(_namaPengadaanController.text,  _metodePengadaanController.text, _paguPengadaanController.text, _hpsPengadaanController.text, _tanggalPengadaanController.text, _usulanStatusController.text).then((result)
      {
         if  ('success' == result){
           _getProses();
           }
         _clearValues();

     });

  }
_getProses() {
  _showProgress('Loading Lpse...');
    ServicePengadaan.getProses().then((prosess) {
      setState(() {
        _prosess = prosess;
        _filterProses = prosess;
      });
      _showProgress(widget.title);
      print("Length: ${prosess.length}");
    });
  }



  _updateProses(Proses proses) {
    _showProgress('Updating Ekatalog...');
    ServicePengadaan.updateProses(
            proses.id, _namaPengadaanController.text,  _metodePengadaanController.text, _paguPengadaanController.text,  _hpsPengadaanController.text, _tanggalPengadaanController.text, _usulanStatusController.text) 
        .then((result) {
      if ('success' == result) {
        setState(() {
          _isUpdating = false;
        });
         _namaPengadaanController.text = '';
        _metodePengadaanController.text = '';
        _paguPengadaanController.text = '';
        _hpsPengadaanController.text = '';
        _tanggalPengadaanController.text = '';
        _usulanStatusController.text = '';
      }
    });

  }
  _deleteProses(Proses proses) {
    _showProgress('Deleting Employee...');
    ServicePengadaan.deleteProses(proses.id).then((result) {
      if ('success' == result) {
        setState(() {
          _prosess.remove(proses);
        });
        _getProses();
      }
    });
  }
   _showValues(Proses proses) {//memunculkan value yang nantinya ditunjukkan
    _namaPengadaanController.text = proses.namaPengadaan;
    _metodePengadaanController.text = proses.metodePengadaan; 
    _paguPengadaanController.text = proses.paguPengadaan;
    _hpsPengadaanController.text = proses.hpsPengadaan;
    _tanggalPengadaanController.text = proses.tanggalPengadaan;
    _usulanStatusController.text = proses.usulanStatus;
    

    setState(() {
      _isUpdating = true;
    });
  }
  _clearValues(){
        _namaPengadaanController.text = '';
        _metodePengadaanController.text = '';
        _paguPengadaanController.text = '';
        _hpsPengadaanController.text = '';
        _tanggalPengadaanController.text = '';
        _usulanStatusController.text = '';
        
  }


SingleChildScrollView _databody(){
  return SingleChildScrollView(
    scrollDirection: Axis.vertical,
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(columns: [
        // DataColumn(
        //   label: Text('ID'),
        
        // ),
         DataColumn(
          label: Text('Nama Pengadaan'),
        
        ),
         DataColumn(
          label: Text('Metode Pengadan'),
        
        ),
         DataColumn(
          label: Text('Pagu'),
        
        ),
         DataColumn(
          label: Text('HPS'),
        
        ),
         DataColumn(
          label: Text('Tanggal Pengadaan'),
        
        ),
         DataColumn(
          label: Text('Status'),
        
        ),
         DataColumn(
          label: Text('Hapus'),
        
        ),
      ],
      rows: _filterProses.map(
        (proses) => DataRow(cells: [
            DataCell(
            Container(
            width: 300,
            child : Text(proses.namaPengadaan.toUpperCase()),    
            ),
               onTap: (){
               _showValues(proses);
              _selectedProses = proses;
          }),
          DataCell(
          Text(proses.metodePengadaan.toUpperCase()),
          onTap: (){
            _showValues(proses);
            _selectedProses = proses;
            }),
          DataCell(
          Text(NumberFormat.currency(locale: 'id', symbol: 'Rp ').format(int.parse(proses.paguPengadaan)),),    
        
          onTap: (){
            _showValues(proses);
            _selectedProses = proses;
          }),
            DataCell(
            Text( NumberFormat.currency(locale: 'id', symbol: 'Rp ').format(int.parse(proses.hpsPengadaan),),
            ),
            onTap: (){
              _showValues(proses);
              _selectedProses = proses;
            }),
            DataCell(
            Text(proses.tanggalPengadaan.toUpperCase()),
            onTap: (){
              _showValues(proses);
              _selectedProses = proses;
            }),
            DataCell(
            Text(proses.usulanStatus.toString()),
            onTap: (){
              _showValues(proses);
              _selectedProses = proses;
            }),
            DataCell(IconButton(icon: Icon(Icons.delete),
            onPressed: (){
              _deleteProses(proses);
            },
            ))
        ]

      )).toList(),
      ),
    ),
      

  );

}

searchField(){
  return Padding(
    padding : EdgeInsets.all(20.0),
    child: TextField(
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(5.0),
        hintText: 'Filter by Status',
      ),
          onChanged: (string){
            _debouncer.run((){

              setState(() {
                
              });

              _filterProses = _prosess
              .where((u) =>
              (u.usulanStatus.toLowerCase().contains(string.toLowerCase()))).toList();
              
              
              

            }
            );
          },
    ),
  );
}

  @override
  Widget build(BuildContext context) {
       return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text(_titleProgress),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  _createProses();
                }),
                IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  _getProses();
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
                  controller: _namaPengadaanController,
                  decoration: InputDecoration.collapsed(hintText: 'Nama Pengadaan',

                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: TextField(
                  controller: _metodePengadaanController,
                  // keyboardType: TextInputType.number,
                  decoration: InputDecoration.collapsed(hintText: 'Metode Pengadaan',

                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: TextField(
                  controller: _paguPengadaanController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration.collapsed(hintText: 'Pagu',

                  ),
                ),
              ),
               Padding(
                padding: EdgeInsets.all(20.0),
                child: TextField(
                  controller: _hpsPengadaanController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration.collapsed(hintText: 'HPS',

                  ),
                ),
              ),
               Padding(
                padding: EdgeInsets.all(20.0),
                child: TextField(
                  controller: _tanggalPengadaanController,
                  // keyboardType: TextInputType.number,
                  decoration: InputDecoration.collapsed(hintText: 'Tanggal Pengadaan',

                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: TextField(
                  controller: _usulanStatusController,
                  // keyboardType: TextInputType.number,
                  decoration: InputDecoration.collapsed(hintText: 'Status',

                  ),
                ),
              ),

              _isUpdating? 
              Row(children: <Widget>[
                OutlineButton(
                  child: Text('Update'),
                  onPressed: (){
                    _updateProses(_selectedProses);
                  },
                  ),
                  
                  OutlineButton(
                    child: Text('Cancel'),
                    onPressed: (){
                      setState((){
                        _isUpdating = false;
                      });
                      _clearValues();
                  },
                  )
              ],
              )
              :Container(),
              searchField(),
              Expanded(child: 
              _databody(),
              ),
              
            ],
            
          ),
        ),
          floatingActionButton: FloatingActionButton(
            onPressed: (){
              _addProses();
          } ,
          child: Icon(Icons.add),
          ),
        );
  }
}

