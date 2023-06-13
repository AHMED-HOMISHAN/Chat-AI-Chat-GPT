// ignore_for_file: non_constant_identifier_names
import 'package:http/http.dart' as http;

String BASE_URL = "https://api.openai.com/v1";
String API_KEY = "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";

void initi() {
  API_KEY = http
      .get(Uri.https(
          'raw.githubusercontent.com', '/Ahmed-Homishan/ChatAI/main/README.md'))
      .toString();
}
