import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mental_health_app/screens/community/api_services.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  late Future<List<Map<String, dynamic>>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  void _loadPosts() {
    _postsFuture = ApiService().fetchPosts(
      page: 1,
      limit: 3,
      userId: 'h4cf3wbgvaqcdm2',
    );
  }

  Future<void> _refreshPosts() async {
    setState(() {
      _loadPosts(); // Reset the Future to fetch fresh data
    });
    await _postsFuture; // Wait for the new data to load
  }

  void _addNewPost(Map<String, dynamic> newPost) {
    setState(() {
      _loadPosts(); // Reload posts to include the new one
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat"), backgroundColor: Colors.blue),
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _refreshPosts,
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _postsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('No posts available'),
                  ),
                ),
              );
            } else {
              return SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  children:
                      snapshot.data!
                          .map((post) => PostWidget(post: post))
                          .toList(),
                ),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreatePostDialog(context),
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _showCreatePostDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CreatePostDialog(onPostCreated: _addNewPost),
    );
  }
}

class PostWidget extends StatefulWidget {
  final Map<String, dynamic> post;

  const PostWidget({super.key, required this.post});

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  late bool _isLiked;
  late int _likeCount;
  bool _isCommenting = false;
  bool _isCommentsVisible = false;
  bool _isCommentsLoading = false;
  late int _commentCount;
  final TextEditingController _commentController = TextEditingController();
  List<Map<String, dynamic>> _comments = [];
  final String _userId = 'h4cf3wbgvaqcdm2';

  @override
  void initState() {
    super.initState();
    _isLiked = widget.post['isUpvoted'];
    _likeCount = widget.post['points'];
    _commentCount = widget.post['commentCount'];
  }

  Future<void> _fetchComments() async {
    setState(() {
      _isCommentsLoading = true;
    });
    try {
      final comments = await ApiService().fetchComments(
        postId: widget.post['id'],
        page: 1,
        limit: 3,
        sortBy: 'recent',
        userId: _userId,
      );
      setState(() {
        _comments = comments;
        _isCommentsVisible = true;
        _isCommentsLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error fetching comments: $e')));
      setState(() {
        _isCommentsVisible = false;
        _isCommentsLoading = false;
      });
    }
  }

  Future<void> _toggleUpvote() async {
    setState(() {
      _isLiked = !_isLiked;
      _likeCount = _isLiked ? _likeCount + 1 : _likeCount - 1;
    });
    final success = await ApiService().upvotePost(
      postId: widget.post['id'],
      userId: _userId,
    );
    if (!success) {
      setState(() {
        _isLiked = !_isLiked;
        _likeCount = _isLiked ? _likeCount + 1 : _likeCount - 1;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to upvote post')));
    }
  }

  Future<void> _addComment() async {
    if (_commentController.text.isNotEmpty) {
      try {
        final newComment = await ApiService().addComment(
          postId: widget.post['id'],
          userId: _userId,
          content: _commentController.text,
        );
        if (newComment != null) {
          setState(() {
            _comments.insert(0, newComment);
            _commentCount++;
            _commentController.clear();
            _isCommenting = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Comment added'),
              backgroundColor: Colors.blue,
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error adding comment: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildChatBox();
  }

  Widget buildChatBox() {
    return Container(
      margin: EdgeInsets.all(8),
      padding: const EdgeInsets.fromLTRB(16.0, 16, 16, 6),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300, width: 1),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildHeader(),
          SizedBox(height: 4),
          buildPostContent(),
          SizedBox(height: 12),
          buildActionRow(),
          if (_isCommentsLoading)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Center(child: CircularProgressIndicator()),
            ),
          if (_isCommenting) buildCommentInput(),
          if (_comments.isNotEmpty && _isCommentsVisible) buildCommentsList(),
        ],
      ),
    );
  }

  Widget buildHeader() {
    String formattedTime = DateFormat(
      'd MMMM yyyy, hh:mm a',
    ).format(DateTime.parse(widget.post['createdAt']));
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              widget.post['author'] != null
                  ? widget.post['author']['username'] ?? 'Unknown'
                  : 'Unknown',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            SizedBox(width: 8),
            Text(
              formattedTime,
              style: TextStyle(fontSize: 9, color: Colors.grey),
            ),
          ],
        ),
        IconButton(
          icon: Icon(
            _isCommentsVisible ? Icons.expand_less : Icons.expand_more,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _isCommentsVisible = !_isCommentsVisible;
            });
            if (_isCommentsVisible) {
              _fetchComments();
            }
          },
        ),
      ],
    );
  }

  Widget buildPostContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.post['title'],
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 4),
        Text(
          widget.post['content'] ?? '',
          style: TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    );
  }

  Widget buildActionRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.favorite,
                color: _isLiked ? Colors.red : Colors.grey,
              ),
              onPressed: _toggleUpvote,
            ),
            Text('$_likeCount', style: TextStyle(color: Colors.grey)),
          ],
        ),
        Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.comment,
                color: _commentCount > 0 ? Colors.blue : Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _isCommenting = !_isCommenting;
                });
              },
            ),
            Text('$_commentCount', style: TextStyle(color: Colors.grey)),
          ],
        ),
        IconButton(
          icon: Icon(Icons.share, color: Colors.grey),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget buildCommentInput() {
    return Column(
      children: [
        SizedBox(height: 8),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                constraints: BoxConstraints(
                  minHeight: 90.0,
                  maxHeight: 90.0,
                  minWidth: double.infinity,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  border: Border.all(color: Colors.grey.shade400, width: 1.0),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextField(
                  controller: _commentController,
                  maxLines: 3,
                  minLines: 3,
                  maxLength: 120,
                  scrollPhysics: BouncingScrollPhysics(),
                  style: TextStyle(fontSize: 12, color: Colors.black87),
                  decoration: InputDecoration(
                    hintText: 'Write a comment...',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: EdgeInsets.all(12),
                    counterText: '',
                  ),
                  textInputAction: TextInputAction.newline,
                ),
              ),
            ),
            SizedBox(width: 8),
            IconButton(
              icon: Icon(Icons.send, color: Colors.blue),
              onPressed: _addComment,
            ),
          ],
        ),
        SizedBox(height: 8),
      ],
    );
  }

  Widget buildCommentsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
          _comments.map((comment) => CommentWidget(comment: comment)).toList(),
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}

