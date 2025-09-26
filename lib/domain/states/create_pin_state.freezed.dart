// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_pin_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CreatePinState {

 String get password; String get confirmPassword; bool get isValid; CreatePinStatus get status; WalletModel get wallet;
/// Create a copy of CreatePinState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreatePinStateCopyWith<CreatePinState> get copyWith => _$CreatePinStateCopyWithImpl<CreatePinState>(this as CreatePinState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreatePinState&&(identical(other.password, password) || other.password == password)&&(identical(other.confirmPassword, confirmPassword) || other.confirmPassword == confirmPassword)&&(identical(other.isValid, isValid) || other.isValid == isValid)&&(identical(other.status, status) || other.status == status)&&(identical(other.wallet, wallet) || other.wallet == wallet));
}


@override
int get hashCode => Object.hash(runtimeType,password,confirmPassword,isValid,status,wallet);

@override
String toString() {
  return 'CreatePinState(password: $password, confirmPassword: $confirmPassword, isValid: $isValid, status: $status, wallet: $wallet)';
}


}

/// @nodoc
abstract mixin class $CreatePinStateCopyWith<$Res>  {
  factory $CreatePinStateCopyWith(CreatePinState value, $Res Function(CreatePinState) _then) = _$CreatePinStateCopyWithImpl;
@useResult
$Res call({
 String password, String confirmPassword, bool isValid, CreatePinStatus status, WalletModel wallet
});


$WalletModelCopyWith<$Res> get wallet;

}
/// @nodoc
class _$CreatePinStateCopyWithImpl<$Res>
    implements $CreatePinStateCopyWith<$Res> {
  _$CreatePinStateCopyWithImpl(this._self, this._then);

  final CreatePinState _self;
  final $Res Function(CreatePinState) _then;

/// Create a copy of CreatePinState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? password = null,Object? confirmPassword = null,Object? isValid = null,Object? status = null,Object? wallet = null,}) {
  return _then(_self.copyWith(
password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,confirmPassword: null == confirmPassword ? _self.confirmPassword : confirmPassword // ignore: cast_nullable_to_non_nullable
as String,isValid: null == isValid ? _self.isValid : isValid // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CreatePinStatus,wallet: null == wallet ? _self.wallet : wallet // ignore: cast_nullable_to_non_nullable
as WalletModel,
  ));
}
/// Create a copy of CreatePinState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WalletModelCopyWith<$Res> get wallet {
  
  return $WalletModelCopyWith<$Res>(_self.wallet, (value) {
    return _then(_self.copyWith(wallet: value));
  });
}
}


/// Adds pattern-matching-related methods to [CreatePinState].
extension CreatePinStatePatterns on CreatePinState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreatePinState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreatePinState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreatePinState value)  $default,){
final _that = this;
switch (_that) {
case _CreatePinState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreatePinState value)?  $default,){
final _that = this;
switch (_that) {
case _CreatePinState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String password,  String confirmPassword,  bool isValid,  CreatePinStatus status,  WalletModel wallet)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreatePinState() when $default != null:
return $default(_that.password,_that.confirmPassword,_that.isValid,_that.status,_that.wallet);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String password,  String confirmPassword,  bool isValid,  CreatePinStatus status,  WalletModel wallet)  $default,) {final _that = this;
switch (_that) {
case _CreatePinState():
return $default(_that.password,_that.confirmPassword,_that.isValid,_that.status,_that.wallet);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String password,  String confirmPassword,  bool isValid,  CreatePinStatus status,  WalletModel wallet)?  $default,) {final _that = this;
switch (_that) {
case _CreatePinState() when $default != null:
return $default(_that.password,_that.confirmPassword,_that.isValid,_that.status,_that.wallet);case _:
  return null;

}
}

}

/// @nodoc


class _CreatePinState implements CreatePinState {
  const _CreatePinState({this.password = '', this.confirmPassword = '', this.isValid = false, this.status = CreatePinStatus.initial, this.wallet = const WalletModel()});
  

@override@JsonKey() final  String password;
@override@JsonKey() final  String confirmPassword;
@override@JsonKey() final  bool isValid;
@override@JsonKey() final  CreatePinStatus status;
@override@JsonKey() final  WalletModel wallet;

/// Create a copy of CreatePinState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreatePinStateCopyWith<_CreatePinState> get copyWith => __$CreatePinStateCopyWithImpl<_CreatePinState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreatePinState&&(identical(other.password, password) || other.password == password)&&(identical(other.confirmPassword, confirmPassword) || other.confirmPassword == confirmPassword)&&(identical(other.isValid, isValid) || other.isValid == isValid)&&(identical(other.status, status) || other.status == status)&&(identical(other.wallet, wallet) || other.wallet == wallet));
}


@override
int get hashCode => Object.hash(runtimeType,password,confirmPassword,isValid,status,wallet);

@override
String toString() {
  return 'CreatePinState(password: $password, confirmPassword: $confirmPassword, isValid: $isValid, status: $status, wallet: $wallet)';
}


}

/// @nodoc
abstract mixin class _$CreatePinStateCopyWith<$Res> implements $CreatePinStateCopyWith<$Res> {
  factory _$CreatePinStateCopyWith(_CreatePinState value, $Res Function(_CreatePinState) _then) = __$CreatePinStateCopyWithImpl;
@override @useResult
$Res call({
 String password, String confirmPassword, bool isValid, CreatePinStatus status, WalletModel wallet
});


@override $WalletModelCopyWith<$Res> get wallet;

}
/// @nodoc
class __$CreatePinStateCopyWithImpl<$Res>
    implements _$CreatePinStateCopyWith<$Res> {
  __$CreatePinStateCopyWithImpl(this._self, this._then);

  final _CreatePinState _self;
  final $Res Function(_CreatePinState) _then;

/// Create a copy of CreatePinState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? password = null,Object? confirmPassword = null,Object? isValid = null,Object? status = null,Object? wallet = null,}) {
  return _then(_CreatePinState(
password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,confirmPassword: null == confirmPassword ? _self.confirmPassword : confirmPassword // ignore: cast_nullable_to_non_nullable
as String,isValid: null == isValid ? _self.isValid : isValid // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CreatePinStatus,wallet: null == wallet ? _self.wallet : wallet // ignore: cast_nullable_to_non_nullable
as WalletModel,
  ));
}

/// Create a copy of CreatePinState
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
