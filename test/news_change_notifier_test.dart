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

  group("getArticles", () {
    final articlesFromService = [
        Article(title: "titletest1", content: "contenttest1"),
    Article(title: "titletest2", content: "contenttest2"),
    Article(title: "titletest3", content: "contenttest3"),
  
    ];

    void arrangeNewsServiceReturns3Articles() {
      when(
        () => mockNewsService.getArticles(),
      ).thenAnswer((invocation) async => articlesFromService);
    }

    test("get Articles using the NewsService ", () async {
      arrangeNewsServiceReturns3Articles();
      await sut.getArticles();
      verify(() => mockNewsService.getArticles()).called(1);
    });

    test("""indicates loding of data , 
      sets articles to the ones form the service , 
      indicates that data is not being loaded anymore """, () async {
      arrangeNewsServiceReturns3Articles();
      final future = sut.getArticles();

      expect(sut.isLoading, true);
      await future;
      expect(
        sut.articles,
        articlesFromService,
      );
      expect(sut.isLoading, false);
    });
  });
}
