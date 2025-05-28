import 'package:flutter/material.dart';
// import 'package:learn_api/models/post.dart';
// import 'package:learn_api/services/post_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Post> _posts = [];
  List<Post> _filteredPosts = [];
  final _searchController = TextEditingController();
  String? _selectedUserId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadPosts() async {
    setState(() => _isLoading = true);
    try {
      // final posts = await PostService.fetchPosts();
      // Simulasi data posts
      final posts = _generateSamplePosts();
      setState(() {
        _posts = posts;
        _filteredPosts = posts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      _showMessage('Error loading posts: $e');
    }
  }

  List<Post> _generateSamplePosts() {
    return List.generate(20, (index) => Post(
      id: index + 1,
      userId: (index % 5) + 1,
      title: 'Post Title ${index + 1}',
      body: 'This is the content of post ${index + 1}. Lorem ipsum dolor sit amet.',
    ));
  }

  void _filterPosts() {
    setState(() {
      _filteredPosts = _posts.where((post) {
        final matchesSearch = _searchController.text.isEmpty ||
            post.title.toLowerCase().contains(_searchController.text.toLowerCase());
        final matchesUser = _selectedUserId == null ||
            post.userId.toString() == _selectedUserId;
        return matchesSearch && matchesUser;
      }).toList();
    });
  }

  void _showAddPostDialog() {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Post Baru'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Judul Post',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: bodyController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Konten Post',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              _addPost(titleController.text, bodyController.text);
              Navigator.pop(context);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _addPost(String title, String body) {
    if (title.isEmpty || body.isEmpty) {
      _showMessage('Judul dan konten harus diisi');
      return;
    }

    final newPost = Post(
      id: _posts.length + 1,
      userId: 1, // Current user ID
      title: title,
      body: body,
    );

    setState(() {
      _posts.insert(0, newPost);
      _filterPosts();
    });
    _showMessage('Post berhasil ditambahkan');
  }

  void _showEditPostDialog(Post post) {
    final titleController = TextEditingController(text: post.title);
    final bodyController = TextEditingController(text: post.body);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Post'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Judul Post',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: bodyController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Konten Post',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              _editPost(post.id, titleController.text, bodyController.text);
              Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _editPost(int postId, String title, String body) {
    if (title.isEmpty || body.isEmpty) {
      _showMessage('Judul dan konten harus diisi');
      return;
    }

    setState(() {
      final index = _posts.indexWhere((post) => post.id == postId);
      if (index != -1) {
        _posts[index] = Post(
          id: postId,
          userId: _posts[index].userId,
          title: title,
          body: body,
        );
        _filterPosts();
      }
    });
    _showMessage('Post berhasil diupdate');
  }

  void _deletePost(int postId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Post'),
        content: const Text('Apakah Anda yakin ingin menghapus post ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _posts.removeWhere((post) => post.id == postId);
                _filterPosts();
              });
              Navigator.pop(context);
              _showMessage('Post berhasil dihapus');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Apakah Anda yakin ingin logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/');
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Management'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Search and Filter Section
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Search by title
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          labelText: 'Cari berdasarkan judul',
                          prefixIcon: const Icon(Icons.search),
                          border: const OutlineInputBorder(),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    _searchController.clear();
                                    _filterPosts();
                                  },
                                )
                              : null,
                        ),
                        onChanged: (_) => _filterPosts(),
                      ),
                      const SizedBox(height: 12),
                      // Filter by user ID
                      Row(
                        children: [
                          const Text('Filter User: '),
                          const SizedBox(width: 8),
                          Expanded(
                            child: DropdownButton<String>(
                              value: _selectedUserId,
                              hint: const Text('Semua User'),
                              isExpanded: true,
                              items: [
                                const DropdownMenuItem(
                                  value: null,
                                  child: Text('Semua User'),
                                ),
                                ...List.generate(5, (i) => i + 1)
                                    .map((userId) => DropdownMenuItem(
                                          value: userId.toString(),
                                          child: Text('User $userId'),
                                        )),
                              ],
                              onChanged: (value) {
                                setState(() => _selectedUserId = value);
                                _filterPosts();
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Posts List
                Expanded(
                  child: _filteredPosts.isEmpty
                      ? const Center(
                          child: Text(
                            'Tidak ada post yang ditemukan',
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _filteredPosts.length,
                          itemBuilder: (context, index) {
                            final post = _filteredPosts[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: ListTile(
                                title: Text(
                                  post.title,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('User ID: ${post.userId}'),
                                    const SizedBox(height: 4),
                                    Text(
                                      post.body,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                                trailing: PopupMenuButton(
                                  itemBuilder: (context) => [
                                    const PopupMenuItem(
                                      value: 'edit',
                                      child: Row(
                                        children: [
                                          Icon(Icons.edit),
                                          SizedBox(width: 8),
                                          Text('Edit'),
                                        ],
                                      ),
                                    ),
                                    const PopupMenuItem(
                                      value: 'delete',
                                      child: Row(
                                        children: [
                                          Icon(Icons.delete, color: Colors.red),
                                          SizedBox(width: 8),
                                          Text('Hapus'),
                                        ],
                                      ),
                                    ),
                                  ],
                                  onSelected: (value) {
                                    if (value == 'edit') {
                                      _showEditPostDialog(post);
                                    } else if (value == 'delete') {
                                      _deletePost(post.id);
                                    }
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddPostDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Post Model
class Post {
  final int id;
  final int userId;
  final String title;
  final String body;

  Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      body: json['body'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'body': body,
    };
  }
}