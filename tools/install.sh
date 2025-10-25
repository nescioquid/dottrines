#!/usr/bin/env sh
#
# Install Dottrines — Nescioquid’s dotfiles
#
# Run via curl:
#   sh -c "$(curl -fsSL https://raw.githubusercontent.com/nescioquid/dottrines/main/tools/install.sh)"
#
# Options:
#   --unattended  Run without prompts or interactivity
#

set -eu

# ---------------------------------------------
# 🎨 Format colors
# ---------------------------------------------
is_tty() { [ -t 1 ]; }

supports_truecolor() {
  colorterm_val="${COLORTERM-}" # default to empty if unset
  term_val="${TERM-}"           # default to empty if unset

  case "$colorterm_val" in
    truecolor|24bit) return 0 ;;
  esac
  case "$term_val" in
    *-truecolor|*-256color) return 0 ;;
  esac
  return 1
}

setup_colors() {
  if ! is_tty; then
    RED=""; DARK_GREEN=""; GREEN=""; ORANGE=""; YELLOW=""; CYAN=""; BOLD=""; ITALIC=""; RESET=""
    return
  fi

  if supports_truecolor; then
    RED=$(printf '\033[38;2;255;85;85m')         # bright red
    DARK_GREEN=$(printf '\033[38;2;80;250;123m') # vivid green
    GREEN=$(printf '\033[38;2;144;238;144m')     # light green
    ORANGE=$(printf '\033[38;2;255;165;0m')      # orange
    YELLOW=$(printf '\033[38;2;241;250;140m')    # soft yellow
    CYAN=$(printf '\033[38;2;139;233;253m')      # light cyan
  else
    RED=$(printf '\033[31m')
    DARK_GREEN=$(printf '\033[32m')
    GREEN=$(printf '\033[92m')                   # bright green as fallback
    ORANGE=$(printf '\033[33m')                  # reuse yellow slot for orange fallback
    YELLOW=$(printf '\033[33m')
    CYAN=$(printf '\033[36m')
  fi

  BOLD=$(printf '\033[1m')
  ITALIC=$(printf '\033[3m')
  RESET=$(printf '\033[0m')
}

log()     { printf '%b %s\n' "${CYAN}>${RESET}" "$*"; }
success() { printf '%b %s\n' "${GREEN}•${RESET}" "$*"; }
warn()    { printf '%b %s\n' "${YELLOW}!${RESET}" "$*"; }
error()   { printf '%b %s\n' "${RED}•${RESET}" "$*" >&2; }

# ---------------------------------------------
# ⚙️ Configuration
# ---------------------------------------------
REPO_URL="https://github.com/nescioquid/dottrines.git"
BRANCH="main"
DOTTRINES_DIR="$HOME/.dottrines"
HOME_DIR="$HOME"
# RELOAD_SHELL=yes
UNATTENDED=no

HAS_BASH=no
HAS_ZSH=no
HAS_OMZ=no

# ---------------------------------------------
# 🧩 Parse arguments
# ---------------------------------------------
  parse_args() {
  while [ $# -gt 0 ]; do
    case "$1" in
      # --no-reload) RELOAD_SHELL=no ;;
      --unattended) UNATTENDED=yes ;;
    esac
    shift
  done
}

