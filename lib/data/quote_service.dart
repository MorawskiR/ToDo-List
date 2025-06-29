import 'package:http/http.dart' as http;
import 'dart:convert';

class QuoteService {
final String _url = 'https://stoic.tekloon.net/stoic-quote';

Future<String?> fetchRandomQuote() async {
  try {
    final response = await http.get(Uri.parse(_url));
    if (response.statusCode==200) {
      final data = jsonDecode(response.body);
      return data['data']['quote'];
    } else {
      print('Blad : ${response.statusCode}');
      return null;
    }
  }catch(e){
    print('blad $e');
    return null;
  }
  }
}