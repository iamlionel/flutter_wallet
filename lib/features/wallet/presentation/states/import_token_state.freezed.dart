// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'import_token_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ImportTokenState {

 String get contractAddress; String get tokenSymbol; String get tokenDecimal; ImportTokenStatus get status;
/// Create a copy of ImportTokenState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImportTokenStateCopyWith<ImportTokenState> get copyWith => _$ImportTokenStateCopyWithImpl<ImportTokenState>(this as ImportTokenState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImportTokenState&&(identical(other.contractAddress, contractAddress) || other.contractAddress == contractAddress)&&(identical(other.tokenSymbol, tokenSymbol) || other.tokenSymbol == tokenSymbol)&&(identical(other.tokenDecimal, tokenDecimal) || other.tokenDecimal == tokenDecimal)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,contractAddress,tokenSymbol,tokenDecimal,status);

@override
String toString() {
  return 'ImportTokenState(contractAddress: $contractAddress, tokenSymbol: $tokenSymbol, tokenDecimal: $tokenDecimal, status: $status)';
}


}

/// @nodoc
abstract mixin class $ImportTokenStateCopyWith<$Res>  {
  factory $ImportTokenStateCopyWith(ImportTokenState value, $Res Function(ImportTokenState) _then) = _$ImportTokenStateCopyWithImpl;
@useResult
$Res call({
 String contractAddress, String tokenSymbol, String tokenDecimal, ImportTokenStatus status
});




}
/// @nodoc
class _$ImportTokenStateCopyWithImpl<$Res>
    implements $ImportTokenStateCopyWith<$Res> {
  _$ImportTokenStateCopyWithImpl(this._self, this._then);

  final ImportTokenState _self;
  final $Res Function(ImportTokenState) _then;

/// Create a copy of ImportTokenState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? contractAddress = null,Object? tokenSymbol = null,Object? tokenDecimal = null,Object? status = null,}) {
  return _then(_self.copyWith(
contractAddress: null == contractAddress ? _self.contractAddress : contractAddress // ignore: cast_nullable_to_non_nullable
as String,tokenSymbol: null == tokenSymbol ? _self.tokenSymbol : tokenSymbol // ignore: cast_nullable_to_non_nullable
as String,tokenDecimal: null == tokenDecimal ? _self.tokenDecimal : tokenDecimal // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ImportTokenStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [ImportTokenState].
extension ImportTokenStatePatterns on ImportTokenState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ImportTokenState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ImportTokenState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ImportTokenState value)  $default,){
final _that = this;
switch (_that) {
case _ImportTokenState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ImportTokenState value)?  $default,){
final _that = this;
switch (_that) {
case _ImportTokenState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String contractAddress,  String tokenSymbol,  String tokenDecimal,  ImportTokenStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ImportTokenState() when $default != null:
return $default(_that.contractAddress,_that.tokenSymbol,_that.tokenDecimal,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String contractAddress,  String tokenSymbol,  String tokenDecimal,  ImportTokenStatus status)  $default,) {final _that = this;
switch (_that) {
case _ImportTokenState():
return $default(_that.contractAddress,_that.tokenSymbol,_that.tokenDecimal,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String contractAddress,  String tokenSymbol,  String tokenDecimal,  ImportTokenStatus status)?  $default,) {final _that = this;
switch (_that) {
case _ImportTokenState() when $default != null:
return $default(_that.contractAddress,_that.tokenSymbol,_that.tokenDecimal,_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _ImportTokenState implements ImportTokenState {
  const _ImportTokenState({this.contractAddress = '', this.tokenSymbol = '', this.tokenDecimal = '', this.status = ImportTokenStatus.initial});
  

@override@JsonKey() final  String contractAddress;
@override@JsonKey() final  String tokenSymbol;
@override@JsonKey() final  String tokenDecimal;
@override@JsonKey() final  ImportTokenStatus status;

/// Create a copy of ImportTokenState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ImportTokenStateCopyWith<_ImportTokenState> get copyWith => __$ImportTokenStateCopyWithImpl<_ImportTokenState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ImportTokenState&&(identical(other.contractAddress, contractAddress) || other.contractAddress == contractAddress)&&(identical(other.tokenSymbol, tokenSymbol) || other.tokenSymbol == tokenSymbol)&&(identical(other.tokenDecimal, tokenDecimal) || other.tokenDecimal == tokenDecimal)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,contractAddress,tokenSymbol,tokenDecimal,status);

@override
String toString() {
  return 'ImportTokenState(contractAddress: $contractAddress, tokenSymbol: $tokenSymbol, tokenDecimal: $tokenDecimal, status: $status)';
}


}

/// @nodoc
abstract mixin class _$ImportTokenStateCopyWith<$Res> implements $ImportTokenStateCopyWith<$Res> {
  factory _$ImportTokenStateCopyWith(_ImportTokenState value, $Res Function(_ImportTokenState) _then) = __$ImportTokenStateCopyWithImpl;
@override @useResult
$Res call({
 String contractAddress, String tokenSymbol, String tokenDecimal, ImportTokenStatus status
});




}
/// @nodoc
class __$ImportTokenStateCopyWithImpl<$Res>
    implements _$ImportTokenStateCopyWith<$Res> {
  __$ImportTokenStateCopyWithImpl(this._self, this._then);

  final _ImportTokenState _self;
  final $Res Function(_ImportTokenState) _then;

/// Create a copy of ImportTokenState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? contractAddress = null,Object? tokenSymbol = null,Object? tokenDecimal = null,Object? status = null,}) {
  return _then(_ImportTokenState(
contractAddress: null == contractAddress ? _self.contractAddress : contractAddress // ignore: cast_nullable_to_non_nullable
as String,tokenSymbol: null == tokenSymbol ? _self.tokenSymbol : tokenSymbol // ignore: cast_nullable_to_non_nullable
as String,tokenDecimal: null == tokenDecimal ? _self.tokenDecimal : tokenDecimal // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ImportTokenStatus,
  ));
}


}

// dart format on
