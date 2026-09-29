abstract final class Routes {
  static const posts = '/posts';
  static String postDetail(int id) => '/posts/$id';
  static const notifications = '/notifications';
  static String notificationDetail(String id) => '/notifications/$id';
}