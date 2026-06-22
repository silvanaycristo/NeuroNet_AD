# NeuroNet_AD

Análisis de datos de transcriptómica de célula única para estudiar redes de
regulación génica asociadas con la enfermedad de Alzheimer, con énfasis en
neuronas Vip y el uso de ARACNe-AP.

> Este repositorio contiene código, notebooks y documentación. Los datos
> primarios y los resultados pesados permanecen en el servidor de la LCG y no
> se versionan en GitHub.

## Estructura

- `src/`: procesamiento, agregación y análisis de redes.
- `scripts/`: ejecución de SuperCell y ARACNe-AP.
- `notebooks/`: análisis exploratorios.
- `figures/`: figuras seleccionadas para documentación.
- `data/`: datos de entrada derivados; su contenido pesado se ignora.
- `input/`: entradas primarias locales; se ignoran.
- `output/`: matrices y resultados generados; se ignoran.
- `aracne_vip/`: resultados de las redes; se ignoran.
- `docs/`: documentación del proyecto y manejo de datos.

## Instalación

Desde la raíz del proyecto:

```bash
conda env create -f environment.yml
conda activate neuronet-ad
```

ARACNe-AP se mantiene como herramienta externa en `ARACNe-AP/` y no forma
parte del repositorio. Los scripts esperan el archivo
`ARACNe-AP/dist/aracne.jar`.

## Uso general

Los scripts deben ejecutarse desde la raíz del proyecto. Ejemplos:

```bash
python src/separar_pacientes_subclass.py
Rscript scripts/supercell_vip.R data/Vip_High.tsv
bash scripts/run_aracne_hvg.sh data/Vip_High_hvg.tsv
python src/analisis_redes.py
```

Los requisitos de datos y la política para archivos grandes se describen en
[`docs/data-management.md`](docs/data-management.md).

## Estado del proyecto

El repositorio está siendo reorganizado desde un entorno de análisis previo.
La descripción científica original del proyecto se incorporará aquí a partir
del README recuperado.
