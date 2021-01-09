import 'dart:convert';
// import 'package:flutter/cupertino.dart';
import 'package:http/http.dart'
  as http;
import 'prosesKegiatan.dart';

class ServicePengadaan{
  static const ROOT = 'http://192.168.100.170/EkatalogDB/pengadaan_action.php';
  static const _CREATE_TABLE_ACTION = 'CREATE_TABLE';
  static const _GET_PRO_ACTION = 'GET_PRO';
  static const _ADD_PRO_ACTION = 'ADD_PRO';
  static const _UPDATE_PRO_ACTION = 'UPDATE_PRO';
  static const _DELETE_PRO_ACTION = 'DELETE_PRO';


static Future<String> createTable() async {
  try{
    var map = Map<String, dynamic>();
    map["action"] = _CREATE_TABLE_ACTION;
    final response = await http.post(ROOT, body: map);
    print("Create Table Response : ${response.body}");
    // if(200 == response.statusCode){
      return response.body;
    // } else {
      // return "error";
    // }
  }catch (e){
   return "error";
  }
}
static Future<void> getProses(Function callback) async {
    var map = Map<String, dynamic>();
    map["action"] = _GET_PRO_ACTION;
    final response = await http.post(ROOT, body:map);
    print ("getProses Response: ${response.body}");
    if (200 == response.statusCode){
      List<Proses> list = parseResponse(response.body);
      callback(list);
    }else{
      callback(List());
    }
}
static List<Proses> parseResponse(String responseBody) {
  print("Masuk ke parsed Response");
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  print(parsed);
  return parsed.map<Proses>((json) =>Proses.fromJson(json)).toList();

}

static Future<String> addProses(String namaUnit,String namaPengadaan, String namaPenyedia,  String metodePengadaan, String paguPengadaan, String hpsPengadaan,String nilaiKontrak, String usulanStatus,{String tanggalPengadaan}) async{
   try{
    var map = Map<String, dynamic>();
    map['action'] = _ADD_PRO_ACTION;
    map['nama_unit'] = namaUnit;
    map['nama_pengadaan'] = namaPengadaan;
    map['tanggal_pengadaan'] =  tanggalPengadaan != null ? tanggalPengadaan : " ";
    map['nama_penyedia'] = namaPenyedia;
    map['metode_pengadaan'] = metodePengadaan;
    map['pagu_pengadaan'] = paguPengadaan;
    map['hps_pengadaan'] = hpsPengadaan;
    map['nilai_kontrak'] = nilaiKontrak;
    map['usulan_status'] = usulanStatus; 
    final response = await http.post(ROOT, body:map);
    print ("addProses Response: ${response.body}");
    if(200 == response.statusCode){
     return "success";
    }else{
      return "error";
    }
  }catch(e){
    return "error";
  }
}


static Future<String> updateProsesPPK(String proId,String namaUnit, String namaPengadaan, String tanggalPengadaan, String namaPenyedia, String metodePengadaan, String paguPengadaan, String hpsPengadaan, String nilaiKontrak, String sisaAnggaran, String usulanStatus) async{
  try{
    var map = Map<String,dynamic>();
    map['action'] = _UPDATE_PRO_ACTION;
    map['pro_id'] = proId;
    map['nama_unit'] = namaUnit;
    map['nama_pengadaan'] = namaPengadaan;
    map['tanggal_pengadaan'] = tanggalPengadaan;
    map['nama_penyedia'] = namaPenyedia;
    map['metode_pengadaan'] = metodePengadaan!= null ? metodePengadaan : " ";
    map['pagu_pengadaan'] = paguPengadaan;
    map['hps_pengadaan'] = hpsPengadaan;
    map['nilai_kontrak'] = nilaiKontrak;
    map['sisa_anggaran'] =  sisaAnggaran;
    map['usulan_status'] = usulanStatus;
    final response = await http.post(ROOT, body: map);
    print("updateProses Response : ${response.body}");
    if(200 == response.statusCode){
      return response.body;
    } else {
      return "error";
    }
  }catch(e){
    return "error";
  }
}


static Future<String> deleteProses(String proId) async{
  try{
    var map = Map<String,dynamic>();
    map['action'] = _DELETE_PRO_ACTION;
    map['pro_id'] = proId;
    final response = await http.post(ROOT, body: map);
    print("deleteProses Response : ${response.body}");
    if(200 == response.statusCode){
      return response.body;
    } else {
      return "error";
    }
  }catch(e){
    return "error";
  }
}

}