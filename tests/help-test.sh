#! ./src/oi
# shellcheck shell=bash

function test_oi_--help {
  assert_successful_code oi --help;
}
