// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'token_asset_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TokenAssetModel {

 String get contractAddress; String get symbol; String get decimal; String get balance;
/// Create a copy of TokenAssetModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TokenAssetModelCopyWith<TokenAssetModel> get copyWith => _$TokenAssetModelCopyWithImpl<TokenAssetModel>(this as TokenAssetModel, _$identity);

  /// Serializes this TokenAssetModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TokenAssetModel&&(identical(other.contractAddress, contractAddress) || other.contractAddress == contractAddress)&&(identical(other.symbol, symbol) || other.symbol == symbol)&&(identical(other.decimal, decimal) || other.decimal == decimal)&&(identical(other.balance, balance) || other.balance == balance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,contractAddress,symbol,decimal,balance);

@override
String toString() {
  return 'TokenAssetModel(contractAddress: $contractAddress, symbol: $symbol, decimal: $decimal, balance: $balance)';
}


}

/// @nodoc
abstract mixin class $TokenAssetModelCopyWith<$Res>  {
  factory $TokenAssetModelCopyWith(TokenAssetModel value, $Res Function(TokenAssetModel) _then) = _$TokenAssetModelCopyWithImpl;
@useResult
$Res call({
 String contractAddress, String symbol, String decimal, String balance
});




}
/// @nodoc
class _$TokenAssetModelCopyWithImpl<$Res>
    implements $TokenAssetModelCopyWith<$Res> {
  _$TokenAssetModelCopyWithImpl(this._self, this._then);

  final TokenAssetModel _self;
  final $Res Function(TokenAssetModel) _then;

/// Create a copy of TokenAssetModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? contractAddress = null,Object? symbol = null,Object? decimal = null,Object? balance = null,}) {
  return _then(_self.copyWith(
contractAddress: null == contractAddress ? _self.contractAddress : contractAddress // ignore: cast_nullable_to_non_nullable
as String,symbol: null == symbol ? _self.symbol : symbol // ignore: cast_nullable_to_non_nullable
as String,decimal: null == decimal ? _self.decimal : decimal // ignore: cast_nullable_to_non_nullable
as String,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TokenAssetModel].
extension TokenAssetModelPatterns on TokenAssetModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TokenAssetModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TokenAssetModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TokenAssetModel value)  $default,){
final _that = this;
switch (_that) {
case _TokenAssetModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TokenAssetModel value)?  $default,){
final _that = this;
switch (_that) {
case _TokenAssetModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String contractAddress,  String symbol,  String decimal,  String balance)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TokenAssetModel() when $default != null:
return $default(_that.contractAddress,_that.symbol,_that.decimal,_that.balance);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String contractAddress,  String symbol,  String decimal,  String balance)  $default,) {final _that = this;
switch (_that) {
case _TokenAssetModel():
return $default(_that.contractAddress,_that.symbol,_that.decimal,_that.balance);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String contractAddress,  String symbol,  String decimal,  String balance)?  $default,) {final _that = this;
switch (_that) {
case _TokenAssetModel() when $default != null:
return $default(_that.contractAddress,_that.symbol,_that.decimal,_that.balance);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TokenAssetModel implements TokenAssetModel {
  const _TokenAssetModel({required this.contractAddress, required this.symbol, required this.decimal, this.balance = '0'});
  factory _TokenAssetModel.fromJson(Map<String, dynamic> json) => _$TokenAssetModelFromJson(json);

@override final  String contractAddress;
@override final  String symbol;
@override final  String decimal;
@override@JsonKey() final  String balance;

/// Create a copy of TokenAssetModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TokenAssetModelCopyWith<_TokenAssetModel> get copyWith => __$TokenAssetModelCopyWithImpl<_TokenAssetModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TokenAssetModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TokenAssetModel&&(identical(other.contractAddress, contractAddress) || other.contractAddress == contractAddress)&&(identical(other.symbol, symbol) || other.symbol == symbol)&&(identical(other.decimal, decimal) || other.decimal == decimal)&&(identical(other.balance, balance) || other.balance == balance));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,contractAddress,symbol,decimal,balance);

@override
String toString() {
  return 'TokenAssetModel(contractAddress: $contractAddress, symbol: $symbol, decimal: $decimal, balance: $balance)';
}


}

/// @nodoc
abstract mixin class _$TokenAssetModelCopyWith<$Res> implements $TokenAssetModelCopyWith<$Res> {
  factory _$TokenAssetModelCopyWith(_TokenAssetModel value, $Res Function(_TokenAssetModel) _then) = __$TokenAssetModelCopyWithImpl;
@override @useResult
$Res call({
 String contractAddress, String symbol, String decimal, String balance
});




}
/// @nodoc
class __$TokenAssetModelCopyWithImpl<$Res>
    implements _$TokenAssetModelCopyWith<$Res> {
  __$TokenAssetModelCopyWithImpl(this._self, this._then);

  final _TokenAssetModel _self;
  final $Res Function(_TokenAssetModel) _then;

/// Create a copy of TokenAssetModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? contractAddress = null,Object? symbol = null,Object? decimal = null,Object? balance = null,}) {
  return _then(_TokenAssetModel(
contractAddress: null == contractAddress ? _self.contractAddress : contractAddress // ignore: cast_nullable_to_non_nullable
as String,symbol: null == symbol ? _self.symbol : symbol // ignore: cast_nullable_to_non_nullable
as String,decimal: null == decimal ? _self.decimal : decimal // ignore: cast_nullable_to_non_nullable
as String,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
