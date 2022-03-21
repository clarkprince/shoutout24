class HMenu {
  final int id;
  final String title;

  HMenu({this.id, this.title});
}

List<HMenu> appMenu = [
  HMenu(title: "Check on me", id: 1),
  HMenu(title: "I need help getting home safely", id: 2),
  HMenu(title: 'I need healthy relationship advice', id: 3),
  HMenu(title: 'Send my location', id: 4),
];
