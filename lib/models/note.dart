class Note {
  late int? _id =0;
  late String? _title;
  late String? _description;
  late String? _date;
  late int _priority;

  Note(this._title, this._date, this._priority, [this._description = '']);

  Note.withId(this._id, this._title, this._date, this._priority,
      [this._description = '']);

  int get id => _id!;
  String get title => _title!;
  String get description => _description!;
  String get date => _date!;
  int get priority => _priority;

  set title(String newTitle) {
    if (newTitle.length < 255) {
      _title = newTitle;
    }
  }

  set description(String newPriority) {
    if (newPriority.length < 255) {
      _description = newPriority;
    }
  }

  set date(String newDate) {
    if (newDate.length == 10) {
      _date = newDate;
    }
  }

  set priority(int newPriority) {
    if (newPriority >= 1 && newPriority <= 2) {
      _priority = newPriority;
    }
  }

// Convert Note to Map

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    if (_id != null) {
      map['id'] = _id;
    }

    map['title'] = _title;
    map['description'] = _description;
    map['date'] = _date;
    map['priority'] = _priority;
    return map;
  }

  Note.fromMapObject(Map<String, dynamic> map) {
    _id = map['id'];
    _title = map['title'];
    _description = map['description'];
    _date = map['date'];
    _priority = map['priority'];
  }
}
