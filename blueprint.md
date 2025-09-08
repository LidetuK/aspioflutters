
# Blog Reader App Blueprint

## Overview

This document outlines the plan and progress for building a Flutter-based mobile frontend for a blog reader app. The app will eventually connect to a WordPress REST API, but the initial version will use mock data for development and testing.

## Implemented Features

### Initial Setup
- **Project:** Created a new Flutter project.
- **Models:** Defined `Post` and `Category` data models.
- **Services:** Implemented a `MockDataService` to provide mock `Post` and `Category` data.

## Current Plan

### Phase 1: Frontend with Mock Data

1.  **Project Structure:**
    -   `lib/models`: Contains data models (`post.dart`, `category.dart`).
    -   `lib/services`: Holds the `mock_data_service.dart`.
    -   `lib/ui/widgets`: For reusable widgets (`post_card.dart`, `post_list.dart`, `category_list.dart`).
    -   `lib/ui/screens`: For app screens (`home_screen.dart`, `post_detail_screen.dart`, `category_screen.dart`).

2.  **Data Models:**
    -   Create `Post` and `Category` classes to match the WordPress API JSON structure.

3.  **Mock Data Service:**
    -   Develop a service that returns mock data for posts and categories.

4.  **UI Components:**
    -   `PostCard`: A widget to display a single blog post with title, featured image, excerpt, and a "Read more" button.
    -   `PostList`: A widget to display a list of `PostCard`s.
    -   `CategoryList`: A widget to display a list of categories.

5.  **Screens:**
    -   **Home Screen:**
        -   Display a scrollable list of all blog posts using `PostList`.
    -   **Post Detail Screen:**
        -   Show the full post details: title, featured image, author, date, and content.
    -   **Category Screen:**
        -   Display a list of categories at the top.
        -   Below the categories, show a list of posts filtered by the selected category.

6.  **Navigation:**
    -   Implement a `BottomNavigationBar` or a `Drawer` for navigating between the "Home" and "Categories" screens.

7.  **Styling:**
    -   Apply a clean and modern design with a consistent theme.
    -   Ensure the layout is responsive and mobile-friendly.
