#!/bin/bash

echo "Setting file paths"
# Grab the config.json inputs
dwi=`jq -r '.dwi' config.json`;
bvals=`jq -r '.bvals' config.json`;
dtiinit=`jq -r '.dtiinit' config.json`;
dtiinitDwi=$dtiinit/dwi_aligned_trilin_noMEC.nii.gz;
dtiinitBvals=$dtiinit/dwi_aligned_trilin_noMEC.bvals;
echo "Files loaded"

## Align multishell dwi to acpc-aligned single shell dwi from dtiinit
echo "Aligning multishell dwi to acpc-space"
mkdir alignment;
mkdir dwi;

# Create b0 from dtiinit
select_dwi_vols \
	${dtiinitDwi} \
	${dtiinitBvals} \
	./alignment/nodif_init.nii.gz \
	0;

# Create b0 from multi-shell dwi
select_dwi_vols \
	${dwi} \
	${bvals} \
	./alignment/nodif_multi.nii.gz \
	0;

# Obtain transformation matrix from nodif_init to nodif_multi
flirt \
	-in ./alignment/nodif_multi.nii.gz \
	-ref ./alignment/nodif_init.nii.gz \
	-out ./alignment/nodif_aligned.nii.gz \
	-omat ./alignment/acpcxform.mat;

# Align multi-shell dwi to nodif_multi
flirt \
	-in ${dwi} \
	-ref ./alignment/nodif_aligned.nii.gz \
	-out ./alignment/dwi.nii.gz \
	-init ./alignment/acpcxform.mat \
	-applyxfm;

# Clean up and change directory
mv ./alignment/dwi.nii.gz ./dwi/;
mv ./alignment/acpcxform.mat ./;
rm -rf ./alignment;
cp -v ${bvals} ./dwi/dwi.bvals;

echo "alignment complete"
