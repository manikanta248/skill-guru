import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QueryVideoCall extends StatefulWidget {
  final List<String> selectedSkills;
  const QueryVideoCall({super.key, required this.selectedSkills});

  static const routeName = '/query-video';

  @override
  State<QueryVideoCall> createState() => _QueryVideoCallState();
}

class _QueryVideoCallState extends State<QueryVideoCall> {
  final TextEditingController _questionController = TextEditingController();
  bool _isOnline = true;
  List<String> selectedRequiredSkills = [];
  bool _showSkills = false;
  final TextEditingController _skillController = TextEditingController();
  List<String> roles = ["Learner", "Guru"];
  List<String> filteredSkills = [];

  @override
  void initState() {
    super.initState();
    filteredSkills = widget.selectedSkills;
    _skillController.addListener(() {
      _filterRoles();
    });
  }

  void _filterRoles() {
    setState(() {
      filteredSkills = widget.selectedSkills
          .where((role) =>
              role.toLowerCase().contains(_skillController.text.toLowerCase()))
          .toList();

      // Show roles if the roleController has text and there are matching roles
      _showSkills =
          _skillController.text.isNotEmpty && filteredSkills.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Call'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isOnline = !_isOnline;
                });
              },
              child: _isOnline
                  ? const Icon(
                      Icons.toggle_on_rounded,
                      size: 60,
                      color: Colors.green,
                    )
                  : const Icon(
                      Icons.toggle_off_rounded,
                      size: 60,
                      color: CupertinoColors.systemGrey3,
                    ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(17.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextField(
              textAlign: TextAlign.left,
              minLines: 6,
              maxLines: 8,
              controller: _questionController,
              decoration: const InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                filled: true,
                fillColor: CupertinoColors.systemGrey5,
                hintText: "Type your question here....",
                hintStyle: TextStyle(color: CupertinoColors.systemGrey2),
              ),
              autocorrect: true,
            ),
            const SizedBox(height: 24),
            Container(
              width: 350,
              height: 60,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color.fromRGBO(102, 102, 102, 0.6),
                    width: 2,
                  ),
                ),
              ),
              child: TextButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 0),
                  ),
                  backgroundColor: MaterialStateProperty.all(
                    const Color.fromRGBO(226, 226, 226, 1),
                  ),
                  shape: MaterialStateProperty.all(
                    const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(6),
                        topRight: Radius.circular(6),
                        bottomLeft: Radius.zero,
                        bottomRight: Radius.zero,
                      ),
                    ),
                  ),
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  minimumSize: MaterialStateProperty.all(const Size(150, 40)),
                ),
                onPressed: () {
                  setState(() {
                    _showSkills = !_showSkills;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Padding(padding: EdgeInsets.only(left: 44)),
                    SizedBox(
                      width: 102,
                      height: 30,
                      child: TextField(
                        controller: _skillController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Add Skill',
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(5, 5, 5, 0.3),
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 150),
                      child: Image.asset(
                        _showSkills
                            ? 'assets/images/up.png'
                            : 'assets/images/down.png',
                        width: 15,
                        height: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: _showSkills,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                width: 353,
                constraints: const BoxConstraints(
                  maxHeight: 120,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.15),
                      spreadRadius: 0,
                      blurRadius: 16,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Text input",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(189, 189, 189, 1),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...filteredSkills.map((String role) {
                              bool isSelected =
                                  selectedRequiredSkills.contains(role);
                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 2),
                                decoration: BoxDecoration(
                                  color:
                                      isSelected ? Colors.blue : Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: isSelected,
                                      onChanged: (bool? newValue) {
                                        setState(() {
                                          if (newValue == true) {
                                            selectedRequiredSkills.add(role);
                                          } else {
                                            selectedRequiredSkills.remove(role);
                                          }
                                        });
                                      },
                                      activeColor: Colors.blue,
                                      checkColor: Colors.white,
                                    ),
                                    Expanded(
                                      child: Text(
                                        role,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: isSelected
                                              ? Colors.white
                                              : const Color.fromRGBO(
                                                  76, 76, 76, 1),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () {},
              child: const Icon(
                Icons.phone_in_talk_outlined,
                size: 50,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _skillController.dispose();
    super.dispose();
  }
}
