abstract class StorageRepo{
  Future setEmail(String email);
  
  Future<String> getEmail();

  Future clearSession();
  Future<String> getUid();
  Future setUid(String uid);
  Future<String> getName();
  Future setName(String name);
  Future<String> getNumber();
  Future setNumber(String number);
  Future<String> getAddress();
  Future setAddress(String address);
  Future setLang(String lang);
  Future<String> getLang();
  
}