import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_tutorial/article.dart';
import 'package:flutter_testing_tutorial/article_page.dart';
import 'package:flutter_testing_tutorial/news_change_notifier.dart';
import 'package:flutter_testing_tutorial/news_page.dart';
import 'package:flutter_testing_tutorial/news_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

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

    Widget createWidgetUnderTest() {
      return MaterialApp(
        title: 'News App',
        home: ChangeNotifierProvider(
          create: (_) => NewsChangeNotifier(mockNewsService),
          child: NewsPage(),
        ),
      );
    }

    testWidgets(
        "tapping on the first articale excerpt poens the article page where the full article content is displayed",
        (widgetTester) async {
      arrangeNewsServiceReturns3Articles();
      await widgetTester.pumpWidget(createWidgetUnderTest());
      await widgetTester.pump();
      await widgetTester.tap(find.text("contenttest1"));
      await widgetTester.pumpAndSettle();
      expect(find.byType(NewsPage), findsNothing);
      expect(find.byType(ArticlePage), findsOneWidget);
      expect(find.text("titletest1"), findsOneWidget);
      expect(find.text("contenttest1"), findsOneWidget);
    });
  });
}