# ---------------------------------------------
# 🧠 Print Header
# ---------------------------------------------
print_intro() {
  printf '%b•.·.°•.·.°•.·.°•.·.°•.·.°•.·.°•.·.°•.·.°•.·.°•.·.°•.·.°•.·.°•.·.°•.·.°•.·.°•%b\n\n' "$BOLD$CYAN" "$RESET"

  printf '•    "%bA dotfiles manager for true believers of the orthodotsy%b."\n\n' "$BOLD$ITALIC" "$RESET"

  printf '        --Nescioquid, %bPrimus Inter Orthodotos%b\n\n' "$ITALIC" "$RESET"

  printf   '      %b╭────────────────────────────────────────────╮%b\n' "$BOLD$CYAN" "$RESET"
  printf   '      %b│ °•.·%b%b.°•.·%b%b.°•.%b  %bINDOTTRINATE%b  %b.•°.%b%b·.•°.%b%b·.•° │%b\n' "$BOLD$CYAN" "$RESET" "$BOLD$RED" "$RESET" "$BOLD$CYAN" "$RESET" "$BOLD$RED" "$RESET" "$BOLD$CYAN" "$RESET" "$BOLD$RED" "$RESET" "$BOLD$CYAN" "$RESET"
  printf   '      %b│ °•.·%b%b.°•.·%b%b.°•.%b  %bTHE%b           %b.•°.%b%b·.•°.%b%b·.•° │%b\n' "$BOLD$CYAN" "$RESET" "$BOLD$RED" "$RESET" "$BOLD$CYAN" "$RESET" "$BOLD$RED" "$RESET" "$BOLD$CYAN" "$RESET" "$BOLD$RED" "$RESET" "$BOLD$CYAN" "$RESET"
  printf   '      %b│ °•.·%b%b.°•.·%b%b.°•.%b  %bENVIRONMENTS%b  %b.•°.%b%b·.•°.%b%b·.•° │%b\n' "$BOLD$CYAN" "$RESET" "$BOLD$RED" "$RESET" "$BOLD$CYAN" "$RESET" "$BOLD$RED" "$RESET" "$BOLD$CYAN" "$RESET" "$BOLD$RED" "$RESET" "$BOLD$CYAN" "$RESET"
  printf   '      %b╰────────────────────────────────────────────╯%b\n\n' "$BOLD$CYAN" "$RESET"

  sleep 3

  printf '%b!%b   This promulgator/installer does not delete or overwrite your files.\n' "$YELLOW" "$RESET"
  printf '    Existing dotfiles are safely %brenamed%b:\n\n' "$BOLD" "$RESET"

  printf '      %b.dotfile%b > %b.dotfile%b%b.pre-indottrination%b\n\n' "$ITALIC" "$RESET" "$ITALIC" "$RESET" "$ITALIC$GREEN" "$RESET"

  printf '    If that already exists, a timestamped backup like\n\n'

  printf '      %b.dotfile%b%b.YYYY-MM-DD_HH-MM-SS%b gets created instead.\n\n' "$ITALIC" "$RESET" "$ITALIC$GREEN" "$RESET"

  printf '    Your original configs remain untouched and recoverable.\n\n'
}

# ---------------------------------------------
# 🧰 Check dependencies
# ---------------------------------------------
check_dependencies() {
  if ! command -v git >/dev/null 2>&1; then
    error "Git is required but not installed. Please install git first."
    exit 1
  fi
}

# ---------------------------------------------
# 📥 Clone or update repo
# ---------------------------------------------
fetch_repo() {
  if [ -d "$DOTTRINES_DIR/.git" ]; then
    log "Updating existing dottrines..."
    git -C "$DOTTRINES_DIR" fetch --depth=1 origin "$BRANCH" >/dev/null 2>&1 || {
      warn "Could not fetch updates from remote."
    }
    git -C "$DOTTRINES_DIR" reset --hard "origin/$BRANCH" >/dev/null 2>&1
    success "dottrines updated."
  else
    log "Cloning dottrines repo into $DOTTRINES_DIR..."
    git clone --branch "$BRANCH" "$REPO_URL" "$DOTTRINES_DIR" >/dev/null 2>&1 || {
      error "Failed to clone repository."
      exit 1
    }
    success "Repository cloned"
  fi
}

# ---------------------------------------------
# 💾 Backup files
# ---------------------------------------------
backup_file() {
  file="$1"
  [ -e "$file" ] || return 0

  dir=$(dirname "$file")
  base=$(basename "$file")
  timestamp=$(date +"%Y-%m-%d_%H-%M-%S")
  prefile="$dir/$base.pre-indottrination"
  datedfile="$dir/$base.$timestamp"

  if [ -e "$prefile" ]; then
    mv "$file" "$datedfile"
    success "Backed up $base > ${datedfile#$HOME_DIR/}"
  else
    mv "$file" "$prefile"
    success "Backed up $base > ${prefile#$HOME_DIR/}"
  fi
}

