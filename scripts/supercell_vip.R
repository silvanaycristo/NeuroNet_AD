# ============================================================
# run_supercell.R
# Construye metacélulas (~100) a partir de una matriz de expresión
# génica de neuronas Vip en Alzheimer usando el paquete SuperCell.
#
# Uso:     Rscript scripts/run_supercell.R <matriz_limpia.txt>
# Ejemplo: Rscript scripts/run_supercell.R data/Vip_High.txt
#
# Output: <nombre_input>_metacells.txt en la misma carpeta que el input
# ============================================================


# --- Bloque 1: Argumentos y validación ---
# commandArgs(trailingOnly=TRUE) captura todo lo que se escribe
# después del nombre del script al llamarlo desde la terminal.
# args[1] será el path al archivo de input.

args <- commandArgs(trailingOnly = TRUE)

if (length(args) == 0) {
  stop("Falta el archivo de input.\nUso: Rscript scripts/run_supercell.R <matriz_limpia.txt>")
}

input_file <- args[1]

if (!file.exists(input_file)) {
  stop(paste("Archivo no encontrado:", input_file))
}


# --- Bloque 2: Instalación y carga de dependencias ---
# Se instalan solo si no están presentes, para no reinstalar cada vez.
# SuperCell no está en CRAN, se instala directo del repositorio de los autores.

if (!requireNamespace("remotes",   quietly = TRUE)) install.packages("remotes")
if (!requireNamespace("SuperCell", quietly = TRUE)) remotes::install_github("GfellerLab/SuperCell")
if (!requireNamespace("Matrix",    quietly = TRUE)) install.packages("Matrix")

library(SuperCell)
library(Matrix)


# --- Bloque 3: Carga de la matriz de expresión ---
# El archivo esperado es una tabla TSV con:
#   - filas    = genes
#   - columnas = células
#   - row.names=1 indica que la primera columna contiene los nombres de los genes
#   - check.names=FALSE preserva los nombres de células tal como están
#     (evita que R reemplace caracteres especiales como "-" por ".")

cat("Cargando matriz:", input_file, "\n")

GE <- read.table(
  input_file,
  sep         = "\t",
  header      = TRUE,
  row.names   = 1,
  check.names = FALSE
)

GE <- as.matrix(GE)

n_genes <- nrow(GE)
n_cells <- ncol(GE)

cat("Dimensiones input:", n_genes, "genes x", n_cells, "células\n")


# --- Bloque 4: Cálculo dinámico de gamma ---
# gamma es el factor de compresión: cuántas células se fusionan en promedio
# para formar una metacélula.
#
#   gamma = n_células / n_metacélulas_objetivo
#
# Al calcularlo desde el número real de células del archivo, garantizamos
# que los 4 grupos (Not AD, Low, Intermediate, High) produzcan cada uno
# aproximadamente 100 metacélulas, aunque tengan distinto número de células.
#
# Valores esperados:
#   Not AD       (5,557  células) → gamma ≈  56
#   Low          (6,358  células) → gamma ≈  64
#   Intermediate (7,506  células) → gamma ≈  75
#   High         (24,458 células) → gamma ≈ 245
#
# Nota: el paquete emite una advertencia cuando gamma > 50 porque está
# fuera del rango típico de uso (10-50). Para nuestro objetivo de ~100
# metacélulas en grupos grandes esto es esperado y no representa un error.

target_metacells <- 100
gamma <- round(n_cells / target_metacells)

cat(sprintf(
  "gamma = %d  (objetivo: ~%d metacélulas desde %d células)\n",
  gamma, target_metacells, n_cells
))


# --- Bloque 5: Construcción de metacélulas con SCimplify() ---
# Pipeline interno de SCimplify:
#   1. Selecciona los n.var.genes con mayor varianza
#   2. Aplica PCA con n.pc componentes sobre esos genes
#   3. Construye un grafo kNN (k=k.knn) en el espacio del PCA
#   4. Particiona el grafo con el algoritmo walktrap (por defecto)
#      para encontrar comunidades densamente conectadas → metacélulas
#   5. Devuelve un vector de membresía: a qué metacélula pertenece cada célula
#
# Parámetros usados:
#   gamma       → factor de compresión (calculado arriba)
#   k.knn = 15  → vecinos para el grafo kNN; valor robusto para datasets
#                 de todos los tamaños (el tutorial oficial usa 30 para
#                 datasets grandes; 15 es un punto intermedio adecuado)
#   n.var.genes → top 2000 genes más variables para la reducción dimensional
#   n.pc = 20   → componentes principales para el embedding del grafo kNN;
#                 captura más variabilidad que el default de 10, adecuado
#                 para los 4 grupos incluyendo High (24k células)
#   do.scale    → escala cada gen a media=0 y varianza=1 antes del PCA,
#                 evitando que genes con alta expresión absoluta dominen
#   seed        → fija la aleatoriedad para resultados reproducibles

cat("Construyendo metacells (gamma =", gamma, ")...\n")

SC <- SCimplify(
  X           = GE,
  gamma       = gamma,
  k.knn       = 15,
  n.var.genes = 2000,
  n.pc        = 20,
  do.scale    = TRUE,
  seed        = 12345
)

cat("Metacells generados:", SC$n.sc, "\n")


# --- Bloque 6: Cálculo de expresión por metacélula ---
# supercell_GE() toma la matriz original y el vector de membresía (SC$membership)
# y promedia la expresión génica de todas las células asignadas a cada metacélula.
# El resultado es una nueva matriz genes × metacélulas, mucho más compacta
# que la original pero representativa de la estructura transcriptómica.

cat("Calculando expresión por metacell...\n")

SC.GE <- supercell_GE(GE, SC$membership)

cat("Dimensiones output:", nrow(SC.GE), "genes x", ncol(SC.GE), "metacells\n")


# --- Bloque 7: Guardar el output ---
# El nombre del archivo de salida se construye desde el nombre del input:
#   Vip_High.txt → Vip_High_metacells.txt
# Se guarda en la misma carpeta que el input (dirname lo extrae del path).
# col.names=NA es necesario para que la columna de row.names quede alineada
# correctamente con los encabezados al escribir la tabla.

input_dir  <- dirname(input_file)
input_base <- sub("\\.tsv$", "", basename(input_file))
out_file   <- file.path(input_dir, paste0(input_base, "_metacells.tsv"))

write.table(
  as.matrix(SC.GE),
  file      = out_file,
  sep       = "\t",
  quote     = FALSE,
  col.names = NA
)

cat("Guardado en:", out_file, "\n")
cat("Listo!\n")
