// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'seed_phrase_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SeedPhraseState {

 List<String> get mnemonics; List<String> get randomMnemonics; List<String> get confirmMnemonics; String get errorMessage; bool get isMnemonicsValid; SeedPhraseStatus get status;// 添加你在 copyWith 中提到但在构造函数中缺少的字段
 String? get generatedSeedHex; String? get confirmSeedHex; String? get generatedSeedEntropy; String? get confirmEntropy;
/// Create a copy of SeedPhraseState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SeedPhraseStateCopyWith<SeedPhraseState> get copyWith => _$SeedPhraseStateCopyWithImpl<SeedPhraseState>(this as SeedPhraseState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SeedPhraseState&&const DeepCollectionEquality().equals(other.mnemonics, mnemonics)&&const DeepCollectionEquality().equals(other.randomMnemonics, randomMnemonics)&&const DeepCollectionEquality().equals(other.confirmMnemonics, confirmMnemonics)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.isMnemonicsValid, isMnemonicsValid) || other.isMnemonicsValid == isMnemonicsValid)&&(identical(other.status, status) || other.status == status)&&(identical(other.generatedSeedHex, generatedSeedHex) || other.generatedSeedHex == generatedSeedHex)&&(identical(other.confirmSeedHex, confirmSeedHex) || other.confirmSeedHex == confirmSeedHex)&&(identical(other.generatedSeedEntropy, generatedSeedEntropy) || other.generatedSeedEntropy == generatedSeedEntropy)&&(identical(other.confirmEntropy, confirmEntropy) || other.confirmEntropy == confirmEntropy));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(mnemonics),const DeepCollectionEquality().hash(randomMnemonics),const DeepCollectionEquality().hash(confirmMnemonics),errorMessage,isMnemonicsValid,status,generatedSeedHex,confirmSeedHex,generatedSeedEntropy,confirmEntropy);

@override
String toString() {
  return 'SeedPhraseState(mnemonics: $mnemonics, randomMnemonics: $randomMnemonics, confirmMnemonics: $confirmMnemonics, errorMessage: $errorMessage, isMnemonicsValid: $isMnemonicsValid, status: $status, generatedSeedHex: $generatedSeedHex, confirmSeedHex: $confirmSeedHex, generatedSeedEntropy: $generatedSeedEntropy, confirmEntropy: $confirmEntropy)';
}


}

