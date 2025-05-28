import 'package:flutter/material.dart';
import 'package:learn_api/models/user.dart';
import 'package:learn_api/services/user_service.dart';

class HomePageStateful extends StatefulWidget {
  const HomePageStateful({super.key});

  @override
  State<HomePageStateful> createState() => _HomePageStatefulState();
}

class _HomePageStatefulState extends State<HomePageStateful> {
  List<User> users = [];
  bool isLoading = true;

  void fetchUser() async {
    final result = await UserService.fetchUsers();
    setState(() {
      users = result;
      isLoading = false;
    });
  }

  void logout() {
    // Jika menyimpan token, hapus token di sini
    Navigator.pushReplacementNamed(context, '/'); // kembali ke login
  }

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // menonaktifkan tombol back
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Get Api StateFul'),
          automaticallyImplyLeading: false, // sembunyikan tombol back
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Logout',
              onPressed: logout,
            ),
          ],
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(user.avatar),
                      ),
                      title: Text('${user.firstName} ${user.lastName}'),
                      subtitle: Text(user.email),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
