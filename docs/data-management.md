# Manejo de datos

## Principio general

GitHub contiene código y documentación, no los datos completos ni los
resultados masivos. El proyecto en Chaac supera los 500 GB y contiene archivos
individuales de decenas de GB.

## Directorios locales

| Ruta | Contenido | ¿Se versiona? |
| --- | --- | --- |
| `data/` | tablas derivadas y matrices por condición | No |
| `input/` | entradas primarias | No |
| `output/` | matrices por donante y subtipo | No |
| `app/` | copias de datos para aplicaciones/análisis | No |
| `aracne_vip/` | redes y resultados de ARACNe | No |
| `logs/` | bitácoras de ejecución | No |
| `figures/` | figuras finales seleccionadas | Sí |

Cada directorio ignorado puede conservar un `README.md` pequeño que documente
cómo obtener o regenerar su contenido.

## Reproducibilidad

Al añadir un conjunto de datos, documentar:

1. Fuente y versión.
2. Fecha de descarga.
3. Restricciones de acceso o uso.
4. Nombre y suma de verificación del archivo original.
5. Script y parámetros usados para generar derivados.
6. Ubicación en el servidor.

No incluir identificadores sensibles ni credenciales en el repositorio.
