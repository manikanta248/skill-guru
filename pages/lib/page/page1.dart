import 'package:flutter/material.dart';
import 'package:pages/page/page2.dart';
import 'package:pages/page/page3.dart';

class SelectRole extends StatefulWidget {
  const SelectRole({super.key});

  @override
  _SelectRoleState createState() => _SelectRoleState();
}

class _SelectRoleState extends State<SelectRole> {
  List<String> selectedRoles = [];
  bool _showRoles = false;
  final TextEditingController _roleController = TextEditingController();
  List<String> roles = ["Learner", "Guru"];
  List<String> filteredRoles = [];

  String data = '';

  @override
  void initState() {
    super.initState();
    filteredRoles = roles;
    _roleController.addListener(() {
      _filterRoles();
    });
  }

  void _filterRoles() {
    setState(() {
      filteredRoles = roles
          .where((role) =>
              role.toLowerCase().contains(_roleController.text.toLowerCase()))
          .toList();

      _showRoles = _roleController.text.isNotEmpty;
    });
  }

  void _handleSubmit() {
    if (selectedRoles.length < 2) {
      data = selectedRoles[0];
    }
  }

  void _navigateToDetailScreen() {
    if (roles.isNotEmpty && selectedRoles.length < 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LearnerSkills(data: data)),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LearnerGuruSkills(data: data)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 96),
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Image.asset('assets/images/back.png'),
                    ),
                  ),
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Join as Learner or Guru",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(76, 76, 76, 1),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Center(
                child: Text(
                  "Learn and Share",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(76, 76, 76, 1),
                  ),
                ),
              ),
              const SizedBox(height: 80),
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
                    padding: WidgetStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 0),
                    ),
                    backgroundColor: WidgetStateProperty.all(
                      const Color.fromRGBO(226, 226, 226, 1),
                    ),
                    shape: WidgetStateProperty.all(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(6),
                          topRight: Radius.circular(6),
                          bottomLeft: Radius.zero,
                          bottomRight: Radius.zero,
                        ),
                      ),
                    ),
                    overlayColor: WidgetStateProperty.all(Colors.transparent),
                    minimumSize: WidgetStateProperty.all(const Size(150, 40)),
                  ),
                  onPressed: () {
                    setState(() {
                      _showRoles = !_showRoles;
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
                          controller: _roleController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'am xxx',
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
                          _showRoles
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
                visible: _showRoles,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  width: 353,
                  constraints: const BoxConstraints(
                    maxHeight: 125,
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
                              ...filteredRoles.map((String role) {
                                bool isSelected = selectedRoles.contains(role);
                                return Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 2),
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
                                              selectedRoles.add(role);
                                            } else {
                                              selectedRoles.remove(role);
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
            ],
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(top: 456),
              child: SizedBox(
                width: 295,
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedRoles.isNotEmpty) {
                      _handleSubmit();
                      _navigateToDetailScreen();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedRoles.isNotEmpty
                        ? const Color.fromRGBO(0, 145, 234, 1)
                        : Colors.grey,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Next',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Image.asset(
                        'assets/images/arrowNext.png',
                        width: 24,
                        height: 24,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _roleController.dispose();
    super.dispose();
  }
}
