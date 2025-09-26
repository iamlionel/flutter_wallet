// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_landing_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthLandingState {

 String get password; String get errorMessage; bool get isValid; WalletModel get wallet; AuthLandingStatus get status;
/// Create a copy of AuthLandingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthLandingStateCopyWith<AuthLandingState> get copyWith => _$AuthLandingStateCopyWithImpl<AuthLandingState>(this as AuthLandingState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthLandingState&&(identical(other.password, password) || other.password == password)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.isValid, isValid) || other.isValid == isValid)&&(identical(other.wallet, wallet) || other.wallet == wallet)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,password,errorMessage,isValid,wallet,status);

@override
String toString() {
  return 'AuthLandingState(password: $password, errorMessage: $errorMessage, isValid: $isValid, wallet: $wallet, status: $status)';
}


}

/// @nodoc
abstract mixin class $AuthLandingStateCopyWith<$Res>  {
  factory $AuthLandingStateCopyWith(AuthLandingState value, $Res Function(AuthLandingState) _then) = _$AuthLandingStateCopyWithImpl;
@useResult
$Res call({
 String password, String errorMessage, bool isValid, WalletModel wallet, AuthLandingStatus status
});


$WalletModelCopyWith<$Res> get wallet;

}
/// @nodoc
class _$AuthLandingStateCopyWithImpl<$Res>
    implements $AuthLandingStateCopyWith<$Res> {
  _$AuthLandingStateCopyWithImpl(this._self, this._then);

  final AuthLandingState _self;
  final $Res Function(AuthLandingState) _then;

/// Create a copy of AuthLandingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? password = null,Object? errorMessage = null,Object? isValid = null,Object? wallet = null,Object? status = null,}) {
  return _then(_self.copyWith(
password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,isValid: null == isValid ? _self.isValid : isValid // ignore: cast_nullable_to_non_nullable
as bool,wallet: null == wallet ? _self.wallet : wallet // ignore: cast_nullable_to_non_nullable
as WalletModel,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AuthLandingStatus,
  ));
}
/// Create a copy of AuthLandingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WalletModelCopyWith<$Res> get wallet {
  
  return $WalletModelCopyWith<$Res>(_self.wallet, (value) {
    return _then(_self.copyWith(wallet: value));
  });
}
}


/// Adds pattern-matching-related methods to [AuthLandingState].
extension AuthLandingStatePatterns on AuthLandingState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthLandingState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthLandingState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthLandingState value)  $default,){
final _that = this;
switch (_that) {
case _AuthLandingState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthLandingState value)?  $default,){
final _that = this;
switch (_that) {
case _AuthLandingState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String password,  String errorMessage,  bool isValid,  WalletModel wallet,  AuthLandingStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthLandingState() when $default != null:
return $default(_that.password,_that.errorMessage,_that.isValid,_that.wallet,_that.status);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String password,  String errorMessage,  bool isValid,  WalletModel wallet,  AuthLandingStatus status)  $default,) {final _that = this;
switch (_that) {
case _AuthLandingState():
return $default(_that.password,_that.errorMessage,_that.isValid,_that.wallet,_that.status);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String password,  String errorMessage,  bool isValid,  WalletModel wallet,  AuthLandingStatus status)?  $default,) {final _that = this;
switch (_that) {
case _AuthLandingState() when $default != null:
return $default(_that.password,_that.errorMessage,_that.isValid,_that.wallet,_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _AuthLandingState implements AuthLandingState {
  const _AuthLandingState({this.password = '', this.errorMessage = '', this.isValid = false, this.wallet = const WalletModel(), this.status = AuthLandingStatus.initial});
  

@override@JsonKey() final  String password;
@override@JsonKey() final  String errorMessage;
@override@JsonKey() final  bool isValid;
@override@JsonKey() final  WalletModel wallet;
@override@JsonKey() final  AuthLandingStatus status;

/// Create a copy of AuthLandingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthLandingStateCopyWith<_AuthLandingState> get copyWith => __$AuthLandingStateCopyWithImpl<_AuthLandingState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthLandingState&&(identical(other.password, password) || other.password == password)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.isValid, isValid) || other.isValid == isValid)&&(identical(other.wallet, wallet) || other.wallet == wallet)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,password,errorMessage,isValid,wallet,status);

@override
String toString() {
  return 'AuthLandingState(password: $password, errorMessage: $errorMessage, isValid: $isValid, wallet: $wallet, status: $status)';
}


}

/// @nodoc
abstract mixin class _$AuthLandingStateCopyWith<$Res> implements $AuthLandingStateCopyWith<$Res> {
  factory _$AuthLandingStateCopyWith(_AuthLandingState value, $Res Function(_AuthLandingState) _then) = __$AuthLandingStateCopyWithImpl;
@override @useResult
$Res call({
 String password, String errorMessage, bool isValid, WalletModel wallet, AuthLandingStatus status
});


@override $WalletModelCopyWith<$Res> get wallet;

}
/// @nodoc
class __$AuthLandingStateCopyWithImpl<$Res>
    implements _$AuthLandingStateCopyWith<$Res> {
  __$AuthLandingStateCopyWithImpl(this._self, this._then);

  final _AuthLandingState _self;
  final $Res Function(_AuthLandingState) _then;

/// Create a copy of AuthLandingState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? password = null,Object? errorMessage = null,Object? isValid = null,Object? wallet = null,Object? status = null,}) {
  return _then(_AuthLandingState(
password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,isValid: null == isValid ? _self.isValid : isValid // ignore: cast_nullable_to_non_nullable
as bool,wallet: null == wallet ? _self.wallet : wallet // ignore: cast_nullable_to_non_nullable
as WalletModel,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AuthLandingStatus,
  ));
}

/// Create a copy of AuthLandingState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WalletModelCopyWith<$Res> get wallet {
  
  return $WalletModelCopyWith<$Res>(_self.wallet, (value) {
    return _then(_self.copyWith(wallet: value));
  });
}
}

// dart format on
