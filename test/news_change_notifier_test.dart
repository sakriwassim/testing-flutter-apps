import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_tutorial/article.dart';
import 'package:flutter_testing_tutorial/news_change_notifier.dart';
import 'package:flutter_testing_tutorial/news_service.dart';
import 'package:mocktail/mocktail.dart';

// class BadMockNewsService implements NewsService {
//   bool getArticalesCalled = false;
//   @override
//   Future<List<Article>> getArticles() async {
//     getArticalesCalled = true;
//     return [
//       Article(title: "test1", content: "test 1 content"),
//       Article(title: "test2", content: "test 2 content"),
//       Article(title: "test3", content: "test 3 content"),
//     ];
//   }
// }

class MockNewsService extends Mock implements NewsService {}

void main() {
  late NewsChangeNotifier sut;
  late MockNewsService mockNewsService;

  setUp(() {
    mockNewsService = MockNewsService();
    sut = NewsChangeNotifier(mockNewsService);
  });

  test(
    "initial values are correct ",
    () {
      expect(sut.articles, []);
      expect(sut.isLoading, false);
    },
  );
}
