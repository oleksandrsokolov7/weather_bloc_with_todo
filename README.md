# Weather App with BLoC and Dio

This project is a simple **Weather App** built using **Flutter**, **BLoC** for state management, and **Dio** for HTTP requests. The app fetches weather data from an external API and displays it to the user.

## Features
- Display the current weather, including temperature, humidity, and wind speed.
- Use of **BLoC** for managing app state.
- **Dio** used for fetching weather data via API calls.
- Displaying weather information in **Celsius** with the city name.

## Libraries Used
- `flutter_bloc` - BLoC pattern for state management.
- `dio` - HTTP client for fetching weather data.

## Project Structure
- `main.dart`: The main entry point where the app is initialized.
- `weather_bloc.dart`: Contains the business logic for weather fetching and state management.
- `home_page.dart`: The user interface for displaying weather data.
- `weather_model.dart`: A model to represent the weather data.

## Setup

To get started with this project:

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/weather_app.git
