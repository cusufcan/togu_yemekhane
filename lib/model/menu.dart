class Menu {
  final List<String> menuList;

  Menu({required this.menuList});

  factory Menu.fromJson(Map<String, dynamic> json) {
    return Menu(
      menuList: List<String>.from(json['menuList']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'menuList': menuList,
    };
  }

  @override
  String toString() {
    return menuList.toString();
  }
}
