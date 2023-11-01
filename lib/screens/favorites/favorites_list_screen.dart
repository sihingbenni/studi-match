import 'package:flutter/material.dart';

import '../../models/job_favorites.dart';

class FavoritesListScreen extends StatefulWidget {
  const FavoritesListScreen({super.key});

  @override
  State<FavoritesListScreen> createState() => _FavoritesListScreenState();
}

class _FavoritesListScreenState extends State<FavoritesListScreen> {

  final List<JobFavorite> dummyJobFavorites = [
    JobFavorite(
      title: 'Software Developer Intern',
      description: 'Join an innovative tech startup for a summer internship.',
      isLiked: true,
    ),
    JobFavorite(
      title: 'Marketing Assistant',
      description: 'Assist in creating marketing campaigns and strategies.',
      isLiked: true,
    ),
    JobFavorite(
      title: 'Data Analyst',
      description: 'Analyze data and generate insights for a leading company.',
      isLiked: true,
    ),
    JobFavorite(
      title: 'Graphic Designer',
      description: 'Create stunning visuals and designs for various projects.',
      isLiked: true,
    ),
    JobFavorite(
      title: 'Content Writer',
      description: 'Write compelling articles and content for a blog.',
      isLiked: true,
    ),
    JobFavorite(
      title: 'UX/UI Designer',
      description: 'Design user-friendly interfaces for web and mobile apps.',
      isLiked: true,
    ),
    JobFavorite(
      title: 'Sales Representative',
      description: 'Join a dynamic sales team and drive revenue growth.',
      isLiked: true,
    ),
    JobFavorite(
      title: 'Customer Support Specialist',
      description: 'Provide exceptional support to customers and resolve issues.',
      isLiked: true,
    ),
    JobFavorite(
      title: 'Accounting Intern',
      description: 'Gain hands-on experience in accounting and finance.',
      isLiked: true,
    ),
    JobFavorite(
      title: 'Project Manager',
      description: 'Lead project teams and ensure successful project delivery.',
      isLiked: true,
    ),
  ];



  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: Icon(Icons.favorite, color: Colors.red[900]),
      title: const Text('Favorites'),
    ),
    body: ListView.builder(
      itemCount: dummyJobFavorites.length,
      itemBuilder: (context, index) {
        final jobFavorite = dummyJobFavorites[index];
        return ListTile(
          leading: jobFavorite.isLiked
              ? Icon(Icons.star, color: Colors.yellow[900])
              : const Icon(Icons.star_border),
          title: Text(jobFavorite.title),
          subtitle: Text(jobFavorite.description),
          onTap: () {
            // Handle the tap event here (e.g., navigate to job details).
          },
        );
      },
    )

  );
}
