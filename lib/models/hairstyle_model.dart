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
          fullDescription: 'Yanların kısa, üstlerin biraz daha uzun bırakılarak pürüzsüz bir geçiş sağlandığı modern ve popüler bir saç modelidir.',
          difficulty: 'Orta',
          duration: '30 - 40 Dk',
          imageUrl: 'assets/images/fade.png',
        ),
        HairstyleModel(
          id: 'h2',
          name: 'Buzz Cut',
          shortDescription: 'Kısa ve pratik askeri kesim.',
          fullDescription: 'Makine ile saçın her yerinin çok kısa ve eşit kesildiği, bakım gerektirmeyen son derece pratik bir stildir.',
          difficulty: 'Kolay',
          duration: '15 - 20 Dk',
          imageUrl: 'assets/images/buzz.png',
        ),
        HairstyleModel(
          id: 'h3',
          name: 'Pompadour',
          shortDescription: 'Üstleri hacimli klasik tarz.',
          fullDescription: 'Ön kısımların geriye doğru hacimli bir şekilde taranıp şekillendirildiği, yanların ise kısa kesildiği klasik ve şık bir model.',
          difficulty: 'Zor',
          duration: '45 - 50 Dk',
          imageUrl: 'assets/images/pompadour.png',
        ),
        HairstyleModel(
          id: 'h4',
          name: 'Undercut',
          shortDescription: 'Yanları kazınmış üstler uzun.',
          fullDescription: 'Yanların ve enselerin kazındığı veya çok kısa kesildiği, üstlerin uzun bırakılıp ayrık tutulduğu asi bir tarz.',
          difficulty: 'Orta',
          duration: '30 - 45 Dk',
          imageUrl: 'assets/images/undercut.png',
        ),
        HairstyleModel(
          id: 'h5',
          name: 'Crew Cut',
          shortDescription: 'Düzgün ve profesyonel görünüm.',
          fullDescription: 'Önlerin biraz uzun, arkaya doğru kısalarak devam ettiği, yanların temizlendiği çok kullanışlı profesyonel bir kesim.',
          difficulty: 'Kolay',
          duration: '20 - 30 Dk',
          imageUrl: 'assets/images/crew.png',
        ),
        HairstyleModel(
          id: 'h6',
          name: 'Curly Style',
          shortDescription: 'Kıvırcık saçlar için özel kesim.',
          fullDescription: 'Doğal kıvırcık saçları ön plana çıkaran, buklelerin belirginleştiği özel makas ve tekniklerle uygulanan model.',
          difficulty: 'Orta',
          duration: '40 - 50 Dk',
          imageUrl: 'assets/images/curly.png',
        ),
        HairstyleModel(
          id: 'h7',
          name: 'Modern Fade',
          shortDescription: 'Sıfır numara ile kusursuz geçiş.',
          fullDescription: 'Ten rengi ile saç arasında jilet veya sıfır numara ile başlayan mükemmel bir solma (fade) efektinin uygulandığı tarz.',
          difficulty: 'Zor',
          duration: '45 - 60 Dk',
          imageUrl: 'assets/images/modern_fade.png',
        ),
        HairstyleModel(
          id: 'h8',
          name: 'Classic Cut',
          shortDescription: 'Zamansız ve temiz standart kesim.',
          fullDescription: 'Her ortama uyan, yanların makasla temizlendiği ve üstlerin hafif uzun bırakılarak yana tarandığı standart erkek kesimi.',
          difficulty: 'Kolay',
          duration: '20 - 30 Dk',
          imageUrl: 'assets/images/classic.png',
        ),
      ];
}
