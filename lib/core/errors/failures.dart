// failures.dart
abstract class Failure {}

class ServerFailure extends Failure {}

class OfflineFailure extends Failure {}

class CacheFailure extends Failure {}

class OfflinePromptFailure extends Failure {}

class OfflineDeleteFailure extends Failure {}

class EmailAlreadyInUseFailure extends Failure {}

class NotAuthenticatedFailure extends Failure {}

class SignInAbortedFailure extends Failure {}

class InvalidCredentialFailure extends Failure {}

class EmailNotVerifiedFailure extends Failure {}

class TooManyRequestsFailure extends Failure {}

class ModelFailure extends Failure {}
