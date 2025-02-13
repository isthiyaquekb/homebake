# Home Bake

Home Bake is a Flutter-based eCommerce application designed for a family-run business selling homemade snacks. This app provides a seamless experience for both customers and administrators, allowing easy order placement, management, and tracking.

## Features

### Customer App:
- User authentication (Sign Up, Login, Forgot Password)
- Browse available snacks
- Add products to cart and manage cart
- Place orders and track order status
- Secure checkout process
- QR code-based order verification for Cash on Delivery (COD) orders
- Search and filter products

### Admin Panel:
- Admin authentication
- Dashboard with revenue, orders, and inventory analytics
- Order management (view, accept, reject, update order status)
- Inventory management (add, edit, delete products)
- Sales analytics with charts

## Tech Stack
- **Flutter**: Frontend framework
- **Firebase Authentication**: User authentication
- **Cloud Firestore**: Real-time database for storing products, orders, and users
- **Provider (MVVM Pattern)**: State management

## Project Structure
```
lib/
│── core/
│   ├── services/            # Firebase services (Auth, Firestore, etc.)
│   ├── constants/           # App-wide constants (colors, assets, routes)
│
│── features/
│   ├── auth/                # Authentication feature (Model, View, ViewModel)
│   ├── products/            # Product listing and details
│   ├── cart/                # Cart management
│   ├── orders/              # Order processing and history
│
│── utils/
│   ├── formatter.dart       # Utility for formatting text, dates, etc.
│   ├── app_permissions.dart # Manage app-level permissions
│   ├── snackbars.dart       # Common snackbar messages
│
│── widgets/
│   ├── buttons.dart         # Reusable button widgets
│   ├── text_fields.dart     # Custom TextFormFields
│
│── main.dart                # App entry point

```

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/your-repo/home_bake.git
   ```
2. Navigate to the project directory:
   ```bash
   cd home_bake
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app:
   ```bash
   flutter run
   ```

## Firebase Setup
1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com/).
2. Enable **Authentication** (Email/Password, Google Sign-In, etc.).
3. Set up **Cloud Firestore** with necessary collections (`users`, `orders`, `products`, `carts`).
4. Download the `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) and place them in the respective directories:
    - `android/app/`
    - `ios/Runner/`

## Firestore Collections Structure

### Users Collection
```
/users/{userId}
   - userId: string
   - name: string
   - email: string
   - phone: string
   - address: string
```

### Products Collection
```
/products/{productId}
   - productId: string
   - name: string
   - description: string
   - price: double
   - imageUrl: string
   - category: string
```

### Orders Collection
```
/orders/{orderId}
   - orderId: string
   - userId: string
   - items: array
   - totalPrice: double
   - status: string (pending, accepted, completed)
   - createdAt: timestamp
```

## Contributing
Contributions are welcome! Feel free to open issues and submit pull requests.

## License
This project is licensed under the MIT License.

## Contact
For any inquiries, feel free to reach out at **isthiishq@gmail.com**.

