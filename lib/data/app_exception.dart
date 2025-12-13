class AppExceptions implements Exception
{
  final _message;
  final _prefix;

  AppExceptions([this._message,this._prefix]);

  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends AppExceptions {
  FetchDataException([String? message]) : super(message, "Error During Communication");
}

class ServerException extends AppExceptions {
  ServerException([String? message]) : super(message, "Internal Server Error");
}

class InvalidInputException extends AppExceptions {
  InvalidInputException([String? message]) : super(message, "Invalid Input");
}

class InvalidOutputException extends AppExceptions {
  InvalidOutputException([String? message]) : super(message, "Invalid Output");
}

class InvalidOperationException extends AppExceptions {
  InvalidOperationException([String? message]) : super(message, "Invalid Operation");
}

class InvalidStateException extends AppExceptions {
  InvalidStateException([String? message]) : super(message, "Invalid State");
}

class InvalidTokenException extends AppExceptions {
  InvalidTokenException([String? message]) : super(message, "Invalid Token");
}

class InvalidUrlException extends AppExceptions {
  InvalidUrlException([String? message]) : super(message, "Invalid Url");
}

class InvalidFormatException extends AppExceptions {
  InvalidFormatException([String? message]) : super(message, "Invalid Format");
}

class InvalidDataException extends AppExceptions {
  InvalidDataException([String? message]) : super(message, "Invalid Data");
}

class InvalidDataTypeException extends AppExceptions {
  InvalidDataTypeException([String? message]) : super(message, "Invalid Data Type");
}

class InvalidDataFormatException extends AppExceptions {
  InvalidDataFormatException([String? message]) : super(message, "Invalid Data Format");
}

class InternetErrorException extends AppExceptions {
  InternetErrorException([String? message]) : super(message, "Internet Error");
}

class TimeoutException extends AppExceptions {
  TimeoutException([String? message]) : super(message, "Timeout");
}

class NotFoundException extends AppExceptions {
  NotFoundException([String? message]) : super(message, "Not Found");
}

class BadRequestException extends AppExceptions {
  BadRequestException([String? message]) : super(message, "Bad Request");
}

class UnauthorizedException extends AppExceptions {
  UnauthorizedException([String? message]) : super(message, "Unauthorized");
}

class ForbiddenException extends AppExceptions {
  ForbiddenException([String? message]) : super(message, "Forbidden");
}

class ConflictException extends AppExceptions {
  ConflictException([String? message]) : super(message, "Conflict");
}
