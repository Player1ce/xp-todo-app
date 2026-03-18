import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xp_todo_app/providers/auth_providers.dart';
import "package:xp_todo_app/util/cloud_function_utils.dart";
import 'package:xp_todo_app/util/download_as_csv.dart';
import 'package:xp_todo_app/util/ui_utils.dart';
import 'package:xp_todo_app/util/enums/user_role.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:xp_todo_app/widgets/sign_in_required_widget.dart';

class AdminPage extends ConsumerStatefulWidget {
  static const routeName = '/admin';

  const AdminPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends ConsumerState<AdminPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedUserEmail = '';

  Map<String, dynamic>? _userRoles;
  List<Map<String, dynamic>> _userData = [];

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      // _generalUserService = Provider.of<GeneralUserService>(
      //   context,
      //   listen: false,
      // );
      // debugPrint("AdminPage didChangeDependencies called");
      // debugPrint("GeneralUserService: $_generalUserService");
      _initialized = true;
    }
  }

  Future<void> _callRoleFunction(String functionName) async {
    if (_selectedUserEmail.isEmpty) return;
    // debugPrint('Getting callable for function $functionName with uid $_selectedUserEmail');
    HttpsCallable function = FirebaseFunctions.instance.httpsCallable(
      functionName,
    );
    try {
      // debugPrint('Calling function $functionName with uid $_selectedUserEmail');
      final response = await function.call({'targetEmail': _selectedUserEmail});
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(response.data['message'])));
      } else {
        debugPrint(
          "Context not mounted. Function returned message: ${response.data['message']}",
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $error')));
      } else {
        debugPrint("Context not mounted. Error: $error");
      }
    }
  }

  List<List<String>> _convertUserDataToLineList(
    List<Map<String, dynamic>> userData,
  ) {
    return userData.map((row) {
      final claims = row['customClaims'] as List<UserRole>? ?? [];
      return List<String>.from([
        row['email'] ?? '',
        row['uid'] ?? '',
        row['disabled']?.toString() ?? '',
        ...UserRole.values.map(
          (role) => claims.contains(role) ? 'true' : 'false',
        ),
      ]);
    }).toList();
  }

  Map<String, dynamic> convertToMapStringDynamic(Map<Object?, Object?> input) {
    return input.map((key, value) {
      return MapEntry(
        key.toString(),
        value is Map<Object?, Object?>
            ? convertToMapStringDynamic(value)
            : value,
      );
    });
  }

  List<String> header = [
    'email',
    'uid',
    'disabled',
    for (var role in UserRole.values) role.name,
  ];

  Widget _buildPadded(Widget child) {
    return Padding(padding: const EdgeInsets.only(bottom: 8), child: child);
  }

  // Future<void> _downloadCSV() async {
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (context) => const Dialog(
  //       child: Padding(
  //         padding: EdgeInsets.all(16.0),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             CircularProgressIndicator(),
  //             SizedBox(height: 16),
  //             Text('Exporting word data to CSV...'),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );

  //   try {
  //     // final csvService = CsvExportService();
  //     // final success = await csvService.exportAllWordsToCSV();

  //     if (!mounted) return;
  //     Navigator.pop(context);

  //     if (success) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text('CSV export successful! File has been downloaded.'),
  //           duration: Duration(seconds: 3),
  //         ),
  //       );
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text('Failed to export CSV. Please try again.'),
  //           duration: Duration(seconds: 3),
  //         ),
  //       );
  //     }
  //   } catch (e) {
  //     debugPrint('Error downloading CSV: $e');
  //     if (!mounted) return;
  //     Navigator.pop(context);

  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Error: ${e.toString()}'),
  //         duration: const Duration(seconds: 3),
  //       ),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => SignInRequiredWidget(
        message: "Failed to load user. Please sign in again.",
      ),
      data: (user) {
        if (user == null) {
          return SignInRequiredWidget(
            message: 'Please sign in to view this page.',
          );
        }

        return AdaptiveScaffold(
          appBar: AdaptiveAppBar(
            title: 'Admin Page',
            // actions: [
            //   IconButton(
            //     icon: const Icon(Icons.download),
            //     tooltip: 'Download Word List as CSV',
            //     onPressed: _downloadCSV,
            //   ),
            // ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    labelText: 'Search User by Email',
                  ),
                  onChanged: (String value) async {
                    // debugPrint("Setting value for $value");
                    setState(() {
                      _selectedUserEmail = value;
                      _userRoles = null;
                      // debugPrint("_selectedUserEmail set to $value");
                    });
                  },
                ),
                // ),
                Flexible(
                  fit: FlexFit.loose,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Selected User Email: $_selectedUserEmail'),
                            // TODO: make this wrap
                            if (_userRoles != null)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(" User Roles: ["),
                                  ..._userRoles!.entries.map((entry) {
                                    return Text(
                                      "(${entry.key}: ${entry.value}), ",
                                    );
                                  }),
                                  const Text("]"),
                                ],
                              ),
                            _buildPadded(
                              ElevatedButton(
                                child: const Text("Get Custom Claims"),
                                onPressed: () async {
                                  late final Map<String, dynamic>? customClaims;
                                  bool failure = false;
                                  try {
                                    customClaims = await callFunctionWithThrow(
                                      context,
                                      'getUserCustomClaims',
                                      {'targetEmail': _selectedUserEmail},
                                    );
                                  } catch (e) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Failed to get custom claims: $e',
                                          ),
                                        ),
                                      );
                                    } else {
                                      debugPrint(
                                        "Failed to get custom claims: $e",
                                      );
                                    }
                                    failure = true;
                                  }

                                  if (failure) {
                                    setState(() {
                                      _userRoles = null;
                                    });
                                    return;
                                  } else if (customClaims == null) {
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'No custom claims found for this user.',
                                          ),
                                        ),
                                      );
                                    } else {
                                      debugPrint(
                                        "No custom claims found for this user.",
                                      );
                                    }
                                    setState(() {
                                      _userRoles = {};
                                    });
                                  } else {
                                    setState(() {
                                      _userRoles = customClaims!;
                                    });
                                  }
                                },
                              ),
                            ),
                            // TODO: add a button here to make a user a parnet and one to make them a researcher or use a dropdown and a single button to change user type.
                            _buildPadded(
                              ElevatedButton(
                                child: const Text("Assign Base Role"),
                                onPressed: () async {
                                  if (await showConfirmationDialog(
                                    context,
                                    'Are your sure you want to assign the Base role to $_selectedUserEmail?',
                                  )) {
                                    await _callRoleFunction('giveBaseClaim');
                                  }
                                },
                              ),
                            ),
                            _buildPadded(
                              ElevatedButton(
                                child: const Text("Remove Base Role"),
                                onPressed: () async {
                                  if (await showConfirmationDialog(
                                    context,
                                    'Are your sure you want to remove the Base role from $_selectedUserEmail?',
                                  )) {
                                    await _callRoleFunction('removeBaseClaim');
                                  }
                                },
                              ),
                            ),
                            _buildPadded(
                              ElevatedButton(
                                child: const Text('Assign Manager Role'),
                                onPressed: () async {
                                  if (await showConfirmationDialog(
                                    context,
                                    'Are your sure you want to give the Manager role to $_selectedUserEmail?',
                                  )) {
                                    _callRoleFunction('giveManagerClaim');
                                  }
                                },
                              ),
                            ),
                            _buildPadded(
                              ElevatedButton(
                                child: const Text('Remove Manager Role'),
                                onPressed: () async {
                                  if (await showConfirmationDialog(
                                    context,
                                    'Are your sure you want to remove the Manager role from $_selectedUserEmail?',
                                  )) {
                                    _callRoleFunction('removeManagerClaim');
                                  }
                                },
                              ),
                            ),
                            _buildPadded(
                              ElevatedButton(
                                child: const Text('Assign Admin Role'),
                                onPressed: () async {
                                  if (await showConfirmationDialog(
                                    context,
                                    'Are your sure you want to give the Admin role to $_selectedUserEmail?',
                                  )) {
                                    _callRoleFunction('giveAdminClaim');
                                  }
                                },
                              ),
                            ),
                            _buildPadded(
                              ElevatedButton(
                                child: const Text('Remove Admin Role'),
                                onPressed: () async {
                                  if (await showConfirmationDialog(
                                    context,
                                    'Are your sure you want to remove the Admin role from $_selectedUserEmail?',
                                  )) {
                                    _callRoleFunction('removeAdminClaim');
                                  }
                                },
                              ),
                            ),
                            _buildPadded(
                              ElevatedButton(
                                child: const Text('Get Email-UID Data'),
                                onPressed: () async {
                                  if (await showConfirmationDialog(
                                    context,
                                    'This will query all email and uid data and return it as a csv. Continue?',
                                  )) {
                                    // Check if context is still mounted before using it
                                    if (!context.mounted) return;
                                    var userData = await callFunction(
                                      context,
                                      'getEmailUIDTable',
                                      {},
                                    );
                                    if (userData != null) {
                                      // List<Map<String, dynamic>>
                                      // debugPrint(
                                      //     "userData received: ${userData['users']}");
                                      // debugPrint("");
                                      // // print the type of users
                                      // debugPrint(
                                      //     "users type: ${userData['users'].runtimeType}");
                                      // // print the type of users['users'].first
                                      // debugPrint(
                                      //     "users[0] type: ${userData['users'][0].runtimeType}");

                                      // // print the type of the objects in userDats.first
                                      // debugPrint("");
                                      // userData['users'].forEach((key, value) {
                                      //   debugPrint(
                                      //       "userData.first key: $key value: $value");
                                      //   debugPrint(
                                      //       "\t\tuserData.first valuetype: ${value.runtimeType} ");
                                      // });

                                      List<Map<String, dynamic>>
                                      users = (userData['users'] as List)
                                          .map<Map<String, dynamic>>((user) {
                                            final rawMap =
                                                user as Map<Object?, Object?>;
                                            final userMap =
                                                convertToMapStringDynamic(
                                                  rawMap,
                                                );

                                            if (userMap['customClaims'] !=
                                                null) {
                                              userMap['customClaims'] =
                                                  UserRole.getRolesFromClaims(
                                                    userMap['customClaims'],
                                                  );
                                            }

                                            return userMap;
                                          })
                                          .toList();

                                      // debugPrint("userData received: $users");
                                      // debugPrint("");
                                      // // print the type of users
                                      // debugPrint("users type: ${users.runtimeType}");
                                      // // print the type of users['users'].first
                                      // debugPrint(
                                      //     "users[0] type: ${users[0].runtimeType}");

                                      // // print the type of the objects in userDats.first
                                      // debugPrint("");
                                      // users.first.forEach((key, value) {
                                      //   debugPrint(
                                      //       "userData.first key: $key value: $value");
                                      //   debugPrint(
                                      //       "\t\tuserData.first valuetype: ${value.runtimeType} ");
                                      // });
                                      // debugPrint("");

                                      setState(() {
                                        _userData = users;
                                      });

                                      final dataList =
                                          _convertUserDataToLineList(users);

                                      // debugPrint("userData received: $dataList");
                                      // debugPrint("");
                                      // // print the type of dataList
                                      // debugPrint(
                                      //     "dataList type: ${dataList.runtimeType}");
                                      // // print the type of dataList['dataList'].first
                                      // debugPrint(
                                      //     "dataList[0] type: ${dataList[0].runtimeType}");

                                      // // print the type of the objects in userDats.first
                                      // debugPrint("");
                                      // for (var value in dataList.first) {
                                      //   debugPrint("userData value: $value");
                                      //   debugPrint(
                                      //       "\t\tuserData valuetype: ${value.runtimeType} ");
                                      // }
                                      // debugPrint("");

                                      downloadAsCSV(
                                        header,
                                        dataList,
                                        "UserUIDData",
                                      );
                                    } else {
                                      debugPrint("No user data received");
                                    }
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_userData.isNotEmpty)
                        Expanded(
                          child: ListView.builder(
                            itemCount: _userData.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(_userData[index]['email'] ?? ''),
                                subtitle: Text(
                                  'UID: ${_userData[index]['uid'] ?? ''}, Roles: ${_userData[index]['customClaims'].toString()}${_userData[index]['disabled'] ? '  -  (User is disabled.)' : ''}',
                                ),
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
