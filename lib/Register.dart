import 'dart:convert';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:hiremi/CongratulationScreen.dart';
import 'package:hiremi/CreateUrPass.dart';
import 'package:hiremi/HomePage.dart';
import 'package:hiremi/api_services/base_services.dart';
import 'package:hiremi/api_services/user_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';
import 'package:hiremi/signin.dart';
import 'package:hiremi/widgets/neo_text.dart';
import 'package:http/http.dart' as http;
import 'package:csc_picker/csc_picker.dart';

class Register extends StatefulWidget {

  @override
  State<Register> createState() => _RegisterState();
}
enum Gender{
  Male,Female,Other;
}

class _RegisterState extends State<Register> {
  String? countryPicker;
  String? statePicker;
  String? cityPicker;
  String genderSelector = "";
  var uuid = Uuid();
  String errorTextVal = '';
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  late String valueChoose;
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final fatherFirstController = TextEditingController();
  final fatherLastController = TextEditingController();
  final genderController = TextEditingController();
  final emailController = TextEditingController();
  final dateOfBirthController=TextEditingController();
  final birthStateController = TextEditingController();
  final birthcityController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final whatsAppNumberController = TextEditingController();
  final collageStateController = TextEditingController();
  final collageNameController = TextEditingController();
  final branchNameController = TextEditingController();
  final DegreeNameController=TextEditingController();
  final passingYearController = TextEditingController();
  final passwordController = TextEditingController();
  final conformPasswordController = TextEditingController();
  final otp = TextEditingController();

  Future<void> storeCSRFToken(String csrfToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('csrfToken', csrfToken);
  }
 // TextEditingController passingYearController = TextEditingController();
  DateTime? selectedDate;

  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: selectedDate ?? DateTime.now(),
  //     firstDate: DateTime(2015),
  //     lastDate: DateTime(2035),
  //   );
  //
  //   if (picked != null && picked != selectedDate) {
  //     setState(() {
  //       selectedDate = picked;
  //       passingYearController.text = picked.year.toString();
  //     });
  //   }
  // }

@override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  List listItem=[
    "Male","Female","Other"
  ];
  List<String> indianStates = [
    'Andaman and Nicobar Islands',
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chandigarh',
    'Chhattisgarh',
    'Dadra and Nagar Haveli and Daman and Diu',
    'Delhi',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jammu and Kashmir',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Ladakh',
    'Lakshadweep',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Puducherry',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal'
  ];
  // List<String> Branch = [
  //   'Andhra Pradesh',
  //   'Arunachal Pradesh',
  //   'Assam',
  //   'Bihar',
  //   'Chhattisgarh',
  //   'Goa',
  //   'Gujarat',
  //   'Haryana',
  //   'Himachal Pradesh',
  //   'Jharkhand',
  //   'Karnataka',
  //   'Kerala',
  //   'Madhya Pradesh',
  //   'Maharashtra',
  //   'Manipur',
  //   'Meghalaya',
  //   'Mizoram',
  //   'Nagaland',
  //   'Odisha',
  //   'Punjab',
  //   'Rajasthan',
  //   'Sikkim',
  //   'Tamil Nadu',
  //   'Telangana',
  //   'Tripura',
  //   'Uttar Pradesh',
  //   'Uttarakhand',
  //   'West Bengal',
  //   'Andaman and Nicobar Islands',
  //   'Chandigarh',
  //   'Dadra and Nagar Haveli and Daman and Diu',
  //   'Lakshadweep',
  //   'Delhi',
  //   'Puducherry',
  // ];
  List<String> Branch = [
    'Aerospace Engineering',
    'Automotive Engineering',
    'Chemical Engineering',
    'Civil Engineering',
    'Computer Science and Engineering',
    'Electrical Engineering',
    'Electronics and Communication Engineering',
    'Finance',
    'Human Resources',
    'Industrial Engineering',
    'Information Technology',
    'Marine Engineering',
    'Marketing',
    'Materials Engineering',
    'Mechanical Engineering',
    'Metallurgical Engineering',
    'Nuclear Engineering',
    'Robotics Engineering',
    'Sales',
    'Other',
  ];
  List<String> Degree = [
    'B.Com',
    'B.Sc',
    'B.Tech',
    'BBA',
    'BCA',
    'Diploma',
    'M.Com',
    'M.Sc',
    'M.Tech',
    'MBA',
    'MCA',
    'Other',
  ];



  Future<void> submitVerification() async{
   //saveFullNameToSharedPreferences(firstnameController.text.toString()+lastnameController.text.toString());

    final url =Uri.parse('${ApiUrls.baseurl}api/registers/');
    try {
      final response = await http.post(
        url,

          body: {
         //  'uid': Uuid().v4().substring(0, 8),
          'full_name':firstnameController.text+' '+lastnameController.text,
          'father_name': lastnameController.text+' '+fatherLastController.text,
            'gender': _gender.toString().split('.').last,
            // "gender": genderSelector.toString(),
      "email": emailController.text,
            'date_of_birth': dateOfBirthController.text,
          'phone_number':phoneNumberController.text,
          'whatsapp_number':whatsAppNumberController.text,
          'college_state': collageStateController.text,
           'college_name':collageNameController.text,
          'branch_name':branchNameController.text,
            "degree_name":DegreeNameController.text,
          'passing_year':passingYearController.text,
          'password':passwordController.text,
            'address': '$countryPicker-$statePicker-$cityPicker',
          },
      );
      if (response.statusCode == 201) {
        Navigator.push(context,MaterialPageRoute(builder: (context)
        {
          return SignIn(isRegistrationSuccessful: true);
        }
        ),);
        print('Data posted successfully');
        print('Response body(PostAPI): ${response.body}');
        print('Status body(PostAPI): ${response.statusCode}');

      }

      else {
        // Handle errors
        print('Failed to post data(PostAPI). Status code: ${response
            .statusCode}, ');
        print('Response body(PostAPI): ${response.body}');
      }
    }
    catch(error)
    {
      print('Error:$error');
    }

  }


