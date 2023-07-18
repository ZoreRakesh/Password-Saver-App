import 'package:encrypt/encrypt.dart';

class EncryptData{
//for AES Algorithms

    static final key = Key.fromUtf8('my 32 length key................');
    static final iv = IV.fromLength(16);
    static final encrypter = Encrypter(AES(key));


 static  encryptAES(plainText){

    final encrypted = encrypter.encrypt(plainText, iv: iv);
   return encrypted.base64;
 }

  
  static  decryptAES(plainText){
    return encrypter.decrypt64(plainText, iv: iv);
  }
  
}

