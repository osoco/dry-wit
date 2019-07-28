#!/bin/bash dry-wit
# Copyright 2016-today Automated Computing Machinery S.L.
# Distributed under the terms of the GNU General Public License v3

# set -o xtrace

DW.import array;

function test_reset() {
  forEachAssociativeArrayEntryDoCalled=${FALSE};
  forEachAssociativeArrayEntryDoCalls=();
  __DW_ASSOCIATIVE_ARRAY_FOR_TESTING2=( [foo]=bar [foo2]=bar2 );
}

## Called before each test.
function test_setup() {
  test_reset;
}

## Called after each test.
function test_tearDown() {
  test_reset;
}

function forEachAssociativeArrayEntryDo_callback() {
  forEachAssociativeArrayEntryDoCalled=${TRUE};
  forEachAssociativeArrayEntryDoCalls[${1}]="${2}";
}

function forEachAssociativeArrayEntryDo_calls_the_callback_for_each_entry_test() {
  forEachAssociativeArrayEntryDo __DW_ASSOCIATIVE_ARRAY_FOR_TESTING forEachAssociativeArrayEntryDo_callback;
  Assert.isTrue ${forEachAssociativeArrayEntryDoCalled} "Callback not called in forEachAssociativeArrayEntryDo";
  Assert.isNotEmpty "${!forEachAssociativeArrayEntryDoCalls[@]}" "Callback keys are empty";
  # TODO: Understand why using the keys directly in Assert.areEqual fail.
  local _keys="${!forEachAssociativeArrayEntryDoCalls[@]}";
  Assert.areEqual "foo foo2" "${_keys}" "Callback keys are not valid";
  Assert.isNotEmpty "${forEachAssociativeArrayEntryDoCalls[*]}" "Callback keys are empty";
  Assert.areEqual "bar bar2" "${forEachAssociativeArrayEntryDoCalls[*]}" "Callback values are not valid";
}

function retrieveAssociatedArrayKeys_supports_spaces_in_keys_test() {
  retrieveAssociativeArrayKeys associativeArrayWithSpacesInKeys;
  local _keys="${RESULT}";
  Assert.isNotEmpty "${_keys}" "retrieveAssociateArrayKeys returned an empty string";
  Assert.areEqual "${_keys}" '"with spaces"' "retrieveAssociateArrayKeys returned ${_keys} and should be \"with spaces\"";
}

function clearAssociativeArray_test() {
  Assert.areEqual "${__DW_ASSOCIATIVE_ARRAY_FOR_TESTING2[foo]}" "bar" "Test is not correctly defined";
  clearAssociativeArray __DW_ASSOCIATIVE_ARRAY_FOR_TESTING2;
  Assert.areEqual "${#__DW_ASSOCIATIVE_ARRAY_FOR_TESTING2[@]}" "0" "clearAssociativeArray did'nt clear the array";
}

function isArrayEmpty_test() {
  local -a test_array=();
  Assert.functionExists "isArrayEmpty" "isArrayEmpty doesn't exist";
  Assert.isEmpty "${test_array[*]}" "test_array is not empty";
}

function nth_test() {
  local _array="a b c";
  local _position=0;
  if nth "${_array}" "${_position}"; then
    Assert.areEqual "a" "${RESULT}" "nth \"${_array}\" \"${_position}\" failed";
  else
    Assert.fail "nth \"${_array}\" \"${_position}\" failed";
  fi
}

declare -Ag __DW_ASSOCIATIVE_ARRAY_FOR_TESTING=( [foo]=bar [foo2]=bar2 );
declare -Ag __DW_ASSOCIATIVE_ARRAY_FOR_TESTING2=( [foo]=bar [foo2]=bar2 );
declare -Ag associativeArrayWithSpacesInKeys=( [with spaces]="dummy value" );
declare -Ag forEachAssociativeArrayEntryDoCalls=();
declare -ig forEachAssociativeArrayEntryDoCalled=${FALSE};
#