# ---------------------------------------------
# 📦 Installation
# ---------------------------------------------
install_files() {
  log "Promulgating dottrines into $HOME_DIR..."

  # General files to install for everyone
  WHITELIST_GENERAL=".gitconfig .nanorc"

  # Shell-specific files
  WHITELIST_BASH=".bashrc"
  WHITELIST_ZSH=".zshrc"

  # Install general files
  for file in $WHITELIST_GENERAL; do
    src="$DOTTRINES_DIR/$file"
    dest="$HOME_DIR/$file"
    if [ -f "$src" ]; then
      [ -e "$dest" ] && backup_file "$dest"
      cp -f "$src" "$dest"
      success "Installed $file"
    fi
  done

  # Install bash files if bash is present
  if [ "$HAS_BASH" = yes ]; then
    for file in $WHITELIST_BASH; do
      src="$DOTTRINES_DIR/bash/$file"
      dest="$HOME_DIR/$file"
      if [ -f "$src" ]; then
        [ -e "$dest" ] && backup_file "$dest"
        cp -f "$src" "$dest"
        success "Installed $file"
      fi
    done
  fi

  # Install zsh files if zsh is present
  if [ "$HAS_ZSH" = yes ]; then
    for file in $WHITELIST_ZSH; do
      src="$DOTTRINES_DIR/zsh/$file"
      dest="$HOME_DIR/$file"
      if [ -f "$src" ]; then
        [ -e "$dest" ] && backup_file "$dest"
        cp -f "$src" "$dest"
        success "Installed $file"
      fi
    done
  fi
}

install_run_commands() {
  # Install bash run commands if bash is present
  if [ "$HAS_BASH" = yes ] && [ -f "$DOTTRINES_DIR/.bashrc" ]; then
    dest="$HOME_DIR/.bashrc"
    if [ -e "$dest" ]; then
      backup_file "$dest"
    fi
    cp "$DOTTRINES_DIR/.bashrc" "$dest"
    success "Installed .bashrc"
  fi

  # Install zsh run commands if zsh is present
  if [ "$HAS_ZSH" = yes ] && [ -f "$DOTTRINES_DIR/.zshrc" ]; then
    dest="$HOME_DIR/.zshrc"
    if [ -e "$dest" ]; then
      backup_file "$dest"
    fi
    cp "$DOTTRINES_DIR/.zshrc" "$dest"
    success "Installed .zshrc"
  fi
}

