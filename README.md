## WISTFUL (Whole-rock Interpretative Seismic Toolbox for Ultramafic Lithologies)
coded by William Shinevar

Last updated 05/2021

Hello and thanks for downloading WISTFUL!

This repository contains description and link to the WISTFUL database calculations, as well as GUIs and scripts to analyze this data for the use of geo-scientists.

# Data Files
In addition to this code, one should download the data files from this link: https://drive.google.com/file/d/1_eTLBl8XILSbv_XhhhkR5WFJ3JNScW_v/view?usp=sharing
## WISTFUL_densities_clean.mat
This file contains the densities in kg/m^3 for all samples over the investigated range of pressure and temperature. 
## WISTFUL_parsed_modes_clean.mat
This file contains the parsed modal assemblage (olivine, orthopyroxene, clinopyroxene, garnet, spinel) in vol. % for all samples over the investigated range of pressure and temperature. 
## WISTFUL_speeds_moduli_clean.mat
This file contains the parsed anharmonic shear and bulk modulus (in Pa) as well as the Vp and Vs (in km/s) for each rock in the database over the pressure and temperature range. Pressure is in units of bars and temperature is in K. 
## WISTFUL_compositions_clean.mat
This file contains the oxide composition for each rock in the database in wt. % along with calculated XMg and location data when available. 
## WISTFUL_rockType.mat
This file contains the analyzed rocktype of all samples at 800C and 2 GPa. isPeridotite is a logical stating whether the rock is a peridotite. isPyroxenite is a logical saying whether the rock is a pyroxenite. 
rocktype the rocktype number for each sample as follows:

1 = dunite (>90% olivine).

2 = harzburgite (>40% olivine, <10% cpx)

3 is for wehrlite (>40% olivine, <10% opx)

4 is for lherzolite (>40% olivine, >10% opx and >10% cpx)

5 is for olivine websterite (<40% olivine, >10% opx and >10% cpx)

6 is for websterite (<10% olivine)

7 is for orthopyroxenite (>90% opx)

8 is for clinopyroxenite (>90% cpx)

10 is olivine orthopyroxenite (<40% olivine, <10% cpx)

11 is olivine clinopyroxenite (<40% olivine, <10% opx)
# Live Scripts
## calculateWaveSpeedFiles.mlx
The data repository also creates a live script to apply various anelastic corrections to the anharmonic seismic wave speed file. Two anelasticities are currently implemented: 1) The extended-Burgers model from Jackson & Faul (2010)(https://doi.org/10.1016/j.pepi.2010.09.005), and 2). the power law formulation of Behn et al. (2009) (https://doi.org/10.1016/j.epsl.2009.03.014).
The matlab functions implementing the Jackson & Faul model (creep10.m, J1anel.m, J1p.m, J2anel.m, and J2p.m) are taken from the supplement of Garber et al. (2018) (https://doi.org/10.1029/2018GC007534).

To utilize this script, open the function in MATLAB in the same folder as the other matlab functions as well as the two data files: WISTFUL_speeds_moduli_clean.mat and WISTFUL_densities_clean.mat.
Once opened, you can choose the anelastic correction, the period, grain size, and olivine COH (~100 ppm wt (H2O) = ~1500 ppm H/Si) (only changes the Behn et al. (2009) model). You can also choose the resulting saved file name for the use in the WISTFUL GUI's. If no file name is chosen, a default file name listing all the parameters is used.
Hit the run button, and the chosen anelasticity will be applied on the WISTFUL anharmonic wave speeds!
# GUIs
By default, all GUI's load anharmonic wavespeeds. To change this, hit the load button in the top left of all GUIS to load the file saved from the livescript calculateWaveSpeedFiles.mlx. If one wishes to save the data found in the GUI figures, use the export data button to export the data to the workspace, where you can save to a .mat file using the save command.
## WISTFUL_relationships
This MATLAB app allows plotting of parameters in the WISTFUL database over a range of pressure and temperature. 
## WISTFUL_inversion
This MATLAB app finds the best fitting compositions or parameters given pressure and seismic wave speed (one or more of Vp, Vs, and Vp/Vs). One can either fit by examining the X closest samples or by looking at the averages or distributions of data within error. To fit many seismic wave speed points, use the function fitSeismicWaveSpeeds.m.
## WISTFUL_profiles
This MATLAB app allows the production of seismic wavespeed or density profiles and ranges for various geotherms and rock types. To use a loaded geotherm, you must load a .mat file with vector files for depth [km], pressure[bars], and temperature [degree C] named as z, p, and t (NOTE: These variable names are case-sensitive). The depths should be increasing in value to plot well. 
# Functions
## numWithinError.m
This script calculates the best-fit temperature for a given seismic constraint using the number of samples within error. Benefit of this script over the GUI is that you can input a list of seismic wavespeeds for constraints.
## fitPropertyNumWithin.m
Sister script to numWithinError.m that uses the outputs to calculate average input properties at investigated pressures and temperatures. Uses outputs from numWithinError.m.
## findClosestX.m
This script calculates the best-fit temperature for a given seismic constraint using the average misfit of the X closest samples. Benefit of this script over the GUI is that you can input a list of seismic wavespeeds for constraints.
## fitPropertyClosestX.m
Sister script to findClosestX.m that uses the outputs to calculate average input properties at investigated pressures and temperatures. Uses outputs from findClosestX.m.
## exampleClosestX.m and exampleNumWithin.m
These scripts show example uses of the above functions. 
