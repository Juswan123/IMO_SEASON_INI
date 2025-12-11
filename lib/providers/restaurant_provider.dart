import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/restaurant_model.dart';

class RestaurantProvider with ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  List<Restaurant> _restaurants = [];
  List<Restaurant> get restaurants => _restaurants;

  List<Restaurant> _myRestaurants = [];
  List<Restaurant> get myRestaurants => _myRestaurants;

  List<NotificationItem> _notifications = [];
  List<NotificationItem> get notifications => _notifications;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // 1. Fetch Feed & Search
  Future<void> fetchRestaurants({String query = ''}) async {
    _isLoading = true;
    notifyListeners();

    try {
      var dbQuery = _supabase.from('restaurants').select();
      if (query.isNotEmpty) {
        dbQuery = dbQuery.ilike('name', '%$query%');
      }

      final List<dynamic> data = await dbQuery.order('created_at', ascending: false);
      _restaurants = data.map((e) => Restaurant.fromJson(e)).toList();
    } catch (e) {
      debugPrint("Error fetch restaurants: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  // 2. Fetch Postingan Profil (Diperbaiki agar aman)
  Future<void> fetchMyRestaurants() async {
    _myRestaurants = [];

    // Cek user langsung dari instance Supabase
    final userId = _supabase.auth.currentUser?.id;

    // Jika tidak ada user login, stop proses
    if (userId == null) {
      notifyListeners();
      return;
    }

    try {
      final List<dynamic> data = await _supabase
          .from('restaurants')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      _myRestaurants = data.map((e) => Restaurant.fromJson(e)).toList();
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetch my resto: $e");
    }
  }

  // 3. Fetch Notifikasi
  Future<void> fetchNotifications() async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) return;

    try {
      final List<dynamic> data = await _supabase
          .from('notifications')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      _notifications = data.map((e) => NotificationItem.fromJson(e)).toList();
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetch notif: $e");
    }
  }

  Future<List<Menu>> fetchMenus(String restaurantId) async {
    try {
      final data = await _supabase.from('menus').select().eq('restaurant_id', restaurantId);
      return (data as List).map((e) => Menu.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<Review>> fetchReviews(String restaurantId) async {
    try {
      final data = await _supabase
          .from('reviews')
          .select()
          .eq('restaurant_id', restaurantId)
          .order('created_at', ascending: false);
      return (data as List).map((e) => Review.fromJson(e)).toList();
    } catch (e) {
      return [];
    }
  }

  // CREATE (UPLOAD)
  Future<void> addRestaurant(Restaurant resto, List<Menu> menus) async {
    try {
      // Pastikan User ID ada di object resto sebelum kirim
      if (resto.userId.isEmpty) {
        throw "User ID tidak valid. Silakan login ulang.";
      }

      final List<dynamic> res = await _supabase.from('restaurants').insert(resto.toJson()).select();
      final String newId = res.first['id'];

      if (menus.isNotEmpty) {
        final menuData = menus.map((m) => m.toJson(newId)).toList();
        await _supabase.from('menus').insert(menuData);
      }

      await fetchRestaurants();
      await fetchMyRestaurants();
    } catch (e) {
      rethrow;
    }
  }

  // UPDATE
  Future<void> updateRestaurant(Restaurant resto) async {
    try {
      await _supabase.from('restaurants').update({
        'name': resto.name,
        'description': resto.description,
        'address': resto.address,
        'image_url': resto.imageUrl,
      }).eq('id', resto.id);

      await fetchRestaurants();
      await fetchMyRestaurants();
    } catch (e) {
      rethrow;
    }
  }

  // DELETE
  Future<void> deleteRestaurant(String id) async {
    try {
      await _supabase.from('restaurants').delete().eq('id', id);

      _restaurants.removeWhere((r) => r.id == id);
      _myRestaurants.removeWhere((r) => r.id == id);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // ADD REVIEW
  Future<void> addReview(String restaurantId, String restaurantOwnerId, int rating, String comment) async {
    final user = _supabase.auth.currentUser;
    // Jika user null, gunakan nama 'Guest' atau lempar error
    if (user == null) throw "Harap login untuk memberi ulasan";

    final userName = user.userMetadata?['full_name'] ?? 'User';

    try {
      await _supabase.from('reviews').insert({
        'restaurant_id': restaurantId,
        'user_id': user.id,
        'user_name': userName,
        'rating': rating,
        'comment': comment,
      });

      if (user.id != restaurantOwnerId) {
        await _supabase.from('notifications').insert({
          'user_id': restaurantOwnerId,
          'sender_name': userName,
          'message': 'memberi rating $rating bintang: "$comment"',
        });
      }
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<double> getAverageRating(String restaurantId) async {
    try {
      final List data = await _supabase.from('reviews').select('rating').eq('restaurant_id', restaurantId);
      if (data.isEmpty) return 0.0;
      double total = data.fold(0, (sum, item) => sum + (item['rating'] as num));
      return total / data.length;
    } catch (e) {
      return 0.0;
    }
  }
}