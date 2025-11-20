# 1. Setup and Data
setwd("../Project_Solution")
library(pls)
Credit <- read.csv("../Project_Solution/Credit.csv")

set.seed(1) # Set seed for reproducibility of PCR

# 2. Run Principal Component Regression 
# It combines your correlated variables into a smaller set of new
# uncorrelated "super-variables" called Principal Components
pcr_model <- pcr(
  #standardize the data to a z-Distribution (scale = TRUE)
  Balance ~ ., data = Credit, scale = TRUE, validation = "CV")

# 3. Extract Coefficients
# The raw coefficients are a 3D array: [Variables, Balance, PCs]
# We extract "Balance" out because its our dependent variable
# For each Category e.g Income we take the Coefficient that explains the relationship between 
# e.g. Income and Balance
coef_matrix <- pcr_model$coefficients[, "Balance", ]

# 4. Data Preparation for Smoothing 
# In Principal Component Analysis (PCA), you cannot create more components than you have input variables.
# Component 1 explains the most variance.
# ...
# Component 11 explains the least variance.
# Component 12 is impossible (there is no more data left to explain).
# If you use all 11 components, your PCR model becomes exactly the same as a 
#standard Least Squares Regression model (OLS).
n_components <- 11
stretch_factor <- 10 # makes 110 data points instead of 11 so the plot is more beautiful (and like the textbook)

# Repeat the columns to match the plotting grid
# Transpose (t) is used so that plot reads components as x and variables as y
stretched_coefs <- t(coef_matrix[, rep(1:n_components, each = stretch_factor)])

# Create the x-axis grid
x_grid <- seq(1, n_components, length = n_components * stretch_factor)

# 5. Plotting
par(mfrow = c(1, 2))

# --- Plot Left: Standardized Coefficients ---
# Define colors and line types 
line_cols <- c("black", "red", "blue", "grey", "grey", "grey", "grey", "orange", "grey", "grey", "grey")
line_types <- c(1, 2, 3, 1, 1, 1, 1, 4, 1, 1, 1)
line_widths <- c(2.2, 2.2, 2.2, 1.2, 1.2, 1.2, 1.2, 2.2, 1.2, 1.2, 1.2)

# actual plot
matplot(x_grid, stretched_coefs, 
        type = 'l', 
        col = line_cols, 
        lty = line_types, 
        lwd = line_widths,
        xlab = "Number of Components", 
        ylab = "Standardized Coefficients", 
        cex.lab = 1.3)

# legend
legend("topleft", 
       names(Credit)[c(1, 2, 3, 8)], 
       col = c("black", "red", "blue", "orange"), 
       lty = 1:4, lwd = 2, bty = "n", cex = 1.3)

# --- Plot Right: Cross-Validation MSE ---
# Using 'MSEP' function to extract Mean Squared Error of Prediction
cv_mse <- MSEP(pcr_model)$val[1, 1, -1] 
# $val$ (1-> Cross Validation Standart error , 1 -> Balance, -1 -> Remove Intercept )

plot(cv_mse, 
     col = "purple", 
     type = "b",
     ylab = "Cross-Validation MSE", 
     xlab = "Number of Components", 
     cex.lab = 1.3)
