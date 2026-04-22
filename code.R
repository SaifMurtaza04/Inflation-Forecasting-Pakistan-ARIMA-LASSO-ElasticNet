# Install necessary packages (run only once)
#install.packages(c( "car", "ggplot2"))
#install.packages("reshape2")  
#install.packages("GGally")
#install.packages("forecast")

# Load libraries
library(readxl)
library(car)       # For VIF (multicollinearity check)
library(ggplot2)   # For better visualization (optional))
library(reshape2)
library(GGally)
library(forecast)



#___________________TASK01___________________________________

# Read data
data <- read_excel("C:/Users/Hassan/Downloads/updatedData.xlsx")

# Check the structure of the data (ensure variables are numeric)
str(data)

# View first few rows
head(data)





#__________________TASK02______________________________________
# Summary statistics
summary(data)





#___________________TASK03______________________________________
# Select only numeric variables
numeric_data <- data[sapply(data, is.numeric)]

# Convert wide data to long format for ggplot2
data_long <- melt(numeric_data)

# Create the boxplot
ggplot(data_long, aes(x = variable, y = value, fill = variable)) +
  geom_boxplot(outlier.color = "red", outlier.shape = 8, alpha = 0.7) +
  theme_minimal() +
  labs(title = "Box and Whisker Plots of All Numeric Variables",
       x = "Variables", y = "Values") +
  theme(legend.position = "none",
        axis.text.x = element_text(angle = 45, hjust = 1))



#___________________TASK04_____________________________________
# Select numeric columns
numeric_data <- data[sapply(data, is.numeric)]

# Create a dummy grouping variable (based on first numeric variable)
data$Group <- cut(numeric_data[[1]], 
                  breaks = 3, 
                  labels = c("Low", "Medium", "High"))

# Create the ggpairs plot and save it to a variable
plot_matrix <- ggpairs(data,
                       columns = which(sapply(data, is.numeric)),
                       mapping = aes(color = Group),  # for scatter plots
                       upper = list(continuous = wrap("points", alpha = 0.7, size = 1.5)),
                       lower = list(continuous = wrap("points", alpha = 0.7, size = 1.5)),
                       diag = list(continuous = wrap("densityDiag", mapping = aes(fill = Group), alpha = 0.5)),
                       title = "Scatter Plot Matrix For All Variables") +
  theme_minimal() +
  scale_color_manual(values = c("Low" = "#a5141f",   
                                "Medium" = "#6219a2", 
                                "High" = "#0bcfc3")) + 
  scale_fill_manual(values = c("Low" = "#a5141f",
                               "Medium" = "#6219a2",
                               "High" = "#a5141f"))

# Print the customized plot
print(plot_matrix)


#________________________________TASK05__________________________
#---------------------------------ARIMA---------------------------
df <- data[sapply(data, is.numeric)]  # recreate df with numeric columns
df <- na.omit(df)                     # remove any missing values
# Check if Inflation exists
names(df)

inflation_ts <- ts(df$Inflation, start = 1990, frequency = 1)


# Visualize
autoplot(inflation_ts) + ggtitle("Inflation Time Series")

# Fit ARIMA model
arima_model <- auto.arima(inflation_ts)
summary(arima_model)

# Forecast next 12 periods
inflation_forecast <- forecast(arima_model, h = 10)
autoplot(inflation_forecast)

#------------------------------RIDGE--------------------------------
#install.packages("glmnet")
library(glmnet)
# Remove inflation column from predictors
x <- as.matrix(df[, !names(df) %in% "Inflation"])
y <- df$Inflation
ridge_model <- cv.glmnet(x, y, alpha = 0)
plot(ridge_model)
coef(ridge_model, s = "lambda.min")
ridge_model <- cv.glmnet(x, y, alpha = 0)
plot(ridge_model)
coef(ridge_model, s = "lambda.min")

#-----------------------------LASSO---------------------------------
lasso_model <- cv.glmnet(x, y, alpha = 1)
plot(lasso_model)
coef(lasso_model, s = "lambda.min")


#-------------------------Elastic Net-------------------------------
elastic_model <- cv.glmnet(x, y, alpha = 0.5)
plot(elastic_model)
coef(elastic_model, s = "lambda.min")


#---------------------------------PREDICTIOn---------------------------
#------------------- PREP: Get actual values ---------------------
# Ensure y is the actual inflation vector (response variable)
y <- df$Inflation
n <- length(y)

#------------------- ARIMA Predictions ---------------------------
fitted_arima <- fitted(arima_model)

# Align length with actual data
len_arima <- length(fitted_arima)
actual_arima <- y[1:len_arima]

# Calculate MSE for ARIMA
mse_arima <- mean((actual_arima - fitted_arima)^2)

#------------------- Ridge Predictions ---------------------------
pred_ridge <- predict(ridge_model, s = "lambda.min", newx = x)
pred_ridge <- as.numeric(pred_ridge)
mse_ridge <- mean((y - pred_ridge)^2)

#------------------- LASSO Predictions ---------------------------
pred_lasso <- predict(lasso_model, s = "lambda.min", newx = x)
pred_lasso <- as.numeric(pred_lasso)
mse_lasso <- mean((y - pred_lasso)^2)

#------------------- Elastic Net Predictions ---------------------
pred_elastic <- predict(elastic_model, s = "lambda.min", newx = x)
pred_elastic <- as.numeric(pred_elastic)
mse_elastic <- mean((y - pred_elastic)^2)

#------------------- Print MSEs ----------------------------------
cat("Mean Squared Errors:\n")
cat("ARIMA       :", round(mse_arima, 4), "\n")
cat("Ridge       :", round(mse_ridge, 4), "\n")
cat("LASSO       :", round(mse_lasso, 4), "\n")
cat("Elastic Net :", round(mse_elastic, 4), "\n")

#------------------- Plot All Predictions ------------------------
years <- seq(1990, length.out = length(y))  
plot(y, type = "l", col = "black", lwd = 2,
     ylab = "Inflation", xlab = "Year",
     main = "Actual vs Predicted Inflation (ARIMA, Ridge, LASSO, Elastic Net)",
     xaxt = "n")  # Suppress default x-axis


axis(1, at = seq_along(y), labels = years)


lines(fitted_arima, col = "orange", lwd = 2)     # ARIMA
lines(pred_ridge, col = "red", lwd = 2)          # Ridge
lines(pred_lasso, col = "green", lwd = 2)        # LASSO
lines(pred_elastic, col = "purple", lwd = 2)     # Elastic Net

legend("topleft", 
       legend = c("Actual", "ARIMA", "Ridge", "LASSO", "Elastic Net"),
       col = c("black", "orange", "red", "green", "purple"), 
       lwd = 2)


