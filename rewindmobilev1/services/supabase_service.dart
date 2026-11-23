import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final client = Supabase.instance.client;

  static bool get isLoggedIn {
    return client.auth.currentUser != null;
  }
}