install_oh_my_zsh() {
  [ "$HAS_ZSH" = yes ] || return 0
  [ -d "$HOME/.oh-my-zsh" ] || return 0

  OMZ_SRC="$DOTTRINES_DIR/oh-my-zsh"
  [ -d "$OMZ_SRC" ] || return

  log "Promulgating custom oh-my-zsh indottrinations into ~/.oh-my-zsh..."

  find "$OMZ_SRC" -mindepth 1 ! -path "*/.git/*" | while IFS= read -r src; do
    # Determine relative path inside .oh-my-zsh
    rel=${src#$OMZ_SRC/}   # strip the source prefix

    # Destination is inside $HOME/.oh-my-zsh
    dest="$HOME/.oh-my-zsh/$rel"

    # Create parent directory if needed
    mkdir -p "$(dirname "$dest")"

    if [ -f "$src" ]; then
      [ -e "$dest" ] && backup_file "$dest"
      cp -f "$src" "$dest"
      success "Installed oh-my-zsh/$rel"
    elif [ -d "$src" ]; then
      mkdir -p "$dest"
    fi
  done
}

# ---------------------------------------------
# 🎉 Success banner
# ---------------------------------------------
print_success() {
  printf '\n      %b╭────────────────────────────────────────────╮%b\n' "$BOLD$CYAN" "$RESET"
  printf   '      %b│ .•°%b%b.·.%b%b•°%b%b.·.%b%b•°%b  %bDOTTRINES%b     %b°•%b%b.·.%b%b°•%b%b.·.%b%b°•. │%b\n' "$BOLD$CYAN" "$RESET" "$BOLD$GREEN" "$RESET" "$BOLD$CYAN" "$RESET" "$BOLD$GREEN" "$RESET" "$BOLD$CYAN" "$RESET" "$BOLD$GREEN" "$RESET" "$BOLD$CYAN" "$RESET" "$BOLD$GREEN" "$RESET" "$BOLD$CYAN" "$RESET" "$BOLD$GREEN" "$RESET" "$BOLD$CYAN" "$RESET"
  printf   '      %b│ .•°%b%b.·.%b%b•°%b%b.·.%b%b•°%b  %bPROMULGATED%b   %b°•%b%b.·.%b%b°•%b%b.·.%b%b°•. │%b\n' "$BOLD$CYAN" "$RESET" "$BOLD$GREEN" "$RESET" "$BOLD$CYAN" "$RESET" "$BOLD$GREEN" "$RESET" "$BOLD$CYAN" "$RESET" "$BOLD$GREEN" "$RESET" "$BOLD$CYAN" "$RESET" "$BOLD$GREEN" "$RESET" "$BOLD$CYAN" "$RESET" "$BOLD$GREEN" "$RESET" "$BOLD$CYAN" "$RESET"
  printf   '      %b│ .•°%b%b.·.%b%b•°%b%b.·.%b%b•°%b  %bSUCCESSFULLY%b  %b°•%b%b.·.%b%b°•%b%b.·.%b%b°•. │%b\n' "$BOLD$CYAN" "$RESET" "$BOLD$GREEN" "$RESET" "$BOLD$CYAN" "$RESET" "$BOLD$GREEN" "$RESET" "$BOLD$CYAN" "$RESET" "$BOLD$GREEN" "$RESET" "$BOLD$CYAN" "$RESET" "$BOLD$GREEN" "$RESET" "$BOLD$CYAN" "$RESET" "$BOLD$GREEN" "$RESET" "$BOLD$CYAN" "$RESET"
  printf   '      %b╰────────────────────────────────────────────╯%b\n\n' "$BOLD$CYAN" "$RESET"

  sleep 2.5

  printf '•   Congrats on being indottrinated!\n\n'

  sleep 2.5

  printf '•°. You are now a %btrue believer%b, one of the %borthodots%b.·.°•\n\n' "$ITALIC" "$RESET" "$YELLOW" "$RESET"

  sleep 3

  printf '    Just have faith, reload your shell and you'\''re good to go.\n'
  printf '    Have fun creating things in your new environment!\n\n'

  printf '%b•°.·.•°.·.•°.·.•°.·.•°.·.•°.·.•°.·.•°.·.•°.·.•°.·.•°.·.•°.·.•°.·.•°.·.•°.·.•%b\n\n' "$BOLD$CYAN" "$RESET"
}

# ---------------------------------------------
# ♻️ Reload run commands
# ---------------------------------------------

# reload_shell() {
#   [ "$RELOAD_SHELL" = yes ] || return

#   # Try to detect the actual running shell (not just login shell)
#   current_shell=$(ps -p $$ -o comm= 2>/dev/null | tail -n1)
#   current_shell=${current_shell##*/}

#   # Fallback to $SHELL if ps gave something generic like "sh"
#   case "$current_shell" in
#     sh|dash|busybox)
#       current_shell=$(basename "${SHELL:-sh}")
#       ;;
#   esac

#   log "Reloading $current_shell environment..."

#   case "$current_shell" in
#     bash)
#       if command -v bash >/dev/null 2>&1; then
#         exec bash --login
#       fi
#       ;;
#     zsh)
#       if command -v zsh >/dev/null 2>&1; then
#         exec zsh -l
#       fi
#       ;;
#     *)
#       log "Unknown shell '$current_shell', falling back to POSIX sh."
#       exec sh -l
#       ;;
#   esac

#   success "Shell environment refreshed."
# }

# ---------------------------------------------
# 🚀 Main function
# ---------------------------------------------
main() {
  [ ! -t 0 ] && UNATTENDED=yes

  parse_args "$@"
  setup_colors
  print_intro

  # Pause and prompt the user
  if [ "$UNATTENDED" != yes ]; then
    printf "%b?%b   Proceed with the indottrination? [Y/n]: " "$YELLOW" "$RESET"
    read -r answer
    case "$answer" in
      [Nn]*)
        printf "\n%b•%b   Indottrination aborted. You remain dotless, unbeliever.\n\n" "$RED" "$RESET"

        printf '%b•°.·.•°.·.•°.·.•°.·.•°.·.•°.·.•°.·.•°.·.•°.·.•°.·.•°.·.•°.·.•°.·.•°.·.•°.·.•%b\n\n' "$BOLD$CYAN" "$RESET"
        exit 0
        ;;
    esac
  fi

  printf "\n"
  printf "•°. %bMay the Dots abide and multiply with you.%b\n\n" "$BOLD" "$RESET"
  sleep 2.5

  check_dependencies

  # Detect installed shells safely under POSIX sh
  if command -v bash >/dev/null 2>&1; then
    HAS_BASH=yes
  else
    HAS_BASH=no
  fi

  if command -v zsh >/dev/null 2>&1; then
    HAS_ZSH=yes
  else
    HAS_ZSH=no
  fi

  if [ "$HAS_ZSH" = yes ] && [ -d "$HOME/.oh-my-zsh" ]; then
    HAS_OMZ=yes
  else
    HAS_OMZ=no
  fi

  fetch_repo
  install_files
  install_run_commands
  install_oh_my_zsh
  sleep 3
  print_success
  # reload_shell
}

main "$@"
