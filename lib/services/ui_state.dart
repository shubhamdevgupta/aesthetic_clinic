// ui_state.dart
sealed class UiState<T> {}

class Idle<T> extends UiState<T> {}

class Loading<T> extends UiState<T> {}

class Success<T> extends UiState<T> {
  final T response; // raw API response, can be object or list
  Success(this.response);
}

class Error<T> extends UiState<T> {
  final String message;
  Error(this.message);
}

class NoInternet<T> extends UiState<T> {
  final String message;
  NoInternet([this.message = "No Internet Connection"]);
}
