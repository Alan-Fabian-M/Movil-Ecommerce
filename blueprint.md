# Blueprint: AI-Powered Flutter App

This document outlines the structure, features, and development plan for a Flutter application being built with the assistance of an AI development agent.

## 1. Project Overview

The goal is to create a modern and visually appealing e-commerce application for a boutique. The AI agent will handle the majority of the development tasks, from UI creation to business logic implementation, following the user's high-level requests.

## 2. Style and Design

- **Theme:** Modern, minimalist, and premium.
- **Color Palette:** A dark theme with black as the primary background color (`Colors.black`), accented with white and shades of grey. Interactive elements will have a subtle "glow" effect.
- **Typography:** Custom fonts will be sourced from `google_fonts` to create a unique and readable text hierarchy. Specifically, `Montserrat` for titles and headings, and `Roboto` for body text.
- **Iconography:** Clean and modern icons from the Material Design library.
- **Visuals:** High-quality product images will be used. Placeholder images will be sourced from `picsum.photos` for development.
- **Layout:** A responsive grid layout for product listings and clean, spacious layouts for detail screens.

## 3. Implemented Features

- **Authentication Flow:**
  - **Login Screen**: Minimalist design with navigation to the Home and Registration screens.
  - **Registration Screen**: Consistent design for creating a new account.
- **Home Screen (`lib/presentation/screens/home_screen.dart`):**
  - Displays a grid of products from a boutique catalog.
  - Features pagination to browse through products.
- **Product Card (`lib/presentation/widgets/product_card.dart`):**
  - A reusable card to display a product's image, name, and price.
- **Product Detail Screen (`lib/presentation/screens/product_detail_screen.dart`):**
  - Displays detailed information about a selected product.
  - Allows users to select and add products to the cart.
- **Shopping Cart (`lib/presentation/screens/cart_screen.dart`):**
  - A dedicated screen to view and manage items in the shopping cart.
  - Real-time updates of cart items and total price.
- **State Management:**
  - Use of the `provider` package for managing the state of the shopping cart (`CartModel`).
- **Product Model (`lib/data/models/product_model.dart`):**
  - A data model structuring product information with `id`, `name`, `price`, `imageUrl`, and `description`.

## 4. Current Plan

### Step 1: Implement Bottom Navigation Bar

- **Goal:** Add a persistent bottom navigation bar for easy access to the main sections of the app: Catalog, Orders, and Profile.
- **File Creation:**
    - `lib/presentation/screens/main_navigation.dart`: This will be the main stateful widget that houses the bottom navigation bar and manages the selected screen.
    - `lib/presentation/screens/orders_screen.dart`: A new screen to display the user's order history.
    - `lib/presentation/screens/profile_screen.dart`: A new screen for the user's profile information.
- **UI Components:**
    - The `BottomNavigationBar` will have three items: "Catalog" (using `Icons.store`), "Orders" (using `Icons.receipt_long`), and "Profile" (using `Icons.person`).
    - The `AppBar` (including the shopping cart icon) will be moved to `main_navigation.dart` to be persistent across all three tabs.
- **Integration:**
    - Update `main.dart` to set `MainNavigation` as the home screen.
    - The body of `MainNavigation` will switch between `HomeScreen`, `OrdersScreen`, and `ProfileScreen` based on the active tab.
- **Finalization:** Run `flutter analyze` to ensure code quality.
