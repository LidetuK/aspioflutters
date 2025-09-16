# Flutter Blog App

This is the **mobile app frontend** for the Blog Platform project. It is built with **Flutter** and consumes posts from a **WordPress backend**.

## 🏗 Project Overview

- **Backend:** WordPress (headless CMS, provides posts via REST API)
- **Mobile Frontend:** Flutter
- **Purpose:** Display blog posts, post detail pages, and categories on Android/iOS.

## 🔹 Features

- Home Page: Lists latest blog posts with title, image, and excerpt.
- Post Detail Page: Displays full article with title, author, date, and content.
- Category Page: Filter posts by category.
- Clean, responsive UI for both Android & iOS.
- API integration with WordPress REST API.

## 🔹 Bonus Features

- ✅ **Search Feature**  
  Search for posts by keyword across the blog.

- ✅ **Pagination / Infinite Scroll**  
  "Load More" button / infinite scroll for browsing long lists of posts.

- ❌ **API Authentication**  
  Skipped. Since this is a public blog, securing the WordPress API adds unnecessary complexity. The REST API is public and works fine.

## 🔹 Getting Started

### 1. Clone the Repository
```bash
git clone https://github.com/yourusername/flutter-blog-app.git
cd flutter-blog-app
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Run the App
```bash
# For web development
flutter run -d web-server

# For mobile development
flutter run

# For release mode (removes debug ribbon)
flutter run -d web-server --release
```

## 🔹 Project Structure

```
lib/
├── models/
│   └── post.dart              # Post, Author, and Category models
├── services/
│   ├── wordpress_api.dart     # WordPress REST API integration
│   └── mock_data_service.dart # Mock data (deprecated)
├── ui/
│   ├── screens/
│   │   ├── home_screen.dart      # Main blog listing
│   │   ├── category_screen.dart  # Category filtering
│   │   └── post_detail_screen.dart # Full post view
│   └── widgets/
│       ├── post_card.dart        # Individual post card
│       ├── post_list.dart        # List of posts
│       ├── category_list.dart    # Category selection
│       ├── search_bar.dart       # Search functionality
│       └── cors_image.dart       # CORS proxy image loading
└── main.dart                  # App entry point
```

## 🔹 Key Technologies

- **Flutter 3.35.3** - Cross-platform UI framework
- **Dart 3.9.2** - Programming language
- **WordPress REST API** - Backend content management
- **Cached Network Image** - Image loading and caching
- **CORS Proxy** - Bypass cross-origin restrictions for images

## 🔹 API Integration

The app connects to a WordPress site at `https://elfignentertainment.com/aspio/` and fetches:

- **Posts:** `/wp-json/wp/v2/posts?_embed=true`
- **Categories:** `/wp-json/wp/v2/categories`
- **Search:** Client-side filtering across all posts

## 🔹 Features in Detail

### 🏠 Home Screen
- Displays latest blog posts with pagination
- "Load More" button for additional posts
- Search functionality across all posts
- Pull-to-refresh support

### 📂 Category Screen
- Lists all available categories
- Click to filter posts by category
- Shows post count per category
- Real-time filtering

### 📖 Post Detail Screen
- Full article content with proper formatting
- Author information and publication date
- Featured image display
- Clean, readable typography

### 🔍 Search Feature
- Real-time search across post titles, excerpts, and categories
- Search results counter
- Clear search functionality

## 🔹 Image Loading Solution

The app uses a sophisticated CORS proxy system to load WordPress images:

- **Multiple Proxy Services:** Tries different CORS proxies automatically
- **Fallback System:** Graceful degradation to placeholder images
- **Caching:** Images are cached for better performance
- **Error Handling:** Robust error handling with user-friendly messages

## 🔹 Development Notes

### CORS Issues
WordPress images are loaded through CORS proxies to bypass browser restrictions:
- `api.allorigins.win`
- `cors-anywhere.herokuapp.com`
- `thingproxy.freeboard.io`

### Debug Mode
- **Debug Mode:** Shows red "DEBUG" ribbon
- **Release Mode:** Clean UI without debug indicators
- Use `--release` flag to remove debug ribbon

### Pagination
- Initial load: 2 posts
- Load more: 2 additional posts per click
- Smooth loading states with progress indicators

## 🔹 Future Enhancements

- [ ] Offline support with local caching
- [ ] Push notifications for new posts
- [ ] Dark mode theme
- [ ] Social sharing functionality
- [ ] Comments integration
- [ ] User authentication and favorites

## 🔹 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 🔹 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🔹 Support

For support and questions:
- Create an issue on GitHub
- Check the Flutter documentation
- Review WordPress REST API documentation

---

**Built with ❤️ using Flutter and WordPress**