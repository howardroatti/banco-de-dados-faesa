#!/usr/bin/env bash
# Build dos slides — Banco de Dados FAESA
# 1) Renderiza diagramas Mermaid (.mmd -> .svg) ao lado do fonte
# 2) Renderiza os decks Marp (.md -> .html) ao lado do fonte, com o tema FAESA
#
# Uso:  ./build.sh            (renderiza tudo)
#       ./build.sh caminho.md (renderiza um deck específico + seus diagramas)
#
# Requisitos: @marp-team/marp-cli (marp) e @mermaid-js/mermaid-cli (mmdc)
set -uo pipefail
cd "$(dirname "$0")"
THEME="themes/faesa.css"

render_mmd () { # $1 = arquivo .mmd
  echo "  mmd → svg: $1"
  mmdc -i "$1" -o "${1%.mmd}.svg" -t neutral -b transparent -q >/dev/null 2>&1 \
    || echo "    ! falha no mmdc: $1"
}
render_md () { # $1 = arquivo .md  (marp: um por vez; </dev/null evita que ele "coma" o stdin do loop)
  echo "  md  → html: $1"
  marp "$1" --theme "$THEME" --html --allow-local-files -o "${1%.md}.html" </dev/null >/dev/null 2>&1 \
    || echo "    ! falha no marp: $1"
}

if [ "${1:-}" != "" ]; then                 # deck específico
  dir="$(dirname "$1")"
  if [ -d "$dir/assets" ]; then
    for f in "$dir"/assets/*.mmd; do [ -e "$f" ] && render_mmd "$f"; done
  fi
  render_md "$1"
else                                         # tudo
  echo "== Diagramas Mermaid =="
  while IFS= read -r f; do render_mmd "$f"; done < <(find unidades _template -name '*.mmd' 2>/dev/null)
  echo "== Decks Marp =="
  while IFS= read -r f; do render_md "$f"; done < <(find unidades _template -name '*.md' 2>/dev/null)
fi
echo "OK."
