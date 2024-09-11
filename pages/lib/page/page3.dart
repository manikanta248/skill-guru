import 'package:flutter/material.dart';

class LearnerGuruSkills extends StatefulWidget {
  final String data;
  const LearnerGuruSkills({required this.data, super.key});

  @override
  _LearnerGuruSkillsState createState() => _LearnerGuruSkillsState();
}

class _LearnerGuruSkillsState extends State<LearnerGuruSkills> {
  bool isLearner = false;
  bool isGuru = false;

  List<String> selectedLearnerSkills = [];
  List<String> selectedGuruSkills = [];

  bool _showLearnerSkills = false;
  bool _showGuruSkills = false;

  final TextEditingController _learnerSkillController = TextEditingController();
  final TextEditingController _guruSkillController = TextEditingController();

  List<String> learnerSkills = [
    "Figma",
    "App Development",
    "Power BI",
    "Photoshop",
    "After Effects",
    "Web Development"
  ];
  List<String> guruSkills = [
    "Figma",
    "App Development",
    "Power BI",
    "Photoshop",
    "After Effects",
    "Web Development"
  ];

  List<String> filteredLearnerSkills = [];
  List<String> filteredGuruSkills = [];

  String role = '';

  @override
  void initState() {
    super.initState();

    filteredLearnerSkills = learnerSkills;
    filteredGuruSkills = guruSkills;

    _learnerSkillController.addListener(() {
      _filterSkills(_learnerSkillController.text, isLearner: true);
    });

    _guruSkillController.addListener(() {
      _filterSkills(_guruSkillController.text, isLearner: false);
    });

    role = widget.data;
    if (widget.data == 'Learner') {
      isLearner = true;
    } else if (widget.data == 'Guru') {
      isGuru = true;
    }
  }

  void _filterSkills(String searchText, {required bool isLearner}) {
    setState(() {
      if (isLearner) {
        filteredLearnerSkills = learnerSkills
            .where((skill) =>
                skill.toLowerCase().contains(searchText.toLowerCase()))
            .toList();
        _showLearnerSkills = searchText.isNotEmpty;
      } else {
        filteredGuruSkills = guruSkills
            .where((skill) =>
                skill.toLowerCase().contains(searchText.toLowerCase()))
            .toList();
        _showGuruSkills = searchText.isNotEmpty;
      }
    });
  }

  void _onSkillSelected(String skill, bool isLearner) {
    setState(() {
      if (isLearner) {
        if (selectedLearnerSkills.contains(skill)) {
          selectedLearnerSkills.remove(skill);
        } else {
          selectedLearnerSkills.add(skill);
        }
      } else {
        if (selectedGuruSkills.contains(skill)) {
          selectedGuruSkills.remove(skill);
        } else {
          selectedGuruSkills.add(skill);
        }
      }
    });
  }

  void _handleSubmit() {
    // Handle the selected skills submission
    print("Learner Selected Skills: $selectedLearnerSkills");
    print("Guru Selected Skills: $selectedGuruSkills");
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
                          Navigator.pop(context); // Navigate back
                        },
                        child: Image.asset('assets/images/back.png'),
                      ),
                    ),
                  ),
                  const Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Unlock your potential",
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
                  "Discover, ask, and grow",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(76, 76, 76, 1),
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Learner skills input
              _buildSkillsInput(
                  "Learner skills",
                  _learnerSkillController,
                  _showLearnerSkills,
                  filteredLearnerSkills,
                  selectedLearnerSkills,
                  isLearner),
              const SizedBox(height: 20),

              // Guru skills input
              _buildSkillsInput(
                  "Guru skills",
                  _guruSkillController,
                  _showGuruSkills,
                  filteredGuruSkills,
                  selectedGuruSkills,
                  isGuru),
              const SizedBox(height: 10),

              // Next button
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10), // Adjust padding as needed
                  child: SizedBox(
                    width: 295,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: selectedLearnerSkills.isNotEmpty
                          ? _handleSubmit
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedLearnerSkills.isNotEmpty
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
        ],
      ),
    );
  }

  Widget _buildSkillsInput(
    String hintText,
    TextEditingController controller,
    bool showSkills,
    List<String> filteredSkills,
    List<String> selectedSkills,
    bool isRoleSelected,
  ) {
    return Column(
      children: [
        Container(
          width: 350, // Decreased width
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
                if (hintText == "Learner skills") {
                  _showLearnerSkills = !_showLearnerSkills;
                } else {
                  _showGuruSkills = !_showGuruSkills;
                }
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Padding(padding: EdgeInsets.only(left: 40)),
                SizedBox(
                  width: 130,
                  height: 30,
                  child: TextField(
                    controller: controller,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: hintText,
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
                    showSkills
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
        if (showSkills)
          Container(
            width: 350, // Decreased width
            constraints: const BoxConstraints(
              maxHeight: 110,
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
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
                        ...filteredSkills.map((String skill) {
                          bool isSelected = selectedSkills.contains(skill);
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 2),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.blue : Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: isSelected,
                                  onChanged: (bool? newValue) {
                                    print("Checkbox clicked: $skill");
                                    _onSkillSelected(skill, isRoleSelected);
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
                                          : const Color.fromRGBO(76, 76, 76, 1),
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
      ],
    );
  }
}
