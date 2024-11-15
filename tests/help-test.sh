#! ./src/oi
# shellcheck shell=bash

function test_oi_--help {
  assert_successful_code oi --help;
}

function test_oi_--help_content {
  local help_txt;

  help_txt="$(oi --help 2>&1 > /dev/null)";

  echo "help_txt: ${help_txt}";

  assert_contains "Usage: oi [OPTIONS]" "${help_txt}";
  assert_contains "oi::log.info" "${help_txt}";
  assert_not_contains "oi::_help" "${help_txt}";
}
