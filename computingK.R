computingK <- function(){
  library("readxl")
  library("writexl")
  library("cellranger")
  library("rstudioapi")
  dir = dirname(rstudioapi::getSourceEditorContext()$path)
  setwd(dir)
  source("K_equations.R")
  source("help_computingK.R")
  
  
  cat("---- Analyzing input data...\n")
  data <- readxl::read_xlsx(paste(dir,"/Data/USDA_VFS.xlsx", sep = ""), sheet = 1, col_names = TRUE, col_types = c("numeric","numeric","numeric", "numeric", "numeric", "numeric"))
  input_data <- readxl::read_xlsx(paste(dir,"/Input_data.xlsx", sep = ""), sheet = 1, range = cell_cols("A:G"), col_names = TRUE, col_types = c("numeric", "numeric", "numeric", "numeric", "numeric", "numeric", "numeric"))
  
  # First we check if the input data is correct (must be satisfied that sand + silt + clay = 100%)
  col1 = names(input_data[1])
  col2 = names(input_data[2])
  col3 = names(input_data[3])
  
  for (i in 1:nrow(input_data)) {
    ele1 = as.numeric(input_data[i,1])
    ele2 = as.numeric(input_data[i,2])
    ele3 = as.numeric(input_data[i,3])
    sum = (ele1 + ele2 + ele3)
    
    if ( floor(sum) != 100) {
      cat("---- WARNING! Data with values: \n", col1, ele1, "\n", col2, ele2, "\n", col3, ele3, "\nhas wrong quantities, it will be left blank\n")  
    }
  }
  
  # Used for giving the output data in the same order as the input
  input_data$id <- 1:nrow(input_data)
  merged <- merge(x = input_data, y = data, by = c(col1, col2, col3), all.x = TRUE, sort = FALSE)
  ordered <- merged[order(merged$id),]
  
  output_data <- ordered[, ! names(ordered) %in% "id", drop = F]
  
  # Now we will add the value of the K for each quartile
  vectorq1 <- rep(c(0),times=nrow(output_data))
  vectorq2 <- rep(c(0),times=nrow(output_data))
  vectorq3 <- rep(c(0),times=nrow(output_data))
  check <- rep(c(0),times=nrow(output_data))
  
  for (i in 1:nrow(output_data)) {
    sand = output_data[i,1]
    silt = output_data[i,2]
    clay = output_data[i,3]
    VFS = output_data[i,4]
    a = output_data[i, 5]
    soil = output_data[i, 6]
    permeability = output_data[i,7]
    VFS2 = output_data[i,8]
    VFS1 = output_data[i,9]
    VFS3 = output_data[i,10]
    check[i] <- NA
    #First we check if this data is correct or not. If it is not correct, then the entries of VFS1, VFS2, VFS3 will be empty
    if(decimalplaces(sand) || decimalplaces(silt) || decimalplaces(clay) || decimalplaces(VFS)) {
      cat("WARNING! All SandUSDA, SiltUSDA, ClayUSDA and VFS_USDA must have at most 1 decimal. That data will be left with a blank space\n")
      cat("The data of that wrong entry is: \n")
      cat ( names(input_data[1]),":", sand, "\n", names(input_data[2]), ": ", silt ,"\n", names(input_data[3]),":", clay, "\n", names(input_data[4]),":", VFS ,"\n", names(input_data[5]),": ", a, "\n", names(input_data[6]), ": ", soil, "\n", names(input_data[7]), ": ", permeability,"\n")
      vectorq1[i] <- NA
      vectorq2[i] <- NA
      vectorq3[i] <- NA
    } else if (is.na(VFS1) || is.na(VFS2) || is.na(VFS3)) {
      cat("Estimate of VFS not found for the following entry: \n")
      cat ( names(input_data[1]),":", sand, "\n", names(input_data[2]), ": ", silt ,"\n", names(input_data[3]),":", clay, "\n", names(input_data[4]),":", VFS ,"\n", names(input_data[5]),": ", a, "\n", names(input_data[6]), ": ", soil, "\n", names(input_data[7]), ": ", permeability,"\n")
      cat("That entry will be left with a blank space.\n")
      vectorq1[i] <- NA
      vectorq2[i] <- NA
      vectorq3[i] <- NA
    } else if (is.element(soil, c(1,2,3,4)) && is.element(permeability, c(1,2,3,4,5,6))) {
      # We check if the values of the soil structure and permeability are correct
      
      if (0 <= a && a <= 4){
        # We also check for the organic matter
        
        if ((clay < 12 && silt > 80) || (clay > 40 && silt < 40) || (clay > 20 && clay <= 40 && sand > 45)) {
          cat("WARNING! Texture out of range of Factor K definition for the following entry: \n")
          cat ( names(input_data[1]),":", sand, "\n", names(input_data[2]), ": ", silt ,"\n", names(input_data[3]),":", clay, "\n", names(input_data[4]),":", VFS ,"\n", names(input_data[5]),": ", a, "\n", names(input_data[6]), ": ", soil, "\n", names(input_data[7]), ": ", permeability,"\n")
          cat("An extrapolation is being done. \n")
          check[i] <- 'EXTRAPOLATION-OUT OF RANGE'
        }
        
        if (is.na(VFS)) {
          vectorq1[i] <- K_equations(VFS1, silt, sand, a, soil, permeability)
          vectorq2[i] <- K_equations(VFS2, silt, sand, a, soil, permeability)
          vectorq3[i] <- K_equations(VFS3, silt, sand, a, soil, permeability)
          
          if(is.na(vectorq1[i]) || is.na(vectorq2[i]) || is.na(vectorq3[i])) {
            # If the output is NA, then the reason is because of the M parameter
            
            cat("WARNING! Result of parameter M is bigger tan 8000. You can call help() for generic information about the usage of this program. That data will be left with a blank space\n")
            cat("The data of that wrong entry is: \n", names(input_data[1]),":", sand, "\n", names(input_data[2]), ": ", silt ,"\n", names(input_data[3]),":", clay, "\n", names(input_data[4]),": ", a, "\n", names(input_data[4]), ": ", soil, "\n", names(input_data[5]), ": ", permeability,"\n")
          }
        } else {
          # Checking if VFS_USDA > SandUSDA
          if (VFS > sand) {
            cat('WARNING! VFS_USDA is greater than SandUSDA. Factor K is not being computed.')
            vectorq2[i] <- NA
          } else {
            vectorq2[i] <- K_equations(VFS, silt, sand, a, soil, permeability)
            if(is.na(vectorq2[i])) {
              # If the output is NA, then the reason is because of the M parameter
              
              cat("WARNING! Result of parameter M is bigger tan 8000. You can call help() for generic information about the usage of this program. That data will be left with a blank space\n")
              cat("The data of that wrong entry is: \n", names(input_data[1]),":", sand, "\n", names(input_data[2]), ": ", silt ,"\n", names(input_data[3]),":", clay, "\n", names(input_data[4]),": ", a, "\n", names(input_data[4]), ": ", soil, "\n", names(input_data[5]), ": ", permeability,"\n")
            }
          }
          output_data[i,8] <- NA
          output_data[i,9] <- NA
          output_data[i,10] <- NA
          vectorq1[i] <- NA
          vectorq3[i] <- NA
        }
        
      } else {
        cat("--------WARNING! There is something wrong with the value of the organic matter.")
        cat("RECALL THAT: \n")
        cat("* O.M. : organic matter. Must be a value from 0.0 to 4.0 (included) with one decimal.")
        cat("For more information call help(\"input data\")\n")
        cat("That entry will be left blank when doing the computations")
        vectorq1[i] <- NA
        vectorq2[i] <- NA
        vectorq3[i] <- NA
      }
      
    } else {
      cat("--------WARNING! There is something wrong with atribute permeability or soil structure. The data of that wrong entry is: \n", names(input_data[1]),":", sand, "\n", names(input_data[2]), ": ", silt ,"\n", names(input_data[3]),":", clay, "\n", names(input_data[4]),": ", a, "\n", names(input_data[5]), ": ", soil, "\n", names(input_data[6]), ": ", permeability,"\n")
     
      cat("RECALL THAT: \n")
      cat("* Soil structure: must be a number from 1 to 4 with the following meanings: \n")
      cat ("       1 = very fine granular\n       2 = fine granular\n       3 = moderate or coorse granular\n       4 = blocky, platy, or massive\n")
      cat("* Permeability: must be a number from 1 to 6 with the following meanings: \n")
      cat ("       1 = rapid\n       2 = moderate to rapid\n       3 = moderate\n       4 = slow to moderate\n       5 = slow\n       6 = very slow\n")
      cat("For more information call help(\"input data\")\n")
      cat("That entry will be left blank when doing the computations")
      vectorq1[i] <- NA
      vectorq2[i] <- NA
      vectorq3[i] <- NA
    }
    
  }
  
  # Computing K in SI
  vectorq1IS <- round(1.317*vectorq1, digits = 3)
  vectorq2IS <- round(1.317*vectorq2, digits = 3)
  vectorq3IS <- round(1.317*vectorq3, digits = 3)

  output_data$FactorK_US <- vectorq2
  output_data$FactorK_Q1_US <- vectorq1
  output_data$FactorK_Q3_US <- vectorq3
 
  
  output_data$FactorK_SI <- vectorq2IS
  output_data$FactorK_Q1_SI <- vectorq1IS
  output_data$FactorK_Q3_SI <- vectorq3IS
  
  output_data$Check <- check
  
  # Writing the resulting data
  
  writexl::write_xlsx(output_data, "Output_data.xlsx", col_names = TRUE, format_headers = TRUE)
  
  cat("---- Output data has been produced\n")
}

