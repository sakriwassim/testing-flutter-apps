import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_tutorial/article.dart';
import 'package:flutter_testing_tutorial/main.dart';
import 'package:flutter_testing_tutorial/news_change_notifier.dart';
import 'package:flutter_testing_tutorial/news_page.dart';
import 'package:flutter_testing_tutorial/news_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class MockNewsService extends Mock implements NewsService {}

void main() {
  late MockNewsService mockNewsService;

  setUp(() {
    mockNewsService = MockNewsService();
  });

  final articlesFromService = [
    Article(title: "titletest1", content: "contenttest1"),
    Article(title: "titletest2", content: "contenttest2"),
    Article(title: "titletest3", content: "contenttest3"),
  ];

  void arrangeNewsServiceReturns3Articles() {
    when(
      () => mockNewsService.getArticles(),
    ).thenAnswer(
      (invocation) async => articlesFromService,
    );
  }

  void arrangeNewsServiceReturns3ArticlesAfter2SecondWait() {
    when(
      () => mockNewsService.getArticles(),
    ).thenAnswer(
      (invocation) async {
        await Future.delayed(const Duration(seconds: 2));
        return articlesFromService;
      },
    );
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

  testWidgets("title is displayed ", (WidgetTester tester) async {
    arrangeNewsServiceReturns3Articles();
    await tester.pumpWidget(createWidgetUnderTest());
    expect(find.text("News"), findsOneWidget);
  });
  testWidgets("loading indicator is disolayed with waiting for articals ",
      (tester) async {
    arrangeNewsServiceReturns3ArticlesAfter2SecondWait();

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump(const Duration(microseconds: 500));
    expect(find.byKey(Key("progress-indicator")), findsOneWidget);

    await tester.pumpAndSettle();
  });

  testWidgets(
    "articales are displayed",
    (tester) async {
      arrangeNewsServiceReturns3Articles();

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      for (final article in articlesFromService) {
        expect(find.text(article.title), findsOneWidget);
        expect(find.text(article.content), findsOneWidget);
      }
    },
  );
}
