
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../config.dart';

class TabachkiApi {
  static Uri _uri() => Uri.parse(Config.backendUrl);
  static Map<String, String> _headers() => {'Content-Type':'application/json'};

  static Future<List<Map<String, dynamic>>> listStores() async {
    final r = await http.post(_uri(), headers:_headers(), body: jsonEncode({'action':'list_stores','apiKey':Config.backendApiKey}));
    final j = jsonDecode(r.body);
    return j['ok']==true ? (j['rows'] as List).cast<Map<String,dynamic>>() : [];
  }

  static Future<bool> startShift({required String storeId, required String user, required String shiftType}) async {
    final r = await http.post(_uri(), headers:_headers(), body: jsonEncode({'action':'start_shift','apiKey':Config.backendApiKey,'storeId':storeId,'user':user,'shiftType':shiftType}));
    final j = jsonDecode(r.body);
    return j['ok']==true;
  }

  static Future<bool> endShift({required String storeId, required String user, required String shiftType}) async {
    final r = await http.post(_uri(), headers:_headers(), body: jsonEncode({'action':'end_shift','apiKey':Config.backendApiKey,'storeId':storeId,'user':user,'shiftType':shiftType}));
    final j = jsonDecode(r.body);
    return j['ok']==true;
  }

  static Future<bool> sendZReport({required String user, required String storeId, required String shift, required String revenue, required String expense, String? comment}) async {
    final r = await http.post(_uri(), headers:_headers(), body: jsonEncode({
      'action':'z_report','apiKey':Config.backendApiKey,'user':user,'storeId':storeId,
      'shift':shift,'revenue':double.tryParse(revenue)??0,'expense':double.tryParse(expense)??0,'comment':comment??''
    }));
    final j = jsonDecode(r.body);
    return j['ok']==true;
  }

  static Future<List<Map<String,dynamic>>> fetchStock({String? storeId}) async {
    final r = await http.post(_uri(), headers:_headers(), body: jsonEncode({'action':'list_stock','apiKey':Config.backendApiKey,'storeId':storeId}));
    final j = jsonDecode(r.body);
    return j['ok']==true ? (j['rows'] as List).cast<Map<String,dynamic>>() : [];
  }

  static Future<List<Map<String,dynamic>>> fetchEmployees({String? storeId}) async {
    final r = await http.post(_uri(), headers:_headers(), body: jsonEncode({'action':'list_employees','apiKey':Config.backendApiKey,'storeId':storeId}));
    final j = jsonDecode(r.body);
    return j['ok']==true ? (j['rows'] as List).cast<Map<String,dynamic>>() : [];
  }

  static Future<List<Map<String,dynamic>>> listRatings() async {
    final r = await http.post(_uri(), headers:_headers(), body: jsonEncode({'action':'list_ratings','apiKey':Config.backendApiKey}));
    final j = jsonDecode(r.body);
    return j['ok']==true ? (j['rows'] as List).cast<Map<String,dynamic>>() : [];
  }

  // Заглушка: если нет visionApiKey, просто вернём пустой результат с подсказкой.
  static Future<Map<String, dynamic>> recognizeBrandsWithVision(Uint8List imageBytes) async {
    if (Config.visionApiKey.isEmpty) {
      return {'ok': false, 'found': <String>[], 'missing': Config.expectedBrands};
    }
    final uri = Uri.parse('https://vision.googleapis.com/v1/images:annotate?key=${Config.visionApiKey}');
    final b64 = base64Encode(imageBytes);
    final body = jsonEncode({'requests':[{'image': {'content': b64}, 'features': [{'type':'TEXT_DETECTION'}]}]});
    final r = await http.post(uri, headers: {'Content-Type':'application/json'}, body: body);
    if (r.statusCode != 200) {
      return {'ok': false, 'found': <String>[], 'missing': Config.expectedBrands};
    }
    final j = jsonDecode(r.body);
    final text = (((j['responses'] ?? [])[0] ?? {})['fullTextAnnotation'] ?? {})['text'] ?? '';
    final lc = (text as String).toLowerCase();
    final found = <String>[];
    for (final b in Config.expectedBrands) {
      if (lc.contains(b.toLowerCase().replaceAll('_',' '))) found.add(b);
    }
    final missing = Config.expectedBrands.where((b) => !found.contains(b)).toList();
    return {'ok': true, 'found': found, 'missing': missing};
  }
}