  Future<void> checkEmailExistence() async  {
    try {
      final response = await http.get(Uri.parse('${ApiUrls.baseurl}api/registers/'));

      if (response.statusCode == 200) {
        print('Response body: ${response.body}');

        // Parse the JSON data
        final List<dynamic> dataList = json.decode(response.body);

        // Check if the data is a non-empty list
        if (dataList.isNotEmpty) {
          for (final data in dataList) {
            // Check if the data is a Map
            if (data is Map<String, dynamic>) {
              // Print the entire data for inspection
             // print('Entire data: $data');


              // Check for specific keys in the data
              if (data.containsKey('email')) {
                // Extract the username and password from the response data
                final serverUsername = data['email']?.toString() ?? '';


                // Check if the entered username and password match the server data
                if (emailController.text == serverUsername) {
                  // Username and password match, navigate to the home page
                print("Email Already exist");


                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Stack(
                      children: [
                        // Blurred background
                        BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Container(
                            color: Colors.black.withOpacity(0.5), // Adjust the opacity as needed
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                          ),
                        ),
                        // AlertDialog on top of the blurred background
                        AlertDialog(
                          backgroundColor: Colors.white,
                          surfaceTintColor: Colors.transparent,// Set the background color to transparent
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: 30),
                              Center(
                                child: Text(
                                  "Email Already Exist",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: "FontMain",
                                    fontSize: 18,
                                    color: Color(0xFFBD232B),
                                  ),
                                ),
                              ),
                              SizedBox(height: 35),
                              ElevatedButton(
                                onPressed: () {
                                  // Pop the current route (the AlertDialog)
                                  Navigator.of(context).pop();

                                  // Add any additional logic here

                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFF13640),
                                  minimumSize: Size(250, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: const Text(
                                  "OK",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                );

                // Break out of the loop if a match is found (assuming you only want the first match)




                break;
                }
                else {
                  // Username and password do not match, handle accordingly (show error message, etc.)
                  submitVerification();
                print('New Email ID');
                print("Hello");
             // break;

                }
              } else {
                // Handle the case where the server response does not contain expected keys
                print('Server response is missing expected keys.');
              }
            } else {
              // Handle the case where the server response is not a Map
              print('Invalid server response format.');
            }
          }
        }

        else {
          // Handle the case where the server response is an empty list
          print('Server response is an empty list.');
          submitVerification();
        }

      }
      else {
        // If the server did not return a 200 OK response,
        // throw an exception.
        print('Status code: ${response.statusCode}');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error in fetchData: $e');
      // Handle the error (show error message, etc.)
    }
  }

  Future<void> saveFullNameToSharedPreferences(String FullName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('FullName', FullName);
   print(FullName);
  }
  Gender _gender=Gender.Male;
  final UserService _userService = UserService();

  @override
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {


    double screenWidth=MediaQuery.of(context).size.width;
    void selectDatePicker() async {
      DateTime? currentDate = DateTime.now();
      DateTime? initialDate = DateTime(currentDate.year - 20); // Set an initial date (e.g., 20 years ago)

      DateTime? datePicker = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(1900), // Adjust the start year as needed
        lastDate: currentDate,
      );

      if (datePicker != null && datePicker != currentDate) {
        // If a date is selected and it's not the current date
        setState(() {
          dateOfBirthController.text = datePicker.toString().split(" ")[0];
        });
      }
    }
    void _selectYear(BuildContext context) async {
      int currentYear = DateTime.now().year;
      List<int> years = List.generate(37, (index) => currentYear - 24 + index);

      int? selectedYear = await showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text('Select a Year'),
            children: years
                .map(
                  (year) => SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, year);
                },
                child: ListTile(
                  title: Center(child: Text(year.toString())),
                ),
              ),
            )
                .toList(),
          );
        },
      );

      if (selectedYear != null) {
        passingYearController.text = selectedYear.toString();
      }
    }
    // return Scaffold(
    //   body: SingleChildScrollView(
    //
    //     child: Form(
    //       key: _formKey,
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.start,
    //         children: [
    //           SizedBox(height: 30,),
    //           Row(
    //             children: [
    //
    //               InkWell(
    //                   onTap: (){
    //                     Navigator.push(context,MaterialPageRoute(builder: (context)
    //                     {
    //                       return SignIn();
    //                     }
    //                     ),);
    //                   },
    //                   child: Image.asset('images/Back_Button.png')),
    //             ],
    //           ),
    //           SizedBox(height: 10,),
    //           Container(
    //             child: Row(
    //               children: [
    //
    //                 SizedBox(width: 10,),
    //                CustomTextWidget(text: "Register",
    //                color:  Color(0xFFBD232B),
    //                fontSize: 30,
    //                ),
    //
    //               ],
    //             ),
    //           ),
    //           Container(
    //             child: Row(
    //               children: [
    //                 SizedBox(width: 30,),
    //                 CustomTextWidget(text: "Create your new account,\nwe are glad that you joined us.",
    //                   fontSize: screenWidth < 411 ? 11 : 13,
    //                 ),
    //               ],
    //             ),
    //           ),
    //           SizedBox(height: 45,),
    //
    //           Container(
    //
    //             color: Colors.white,
    //             child:  Row(
    //               children: [
    //                 SizedBox(width: 30,),
    //                 Text("Your Name",style: TextStyle(
    //                   color:  Colors.black,
    //                   fontWeight: FontWeight.w700,
    //                   fontSize: screenWidth < 400 ? 23 : 26,
    //                   fontFamily: 'FontMain',
    //                 ),),
    //               ],),
    //           ),
    //           Container(
    //             color: Colors.white,
    //
    //             child:  Row(
    //               children: [
    //                 Flexible(
    //                   child: Padding(
    //                     padding: EdgeInsets.all(30.0),
    //
    //                     child: TextFormField(
    //                       controller:firstnameController ,
    //                       validator: (value) {
    //                         if (value!.isEmpty) {
    //                           return 'Please enter name';
    //                         }
    //                         return null; // Return null if the input is valid
    //                       },
    //                       decoration: InputDecoration(labelText: 'First Name',
    //                           labelStyle: TextStyle( color:Color(0xFFCACACA))),
    //                     ),
    //                   ),
    //
    //
    //                 ),
    //
    //                 Flexible(
    //                   child: Padding(
    //                     padding: EdgeInsets.all(30.0),
    //                     child: TextFormField(
    //                       controller:lastnameController ,
    //                       validator: (value) {
    //                         if (value!.isEmpty) {
    //                           return 'Please enter name';
    //                         }
    //                         return null; // Return null if the input is valid
    //                       },
    //                       decoration: InputDecoration(labelText: 'Last Name',
    //                       labelStyle: TextStyle( color:Color(0xFFCACACA))),
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //           SizedBox(height: 30,),
    //           Container(
    //
    //             color: Colors.white,
    //             child:  Row(
    //               children: [
    //                 SizedBox(width: 30,),
    //                 Text("Father's Name",style: TextStyle(
    //                   color: Colors.black,
    //                   fontWeight: FontWeight.w700,
    //                   fontSize: screenWidth < 400 ? 23 : 26,
    //                   fontFamily: 'FontMain',
    //                 ),),
    //               ],),
    //           ),
    //           Container(
    //             color: Colors.white,
    //
    //             child: Row(
    //               children: [
    //                 Flexible(
    //                   child: Padding(
    //                     padding: EdgeInsets.all(30.0),
    //                     child: TextFormField(
    //                       controller:fatherFirstController ,
    //                       validator: (value) {
    //                         if (value!.isEmpty) {
    //                           return 'Please enter Fathers name';
    //                         }
    //                         return null; // Return null if the input is valid
    //                       },
    //                       decoration: InputDecoration(labelText: 'First Name',
    //                       labelStyle: TextStyle( color:Color(0xFFCACACA))),
    //                     ),
    //                   ),
    //                 ),
    //
    //                 Flexible(
    //                   child: Padding(
    //                     padding: EdgeInsets.all(30.0),
    //                     child: TextFormField(
    //                       controller: fatherLastController,
    //                       validator: (value) {
    //                         if (value!.isEmpty) {
    //                           return 'Please enter name';
    //                         }
    //                         return null; // Return null if the input is valid
    //                       },
    //                       decoration: InputDecoration(labelText: 'Last Name',
    //                       labelStyle: TextStyle( color:Color(0xFFCACACA))),
    //                     ),
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //           Container(
    //
    //             color: Colors.white,
    //             child:  Row(
    //               children: [
    //                 SizedBox(width: 30,),
    //                 Text("Gender",style: TextStyle(
    //                   color: Colors.black,
    //                   fontWeight: FontWeight.w700,
    //                   fontSize: screenWidth < 400 ? 23 : 26,
    //                   fontFamily: 'FontMain',
    //                 ),),
    //               ],),
    //           ),
    //
    //           Row(
    //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //             children: [
    //               Text("Male",
    //               style: TextStyle(
    //                 fontWeight: FontWeight.w500,
    //                 fontSize: screenWidth < 400 ? 13 : 16,
    //                 fontFamily: 'Poppins.bold',
    //                color: Color(0xFFCACACA),
    //               ),),
    //             Radio(
    //
    //                 value: Gender.Male, groupValue: _gender, onChanged: (gender){
    //               setState(() {
    //                 _gender = gender!;
    //               });
    //             }),
    //               Text("Female",
    //               style: TextStyle(
    //                 fontWeight: FontWeight.w500,
    //                 fontSize: screenWidth < 400 ? 14 : 16,
    //                 fontFamily: 'Poppins.bold',
    //                 color: Color(0xFFCACACA),
    //               ),),
    //               Radio(
    //
    //                   value: Gender.Female, groupValue: _gender, onChanged: (gender){
    //                 setState(() {
    //                   _gender = gender!;
    //                 });
    //               }),
    //
    //             ],
    //           ),
    //
    //
    //          SizedBox(height: 25,),
    //           Container(
    //
    //             color: Colors.white,
    //             child:  Row(
    //               children: [
    //                 SizedBox(width: 30,),
    //                 Text("Enter your Email",style: TextStyle(
    //                   color: Colors.black,
    //                   fontWeight: FontWeight.w700,
    //                   fontSize: screenWidth < 400 ? 24 : 26,
    //                   fontFamily: 'FontMain',
    //                 ),),
    //               ],),
    //           ),
    //           Container(
    //             color: Colors.white,
    //
    //             child:  Row(
    //               children: [
    //                 Flexible(
    //                   child: Padding(
    //                     padding: EdgeInsets.all(20.0),
    //                     child: TextFormField(
    //                       controller:emailController ,
    //                       onChanged: (value) {
    //                         setState(() {
    //                           if (value.contains(' ')) {
    //                             errorTextVal = "Don't use blank spaces";
    //                           } else if (!value.contains('@gmail.com')) {
    //                             errorTextVal = "use @gmail.com in the email";
    //                           } else {
    //                             errorTextVal = '';
    //                           }
    //                         });
    //                       },
    //                       validator: (value) {
    //                         if (value!.isEmpty) {
    //                           return 'Please enter an email';
    //                         }
    //                         // Define a regular expression for email validation.
    //                         final emailRegex =
    //                         RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    //                         if (!emailRegex.hasMatch(value)) {
    //                           return 'Please enter a valid email';
    //                         }
    //                         return null;
    //                       },
    //                       textInputAction: TextInputAction.done,
    //                       decoration: InputDecoration(
    //                         errorText: errorTextVal.isEmpty ? null : errorTextVal,
    //                         enabledBorder: const UnderlineInputBorder(
    //                           borderSide: BorderSide(
    //                             color: Color(0xFFCACACA),
    //                           ),
    //                         ),
    //                         focusedBorder: const UnderlineInputBorder(
    //                           borderSide: BorderSide(
    //                             color: Color(0xFFCACACA),
    //                           ),
    //                         ),
    //                         hintText: 'email@gmail.com',
    //                         hintStyle: const TextStyle(
    //                           color:Color(0xFF9B9B9B),
    //                           fontSize: 14.5,
    //                           fontWeight: FontWeight.w500,
    //                         ),
    //                       ),
    //                     ),
    //                   ),
    //                 ),
    //
    //
    //
    //               ],
    //             ),
    //           ),
    //           SizedBox(height: 25,),
    //           Container(
    //
    //             color: Colors.white,
    //             child:  Row(
    //               children: [
    //                 SizedBox(width: 30,),
    //                 Text("Date of Birth",style: TextStyle(
    //                   color: Colors.black,
    //                   fontWeight: FontWeight.w700,
    //                   fontSize: screenWidth < 400 ? 24 : 26,
    //                   fontFamily: 'FontMain',
    //                 ),),
    //               ],),
    //           ),
    //          SizedBox(height: 10,),
    //
    //           Padding(
    //             padding: EdgeInsets.all(20.0),
    //             child: TextFormField(
    //               readOnly: true,
    //               cursorColor: Color(0xFF9B9B9B),
    //               controller: dateOfBirthController,
    //               focusNode: FocusNode(),
    //               validator: (value) {
    //                 if (value!.isEmpty) {
    //                   return 'Please enter Date of Birth';
    //                 }
    //                 return null; // Return null if the input is valid
    //               },
    //               onTap: () {
    //                 selectDatePicker();
    //               },
    //               decoration: InputDecoration(
    //                 enabledBorder: const UnderlineInputBorder(
    //                   borderSide: BorderSide(
    //                     color: Color(0xFFCACACA),
    //                   ),
    //                 ),
    //                 focusedBorder: const UnderlineInputBorder(
    //                   borderSide: BorderSide(
    //                     color: Color(0xFF9B9B9B),
    //                   ),
    //                 ),
    //                 suffixIcon: IconButton(
    //                   onPressed: () {
    //                     selectDatePicker();
    //                   },
    //                   icon: const Icon(
    //                   //  Icons.expand_more,
    //                     Icons.arrow_drop_down,
    //                   ),
    //                 ),
    //                 suffixIconColor: Color(0xFF9B9B9B),
    //                 prefixIcon: IconButton(
    //                   onPressed: () {
    //                     selectDatePicker();
    //                   },
    //                   icon: const Icon(
    //                     Icons.calendar_month_outlined,
    //                   ),
    //                 ),
    //                 prefixIconColor: Color(0xFF9B9B9B),
    //               ),
    //             ),
    //           ),
    //
    //           SizedBox(height: 10,),
    //           Container(
    //
    //             color: Colors.white,
    //             child:  Row(
    //               children: [
    //                 SizedBox(width: 30,),
    //                 Text("Birth Place",style: TextStyle(
    //                   color: Colors.black,
    //                   fontWeight: FontWeight.w700,
    //                   fontSize: screenWidth < 400 ? 24 : 26,
    //                   fontFamily: 'FontMain',
    //                 ),),
    //               ],),
    //           ),
    //
    //
    //            Padding(
    //             padding: EdgeInsets.all(20.0),
    //             child: TextFormField(
    //               controller: birthStateController,
    //               readOnly: true,
    //               onTap: () {
    //                 // Display a dialog with a list of states for selection
    //                 showDialog(
    //                   context: context,
    //                   builder: (BuildContext context) {
    //                     return AlertDialog(
    //                       title: Text('Select Your Home State'),
    //                       content: SingleChildScrollView(
    //                         child: Column(
    //                           children: indianStates.map((state) {
    //                             return ListTile(
    //                               title: Text(state),
    //                               onTap: () {
    //                                 setState(() {
    //                                   birthStateController.text = state;
    //                                 });
    //                                 Navigator.pop(context); // Close the dialog
    //                               },
    //                             );
    //                           }).toList(),
    //                         ),
    //                       ),
    //                     );
    //                   },
    //                 );
    //               },
    //               decoration: InputDecoration(
    //                 labelText: 'Select Your Home State',
    //                 labelStyle: TextStyle(color: Color(0xFFCACACA)),
    //                 suffixIcon: Icon(Icons.arrow_drop_down),
    //               ),
    //               validator: (value) {
    //                 if (value == null || value.isEmpty) {
    //                   return 'Please select a state';
    //                 }
    //                 return null;
    //               },
    //             ),
    //           ),
    //           SizedBox(height: 15,),
    //          Container(
    //            child: Column(
    //              children: [ Container( color: Colors.white,
    //                child:  Row(
    //                  children: [
    //                    SizedBox(width: 30,),
    //                    Text("Contact Number",style: TextStyle(
    //                      color: Colors.black,
    //                      fontWeight: FontWeight.w700,
    //                      fontSize: screenWidth < 400 ? 24 : 26,
    //                      fontFamily: 'FontMain',
    //                    ),),
    //                  ],),),
    //                Row(
    //                  children: [
    //                    Flexible(
    //                      child: Padding(
    //                        padding: EdgeInsets.all(20.0),
    //                        child: TextFormField(
    //                          controller: phoneNumberController,
    //                          maxLength: 10,
    //                          onChanged: (value) {
    //                            // Remove any non-digit characters from the input value
    //                            phoneNumberController.text = value.replaceAll(RegExp(r'[^0-9]'), ''); // This regex will remove any non-digit characters
    //                          },
    //                          validator: (value) {
    //                            // Get the trimmed value without non-digit characters
    //                            String trimmedValue = value!.replaceAll(RegExp(r'[^0-9]'), '');
    //
    //                            if (trimmedValue.isEmpty) {
    //                              return 'Please enter a phone number';
    //                            } else if (trimmedValue.length < 10) {
    //                              return 'Number should contain 10 digits';
    //                            }
    //                            return null; // Return null if the input is valid
    //                          },
    //                          keyboardType: TextInputType.number,
    //                          inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Restrict input to only digits
    //                          decoration: InputDecoration(
    //                            labelText: 'Phone Number',
    //                            labelStyle: TextStyle(color: Color(0xFFCACACA)),
    //                          ),
    //                        ),
    //
    //
    //                      ),
    //                    ),
    //                  ],
    //                ),
    //                Row(
    //                  children: [
    //                    Flexible(
    //                      child: Padding(
    //                        padding: EdgeInsets.all(20.0),
    //                        child: TextFormField(
    //                          controller: whatsAppNumberController,
    //                          maxLength: 10,
    //                          keyboardType: TextInputType.number,
    //                          onChanged: (value) {
    //                            // Remove any non-digit characters from the input value
    //                            whatsAppNumberController.text = value.replaceAll(RegExp(r'[^0-9]'), ''); // This regex will remove any non-digit characters
    //                          },
    //                          validator: (value) {
    //                            // Get the trimmed value without non-digit characters
    //                            String trimmedValue = value!.replaceAll(RegExp(r'[^0-9]'), '');
    //
    //                            if (trimmedValue.isEmpty) {
    //                              return 'Please enter a WhatsApp number';
    //                            } else if (trimmedValue.length < 10) {
    //                              return 'Number should contain 10 digits';
    //                            }
    //
    //                            return null; // Return null if the input is valid
    //                          },
    //                          decoration: InputDecoration(
    //                            labelText: 'WhatsApp Number',
    //                            labelStyle: TextStyle(color: Color(0xFFCACACA)),
    //                          ),
    //                        ),
    //
    //                      ),
    //                    ),
    //                  ],
    //                ),],
    //            ),
    //          ),
    //          SizedBox(height: 15,),
    //          Container( color: Colors.white,
    //            child:  Row(
    //              children: [
    //                SizedBox(width: 20,),
    //                Text("College",style: TextStyle(
    //                  color: Colors.black,
    //                  fontWeight: FontWeight.w700,
    //                  fontSize: screenWidth < 400 ? 23.5 : 26,
    //                  fontFamily: 'FontMain',
    //                ),),
    //              ],),),
    //
    //           Row(
    //             children: [
    //               Flexible(
    //
    //                 child: Padding(
    //                   padding: EdgeInsets.all(20.0),
    //                   child: TextFormField(
    //                     controller: collageStateController,
    //                     readOnly: true,
    //                     onTap: () {
    //                       showDialog(
    //                         context: context,
    //                         builder: (BuildContext context) {
    //                           return AlertDialog(
    //                             title: Text('Select Your College State'),
    //                             content: SingleChildScrollView(
    //                               child: Column(
    //                                 children: indianStates.map((state) {
    //                                   return ListTile(
    //                                     title: Text(state),
    //                                     onTap: () {
    //                                       setState(() {
    //                                         collageStateController.text = state;
    //                                       });
    //                                       Navigator.pop(context); // Close the dialog
    //                                     },
    //                                   );
    //                                 }).toList(),
    //                               ),
    //                             ),
    //                           );
    //                         },
    //                       );
    //                     },
    //                     decoration: InputDecoration(
    //                       labelText: 'Select Your College State',
    //                       labelStyle: TextStyle(color: Color(0xFFCACACA)),
    //                       suffixIcon: Icon(Icons.arrow_drop_down),
    //                     ),
    //                     validator: (value) {
    //                       if (value == null || value.isEmpty) {
    //                         return 'Please select a state';
    //                       }
    //                       return null;
    //                     },
    //                   ),
    //                 ),
    //
    //
    //
    //               ),
    //             ],
    //           ),
    //           Row(
    //             children: [
    //               Flexible(
    //                 child: Padding(
    //                   padding: EdgeInsets.all(20.0),
    //                   child: TextFormField(
    //                     controller: collageNameController,
    //                     validator: (value) {
    //                       if (value!.isEmpty) {
    //                         return 'Please enter CollageName';
    //                       }
    //                       return null; // Return null if the input is valid
    //                     },
    //                     decoration: InputDecoration(labelText: 'College Name',
    //                         labelStyle: TextStyle( color:Color(0xFFCACACA)
    //
    //                         ),
    //
    //                     ),
    //
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //           Row(
    //             children: [
    //               Flexible(
    //                 child: Padding(
    //                   padding: EdgeInsets.all(20.0),
    //                   child: TextFormField(
    //                     controller: branchNameController,
    //                     readOnly: true,
    //                     onTap: () {
    //                       // Display a dialog with a list of states for selection
    //                       showDialog(
    //                         context: context,
    //                         builder: (BuildContext context) {
    //                           return AlertDialog(
    //                             title: Text('Select Your Branch'),
    //                             content: SingleChildScrollView(
    //                               child: Column(
    //                                 children: Branch.map((Branch) {
    //                                   return ListTile(
    //                                     title: Text(Branch),
    //                                     onTap: () {
    //                                       setState(() {
    //                                         branchNameController.text = Branch;
    //                                       });
    //                                       Navigator.pop(context); // Close the dialog
    //                                     },
    //                                   );
    //                                 }).toList(),
    //                               ),
    //                             ),
    //                           );
    //                         },
    //                       );
    //                     },
    //                     decoration: InputDecoration(
    //                       labelText: 'Select Your Branch',
    //                       labelStyle: TextStyle(color: Color(0xFFCACACA)),
    //                       suffixIcon: Icon(Icons.arrow_drop_down),
    //                     ),
    //                     validator: (value) {
    //                       if (value == null || value.isEmpty) {
    //                         return 'Please select a state';
    //                       }
    //                       return null;
    //                     },
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //           Row(
    //             children: [
    //               Flexible(
    //                 child: Padding(
    //                   padding: EdgeInsets.all(20.0),
    //                   child: TextFormField(
    //                     controller: DegreeNameController,
    //                     readOnly: true,
    //                     onTap: () {
    //                       // Display a dialog with a list of states for selection
    //                       showDialog(
    //                         context: context,
    //                         builder: (BuildContext context) {
    //                           return AlertDialog(
    //                             title: Text('Degree Name'),
    //                             content: SingleChildScrollView(
    //                               child: Column(
    //                                 children: Degree.map((Degree) {
    //                                   return ListTile(
    //                                     title: Text(Degree),
    //                                     onTap: () {
    //                                       setState(() {
    //                                         DegreeNameController.text = Degree;
    //                                       });
    //                                       Navigator.pop(context); // Close the dialog
    //                                     },
    //                                   );
    //                                 }).toList(),
    //                               ),
    //                             ),
    //                           );
    //                         },
    //                       );
    //                     },
    //                     decoration: InputDecoration(
    //                       labelText: 'Degree Name',
    //                       labelStyle: TextStyle(color: Color(0xFFCACACA)),
    //                       suffixIcon: Icon(Icons.arrow_drop_down),
    //                     ),
    //                     validator: (value) {
    //                       if (value == null || value.isEmpty) {
    //                         return 'Please select a Degree Name';
    //                       }
    //                       return null;
    //                     },
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //           Row(
    //             children: [
    //               Flexible(
    //                 // child: Padding(
    //                 //   padding: EdgeInsets.all(20.0),
    //                 //   child: TextFormField(
    //                 //     controller:passingYearController,
    //                 //     validator: (value) {
    //                 //       if (value!.isEmpty) {
    //                 //         return 'Please enter Passing year';
    //                 //       }
    //                 //       return null; // Return null if the input is valid
    //                 //     },
    //                 //     keyboardType: TextInputType.number,
    //                 //     decoration: InputDecoration(labelText: 'Passing Year',
    //                 //         labelStyle: TextStyle( color:Color(0xFFCACACA))),
    //                 //   ),
    //                 // ),
    //
    //           child: Padding(
    //            padding: EdgeInsets.all(20.0),
    //           child: TextFormField(
    //         controller: passingYearController,
    //         readOnly: true,
    //         onTap: () => _selectYear(context),
    //         validator: (value) {
    //           if (value!.isEmpty) {
    //             return 'Please select a year';
    //           }
    //           return null;
    //         },
    //         keyboardType: TextInputType.number,
    //         decoration: InputDecoration(
    //           labelText: 'Year',
    //           labelStyle: TextStyle(color: Color(0xFFCACACA)),
    //           suffixIcon: Icon(Icons.arrow_drop_down),
    //         ),
    //       ),
    //     )
    //               ),
    //             ],
    //           ),
    //           SizedBox(height: 15,),
    //           Container(
    //
    //             color: Colors.white,
    //             child:  Row(
    //               children: [
    //                 SizedBox(width: 30,),
    //                 Text("Create Your Password",style: TextStyle(
    //                   color: Colors.black,
    //                   fontWeight: FontWeight.w700,
    //                   fontSize: screenWidth < 400 ? 23.5 : 26,
    //                   fontFamily: 'FontMain',
    //                 ),),
    //               ],),
    //           ),
    //           SizedBox(height: 15,),
    //
    //           Padding(
    //             padding: const EdgeInsets.only(left: 37, right: 58),
    //
    //             child:TextFormField(
    //               controller: passwordController,
    //               obscureText: !isPasswordVisible,
    //             validator: (value) {
    //                  if (value!.isEmpty) {
    //                         return 'Please enter password';
    //                     }
    //                      return null; // Return null if the input is valid
    //                    },
    //               decoration: InputDecoration(
    //                 enabledBorder: UnderlineInputBorder(
    //                   borderSide: BorderSide(color: Color(0xFFCACACA)),
    //                 ),
    //                 focusedBorder: UnderlineInputBorder(
    //                   borderSide: BorderSide(color: Color(0xFFCACACA)),
    //                 ),
    //                 prefixIcon: Padding(
    //                   padding: EdgeInsets.only(right: 20),
    //                   child: Icon(
    //                     Icons.lock,
    //                     color: Color(0xFF9B9B9B),
    //                     size: 22,
    //                   ),
    //                 ),
    //                 suffixIcon: IconButton(
    //                   onPressed: () {
    //                     setState(() {
    //                       isPasswordVisible = !isPasswordVisible;
    //                     });
    //                   },
    //                   icon: Icon(
    //                     isPasswordVisible ? Icons.visibility : Icons.visibility_off,
    //                     color: Color(0xFF9B9B9B),
    //                   ),
    //                 ),
    //                 hintText: 'Password',
    //                 hintStyle: TextStyle(
    //                   color: Color(0xFF9B9B9B),
    //                   fontSize: screenWidth < 400 ? 13 : 15,
    //                   fontWeight: FontWeight.w500,
    //                 ),
    //               ),
    //             ),
    //           ),
    //          const SizedBox(height: 30),
    //           Padding(
    //             padding: const EdgeInsets.only(left: 37, right: 58),
    //             child:TextFormField(
    //               controller: conformPasswordController,
    //               obscureText: !isConfirmPasswordVisible,
    //               validator: (value) {
    //                 if (value!.isEmpty) {
    //                   return 'Please enter Conform password';
    //                 }
    //                 return null; // Return null if the input is valid
    //               },
    //               decoration: InputDecoration(
    //                 enabledBorder: UnderlineInputBorder(
    //                   borderSide: BorderSide(color: Color(0xFFCACACA)),
    //                 ),
    //                 focusedBorder: UnderlineInputBorder(
    //                   borderSide: BorderSide(color: Color(0xFFCACACA)),
    //                 ),
    //                 prefixIcon: Padding(
    //                   padding: EdgeInsets.only(right: 20),
    //                   child: Icon(
    //                     Icons.lock,
    //                     color: Color(0xFF9B9B9B),
    //                     size: 22,
    //                   ),
    //                 ),
    //                 suffixIcon: IconButton(
    //                   onPressed: () {
    //                     setState(() {
    //                       isConfirmPasswordVisible = !isConfirmPasswordVisible;
    //                     });
    //                   },
    //                   icon: Icon(
    //                     isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
    //                     color: Color(0xFF9B9B9B),
    //                   ),
    //                 ),
    //                 hintText: 'Confirm Password',
    //                 hintStyle: TextStyle(
    //                   color: Color(0xFF9B9B9B),
    //                   fontSize: 15,
    //                   fontWeight: FontWeight.w500,
    //                 ),
    //               ),
    //             ),
    //           ),
    //           SizedBox(height: 35,),
    //           ElevatedButton(onPressed: ()    {
    //
    //           //validateEmail(emailController.text);
    //             if (_formKey.currentState?.validate() == true) {
    //
    //              print("All feilds are filled");
    //                if(passwordController.text != conformPasswordController.text){
    //
    //                  showDialog(
    //                    context: context,
    //                    builder: (BuildContext context) {
    //                      return Stack(
    //                        children: [
    //                          // Blurred background
    //                          BackdropFilter(
    //                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
    //                            child: Container(
    //                              color: Colors.black.withOpacity(0.5), // Adjust the opacity as needed
    //                              width: MediaQuery.of(context).size.width,
    //                              height: MediaQuery.of(context).size.height,
    //                            ),
    //                          ),
    //                          // AlertDialog on top of the blurred background
    //                          AlertDialog(
    //                            backgroundColor: Colors.white,
    //                            surfaceTintColor: Colors.transparent,// Set the background color to transparent
    //                            content: Column(
    //                              mainAxisSize: MainAxisSize.min,
    //                              children: [
    //                                SizedBox(height: 30),
    //                                Center(
    //                                  child: Text(
    //                                    "Password Mismatch",
    //                                    textAlign: TextAlign.center,
    //                                    style: TextStyle(
    //                                      fontFamily: "FontMain",
    //                                      fontSize: 18,
    //                                      color: Color(0xFFBD232B),
    //                                    ),
    //                                  ),
    //                                ),
    //                                SizedBox(height: 35),
    //                                ElevatedButton(
    //                                  onPressed: () {
    //                                    // Pop the current route (the AlertDialog)
    //                                    Navigator.of(context).pop();
    //
    //                                    // Add any additional logic here
    //
    //                                  },
    //                                  style: ElevatedButton.styleFrom(
    //                                    backgroundColor: const Color(0xFFF13640),
    //                                    minimumSize: Size(250, 50),
    //                                    shape: RoundedRectangleBorder(
    //                                      borderRadius: BorderRadius.circular(30),
    //                                    ),
    //                                  ),
    //                                  child: const Text(
    //                                    "OK",
    //                                    style: TextStyle(
    //                                      color: Colors.white,
    //                                      fontWeight: FontWeight.w700,
    //                                      fontSize: 20,
    //                                    ),
    //                                  ),
    //                                ),
    //                              ],
    //                            ),
    //                          ),
    //                        ],
    //                      );
    //                    },
    //                  );
    //               }
    //
    //              else{
    //                checkEmailExistence();
    //              }
    //
    //             }
    //
    //             else {
    //               // Form is not valid, show error message
    //               ScaffoldMessenger.of(context).showSnackBar(
    //                 SnackBar(
    //                   content: Text('Please fix the errors in the form.'),
    //                 ),
    //               );
    //             }
    //
    //
    //            //submitVerification();
    //           },style: ElevatedButton.styleFrom(
    //                 backgroundColor:const Color(0xFFF13640),
    //                 shape:RoundedRectangleBorder(
    //                   borderRadius:BorderRadius.circular(20)
    //                 ),
    //           ), child: Text("Submit",style: TextStyle(
    //             color:Colors.white,
    //             fontWeight:FontWeight.w700,
    //              fontSize:25,
    //           ),)),
    //           SizedBox(height: 35,),
    //
    //
    //         ],
    //       ),
    //     ),
    //   ),
    // );
    return Scaffold(
      body: SingleChildScrollView(

        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 30,),
              Row(
                children: [

                  InkWell(
                      onTap: (){
                        Navigator.push(context,MaterialPageRoute(builder: (context)
                        {
                          return SignIn();
                        }
                        ),);
                      },
                      child: Image.asset('images/Back_Button.png')),
                ],
              ),
              SizedBox(height: 10,),
              Container(
                child: Row(
                  children: [

                    SizedBox(width: 10,),
                    CustomTextWidget(text: "Register",
                      color:  Color(0xFFBD232B),
                      fontSize: 30,
                    ),

                  ],
                ),
              ),
              Container(
                child: Row(
                  children: [
                    SizedBox(width: 30,),
                    CustomTextWidget(text: "Create your new account,\nwe are glad that you joined us.",
                      fontSize: screenWidth < 411 ? 11 : 13,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 45,),

              Container(

                color: Colors.white,
                child:  Row(
                  children: [
                    SizedBox(width: 30,),
                    Text("Your Name",style: TextStyle(
                      color:  Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: screenWidth < 400 ? 23 : 26,
                      fontFamily: 'FontMain',
                    ),),
                  ],),
              ),
              Container(
                color: Colors.white,

                child:  Row(
                  children: [
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.all(30.0),

                        child: TextFormField(
                          controller:firstnameController ,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter name';
                            }
                            return null; // Return null if the input is valid
                          },
                          decoration: InputDecoration(labelText: 'First Name',
                              labelStyle: TextStyle( color:Color(0xFFCACACA))),
                        ),
                      ),


                    ),

                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.all(30.0),
                        child: TextFormField(
                          controller:lastnameController ,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter name';
                            }
                            return null; // Return null if the input is valid
                          },
                          decoration: InputDecoration(labelText: 'Last Name',
                              labelStyle: TextStyle( color:Color(0xFFCACACA))),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30,),
              Container(

                color: Colors.white,
                child:  Row(
                  children: [
                    SizedBox(width: 30,),
                    Text("Father's Name",style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: screenWidth < 400 ? 23 : 26,
                      fontFamily: 'FontMain',
                    ),),
                  ],),
              ),
              Container(
                color: Colors.white,

                child: Row(
                  children: [
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.all(30.0),
                        child: TextFormField(
                          controller:fatherFirstController ,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter Fathers name';
                            }
                            return null; // Return null if the input is valid
                          },
                          decoration: InputDecoration(labelText: 'First Name',
                              labelStyle: TextStyle( color:Color(0xFFCACACA))),
                        ),
                      ),
                    ),

                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.all(30.0),
                        child: TextFormField(
                          controller: fatherLastController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter name';
                            }
                            return null; // Return null if the input is valid
                          },
                          decoration: InputDecoration(labelText: 'Last Name',
                              labelStyle: TextStyle( color:Color(0xFFCACACA))),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(

                color: Colors.white,
                child:  Row(
                  children: [
                    SizedBox(width: 30,),
                    Text("Gender",style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: screenWidth < 400 ? 23 : 26,
                      fontFamily: 'FontMain',
                    ),),
                  ],),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                 Row(
                   children: [
                     Radio(

                         value: Gender.Male, groupValue: _gender, onChanged: (gender){
                       setState(() {
                         _gender = gender!;
                       });
                     }),
                     Text("Male",
                       style: TextStyle(
                         fontWeight: FontWeight.w500,
                         fontSize: screenWidth < 400 ? 18 : 16,
                         fontFamily: 'Poppins.bold',
                         color: Color(0xFFCACACA),
                       ),),
                   ],
                 ),
                  // Radio(
                  //
                  //     value: Gender.Male, groupValue: _gender, onChanged: (gender){
                  //   setState(() {
                  //     _gender = gender!;
                  //   });
                  // }),
                Row(
                  children: [
                    Radio(

                        value: Gender.Female, groupValue: _gender, onChanged: (gender){
                      setState(() {
                        _gender = gender!;
                      });
                    }),
                    Text("Female",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: screenWidth < 400 ? 18 : 16,
                        fontFamily: 'Poppins.bold',
                        color: Color(0xFFCACACA),
                      ),),
                  ],
                )
                  //Radio(
                  //
                  //     value: Gender.Female, groupValue: _gender, onChanged: (gender){
                  //   setState(() {
                  //     _gender = gender!;
                  //   });
                  // }),

                ],
              ),


              SizedBox(height: 25,),
              Container(

                color: Colors.white,
                child:  Row(
                  children: [
                    SizedBox(width: 30,),
                    Text("Enter your Email",style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: screenWidth < 400 ? 24 : 26,
                      fontFamily: 'FontMain',
                    ),),
                  ],),
              ),
              Container(
                color: Colors.white,

                child:  Row(
                  children: [
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: TextFormField(
                          controller:emailController ,
                          onChanged: (value) {
                            setState(() {
                              if (value.contains(' ')) {
                                errorTextVal = "Don't use blank spaces";
                              } else if (!value.contains('@gmail.com')) {
                                errorTextVal = "use @gmail.com in the email";
                              } else {
                                errorTextVal = '';
                              }
                            });
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter an email';
                            }
                            // Define a regular expression for email validation.
                            final emailRegex =
                            RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
                            if (!emailRegex.hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.done,
                          decoration: InputDecoration(
                            errorText: errorTextVal.isEmpty ? null : errorTextVal,
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFFCACACA),
                              ),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFFCACACA),
                              ),
                            ),
                            hintText: 'email@gmail.com',
                            hintStyle: const TextStyle(
                              color:Color(0xFF9B9B9B),
                              fontSize: 14.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),



                  ],
                ),
              ),
              SizedBox(height: 25,),
              Container(

                color: Colors.white,
                child:  Row(
                  children: [
                    SizedBox(width: 30,),
                    Text("Date of Birth",style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: screenWidth < 400 ? 24 : 26,
                      fontFamily: 'FontMain',
                    ),),
                  ],),
              ),
              SizedBox(height: 10,),

              Padding(
                padding: EdgeInsets.all(20.0),
                child: TextFormField(
                  readOnly: true,
                  cursorColor: Color(0xFF9B9B9B),
                  controller: dateOfBirthController,
                  focusNode: FocusNode(),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter Date of Birth';
                    }
                    return null; // Return null if the input is valid
                  },
                  onTap: () {
                    selectDatePicker();
                  },
                  decoration: InputDecoration(
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFCACACA),
                      ),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFF9B9B9B),
                      ),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        selectDatePicker();
                      },
                      icon: const Icon(
                        //  Icons.expand_more,
                        Icons.arrow_drop_down,
                      ),
                    ),
                    suffixIconColor: Color(0xFF9B9B9B),
                    prefixIcon: IconButton(
                      onPressed: () {
                        selectDatePicker();
                      },
                      icon: const Icon(
                        Icons.calendar_month_outlined,
                      ),
                    ),
                    prefixIconColor: Color(0xFF9B9B9B),
                  ),
                ),
              ),

              SizedBox(height: 10,),
              Container(

                color: Colors.white,
                child:  Row(
                  children: [
                    SizedBox(width: 30,),
                    Text("Birth Place",style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: screenWidth < 400 ? 24 : 26,
                      fontFamily: 'FontMain',
                    ),),
                  ],),
              ),


              Padding(
                padding: EdgeInsets.all(20.0),
                child: TextFormField(
                  controller: birthStateController,
                  readOnly: true,
                  onTap: () {
                    // Display a dialog with a list of states for selection
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Select Your Home State'),
                          content: SingleChildScrollView(
                            child: Column(
                              children: indianStates.map((state) {
                                return ListTile(
                                  title: Text(state),
                                  onTap: () {
                                    setState(() {
                                      birthStateController.text = state;
                                    });
                                    Navigator.pop(context); // Close the dialog
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  decoration: InputDecoration(
                    labelText: 'Select Your Home State',
                    labelStyle: TextStyle(color: Color(0xFFCACACA)),
                    suffixIcon: Icon(Icons.arrow_drop_down),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a state';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(height: 15,),
              Container(
                child: Column(
                  children: [ Container( color: Colors.white,
                    child:  Row(
                      children: [
                        SizedBox(width: 30,),
                        Text("Contact Number",style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: screenWidth < 400 ? 24 : 26,
                          fontFamily: 'FontMain',
                        ),),
                      ],),),
                    Row(
                      children: [
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: TextFormField(
                              controller:phoneNumberController ,
                              maxLength: 10,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter phone number';
                                }
                                else if(value.length<10)
                                {
                                  return 'Number should contain 10 digit';
                                }
                                return null; // Return null if the input is valid
                              },
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(labelText: 'Phone Number',
                                  labelStyle: TextStyle( color:Color(0xFFCACACA))),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.all(20.0),
                            child: TextFormField(
                              controller: whatsAppNumberController,
                              maxLength: 10,
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter Whatsapp number';
                                }
                                else if(value.length<10)
                                {
                                  return 'Number should contain 10 digit';
                                }

                                return null; // Return null if the input is valid
                              },
                              decoration: InputDecoration(labelText: 'Whatsapp Number',
                                  labelStyle: TextStyle( color:Color(0xFFCACACA))),
                            ),
                          ),
                        ),
                      ],
                    ),],
                ),
              ),
              SizedBox(height: 15,),
              Container( color: Colors.white,
                child:  Row(
                  children: [
                    SizedBox(width: 20,),
                    Text("College",style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: screenWidth < 400 ? 23.5 : 26,
                      fontFamily: 'FontMain',
                    ),),
                  ],),),

              Row(
                children: [
                  Flexible(

                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: TextFormField(
                        controller: collageStateController,
                        readOnly: true,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Select Your College State'),
                                content: SingleChildScrollView(
                                  child: Column(
                                    children: indianStates.map((state) {
                                      return ListTile(
                                        title: Text(state),
                                        onTap: () {
                                          setState(() {
                                            collageStateController.text = state;
                                          });
                                          Navigator.pop(context); // Close the dialog
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        decoration: InputDecoration(
                          labelText: 'Select Your College State',
                          labelStyle: TextStyle(color: Color(0xFFCACACA)),
                          suffixIcon: Icon(Icons.arrow_drop_down),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a state';
                          }
                          return null;
                        },
                      ),
                    ),



                  ),
                ],
              ),
              Row(
                children: [
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: TextFormField(
                        controller: collageNameController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter CollageName';
                          }
                          return null; // Return null if the input is valid
                        },
                        decoration: InputDecoration(labelText: 'College Name',
                          labelStyle: TextStyle( color:Color(0xFFCACACA)

                          ),

                        ),

                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: TextFormField(
                        controller: branchNameController,
                        readOnly: true,
                        onTap: () {
                          // Display a dialog with a list of states for selection
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Select Your Branch'),
                                content: SingleChildScrollView(
                                  child: Column(
                                    children: Branch.map((Branch) {
                                      return ListTile(
                                        title: Text(Branch),
                                        onTap: () {
                                          setState(() {
                                            branchNameController.text = Branch;
                                          });
                                          Navigator.pop(context); // Close the dialog
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        decoration: InputDecoration(
                          labelText: 'Select Your Branch',
                          labelStyle: TextStyle(color: Color(0xFFCACACA)),
                          suffixIcon: Icon(Icons.arrow_drop_down),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a state';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: TextFormField(
                        controller: DegreeNameController,
                        readOnly: true,
                        onTap: () {
                          // Display a dialog with a list of states for selection
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Degree Name'),
                                content: SingleChildScrollView(
                                  child: Column(
                                    children: Degree.map((Degree) {
                                      return ListTile(
                                        title: Text(Degree),
                                        onTap: () {
                                          setState(() {
                                            DegreeNameController.text = Degree;
                                          });
                                          Navigator.pop(context); // Close the dialog
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        decoration: InputDecoration(
                          labelText: 'Degree Name',
                          labelStyle: TextStyle(color: Color(0xFFCACACA)),
                          suffixIcon: Icon(Icons.arrow_drop_down),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a Degree Name';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Flexible(
                    // child: Padding(
                    //   padding: EdgeInsets.all(20.0),
                    //   child: TextFormField(
                    //     controller:passingYearController,
                    //     validator: (value) {
                    //       if (value!.isEmpty) {
                    //         return 'Please enter Passing year';
                    //       }
                    //       return null; // Return null if the input is valid
                    //     },
                    //     keyboardType: TextInputType.number,
                    //     decoration: InputDecoration(labelText: 'Passing Year',
                    //         labelStyle: TextStyle( color:Color(0xFFCACACA))),
                    //   ),
                    // ),

                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: TextFormField(
                          controller: passingYearController,
                          readOnly: true,
                          onTap: () => _selectYear(context),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please select a year';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Year',
                            labelStyle: TextStyle(color: Color(0xFFCACACA)),
                            suffixIcon: Icon(Icons.arrow_drop_down),
                          ),
                        ),
                      )
                  ),
                ],
              ),
              SizedBox(height: 15,),
              Container(

                color: Colors.white,
                child:  Row(
                  children: [
                    SizedBox(width: 30,),
                    Text("Create Your Password",style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: screenWidth < 400 ? 23.5 : 26,
                      fontFamily: 'FontMain',
                    ),),
                  ],),
              ),
              SizedBox(height: 15,),

              Padding(
                padding: const EdgeInsets.only(left: 66, right: 58),

                child:TextFormField(
                  controller: passwordController,
                  obscureText: !isPasswordVisible,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter password';
                    }
                    return null; // Return null if the input is valid
                  },
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFCACACA)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFCACACA)),
                    ),
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Icon(
                        Icons.lock,
                        color: Color(0xFF9B9B9B),
                        size: 22,
                      ),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                      icon: Icon(
                        isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: Color(0xFF9B9B9B),
                      ),
                    ),
                    hintText: 'Password',
                    hintStyle: TextStyle(
                      color: Color(0xFF9B9B9B),
                      fontSize: screenWidth < 400 ? 13 : 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(left: 66, right: 58),
                child:TextFormField(
                  controller: conformPasswordController,
                  obscureText: !isConfirmPasswordVisible,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter Conform password';
                    }
                    return null; // Return null if the input is valid
                  },
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFCACACA)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFCACACA)),
                    ),
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(right: 20),
                      child: Icon(
                        Icons.lock,
                        color: Color(0xFF9B9B9B),
                        size: 22,
                      ),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isConfirmPasswordVisible = !isConfirmPasswordVisible;
                        });
                      },
                      icon: Icon(
                        isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: Color(0xFF9B9B9B),
                      ),
                    ),
                    hintText: 'Confirm Password',
                    hintStyle: TextStyle(
                      color: Color(0xFF9B9B9B),
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 35,),
              ElevatedButton(onPressed: ()    {

                //validateEmail(emailController.text);
                if (_formKey.currentState?.validate() == true) {

                  print("All feilds are filled");

                  if(passwordController.text != conformPasswordController.text){

                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Stack(
                          children: [
                            // Blurred background
                            BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                              child: Container(
                                color: Colors.black.withOpacity(0.5), // Adjust the opacity as needed
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                              ),
                            ),
                            // AlertDialog on top of the blurred background
                            AlertDialog(
                              backgroundColor: Colors.white,
                              surfaceTintColor: Colors.transparent,// Set the background color to transparent
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(height: 30),
                                  Center(
                                    child: Text(
                                      "Password Mismatch",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: "FontMain",
                                        fontSize: 18,
                                        color: Color(0xFFBD232B),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 35),
                                  ElevatedButton(
                                    onPressed: () {
                                      // Pop the current route (the AlertDialog)
                                      Navigator.of(context).pop();

                                      // Add any additional logic here

                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFF13640),
                                      minimumSize: Size(250, 50),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    child: const Text(
                                      "OK",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }

                  else{
                    checkEmailExistence();
                  }

                }

                else {
                  // Form is not valid, show error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please fix the errors in the form.'),
                    ),
                  );
                }


                //submitVerification();
              },style: ElevatedButton.styleFrom(
                backgroundColor:const Color(0xFFF13640),
                shape:RoundedRectangleBorder(
                    borderRadius:BorderRadius.circular(20)
                ),
              ), child: Text("Submit",style: TextStyle(
                color:Colors.white,
                fontWeight:FontWeight.w700,
                fontSize:25,
              ),)),
              SizedBox(height: 35,),


            ],
          ),
        ),
      ),
    );
  }
}