/// @nodoc
abstract mixin class $SeedPhraseStateCopyWith<$Res>  {
  factory $SeedPhraseStateCopyWith(SeedPhraseState value, $Res Function(SeedPhraseState) _then) = _$SeedPhraseStateCopyWithImpl;
@useResult
$Res call({
 List<String> mnemonics, List<String> randomMnemonics, List<String> confirmMnemonics, String errorMessage, bool isMnemonicsValid, SeedPhraseStatus status, String? generatedSeedHex, String? confirmSeedHex, String? generatedSeedEntropy, String? confirmEntropy
});




}
/// @nodoc
class _$SeedPhraseStateCopyWithImpl<$Res>
    implements $SeedPhraseStateCopyWith<$Res> {
  _$SeedPhraseStateCopyWithImpl(this._self, this._then);

  final SeedPhraseState _self;
  final $Res Function(SeedPhraseState) _then;

/// Create a copy of SeedPhraseState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mnemonics = null,Object? randomMnemonics = null,Object? confirmMnemonics = null,Object? errorMessage = null,Object? isMnemonicsValid = null,Object? status = null,Object? generatedSeedHex = freezed,Object? confirmSeedHex = freezed,Object? generatedSeedEntropy = freezed,Object? confirmEntropy = freezed,}) {
  return _then(_self.copyWith(
mnemonics: null == mnemonics ? _self.mnemonics : mnemonics // ignore: cast_nullable_to_non_nullable
as List<String>,randomMnemonics: null == randomMnemonics ? _self.randomMnemonics : randomMnemonics // ignore: cast_nullable_to_non_nullable
as List<String>,confirmMnemonics: null == confirmMnemonics ? _self.confirmMnemonics : confirmMnemonics // ignore: cast_nullable_to_non_nullable
as List<String>,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,isMnemonicsValid: null == isMnemonicsValid ? _self.isMnemonicsValid : isMnemonicsValid // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SeedPhraseStatus,generatedSeedHex: freezed == generatedSeedHex ? _self.generatedSeedHex : generatedSeedHex // ignore: cast_nullable_to_non_nullable
as String?,confirmSeedHex: freezed == confirmSeedHex ? _self.confirmSeedHex : confirmSeedHex // ignore: cast_nullable_to_non_nullable
as String?,generatedSeedEntropy: freezed == generatedSeedEntropy ? _self.generatedSeedEntropy : generatedSeedEntropy // ignore: cast_nullable_to_non_nullable
as String?,confirmEntropy: freezed == confirmEntropy ? _self.confirmEntropy : confirmEntropy // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SeedPhraseState].
extension SeedPhraseStatePatterns on SeedPhraseState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SeedPhraseState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SeedPhraseState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SeedPhraseState value)  $default,){
final _that = this;
switch (_that) {
case _SeedPhraseState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SeedPhraseState value)?  $default,){
final _that = this;
switch (_that) {
case _SeedPhraseState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> mnemonics,  List<String> randomMnemonics,  List<String> confirmMnemonics,  String errorMessage,  bool isMnemonicsValid,  SeedPhraseStatus status,  String? generatedSeedHex,  String? confirmSeedHex,  String? generatedSeedEntropy,  String? confirmEntropy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SeedPhraseState() when $default != null:
return $default(_that.mnemonics,_that.randomMnemonics,_that.confirmMnemonics,_that.errorMessage,_that.isMnemonicsValid,_that.status,_that.generatedSeedHex,_that.confirmSeedHex,_that.generatedSeedEntropy,_that.confirmEntropy);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> mnemonics,  List<String> randomMnemonics,  List<String> confirmMnemonics,  String errorMessage,  bool isMnemonicsValid,  SeedPhraseStatus status,  String? generatedSeedHex,  String? confirmSeedHex,  String? generatedSeedEntropy,  String? confirmEntropy)  $default,) {final _that = this;
switch (_that) {
case _SeedPhraseState():
return $default(_that.mnemonics,_that.randomMnemonics,_that.confirmMnemonics,_that.errorMessage,_that.isMnemonicsValid,_that.status,_that.generatedSeedHex,_that.confirmSeedHex,_that.generatedSeedEntropy,_that.confirmEntropy);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> mnemonics,  List<String> randomMnemonics,  List<String> confirmMnemonics,  String errorMessage,  bool isMnemonicsValid,  SeedPhraseStatus status,  String? generatedSeedHex,  String? confirmSeedHex,  String? generatedSeedEntropy,  String? confirmEntropy)?  $default,) {final _that = this;
switch (_that) {
case _SeedPhraseState() when $default != null:
return $default(_that.mnemonics,_that.randomMnemonics,_that.confirmMnemonics,_that.errorMessage,_that.isMnemonicsValid,_that.status,_that.generatedSeedHex,_that.confirmSeedHex,_that.generatedSeedEntropy,_that.confirmEntropy);case _:
  return null;

}
}

}

/// @nodoc


class _SeedPhraseState implements SeedPhraseState {
  const _SeedPhraseState({final  List<String> mnemonics = const [], final  List<String> randomMnemonics = const [], final  List<String> confirmMnemonics = const [], this.errorMessage = '', this.isMnemonicsValid = false, this.status = SeedPhraseStatus.initial, this.generatedSeedHex, this.confirmSeedHex, this.generatedSeedEntropy, this.confirmEntropy}): _mnemonics = mnemonics,_randomMnemonics = randomMnemonics,_confirmMnemonics = confirmMnemonics;
  

 final  List<String> _mnemonics;
@override@JsonKey() List<String> get mnemonics {
  if (_mnemonics is EqualUnmodifiableListView) return _mnemonics;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_mnemonics);
}

 final  List<String> _randomMnemonics;
@override@JsonKey() List<String> get randomMnemonics {
  if (_randomMnemonics is EqualUnmodifiableListView) return _randomMnemonics;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_randomMnemonics);
}

 final  List<String> _confirmMnemonics;
@override@JsonKey() List<String> get confirmMnemonics {
  if (_confirmMnemonics is EqualUnmodifiableListView) return _confirmMnemonics;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_confirmMnemonics);
}

@override@JsonKey() final  String errorMessage;
@override@JsonKey() final  bool isMnemonicsValid;
@override@JsonKey() final  SeedPhraseStatus status;
// 添加你在 copyWith 中提到但在构造函数中缺少的字段
@override final  String? generatedSeedHex;
@override final  String? confirmSeedHex;
@override final  String? generatedSeedEntropy;
@override final  String? confirmEntropy;

