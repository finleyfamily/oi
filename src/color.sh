#! /usr/bin/env zsh
# shellcheck shell=bash
# ==============================================================================

function oi::color.reset() {
  #
  # Reset color output (background and foreground colors).
  #
  echo -n -e "${__OI_COLORS_RESET}";
}

function oi::color.default() {
  #
  # Set default output color.
  #
  echo -n -e "${__OI_COLORS_DEFAULT}";
}

function oi::color.black() {
  #
  # Set font output color to black.
  #
  echo -n -e "${__OI_COLORS_BLACK}";
}

function oi::color.red() {
  #
  # Set font output color to red.
  #
  echo -n -e "${__OI_COLORS_RED}";
}

function oi::color.green() {
  #
  # Set font output color to green.
  #
  echo -n -e "${__OI_COLORS_GREEN}";
}

function oi::color.yellow() {
  #
  # Set font output color to yellow.
  #
  echo -n -e "${__OI_COLORS_YELLOW}";
}

function oi::color.blue() {
  #
  # Set font output color to blue.
  #
  echo -n -e "${__OI_COLORS_BLUE}";
}

function oi::color.magenta() {
  #
  # Set font output color to magenta.
  #
  echo -n -e "${__OI_COLORS_MAGENTA}";
}

function oi::color.cyan() {
  #
  # Set font output color to cyan.
  #
  echo -n -e "${__OI_COLORS_CYAN}";
}

function oi::color.bg.default() {
  #
  # Set font output color background to default.
  #
  echo -n -e "${__OI_COLORS_BG_DEFAULT}";
}

function oi::color.bg.black() {
  #
  # Set font output color background to black.
  #
  echo -n -e "${__OI_COLORS_BG_BLACK}";
}

function oi::color.bg.red() {
  #
  # Set font output color background to red.
  #
  echo -n -e "${__OI_COLORS_BG_RED}";
}

function oi::color.bg.green() {
  #
  # Set font output color background to green.
  #
  echo -n -e "${__OI_COLORS_BG_GREEN}";
}

function oi::color.bg.yellow() {
  #
  # Set font output color background to yellow.
  #
  echo -n -e "${__OI_COLORS_BG_YELLOW}";
}

function oi::color.bg.blue() {
  #
  # Set font output color background to blue.
  #
  echo -n -e "${__OI_COLORS_BG_BLUE}";
}

function oi::color.bg.magenta() {
  #
  # Set font output color background to magenta.
  #
  echo -n -e "${__OI_COLORS_BG_MAGENTA}";
}

function oi::color.bg.cyan() {
  #
  # Set font output color background to cyan.
  #
  echo -n -e "${__OI_COLORS_BG_CYAN}";
}

function oi::color.bg.white() {
  #
  # Set font output color background to white.
  #
  echo -n -e "${__OI_COLORS_BG_WHITE}";
}

function oi::color.bold.default() {
  #
  # Set default output color.
  #
  echo -n -e "${__OI_COLORS_BOLD_DEFAULT}";
}

function oi::color.bold.black() {
  #
  # Set font output color to black.
  #
  echo -n -e "${__OI_COLORS_BOLD_BLACK}";
}

function oi::color.bold.red() {
  #
  # Set font output color to red.
  #
  echo -n -e "${__OI_COLORS_BOLD_RED}";
}

function oi::color.bold.green() {
  #
  # Set font output color to green.
  #
  echo -n -e "${__OI_COLORS_BOLD_GREEN}";
}

function oi::color.bold.yellow() {
  #
  # Set font output color to yellow.
  #
  echo -n -e "${__OI_COLORS_BOLD_YELLOW}";
}

function oi::color.bold.blue() {
  #
  # Set font output color to blue.
  #
  echo -n -e "${__OI_COLORS_BOLD_BLUE}";
}

function oi::color.bold.magenta() {
  #
  # Set font output color to magenta.
  #
  echo -n -e "${__OI_COLORS_BOLD_MAGENTA}";
}

function oi::color.bold.cyan() {
  #
  # Set font output color to cyan.
  #
  echo -n -e "${__OI_COLORS_BOLD_CYAN}";
}

function oi::color.dim.default() {
  #
  # Set default output color.
  #
  echo -n -e "${__OI_COLORS_DIM_DEFAULT}";
}

function oi::color.dim.black() {
  #
  # Set font output color to black.
  #
  echo -n -e "${__OI_COLORS_DIM_BLACK}";
}

function oi::color.dim.red() {
  #
  # Set font output color to red.
  #
  echo -n -e "${__OI_COLORS_DIM_RED}";
}

function oi::color.dim.green() {
  #
  # Set font output color to green.
  #
  echo -n -e "${__OI_COLORS_DIM_GREEN}";
}

function oi::color.dim.yellow() {
  #
  # Set font output color to yellow.
  #
  echo -n -e "${__OI_COLORS_DIM_YELLOW}";
}

function oi::color.dim.blue() {
  #
  # Set font output color to blue.
  #
  echo -n -e "${__OI_COLORS_DIM_BLUE}";
}

function oi::color.dim.magenta() {
  #
  # Set font output color to magenta.
  #
  echo -n -e "${__OI_COLORS_DIM_MAGENTA}";
}

function oi::color.dim.cyan() {
  #
  # Set font output color to cyan.
  #
  echo -n -e "${__OI_COLORS_DIM_CYAN}";
}
