# NeuroNet_AD

## Information-theoretic network analysis of single-nucleus transcriptomic data in Alzheimer's disease

NeuroNet_AD is a research project for reconstructing and analyzing gene
regulatory networks from single-nucleus RNA sequencing (snRNA-seq) data. The
project focuses on molecular and cellular changes associated with Alzheimer's
disease (AD), with particular attention to Vip interneurons across
neuropathological stages.

The current workflow combines cell-level transcriptomic processing,
metacell-based aggregation, highly variable gene selection, network
reconstruction with ARACNe-AP, and graph-theoretic analysis. Its broader goal
is to identify regulatory modules, candidate hub genes, and disease-associated
network changes that may help explain selective cellular vulnerability in AD.

> This repository contains source code, notebooks, selected figures, and
> documentation. Primary data and large generated results remain on the LCG
> computing server and are not tracked by GitHub.

## Research objectives

- Reconstruct condition-specific gene regulatory networks from snRNA-seq data.
- Compare network organization across AD neuropathological stages.
- Identify highly connected genes, maximal k-cores, and candidate regulatory
  modules.
- Characterize changes affecting Vip interneurons and other relevant cell
  populations.
- Build a reproducible workflow that separates source code from large,
  restricted, or regenerable data products.

## Data source

The project uses data from the **Seattle Alzheimer's Disease Brain Cell Atlas
(SEA-AD)**, a multimodal atlas of human postmortem brain tissue containing
single-nucleus transcriptomic, epigenomic, and spatial measurements across
different levels of AD pathology.

Primary reference:

> Gabitto, M. I. et al. Integrated multimodal cell atlas of Alzheimer's
> disease. *Nature Neuroscience* **27**, 2366–2383 (2024).
> [https://doi.org/10.1038/s41593-024-01774-5](https://doi.org/10.1038/s41593-024-01774-5)

Users are responsible for complying with the original dataset's access
conditions, licenses, and citation requirements. No primary SEA-AD data are
redistributed through this repository.

## Repository structure

```text
NeuroNet_AD/
├── src/            # Data processing, aggregation, visualization, and analysis
├── scripts/        # SuperCell and ARACNe-AP execution scripts
├── notebooks/      # Exploratory and intermediate analyses
├── figures/        # Selected figures suitable for version control
├── docs/           # Project and data-management documentation
├── data/           # Local derived data (contents excluded from Git)
├── input/          # Primary inputs (contents excluded from Git)
├── output/         # Generated matrices and results (excluded from Git)
├── aracne_vip/     # ARACNe network outputs (excluded from Git)
├── environment.yml # Conda environment definition
└── AGENTS.md       # Working instructions for coding assistants
```

See [`docs/data-management.md`](docs/data-management.md) for the data and
artifact policy.

## Installation

Create the Conda environment from the repository root:

```bash
conda env create -f environment.yml
conda activate neuronet-ad
```

ARACNe-AP is treated as an external dependency. Build or clone it into
`ARACNe-AP/` so that the executable JAR is available at:

```text
ARACNe-AP/dist/aracne.jar
```

The `ARACNe-AP/` directory is intentionally excluded from this repository
because the tool has its own source history and license.

## Workflow

The workflow is under active development. Scripts currently support the
following stages:

1. Extract expression matrices by donor and cell subclass.
2. Aggregate Vip expression matrices by AD neuropathological stage.
3. Build approximately 100 metacells per condition with SuperCell.
4. Select highly variable genes and construct a shared gene set.
5. Reconstruct condition-specific networks with ARACNe-AP.
6. Analyze network degree, mutual-information thresholds, and maximal k-cores.
7. Produce summary plots and exploratory analyses.

Run commands from the repository root. Representative examples:

```bash
python src/separar_pacientes_subclass.py
python src/overall_vip.py
Rscript scripts/supercell_vip.R data/Vip_High.tsv
python scripts/get_hvgs_union.py
python scripts/filter_hvg.py
bash scripts/run_aracne_hvg.sh data/Vip_High_hvg.tsv
python src/analisis_redes.py
```

Some jobs require substantial memory and CPU resources. Review the resource
settings in each script before submitting work to the cluster.

## Expected outputs

Depending on the analysis stage, the workflow may generate:

- donor- and subclass-specific expression matrices;
- condition-level Vip expression matrices;
- metacell expression matrices;
- highly variable gene lists;
- ARACNe mutual-information networks;
- GraphML network representations;
- network statistics and candidate hub genes;
- summary figures and execution logs.

Large and regenerable outputs are excluded from Git. Each analysis should
record its input files, parameters, software versions, and output location.

## Error handling and validation

Scripts perform basic file and argument checks, but the pipeline does not yet
have a unified workflow engine or comprehensive automated test suite. Before
running an analysis:

- confirm that required input files exist;
- inspect paths and cluster resource parameters;
- run shell syntax checks with `bash -n`;
- run Python syntax checks with `python -m compileall src scripts`;
- inspect logs and output dimensions after each major stage;
- use `git status --short` to ensure that large data files are not staged.

Adding small synthetic test fixtures and automated workflow tests is a planned
improvement.

## Authors and collaborators

- **Silvana Yalú Cristo-Martínez** — [silvanac@lcg.unam.mx](mailto:silvanac@lcg.unam.mx)
- **Ximena Fernández-Sánchez** — [xfdzciencias@gmail.com](mailto:xfdzciencias@gmail.com)
- **Rafael Díaz-Martínez** — [rafadiaz@lcg.unam.mx](mailto:rafadiaz@lcg.unam.mx)
- **Daniel Isidoro Chagüen-Hernandez** — [danielchagueno@gmail.com](mailto:danielchagueno@gmail.com)
- **Allan Ken Miyazono-Ushijima** — [allan.miyazono@gmail.com](mailto:allan.miyazono@gmail.com)
- **Guillermo De Anda-Jáuregui** — [gdeanda@inmegen.edu.mx](mailto:gdeanda@inmegen.edu.mx)

For questions, bug reports, or proposed collaborations, please
[open an issue](https://github.com/silvanaycristo/NeuroNet_AD/issues).

## Contributing

Contributions should be developed in dedicated branches and submitted through
pull requests. Avoid committing primary data, large expression matrices,
generated networks, credentials, or user-specific absolute paths.

## Citation

This software is under active development. If you use it before a formal
release or associated publication is available, cite the repository:

> Cristo-Martínez, S. Y. et al. *NeuroNet_AD: Information-theoretic network
> analysis of single-nucleus transcriptomic data in Alzheimer's disease*.
> GitHub repository.
> [https://github.com/silvanaycristo/NeuroNet_AD](https://github.com/silvanaycristo/NeuroNet_AD)

This section should be updated with a versioned DOI and publication citation
when they become available.

## License

The source code in this repository is distributed under the
[MIT License](LICENSE). External tools and datasets remain subject to their
respective licenses and terms of use.
