class HairstyleModel {
  final String id;
  final String name;
  final String shortDescription;
  final String fullDescription;
  final String difficulty;
  final String duration;
  final String imageUrl;

  HairstyleModel({
    required this.id,
    required this.name,
    required this.shortDescription,
    required this.fullDescription,
    required this.difficulty,
    required this.duration,
    required this.imageUrl,
  });

  static List<HairstyleModel> get dummyData => [
    HairstyleModel(
      id: 'h1',
      name: 'Fade Cut',
      shortDescription: 'Modern ve pürüzsüz geçişli kesim.',
      fullDescription:
          'Yanların kısa, üstlerin biraz daha uzun bırakılarak pürüzsüz bir geçiş sağlandığı modern ve popüler bir saç modelidir.',
      difficulty: 'Orta',
      duration: '30 - 40 Dk',
      imageUrl: 'assets/images/fade.png',
    ),
    HairstyleModel(
      id: 'h2',
      name: 'Buzz Cut',
      shortDescription: 'Kısa ve pratik askeri kesim.',
      fullDescription:
          'Makine ile saçın her yerinin çok kısa ve eşit kesildiği, bakım gerektirmeyen son derece pratik bir stildir.',
      difficulty: 'Kolay',
      duration: '15 - 20 Dk',
      imageUrl: 'assets/images/buzz.png',
    ),
    HairstyleModel(
      id: 'h3',
      name: 'Pompadour',
      shortDescription: 'Üstleri hacimli klasik tarz.',
      fullDescription:
          'Ön kısımların geriye doğru hacimli bir şekilde taranıp şekillendirildiği, yanların ise kısa kesildiği klasik ve şık bir model.',
      difficulty: 'Zor',
      duration: '45 - 50 Dk',
      imageUrl: 'assets/images/pompadour.png',
    ),
    HairstyleModel(
      id: 'h4',
      name: 'Under cut',
      shortDescription: 'Yanları kazınmış üstler uzun.',
      fullDescription:
          'Yanların ve enselerin kazındığı veya çok kısa kesildiği, üstlerin uzun bırakılıp ayrık tutulduğu asi bir tarz.',
      difficulty: 'Orta',
      duration: '30 - 45 Dk',
      imageUrl: 'assets/images/undercut.png',
    ),
    HairstyleModel(
      id: 'h5',
      name: 'Crew Cut',
      shortDescription: 'Düzgün ve profesyonel görünüm.',
      fullDescription:
          'Önlerin biraz uzun, arkaya doğru kısalarak devam ettiği, yanların temizlendiği çok kullanışlı profesyonel bir kesim.',
      difficulty: 'Kolay',
      duration: '20 - 30 Dk',
      imageUrl: 'assets/images/crew.png',
    ),
    HairstyleModel(
      id: 'h6',
      name: 'Curly Style',
      shortDescription: 'Kıvırcık saçlar için özel kesim.',
      fullDescription:
          'Doğal kıvırcık saçları ön plana çıkaran, buklelerin belirginleştiği özel makas ve tekniklerle uygulanan model.',
      difficulty: 'Orta',
      duration: '40 - 50 Dk',
      imageUrl: 'assets/images/curly.png',
    ),
    HairstyleModel(
      id: 'h7',
      name: 'Comma Hair Cut',
      shortDescription: 'Saçların virgül şeklinde şekillendirildiği Kore tarzı.',
      fullDescription:
          'Saçların öne doğru taranıp virgül (comma) şekli oluşturacak şekilde katmanlı kesildiği, özellikle Kore tarzı pop kültüründen ilham alan şık bir model.',
      difficulty: 'Orta',
      duration: '40 - 50 Dk',
      imageUrl: 'assets/images/comma_hair.png',
    ),
    HairstyleModel(
      id: 'h8',
      name: 'Mullet Cut',
      shortDescription: 'Önde kısa, arkada uzun asi tarz.',
      fullDescription:
          'Önde ve yanlarda kısa kesilen, arkada ise uzun bırakılan ve genellikle kıvırcık veya dalgalı saçlarla kombine edilen cesur ve retro-modern bir stil.',
      difficulty: 'Orta',
      duration: '35 - 50 Dk',
      imageUrl: 'assets/images/mullet.png',
    ),
  ];
}
