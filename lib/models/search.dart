class Search {
  Search({
    this.id,
    this.title,
  });

  int id;
  String title;

  factory Search.fromJson(Map<String, dynamic> json) {
    return Search(
      id: json["id"],
      title: json["title"],
    );
  }
}

class SList {
  final List<Search> search;

  SList({
    this.search,
  });
  factory SList.fromJson(List<dynamic> parsedJson) {
    List<Search> lsearch = new List<Search>();
    lsearch = parsedJson.map((i) => Search.fromJson(i)).toList();

    return new SList(
      search: lsearch,
    );
  }
}
