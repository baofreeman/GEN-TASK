import 'package:flutter_dotenv/flutter_dotenv.dart';

String apiKey = dotenv.env['OPENAI_API_KEY'] ?? '';
