# Instrucciones para asistentes

## Objetivo

Ayudar a desarrollar y documentar NeuroNet_AD sin copiar datos biomédicos
pesados o potencialmente sensibles fuera del servidor de la LCG.

## Reglas

- Trabajar desde la raíz del proyecto.
- No agregar a Git archivos de `data/`, `input/`, `output/`, `app/`,
  `aracne_vip/` o `logs/`, salvo sus archivos `README.md`.
- No versionar archivos `.h5ad`, matrices grandes ni resultados regenerables.
- Usar rutas relativas a la raíz; no introducir rutas de usuarios concretos.
- No modificar `ARACNe-AP/` salvo petición explícita: es una dependencia
  externa con su propio historial.
- Antes de ejecutar trabajos pesados, indicar memoria, CPU, tiempo estimado y
  archivos de salida.
- Preservar notebooks, pero preferir código reutilizable en `src/`.
- Documentar nuevos pasos reproducibles en el README o en `docs/`.

## Verificación mínima

- Revisar `git status --short` antes de cada commit.
- Confirmar que ningún archivo grande o dato primario esté preparado para Git.
- Para Python, comprobar sintaxis con `python -m compileall src scripts`.
- Para shell, comprobar sintaxis con `bash -n`.

## Pendiente para la autora

Completar este archivo con objetivos científicos, convenciones de nombres,
comandos del clúster y criterios de aceptación específicos del proyecto.
