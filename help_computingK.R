help_K <- function(type = "generic") {
  if (type == "generic") {
    cat("----- YOU ARE IN THE GENERIC HELP FUNCTION. This programm allows to obtain the value of the USLE erodibility K-factor for any given soil. If you want to know more about how this program works you have the following options \n")
    cat("1. help_K(\"input values\") : Tells you information about how the input values must be\n")
    cat("2. help_K(\"output values\") : Tells you information about how the output values are given\n")
  } else if (type == "input values") {
    cat("----- YOU ARE IN THE INPUT VALUES HELP FUNCTION. The following input values are required:\n")
    cat("* SandUSDA: percentage of sand in the USDA particle-size classification system, with one decimal digit.\n")
    cat("* SiltUSDA: percentage of silt in the USDA particle-size classification system, with one decimal digit.\n")
    cat("* ClayUSDA: percentage of clay in the USDA particle-size classification system, with one decimal digit.\n")
    cat("* VFS_USDA : percentage of very fine sand in the USDA particle-size classification system, with one decimal digit. \n")
    cat("* OM : organic matter. Must be a value from 0.0 to 4.0 (included) with one decimal.\n")
    cat("* Structure: code of structure of the topsoil, which is an integer number from 1 to 4. Their meaning can be consulted in Wischmeier and Smith (1978). \n")
    cat("* Permeability: profile permeability class, which is an integer number from 1 to 6. Their meaning can be consulted in Wischmeier and Smith (1978). \n")
  } else if (type == "output values") {
    cat("----- YOU ARE IN THE OUTPUT VALUES HELP FUNCTION. The output values given when executing this program are:\n")
    cat("* SandUSDA: percentage of sand in the USDA particle-size classification system, with one decimal digit.\n")
    cat("* SiltUSDA: percentage of silt in the USDA particle-size classification system, with one decimal digit.\n")
    cat("* ClayUSDA: percentage of clay in the USDA particle-size classification system, with one decimal digit.\n")
    cat("* OM : organic matter. Must be a value from 0.0 to 4.0 (included) with one decimal.\n")
    cat("* Structure: code of structure of the topsoil, which is an integer number from 1 to 4. Their meaning can be consulted in Wischmeier and Smith (1978). \n")
    cat("* Permeability: profile permeability class, which is an integer number from 1 to 6. Their meaning can be consulted in Wischmeier and Smith (1978). \n")
    cat("*VFS_Q2: predicted value for the very fine sand fraction (conditional median). Empty when VFS is known. \n")
    cat("*VFS_Q1: Lower limit of the 50% prediction interval (first conditional quartile). Empty when VFS is known. \n")
    cat("*VFS_Q3: Upper limit of the 50% prediction interval (third conditional quartile). Empty when VFS is known.  \n")
    cat("*FactorK_US: K-factor values expressed in (0.01 ton acre h) / (acre ft-tonf in). \n")
    cat("*FactorK_Q1_US: Lower limit of the 50% prediction interval (first conditional quartile); values expressed in (0.01 ton acre h) / (acre ft-tonf in). Empty when VFS is known. \n")
    cat("*FactorK_Q3_US: Upper limit of the 50% prediction interval (third conditional quartile); values expressed in (0.01 ton acre h) / (acre ft-tonf in). Empty when VFS is known. \n")
    cat("*FactorK_SI: K-factor values expressed in (t ha h)/(MJ ha cm). \n")
    cat("*FactorK_Q1_SI: Lower limit of the 50% prediction interval (first conditional quartile); values expressed in (t ha h)/(MJ ha cm). Empty when VFS is known. \n")
    cat("*FactorK_Q3_SI: Upper limit of the 50% prediction interval (third conditional quartile); values expressed in (t ha h)/(MJ ha cm). Empty when VFS is known. \n")
    cat("*Check: Indicates if an extrapolation is being done when texture is out of range (value 'EXTRAPOLATION-OUT OF RANGE'). If not, empty. \n")
  } else {
    cat("YOU HAVE INTRODUCED A WRONG ARGUMENT TO THE HELP FUNCTION. THE OPTIONS ARE: \n")
    cat("1. help_K() : For generic information\n")
    cat("2. help_K(\"input values\") : Tells you information about how the input values must be\n")
    cat("3. help_K(\"output values\") : Tells you information about how the output values are given\n")
  }
}
