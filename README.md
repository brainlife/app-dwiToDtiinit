[![Abcdspec-compliant](https://img.shields.io/badge/ABCD_Spec-v1.1-green.svg)](https://github.com/brain-life/abcd-spec)
[![Run on Brainlife.io](https://img.shields.io/badge/Brainlife-bl.app.153-blue.svg)](https://doi.org/10.25663/bl.app.153)

# app-dwiToDtiinit

<!-- brainlife-app:begin (generated from the App manifest; edit the manifest, not this block) -->

**Aligns a DWI (single- or multi-shell) to a dtiInit-aligned DWI with FSL flirt on the b0 images and rotates the bvecs, outputting a DWI in the dtiInit space.**

Registers the mean b0 of the input DWI to the b0 of the dtiInit-aligned DWI with FSL flirt, applies the transform to all volumes and rotates the bvecs accordingly. Use it when dtiInit was used only for anatomical (ACPC) alignment and another DWI (for example multi-shell) must be brought into the same space. Both inputs must contain b=0 volumes.

Run it on brainlife.io: [https://doi.org/10.25663/brainlife.app.153](https://doi.org/10.25663/brainlife.app.153)

| Input | Datatype | Required | Description |
|---|---|---|---|
| `input_dwi` | `neuro/dwi` | yes | The path to the dwi datatype to be aligned |
| `dtiinit` | `neuro/dtiinit` | yes | The path to the top directory containing the output from DTIINIT |

| Output | Datatype | Description |
|---|---|---|
| `dwi` | `neuro/dwi` | A DWI dataype, including the DWI nifti and corrected bvecs and bvals, aligned to the DTIINIT output |

Runtime: container `brainlife/fsl:5.0.9`; 1 CPUs; 0.25 h walltime.

<!-- brainlife-app:end -->

This app will align DWI data (multi-shell or single-shell) to a DTIINIT output DWI. This may be need to be done when DTIINIT was used for T1 alignment and tracking and the user wants to fit a model that requires multi-shell DWI and map the measures to tracking (i.e. tract profiles). This app requires DWI and DTIINIT inputs and will output an aligned DWI output. This app uses FSL Flirt to do alignment.

### Authors
- Brad Caron (bacaron@iu.edu)

### Contributors
- Soichi Hayashi (hayashi@iu.edu)
- Franco Pestilli ([@francopestilli](https://github.com/francopestilli))

### Funding
[![NSF-BCS-1734853](https://img.shields.io/badge/NSF_BCS-1734853-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1734853)
[![NSF-BCS-1636893](https://img.shields.io/badge/NSF_BCS-1636893-blue.svg)](https://nsf.gov/awardsearch/showAward?AWD_ID=1636893)

## Running the App 

### On Brainlife.io

You can submit this App online at [https://doi.org/10.25663/bl.app.153](https://doi.org/10.25663/bl.app.53) via the "Execute" tab.

### Running Locally (on your machine)

1. git clone this repo.
2. Inside the cloned directory, create `config.json` with something like the following content with paths to your input files.

```json
{
        "dtiinit": "./input/dtiinit/.",
        "dwi": "./input/dwi/dwi.nii.gz",
        "bvals": "./input/dwi/dwi.bvals",
        "bvecs": "./input/dwi/dwi.bvecs"
}
```

### Sample Datasets

You can download sample datasets from Brainlife using [Brainlife CLI](https://github.com/brain-life/cli).

```
npm install -g brainlife
bl login
mkdir input
bl dataset download 5c45e58c287fa00144a33567 && mv 5c45e58c287fa00144a33567 input/dtiinit
bl dataset download 5b96bbf2059cf900271924f3 && mv 5b96bbf2059cf900271924f3 input/dwi

```


3. Launch the App by executing `main`

```bash
./main
```

## Output

The main output of this App is DWI datatype that's aligned to the DTIINIT DWI.

#### Product.json
The secondary output of this app is `product.json`. This file allows web interfaces, DB and API calls on the results of the processing. 

### Dependencies

This App requires the following libraries when run locally.

  - singularity: https://singularity.lbl.gov/
  - VISTASOFT: https://github.com/vistalab/vistasoft/
  - FSL: https://hub.docker.com/r/brainlife/fsl/tags/5.0.9
  - jsonlab: https://github.com/fangq/jsonlab.git
