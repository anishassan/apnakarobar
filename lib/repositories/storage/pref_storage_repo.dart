
import 'package:sales_management/repositories/storage/storage_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefStorageRepo implements StorageRepo{
  static const _email ='_email';
  static const _uid = '_uid';
  static const _address ='_address';
  static const _contact ='_contact';
  static const _name ='_name';
  static const _lang ='_lang';
  @override
  Future<String> getEmail() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    String email = pref.getString(_email) ?? '';
   return email;
  }
  @override
  Future<String> getUid() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    String uid = pref.getString(_uid) ?? '';
   return uid;
  }

  @override
  Future setEmail(String email)async {
           SharedPreferences pref = await SharedPreferences.getInstance();
           pref.setString(_email, email);
  }
  @override
  Future setUid(String uid)async {
           SharedPreferences pref = await SharedPreferences.getInstance();
           pref.setString(_uid, uid);
  }

  
  @override
  Future clearSession()async {
                  SharedPreferences pref = await SharedPreferences.getInstance();
                  pref.setString(_email, '');
                  pref.setString(_uid, '');
                 
  }
  
  @override
  Future<String> getAddress()async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(_address)??'';
  }
  
  @override
  Future<String> getName()async {
   SharedPreferences pref = await SharedPreferences.getInstance();
   return pref.getString(_name)??'';

  }
  
  @override
  Future<String> getNumber() async{
   SharedPreferences pref = await SharedPreferences.getInstance();
   return pref.getString(_contact)??'';
  }
  
  @override
  Future setAddress(String address) async{
    SharedPreferences pref = await SharedPreferences.getInstance();
           pref.setString(_address, address);
  }
  
  @override
  Future setName(String name) async{
   SharedPreferences pref = await SharedPreferences.getInstance();
           pref.setString(_name, name);
  }
  
  @override
  Future setNumber(String number) async{
 SharedPreferences pref = await SharedPreferences.getInstance();
           pref.setString(_contact, number);
  }
  
  @override
  Future<String> getLang() async{
  SharedPreferences pref = await SharedPreferences.getInstance();
   return pref.getString(_lang)??'';
  }
  
  @override
  Future setLang(String lang)async {
     SharedPreferences pref = await SharedPreferences.getInstance();
           pref.setString(_lang, lang);
  }
  
}