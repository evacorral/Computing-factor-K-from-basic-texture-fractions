# Calculating the USLE erodibility K-factor
This program allows to obtain the value of the USLE erodibility K-factor for any particular soil in two different situations
- When all input variables are known.
- When all input variables are known except the very fine sand (VFS) fraction (0.05-0.1 mm).

This program can be used for the whole possible range of the silt plus VFS fraction values. A detailed explanation of the methodology followed can be consulted at https://doi.org/10.1002/ldr.3121.

Instructions for using the program:
- Download the archive “Computing-factor-K-from-basic-texture-fractions-main” at the  Code ” button.
- Enter your data in the Input_data.xlsx file, that is, the textural fractions according to the USDA system, the organic matter and the structure code of the upper horizon, and the permeability class of the soil profile. The values of the textural fractions and OM must be written as a percentage and with a single decimal figure; if they are entered with two or more decimal figures, the program will not return any results.
- When the VFS fraction is not known, the cell will be left empty; in this case the program will provide an estimate of this value together with a prediction interval.
- Open the file “computingK”, in R.
- Run the code, then, the computingK function will be created in the Environment. Execute this function next by typing “computingK()”
- An analysis of the input data is carried out, warning if the sum of the three textural fractions is not equal to 100, if VFS>sand and if M parameter>8000. If this happens, the program will not return any results.
 - When the texture is out the definition field (see figure ÇÇ in REFERENCE k-FACTOR ARTICLE) of the K-factor, the program does the calculation, but it will warn that an extrapolation is being carried out.
- The Output_data.xlsx file is created, in which 10 new fields are added to the original ones:
  - The predicted value for the VFS fraction (conditional median) and its 50% prediction interval, delimited by the first and third conditional quartiles. Only when the VFS fraction is unknown.
  - The K-factor values, expressed in (0.01 ton acre h)/(acre ft-tonf in) and in (t ha h)/(MJ ha cm). When the VFS fraction is unknown, this is a predicted value (conditional median)
  - A prediction interval of K-factor, only when the VFS fraction is unknown. Delimited by the first and third conditional quartiles. Values expressed in (0.01 ton acre h)/(acre ft-tonf in) and in (t ha h)/(MJ ha cm). 
  - Check: a warning will appear in case the texture values would be out of range.
 
More information about how the program works can be consulted in “help_K()”.
