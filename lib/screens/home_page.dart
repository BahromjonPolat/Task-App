import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:storage/components/button_colors.dart';
import 'package:storage/components/colors.dart';
import 'package:storage/components/date_time_titles.dart';
import 'package:storage/components/image_list.dart';
import 'package:storage/helpers/task_db_helper.dart';
import 'package:storage/models/task_model.dart';
import 'package:storage/widgets/set_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double? _height;
  double? _width;

  int _currentIndex = 0;

  final DateTime _date = DateTime.now();
  String? _currentDate;

  final TextEditingController _titleController = TextEditingController();

  String _radioGroup = "Medium";
  String _subtitle = "Other";
  String? _imageUrl;

  DatabaseHelper _db = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    _height = MediaQuery.of(context).size.height;
    _width = MediaQuery.of(context).size.width;

    _currentDate =
        "${_date.day} ${monthList[_date.month - 1].substring(0, 3)} ${_date.year} ${weekList[_date.weekday - 1].substring(0, 3)}";
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: _showBottomNavigationBar(),
    );
  }

  SafeArea _buildBody() => SafeArea(
        child: FutureBuilder(
            future: _db.getAllTasks(),
            builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snap) {
              return snap.hasData
                  ? _customScrollBody(snap)
                  : const CupertinoActivityIndicator();
            }),
      );

  CustomScrollView _customScrollBody(
      AsyncSnapshot<List<Map<String, dynamic>>> snap) {
    return CustomScrollView(
      slivers: [
        _showHeader(),
        SliverList(
          delegate: SliverChildListDelegate(
            List.generate(snap.data!.length, (index) {
              Map<String, dynamic> map = snap.data![index];
              Task task = Task.fromJson(map);
              return Card(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 6.0,
                    horizontal: 12.0,
                  ),
                  title: setSimpleText(
                    task.title,
                    size: 18.0,
                    weight: FontWeight.bold,
                  ),
                  subtitle: setSimpleText(
                    task.subTitle,
                    color: colorGrey,
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      setSimpleText(
                        task.priority,
                        color: colorGrey,
                      ),
                      CircleAvatar(
                        radius: 16.0,
                        backgroundImage: NetworkImage(task.imageUrl),
                      )
                    ],
                  ),
                ),
              );
            }),
          ),
        )
      ],
    );
  }

  /// Ilovaning yuqori qismi
  SliverToBoxAdapter _showHeader() => SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 18.0,
            vertical: 12.0,
          ),
          child: SizedBox(
            height: _height! * 0.3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    setSimpleText("Today", size: 32.0, weight: FontWeight.bold),
                    _setIcon(
                      Icons.calendar_today_outlined,
                      color: colorGrey,
                      size: 16.0,
                    ),
                  ],
                ),
                setSimpleText(_currentDate!, color: colorGrey),
                _showSearchButton(),
                _showButtons(),
              ],
            ),
          ),
        ),
      );

  /// SEARCH FIELD
  Container _showSearchButton() => Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          gradient: searchButtonGradientColor,
          borderRadius: _setBorderRadius(),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _setIcon(Icons.search),
            setSimpleText("Search", color: colorWhite),
          ],
        ),
      );

  Row _showButtons() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Badge(
              badgeContent: setSimpleText("4", color: colorWhite, size: 10.0),
              position: const BadgePosition(top: 0.0, end: 0.0),
              child: _setButton("Undone", 0)),
          _setButton("Meetings", 1),
          _setButton("Consummation", 2),
        ],
      );

  ElevatedButton _setButton(String label, int index) => ElevatedButton(
        onPressed: () {
          setState(() {
            _currentIndex = index;
          });
        },
        child: setSimpleText(
          label,
          color: _currentIndex == index ? colorDeepBlue : colorGrey,
          weight: FontWeight.bold,
        ),
        style: ElevatedButton.styleFrom(
            primary: _currentIndex == index
                ? const Color(0x2b195ecd)
                : colorTransparent,
            elevation: 0.0,
            shape: RoundedRectangleBorder(borderRadius: _setBorderRadius())),
      );

  _showBottomNavigationBar() => Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton.icon(
          onPressed: _showBottomSheetDialog,
          icon: _setIcon(Icons.add_circle),
          label: setSimpleText("Add new task", color: colorWhite),
          style: ElevatedButton.styleFrom(
              primary: colorDeepBlue,
              fixedSize: Size(_width!, 65.0),
              shape: RoundedRectangleBorder(
                  borderRadius: _setBorderRadius(radius: 32.0))),
        ),
      );

  Icon _setIcon(IconData iconData, {Color? color, double? size}) => Icon(
        iconData,
        color: color ?? colorWhite,
        size: size ?? 24.0,
      );

  BorderRadius _setBorderRadius({double? radius}) =>
      BorderRadius.circular(radius ?? 16.00);

  void _showBottomSheetDialog() {
    showModalBottomSheet(
        isScrollControlled: true,
        elevation: 0.0,
        barrierColor: colorTransparent,
        backgroundColor: colorTransparent,
        context: context,
        builder: (_) {
          return StatefulBuilder(builder: (context, state) {
            return Container(
              height: _height! * 0.82,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                  color: colorDeepBlue,
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(32.0),
                      topLeft: Radius.circular(32.0))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _showTextField(),
                  _showTaskTitles(),
                  const Divider(color: colorWhite, thickness: 0.5),
                  setSimpleText(
                    "Priority",
                    color: colorWhite,
                    size: 18.00,
                  ),
                  _showRadioButtons(),
                  const Divider(color: colorWhite, thickness: 0.5),
                  setSimpleText("Invite", color: colorWhite, size: 18.0),
                  _showProfileImages(),
                  _showFooterButtons(),
                ],
              ),
            );
          });
        });
  }

  TextField _showTextField() {
    return TextField(
      controller: _titleController,
      style: const TextStyle(
        fontSize: 24.0,
        color: Colors.white54,
      ),
      decoration: InputDecoration(
        border: _setBorder(),
        enabledBorder: _setBorder(),
        hintText: "What do you need to do?",
        hintStyle: const TextStyle(
          fontSize: 24.0,
          color: Colors.white54,
        ),
      ),
    );
  }

  OutlineInputBorder _setBorder() =>
      const OutlineInputBorder(borderSide: BorderSide.none);

  _showTaskTitles() => Wrap(
        crossAxisAlignment: WrapCrossAlignment.start,
        spacing: 24.0,
        children: List.generate(
          _taskTitles.length + 1,
          (index) => index == _taskTitles.length
              ? _showAddButton()
              : _setTitleButton(_taskTitles[index], colorList[index]),
        ),
      );

  ElevatedButton _setTitleButton(String label, Color color) => ElevatedButton(
        onPressed: () {
          Fluttertoast.showToast(msg: "$label was chosen");
          _subtitle = label;
        },
        child: setSimpleText(label),
        style: ElevatedButton.styleFrom(primary: color, elevation: 0.0),
      );

  _showAddButton({double? size}) => ElevatedButton(
        onPressed: () {},
        child: _setIcon(Icons.add),
        style: ElevatedButton.styleFrom(
          primary: Colors.white54,
          elevation: 0.0,
          padding: EdgeInsets.zero,
          fixedSize: Size(size ?? 32.0, size ?? 32.0),
        ),
      );

  Row _showRadioButtons() => Row(
        children: [
          _setRadioButton("High!!!"),
          _setRadioButton("Medium"),
          _setRadioButton("Low"),
          _setRadioButton("None"),
        ],
      );

  _setRadioButton(String label) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Theme(
            data: Theme.of(context).copyWith(unselectedWidgetColor: colorWhite),
            child: Radio(
                value: label,
                groupValue: _radioGroup,
                activeColor: colorWhite,
                focusColor: colorWhite,
                hoverColor: colorWhite,
                onChanged: (v) {
                  setState(() {
                    _radioGroup = label;
                  });
                }),
          ),
          setSimpleText(label, color: colorWhite),
        ],
      );

  Wrap _showProfileImages() => Wrap(
        spacing: 12.0,
        children: List.generate(
          imageLinks.length + 1,
          (index) => index != 4
              ? _setImage(
                  imageLinks[index],
                )
              : _showAddButton(size: 48.0),
        ),
      );

  _setImage(String imageUrl) => InkWell(
        onTap: () {
          _imageUrl = imageUrl;
        },
        child: Container(
          height: 48.0,
          width: 48.0,
          decoration: BoxDecoration(
            borderRadius: _setBorderRadius(),
            image: DecorationImage(
                fit: BoxFit.cover, image: NetworkImage(imageUrl)),
          ),
        ),
      );

  Row _showFooterButtons() => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _setBottomButton("Recurring"),
          _setBottomButton("Save", color: colorWhite),
        ],
      );

  _setBottomButton(String label, {Color? color}) => ElevatedButton(
        onPressed: () async {
          String title = _titleController.text;

          if (title.isEmpty) return;

          Task task = Task(title, _subtitle, _radioGroup, _imageUrl);
          _db.addTask(task);
          Fluttertoast.showToast(msg: "$title was added");
          Navigator.pop(context);
          setState(() {});
        },
        child: setSimpleText(label,
            color: color != null ? colorBlack : colorWhite),
        style: ElevatedButton.styleFrom(
          primary: color ?? colorTransparent,
          elevation: 0.0,
        ),
      );

  final List<String> _taskTitles = [
    "Meeting",
    "Review",
    "marketing",
    "Design projection",
  ];
}