/// Create a copy of SeedPhraseState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SeedPhraseStateCopyWith<_SeedPhraseState> get copyWith => __$SeedPhraseStateCopyWithImpl<_SeedPhraseState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SeedPhraseState&&const DeepCollectionEquality().equals(other._mnemonics, _mnemonics)&&const DeepCollectionEquality().equals(other._randomMnemonics, _randomMnemonics)&&const DeepCollectionEquality().equals(other._confirmMnemonics, _confirmMnemonics)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage)&&(identical(other.isMnemonicsValid, isMnemonicsValid) || other.isMnemonicsValid == isMnemonicsValid)&&(identical(other.status, status) || other.status == status)&&(identical(other.generatedSeedHex, generatedSeedHex) || other.generatedSeedHex == generatedSeedHex)&&(identical(other.confirmSeedHex, confirmSeedHex) || other.confirmSeedHex == confirmSeedHex)&&(identical(other.generatedSeedEntropy, generatedSeedEntropy) || other.generatedSeedEntropy == generatedSeedEntropy)&&(identical(other.confirmEntropy, confirmEntropy) || other.confirmEntropy == confirmEntropy));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_mnemonics),const DeepCollectionEquality().hash(_randomMnemonics),const DeepCollectionEquality().hash(_confirmMnemonics),errorMessage,isMnemonicsValid,status,generatedSeedHex,confirmSeedHex,generatedSeedEntropy,confirmEntropy);

@override
String toString() {
  return 'SeedPhraseState(mnemonics: $mnemonics, randomMnemonics: $randomMnemonics, confirmMnemonics: $confirmMnemonics, errorMessage: $errorMessage, isMnemonicsValid: $isMnemonicsValid, status: $status, generatedSeedHex: $generatedSeedHex, confirmSeedHex: $confirmSeedHex, generatedSeedEntropy: $generatedSeedEntropy, confirmEntropy: $confirmEntropy)';
}


}

/// @nodoc
abstract mixin class _$SeedPhraseStateCopyWith<$Res> implements $SeedPhraseStateCopyWith<$Res> {
  factory _$SeedPhraseStateCopyWith(_SeedPhraseState value, $Res Function(_SeedPhraseState) _then) = __$SeedPhraseStateCopyWithImpl;
@override @useResult
$Res call({
 List<String> mnemonics, List<String> randomMnemonics, List<String> confirmMnemonics, String errorMessage, bool isMnemonicsValid, SeedPhraseStatus status, String? generatedSeedHex, String? confirmSeedHex, String? generatedSeedEntropy, String? confirmEntropy
});




}
/// @nodoc
class __$SeedPhraseStateCopyWithImpl<$Res>
    implements _$SeedPhraseStateCopyWith<$Res> {
  __$SeedPhraseStateCopyWithImpl(this._self, this._then);

  final _SeedPhraseState _self;
  final $Res Function(_SeedPhraseState) _then;

/// Create a copy of SeedPhraseState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mnemonics = null,Object? randomMnemonics = null,Object? confirmMnemonics = null,Object? errorMessage = null,Object? isMnemonicsValid = null,Object? status = null,Object? generatedSeedHex = freezed,Object? confirmSeedHex = freezed,Object? generatedSeedEntropy = freezed,Object? confirmEntropy = freezed,}) {
  return _then(_SeedPhraseState(
mnemonics: null == mnemonics ? _self._mnemonics : mnemonics // ignore: cast_nullable_to_non_nullable
as List<String>,randomMnemonics: null == randomMnemonics ? _self._randomMnemonics : randomMnemonics // ignore: cast_nullable_to_non_nullable
as List<String>,confirmMnemonics: null == confirmMnemonics ? _self._confirmMnemonics : confirmMnemonics // ignore: cast_nullable_to_non_nullable
as List<String>,errorMessage: null == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String,isMnemonicsValid: null == isMnemonicsValid ? _self.isMnemonicsValid : isMnemonicsValid // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SeedPhraseStatus,generatedSeedHex: freezed == generatedSeedHex ? _self.generatedSeedHex : generatedSeedHex // ignore: cast_nullable_to_non_nullable
as String?,confirmSeedHex: freezed == confirmSeedHex ? _self.confirmSeedHex : confirmSeedHex // ignore: cast_nullable_to_non_nullable
as String?,generatedSeedEntropy: freezed == generatedSeedEntropy ? _self.generatedSeedEntropy : generatedSeedEntropy // ignore: cast_nullable_to_non_nullable
as String?,confirmEntropy: freezed == confirmEntropy ? _self.confirmEntropy : confirmEntropy // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
