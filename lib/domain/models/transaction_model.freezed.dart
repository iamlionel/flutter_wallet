// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TransactionModel {

 String get hash; String get from; String get to; String get value;// in wei (string)
 String get timeStamp;// unix timestamp string
 String get isError;// "0" = success, "1" = failed
 String get tokenSymbol; String get tokenDecimal; bool get isErc20;
/// Create a copy of TransactionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionModelCopyWith<TransactionModel> get copyWith => _$TransactionModelCopyWithImpl<TransactionModel>(this as TransactionModel, _$identity);

  /// Serializes this TransactionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionModel&&(identical(other.hash, hash) || other.hash == hash)&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to)&&(identical(other.value, value) || other.value == value)&&(identical(other.timeStamp, timeStamp) || other.timeStamp == timeStamp)&&(identical(other.isError, isError) || other.isError == isError)&&(identical(other.tokenSymbol, tokenSymbol) || other.tokenSymbol == tokenSymbol)&&(identical(other.tokenDecimal, tokenDecimal) || other.tokenDecimal == tokenDecimal)&&(identical(other.isErc20, isErc20) || other.isErc20 == isErc20));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hash,from,to,value,timeStamp,isError,tokenSymbol,tokenDecimal,isErc20);

@override
String toString() {
  return 'TransactionModel(hash: $hash, from: $from, to: $to, value: $value, timeStamp: $timeStamp, isError: $isError, tokenSymbol: $tokenSymbol, tokenDecimal: $tokenDecimal, isErc20: $isErc20)';
}


}

