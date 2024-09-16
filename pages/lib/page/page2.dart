import 'package:flutter/material.dart';
import 'package:pages/page/call_page.dart';

class LearnerSkills extends StatefulWidget {
  final String data;
  const LearnerSkills({required this.data, super.key});

  @override
  _LearnerSkillsState createState() => _LearnerSkillsState();
}

class _LearnerSkillsState extends State<LearnerSkills> {
  bool isLearner = false;
  bool isGuru = false;
  bool isLearnerisGuru = false;

  List<String> selectedSkills = [];
  bool _showSkills = false;
  final TextEditingController _skillController = TextEditingController();
  List<String> skills = [
    "Figma",
    "App Development",
    "Power BI",
    "Photoshop",
    "After Effects",
    "Web Development"
  ];
  List<String> filterSkills = [];
  String role = '';
  late ScrollController _scrollController; // Declare ScrollController as late

  @override
  void initState() {
    super.initState();
    filterSkills = skills;
    _skillController.addListener(() {
      _filterSkills();
    });
    role = widget.data;
    _scrollController =
        ScrollController(); // Properly initialize ScrollController

    // Example usage of widget.data
    if (widget.data == 'Learner') {
      isLearner = true;
    } else if (widget.data == 'Guru') {
      isGuru = true;
    }
  }

  void _navigateToDetailScreen() {
    if (isLearner) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                QueryVideoCall(selectedSkills: selectedSkills)),
      );
    }
  }

  void _filterSkills() {
    setState(() {
      filterSkills = skills
          .where((skill) =>
              skill.toLowerCase().contains(_skillController.text.toLowerCase()))
          .toList();

      _showSkills = _skillController.text.isNotEmpty;
    });
  }

  void _handleSubmit() {
    print("Selected Skills: $selectedSkills");
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
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(
                              context); // Navigates back to the previous screen
                        },
                        child: Image.asset('assets/images/back.png'),
                      ),
                    ),
                  ),
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Unlock your potential",
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
                  "Discover, ask and grow",
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
                        width: 130,
                        height: 30,
                        child: TextField(
                          controller: _skillController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '$role skills',
                            hintStyle: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Color.fromRGBO(5, 5, 5, 0.3),
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Padding(
                        padding: const EdgeInsets.only(left: 123),
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
                    maxHeight: 155,
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
                        child: Scrollbar(
                          controller: _scrollController,
                          thumbVisibility: true,
                          thickness: 8.0,
                          radius: const Radius.circular(6),
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ...filterSkills.map((String skill) {
                                  bool isSelected =
                                      selectedSkills.contains(skill);
                                  return Container(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 2),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Colors.blue
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        Checkbox(
                                          value: isSelected,
                                          onChanged: (bool? newValue) {
                                            setState(() {
                                              if (newValue == true) {
                                                selectedSkills.add(skill);
                                              } else {
                                                selectedSkills.remove(skill);
                                              }
                                            });
                                          },
                                          activeColor: Colors.blue,
                                          checkColor: Colors.white,
                                        ),
                                        Expanded(
                                          child: Text(
                                            skill,
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
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedSkills.isNotEmpty) {
                      _handleSubmit();
                      _navigateToDetailScreen();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedSkills.isNotEmpty
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
    _scrollController.dispose(); // Dispose the ScrollController
    super.dispose();
  }
}
