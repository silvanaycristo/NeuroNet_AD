#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DIR="$PROJECT_ROOT/app/data"
TABLA="$PROJECT_ROOT/data/conteocell_id.tsv"
CSV="$PROJECT_ROOT/data/adstate_fem.csv"

printf "ID\tNUM_COLUMNAS\n" > "$TABLA"

sed '1d' "$CSV" | while IFS=',' read -r id col2 col3 || [[ -n "$id" ]]
do
    # Limpiar posibles caracteres raros
    id="${id//$'\r'/}"
    id="${id//\"/}"
    id="$(echo "$id" | xargs)"

    # Buscar archivo que contenga el ID y termine en _Vip.tsv
    file=$(find "$DIR" -type f -name "*${id}*_Vip.tsv" | head -n 1)

    if [[ -n "$file" ]]; then
        NUM_COLUMNAS=$(awk -F'\t' 'NR==1 {print NF-1; exit}' "$file")
        printf "%s\t%s\n" "$id" "$NUM_COLUMNAS" >> "$TABLA"
    else
        printf "%s\t%s\n" "$id" "0" >> "$TABLA"
    fi

done