/// @nodoc
abstract mixin class $TransactionModelCopyWith<$Res>  {
  factory $TransactionModelCopyWith(TransactionModel value, $Res Function(TransactionModel) _then) = _$TransactionModelCopyWithImpl;
@useResult
$Res call({
 String hash, String from, String to, String value, String timeStamp, String isError, String tokenSymbol, String tokenDecimal, bool isErc20
});




}
/// @nodoc
class _$TransactionModelCopyWithImpl<$Res>
    implements $TransactionModelCopyWith<$Res> {
  _$TransactionModelCopyWithImpl(this._self, this._then);

  final TransactionModel _self;
  final $Res Function(TransactionModel) _then;

/// Create a copy of TransactionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hash = null,Object? from = null,Object? to = null,Object? value = null,Object? timeStamp = null,Object? isError = null,Object? tokenSymbol = null,Object? tokenDecimal = null,Object? isErc20 = null,}) {
  return _then(_self.copyWith(
hash: null == hash ? _self.hash : hash // ignore: cast_nullable_to_non_nullable
as String,from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as String,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,timeStamp: null == timeStamp ? _self.timeStamp : timeStamp // ignore: cast_nullable_to_non_nullable
as String,isError: null == isError ? _self.isError : isError // ignore: cast_nullable_to_non_nullable
as String,tokenSymbol: null == tokenSymbol ? _self.tokenSymbol : tokenSymbol // ignore: cast_nullable_to_non_nullable
as String,tokenDecimal: null == tokenDecimal ? _self.tokenDecimal : tokenDecimal // ignore: cast_nullable_to_non_nullable
as String,isErc20: null == isErc20 ? _self.isErc20 : isErc20 // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [TransactionModel].
extension TransactionModelPatterns on TransactionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionModel value)  $default,){
final _that = this;
switch (_that) {
case _TransactionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionModel value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String hash,  String from,  String to,  String value,  String timeStamp,  String isError,  String tokenSymbol,  String tokenDecimal,  bool isErc20)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionModel() when $default != null:
return $default(_that.hash,_that.from,_that.to,_that.value,_that.timeStamp,_that.isError,_that.tokenSymbol,_that.tokenDecimal,_that.isErc20);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String hash,  String from,  String to,  String value,  String timeStamp,  String isError,  String tokenSymbol,  String tokenDecimal,  bool isErc20)  $default,) {final _that = this;
switch (_that) {
case _TransactionModel():
return $default(_that.hash,_that.from,_that.to,_that.value,_that.timeStamp,_that.isError,_that.tokenSymbol,_that.tokenDecimal,_that.isErc20);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String hash,  String from,  String to,  String value,  String timeStamp,  String isError,  String tokenSymbol,  String tokenDecimal,  bool isErc20)?  $default,) {final _that = this;
switch (_that) {
case _TransactionModel() when $default != null:
return $default(_that.hash,_that.from,_that.to,_that.value,_that.timeStamp,_that.isError,_that.tokenSymbol,_that.tokenDecimal,_that.isErc20);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransactionModel implements TransactionModel {
  const _TransactionModel({required this.hash, required this.from, required this.to, required this.value, required this.timeStamp, required this.isError, this.tokenSymbol = '', this.tokenDecimal = '', this.isErc20 = false});
  factory _TransactionModel.fromJson(Map<String, dynamic> json) => _$TransactionModelFromJson(json);

@override final  String hash;
@override final  String from;
@override final  String to;
@override final  String value;
// in wei (string)
@override final  String timeStamp;
// unix timestamp string
@override final  String isError;
// "0" = success, "1" = failed
@override@JsonKey() final  String tokenSymbol;
@override@JsonKey() final  String tokenDecimal;
@override@JsonKey() final  bool isErc20;

/// Create a copy of TransactionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionModelCopyWith<_TransactionModel> get copyWith => __$TransactionModelCopyWithImpl<_TransactionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransactionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionModel&&(identical(other.hash, hash) || other.hash == hash)&&(identical(other.from, from) || other.from == from)&&(identical(other.to, to) || other.to == to)&&(identical(other.value, value) || other.value == value)&&(identical(other.timeStamp, timeStamp) || other.timeStamp == timeStamp)&&(identical(other.isError, isError) || other.isError == isError)&&(identical(other.tokenSymbol, tokenSymbol) || other.tokenSymbol == tokenSymbol)&&(identical(other.tokenDecimal, tokenDecimal) || other.tokenDecimal == tokenDecimal)&&(identical(other.isErc20, isErc20) || other.isErc20 == isErc20));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hash,from,to,value,timeStamp,isError,tokenSymbol,tokenDecimal,isErc20);

@override
String toString() {
  return 'TransactionModel(hash: $hash, from: $from, to: $to, value: $value, timeStamp: $timeStamp, isError: $isError, tokenSymbol: $tokenSymbol, tokenDecimal: $tokenDecimal, isErc20: $isErc20)';
}


}

/// @nodoc
abstract mixin class _$TransactionModelCopyWith<$Res> implements $TransactionModelCopyWith<$Res> {
  factory _$TransactionModelCopyWith(_TransactionModel value, $Res Function(_TransactionModel) _then) = __$TransactionModelCopyWithImpl;
@override @useResult
$Res call({
 String hash, String from, String to, String value, String timeStamp, String isError, String tokenSymbol, String tokenDecimal, bool isErc20
});




}
/// @nodoc
class __$TransactionModelCopyWithImpl<$Res>
    implements _$TransactionModelCopyWith<$Res> {
  __$TransactionModelCopyWithImpl(this._self, this._then);

  final _TransactionModel _self;
  final $Res Function(_TransactionModel) _then;

/// Create a copy of TransactionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hash = null,Object? from = null,Object? to = null,Object? value = null,Object? timeStamp = null,Object? isError = null,Object? tokenSymbol = null,Object? tokenDecimal = null,Object? isErc20 = null,}) {
  return _then(_TransactionModel(
hash: null == hash ? _self.hash : hash // ignore: cast_nullable_to_non_nullable
as String,from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as String,to: null == to ? _self.to : to // ignore: cast_nullable_to_non_nullable
as String,value: null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,timeStamp: null == timeStamp ? _self.timeStamp : timeStamp // ignore: cast_nullable_to_non_nullable
as String,isError: null == isError ? _self.isError : isError // ignore: cast_nullable_to_non_nullable
as String,tokenSymbol: null == tokenSymbol ? _self.tokenSymbol : tokenSymbol // ignore: cast_nullable_to_non_nullable
as String,tokenDecimal: null == tokenDecimal ? _self.tokenDecimal : tokenDecimal // ignore: cast_nullable_to_non_nullable
as String,isErc20: null == isErc20 ? _self.isErc20 : isErc20 // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
