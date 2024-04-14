class OnBoardingModel {
  String imagePath;
  String title;
  String subTitle;
  String nextBottom;
  String skip;

  OnBoardingModel({
    required this.title,
    required this.imagePath,
    required this.subTitle,
    required this.nextBottom,
    required this.skip,
  });

  static List<OnBoardingModel> onBoardingScreens = [
    OnBoardingModel(
        title: 'Make friends from all states',
        imagePath: 'assets/images/onBoarding1.png',
        skip: 'Skip',
        subTitle:
            ' YabYab allows you to discover more and more friends from all over the world and share everything new with them.',
        nextBottom: 'Next'),
    OnBoardingModel(
        title: 'Share everything with your friends',
        imagePath: 'assets/images/onBoarding2.png',
        skip: 'Skip',
        subTitle:
            "YabYab gives you the opportunity to share what's going on in your life with your friends from all over the world.",
        nextBottom: 'Next'),
    OnBoardingModel(
        title: ' Connect with your friends now',
        imagePath: 'assets/images/onBoarding3.png',
        skip: '',
        subTitle: 'YabYab allows you to have conversations with your friends from all over the world and form groups together to discuss the latest news.',
        nextBottom: 'Get Started')
  ];
}