class CommentWidget extends StatefulWidget {
  final Map<String, dynamic> comment;

  const CommentWidget({super.key, required this.comment});

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  late bool _isLiked;
  late int _likeCount;
  final String _userId = 'h4cf3wbgvaqcdm2';

  @override
  void initState() {
    super.initState();
    _isLiked = widget.comment['commentUpvotes']?.isNotEmpty ?? false;
    _likeCount = widget.comment['points'] ?? 0;
  }

  Future<void> _toggleCommentUpvote() async {
    setState(() {
      _isLiked = !_isLiked;
      _likeCount = _isLiked ? _likeCount + 1 : _likeCount - 1;
    });
    final success = await ApiService().upvoteComment(
      commentId: widget.comment['id'],
      userId: _userId,
    );
    if (!success) {
      setState(() {
        _isLiked = !_isLiked;
        _likeCount = _isLiked ? _likeCount + 1 : _likeCount - 1;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to upvote comment')));
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedTime = DateFormat('d MMMM yyyy, hh:mm a').format(
      DateTime.parse(widget.comment['createdAt'] ?? DateTime.now().toString()),
    );
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.only(left: 12),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: Colors.grey.shade300, width: 2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                widget.comment['author']['username'],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              SizedBox(width: 8),
              Text(
                formattedTime,
                style: TextStyle(fontSize: 9, color: Colors.grey),
              ),
            ],
          ),
          SizedBox(height: 2),
          Text(
            widget.comment['content'],
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
          SizedBox(height: 4),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.favorite,
                  color: _isLiked ? Colors.red : Colors.grey,
                  size: 20,
                ),
                onPressed: _toggleCommentUpvote,
              ),
              Text(
                '$_likeCount',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CreatePostDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onPostCreated;

  const CreatePostDialog({super.key, required this.onPostCreated});

  @override
  State<CreatePostDialog> createState() => _CreatePostDialogState();
}

class _CreatePostDialogState extends State<CreatePostDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  bool _isSubmitting = false;
  final String _userId = 'h4cf3wbgvaqcdm2';

  Future<void> _submitPost() async {
    if (_titleController.text.isNotEmpty &&
        _contentController.text.isNotEmpty) {
      setState(() {
        _isSubmitting = true;
      });
      try {
        final newPost = await ApiService().createPost(
          title: _titleController.text,
          content: _contentController.text,
          userId: _userId,
        );
        if (newPost != null) {
          widget.onPostCreated(newPost);
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Post added'), backgroundColor: Colors.blue),
          );
        }
      } catch (e) {
        setState(() {
          _isSubmitting = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error creating post: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Create Post'),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              constraints: BoxConstraints(
                minHeight: 60.0, // Updated minHeight
                maxHeight: 120.0, // Updated maxHeight
              ),
              child: TextField(
                controller: _titleController,
                style: TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 16.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Container(
              constraints: BoxConstraints(minHeight: 90.0, maxHeight: 120.0),
              child: TextField(
                controller: _contentController,
                style: TextStyle(fontSize: 14),
                maxLines: null,
                minLines: 3,
                scrollPhysics: BouncingScrollPhysics(),
                decoration: InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(16.0),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        _isSubmitting
            ? Center(child: CircularProgressIndicator())
            : ElevatedButton(onPressed: _submitPost, child: Text('Submit')),
      ],
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
}
