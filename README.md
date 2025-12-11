# Personal Finance Tracker
Simple personal finance tracker app that allows users to log expenses and income, view their balance, and categorize transactions.

<img width="3125" height="1238" alt="Personal Finance Tracker  (1)" src="https://github.com/user-attachments/assets/b9d90526-192f-4f05-af45-e18b49226817" />


## Features
➕ Add and edit transactions (income or expense) with amount, category, date, and optional notes + Form validation\
📋 View all transactions in a list\
💰 Balance overview visible at the top\
🔍 Filtering by transaction type (all / income / expense)\
💾 Local data persistence

## 📁 Project Structure
```
lib/
 ├── data/
 │    ├── models/
 │    └── repository/
 ├── cubit/
 │    ├── transactions/
 │    └── settings/
 ├── ui/
 │    ├── screens/
 │    └── theme/
 ├── test/
 └── main.dart
 ```

## 🚦 How to Run
 ```
flutter pub get
flutter run
 ```

##  🧪 Testing
Run tests with:
 ```
flutter test
 ```

## 🚀 Future Improvements
⏱ Advanced date range filtering\
📊 Charts for category spending\
🌍 Multi-currency with real-time conversion\
🔐 Multiple users and session management\
🧪 More comprehensive unit + widget tests\
🔄 Import/export of data (CSV, JSON)

## Explanation of choices
### Architecture
The architecture separates between UI, state management, and data layer:
- **State Management**
  - Implemented using Cubit from the Bloc package
  - Separate cubits for:
    - Transaction management
    - Filtering
    - App theme
- **Data Layer**
  - Hive database for local persistence
  - Repository layer abstracts database operations
  - Fully decoupled from UI, enabling easy testing
- **UI Layer**
  - Declarative Flutter widgets
  - Responsive Material layout
  - Bottom sheets used for adding/editing entries
  - Settings screen accessible via the top-right corner of the Home screen

**Cubits**: I used Cubits instead of BLoC beacuse I have stronger experience with those and because of time constraints.\
**Hive**: Provides excellent performance with minimal boilerplate, perfect for small structured records like transactions.\
**Separate ThemeCubit**: Theme preference is persisted using SharedPreferences.\
**Repository Pattern**: Keeps UI and logic clean and enables replaceable storage backend.

### Trade-offs and shortcuts (due to time constraints)
- Validation is minimal
- Limited filtering (basic type filter only)
- UI was adapted using Claude, providing an image of the desired style and the code for the page to update
- Test cases were ampliated with Github Copilot

### Estimated Time Spent
The project took about 2 and a half hours to reach the basic requirements. The implementation of bonus requests, like edit/deletion of transactions, testing, and completion of the readme took another hour and a half, for a total of approx 4 hours of time spent.
