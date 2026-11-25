<h1 align="center">Align DWI to dtiInit</h1>

<p align="center">
  A diffusion-weighted image (single- or multi-shell) linearly aligned to the ACPC-aligned DWI of a dtiInit output, with rotated bvecs, using FSL FLIRT.
</p>

<p align="center">
  <a href="https://github.com/brainlife/abcd-spec"><img src="https://img.shields.io/badge/ABCD_Spec-v1.1-green.svg" alt="ABCD Spec v1.1"></a>
  <a href="https://doi.org/10.25663/brainlife.app.153"><img src="https://img.shields.io/badge/Brainlife-brainlife.app.153-blue.svg" alt="Run on brainlife.io"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-lightgrey.svg" alt="MIT license"></a>
</p>

> 📍 **This branch, `v1.0.0`, is the brainlife.io App Align DWI to Dtiinit** ([doi:10.25663/brainlife.app.153](https://doi.org/10.25663/brainlife.app.153)).

## 🧠 At a glance

<!-- brainlife-app:begin (generated from the App manifest; edit the manifest, not this block) -->

> **Aligns a DWI (single- or multi-shell) to a dtiInit-aligned DWI with FSL flirt on the b0 images and rotates the bvecs, outputting a DWI in the dtiInit space.**

Registers the mean b0 of the input DWI to the b0 of the dtiInit-aligned DWI with FSL flirt, applies the transform to all volumes and rotates the bvecs accordingly. Use it when dtiInit was used only for anatomical (ACPC) alignment and another DWI (for example multi-shell) must be brought into the same space. Both inputs must contain b=0 volumes.

| | |
|---|---|
| 📥 **Inputs** | `neuro/dwi` · `neuro/dtiinit` |
| 📤 **Outputs** | `neuro/dwi` |
| 🐳 **Container** | `brainlife/fsl:5.0.9` |
| ⚙️ **Resources** | 1 CPUs · 0.25 h walltime |
| 🔗 **Run it** | [doi.org/10.25663/brainlife.app.153](https://doi.org/10.25663/brainlife.app.153) |

#### 📥 Inputs

| Input | Datatype | Required | Description |
|---|---|---|---|
| `input_dwi` | `neuro/dwi` | yes | The path to the dwi datatype to be aligned |
| `dtiinit` | `neuro/dtiinit` | yes | The path to the top directory containing the output from DTIINIT |

#### 📤 Outputs

| Output | Datatype | Description |
|---|---|---|
| `dwi` | `neuro/dwi` | A DWI dataype, including the DWI nifti and corrected bvecs and bvals, aligned to the DTIINIT output |

<!-- brainlife-app:end -->

## 🚀 Running the App

### ☁️ On brainlife.io

Open the App at [doi.org/10.25663/brainlife.app.153](https://doi.org/10.25663/brainlife.app.153), choose a `neuro/dwi` dataset and the `neuro/dtiinit` output it should be aligned to, and press **Execute**. The aligned DWI is archived to your project as a new `neuro/dwi` dataset.

Use it when dtiInit was used for T1 alignment and tracking and you want to fit a model that needs the original (for example multi-shell) DWI, and map its measures onto the tracking results (for example tract profiles).

### 💻 Locally

You need [Singularity/Apptainer](https://apptainer.org/) and [`jq`](https://jqlang.github.io/jq/). The App runs FSL 5.0.9 from `brainlife/fsl:5.0.9` and a compiled MATLAB program (vistasoft `dtiRawReorientBvecs`, with jsonlab) from `brainlife/mcr:neurodebian1604-r2017a`.

1. Clone this repository and check out the App branch: `git checkout v1.0.0`.
2. Create `config.json` with the paths to your inputs:

   ```json
   {
       "dtiinit": "./input/dtiinit",
       "dwi": "./input/dwi/dwi.nii.gz",
       "bvals": "./input/dwi/dwi.bvals",
       "bvecs": "./input/dwi/dwi.bvecs"
   }
   ```

3. Run the App:

   ```bash
   ./main
   ```

### 🧪 Sample data

Download a sample dtiInit output and DWI from brainlife.io with the [brainlife CLI](https://github.com/brainlife/cli):

```bash
npm install -g brainlife
bl login
mkdir input
bl dataset download 5c45e58c287fa00144a33567 && mv 5c45e58c287fa00144a33567 input/dtiinit
bl dataset download 5b96bbf2059cf900271924f3 && mv 5b96bbf2059cf900271924f3 input/dwi
```

## 📦 Outputs

The App extracts the b0 volumes of both images, estimates a FLIRT transform from the DWI b0 to the dtiInit b0 (`dwi_aligned_trilin_noMEC`), applies it to the whole DWI and rotates the bvecs with the same transform.

```text
dwi/
├── dwi.nii.gz    DWI aligned to the dtiInit DWI
├── dwi.bvals     copied from the input
└── dwi.bvecs     rotated bvecs
acpcxform.mat     FLIRT transform from the input DWI to the dtiInit DWI
```

## 🩺 Troubleshooting

- **`Aligned dwi missing`**: FLIRT did not produce the aligned DWI. Check the log and make sure both inputs have b=0 volumes.

## 📚 Citing

> [!TIP]
> If you use this App in your work, please cite the App, the software it builds on and brainlife.io (below). GitHub's **Cite this repository** button gives the App citation in APA and BibTeX.

- Align DWI to Dtiinit. brainlife.io App. [doi:10.25663/brainlife.app.153](https://doi.org/10.25663/brainlife.app.153)
- Jenkinson et al. FSL. *NeuroImage* 62:782-790 (2012). [doi:10.1016/j.neuroimage.2011.09.015](https://doi.org/10.1016/j.neuroimage.2011.09.015)
- Hayashi S, Caron BA, Heinsfeld AS, et al. brainlife.io: a decentralized and open-source cloud platform to support neuroscience research. *Nature Methods* 21:809–813 (2024). [doi:10.1038/s41592-024-02237-2](https://doi.org/10.1038/s41592-024-02237-2)
- Avesani P, McPherson B, Hayashi S, et al. The open diffusion data derivatives, brain data upcycling via integrated publishing of derivatives and reproducible open cloud services. *Scientific Data* 6:69 (2019). [doi:10.1038/s41597-019-0073-y](https://doi.org/10.1038/s41597-019-0073-y)

## 👥 Authors

- Brad Caron

**Contributors:** Soichi Hayashi, Franco Pestilli

## 💰 Funding

[![Wellcome-226486/Z/22/Z](https://img.shields.io/badge/Wellcome-226486%2FZ%2F22%2FZ-purple.svg)](https://wellcome.org/)
[![NIH-NINDS-U24NS140384](https://img.shields.io/badge/NIH_NINDS-U24NS140384-green.svg)](https://reporter.nih.gov/project-details/11261037)
[![NIH-NINDS-UM1NS132207](https://img.shields.io/badge/NIH_NINDS-UM1NS132207-green.svg)](https://reporter.nih.gov/project-details/11411328)
[![NIH-NIBIB-R01EB029272](https://img.shields.io/badge/NIH_NIBIB-R01EB029272-green.svg)](https://reporter.nih.gov/project-details/10262925)
[![NIH-NIBIB-R01EB030896](https://img.shields.io/badge/NIH_NIBIB-R01EB030896-green.svg)](https://reporter.nih.gov/project-details/10428625)
[![NIH-NIMH-R01MH126699](https://img.shields.io/badge/NIH_NIMH-R01MH126699-green.svg)](https://reporter.nih.gov/project-details/10460628)
[![NIH-NIDCD-R01DC020088](https://img.shields.io/badge/NIH_NIDCD-R01DC020088-green.svg)](https://reporter.nih.gov/project-details/11140284)
[![NSF-BCS-1734853](https://img.shields.io/badge/NSF_BCS-1734853-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1734853)
[![NSF-BCS-2203524](https://img.shields.io/badge/NSF_BCS-2203524-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2203524)
[![NSF-IIS-1636893](https://img.shields.io/badge/NSF_IIS-1636893-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1636893)
[![NSF-OAC-2148729](https://img.shields.io/badge/NSF_OAC-2148729-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2148729)
[![NSF-IIS-1912270](https://img.shields.io/badge/NSF_IIS-1912270-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1912270)
[![NSF-IIS-2148700](https://img.shields.io/badge/NSF_IIS-2148700-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=2148700)
[![NSF-OAC-1916518](https://img.shields.io/badge/NSF_OAC-1916518-blue.svg)](https://www.nsf.gov/awardsearch/showAward?AWD_ID=1916518)

<sub>brainlife.io is publicly funded, and acknowledging that support helps keep it running. This App was developed with support from Wellcome, the U.S. National Institutes of Health (including the BRAIN Initiative BRAIN CONNECTS program: The Axonal Projectome EXchange, U24NS140384, and the Center for Mesoscale Connectomics, UM1NS132207) and the U.S. National Science Foundation.</sub>

## ⚖️ License

MIT; see the [`LICENSE`](https://github.com/brainlife/app-dwiToDtiinit/blob/v1.0.0/LICENSE) file on the `v1.0.0` branch. FSL itself is distributed under its own [license](https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/Licence).
