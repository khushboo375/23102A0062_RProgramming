# TASK 1 : Import and Inspect the Dataset

# Import dataset using tryCatch()

air_data <- tryCatch(
  {
    read.csv("data/PRSA_Data_Aotizhongxin_20130301-20170228.csv")
  },
  error = function(e)
  {
    cat("Error:", e$message, "\n")
    NULL
  }
)

# Display first six records
head(air_data)

# Display structure
str(air_data)

# Display rows and columns
dim(air_data)

# Check whether missing values exist
any(is.na(air_data))

# Total missing values
sum(is.na(air_data))


# TASK 2 : Understand NA, NULL and NaN

# Example of NA
temperature <- c(28, 30, NA, 32)

print("Temperature Vector:")
print(temperature)

print("Check NA:")
print(is.na(temperature))

# Example of NULL
missing_object <- NULL

print("NULL Object:")
print(missing_object)

print("Check NULL:")
print(is.null(missing_object))

# Example of NaN
undefined_value <- 0 / 0

print("NaN Value:")
print(undefined_value)

print("Check NaN:")
print(is.nan(undefined_value))

# Comparison of NA, NULL and NaN
comparison <- data.frame(
  Type = c("NA", "NULL", "NaN"),
  Meaning = c(
    "Missing Value",
    "Empty Object",
    "Undefined Numerical Result"
  )
)
print(comparison)


# TASK 3 : Missing Value Summary Function
missing_summary <- function(data)
{
  # Variables required in the assignment
  selected_variables <- c("PM2.5", "PM10", "SO2", "NO2", "TEMP", "WSPM", "wd")
  # Empty dataframe to store results
  summary_table <- data.frame(
    Variable = character(),
    Total_Records = integer(),
    Missing_Values = integer(),
    Missing_Percentage = numeric(),
    stringsAsFactors = FALSE
  )
  for(variable in selected_variables)
  {
    total_records <- nrow(data)
    missing_values <- sum(is.na(data[[variable]]))
    missing_percentage <- (missing_values / total_records) * 100
    summary_table <- rbind(
      summary_table,
      data.frame(
        Variable = variable,
        Total_Records = total_records,
        Missing_Values = missing_values,
        Missing_Percentage = round(missing_percentage,2)
      )
    )
    # Warning if missing percentage >20%
    if(missing_percentage > 20)
    {
      warning(paste(variable,
                    "contains more than 20% missing values"))
    }
  }
  
  return(summary_table)
}
summary_result <- missing_summary(air_data)
print(summary_result)

# TASK 4 : Identify Invalid Numerical Results

# Create pollution_ratio

air_data$pollution_ratio <- air_data$PM2.5 / air_data$PM10
print("Pollution Ratio Created Successfully")

# Count different invalid values

na_count <- sum(is.na(air_data$pollution_ratio))

nan_count <- sum(is.nan(air_data$pollution_ratio))

positive_inf <- sum(air_data$pollution_ratio == Inf, na.rm = TRUE)

negative_inf <- sum(air_data$pollution_ratio == -Inf, na.rm = TRUE)

cat("NA Values:", na_count, "\n")
cat("NaN Values:", nan_count, "\n")
cat("Positive Infinity:", positive_inf, "\n")
cat("Negative Infinity:", negative_inf, "\n")

# Replace NaN and Infinite values with NA

air_data$pollution_ratio[
  is.nan(air_data$pollution_ratio) |
    is.infinite(air_data$pollution_ratio)
] <- NA

# Verify after replacement

cat("Remaining NaN:",
    sum(is.nan(air_data$pollution_ratio)),
    "\n")

cat("Remaining Infinite:",
    sum(is.infinite(air_data$pollution_ratio)),
    "\n")


# TASK 5 : Handle Missing Numerical Values

# Numerical variables to clean
numeric_variables <- c("PM2.5", "PM10", "SO2", "NO2", "TEMP", "WSPM")

# Store missing values before and after cleaning
missing_before_vector <- c()
missing_after_vector <- c()

# Loop through each numerical variable
for(variable in numeric_variables)
{
  # Check if column exists
  if(variable %in% names(air_data))
  {
    # Count missing values before replacement
    missing_before <- sum(is.na(air_data[[variable]]))
    # Calculate median
    median_value <- median(air_data[[variable]], na.rm = TRUE)
    # Replace missing values with median
    air_data[[variable]][is.na(air_data[[variable]])] <- median_value
    # Count missing values after replacement
    missing_after <- sum(is.na(air_data[[variable]]))
    
    missing_before_vector <- c(missing_before_vector, missing_before)
    
    missing_after_vector <- c(missing_after_vector, missing_after)
    
    # Display results
    cat("\n-----------------------------\n")
    cat("Variable :", variable, "\n")
    cat("Missing Before :", missing_before, "\n")
    cat("Median Used :", median_value, "\n")
    cat("Missing After :", missing_after, "\n")
  }
  else
  {
    cat(variable, "does not exist in the dataset.\n")
  }
}

# Verify that all selected numerical variables have no missing values
for(variable in numeric_variables)
{
  cat(variable, ":", sum(is.na(air_data[[variable]])), "missing values\n")
}


# TASK 6 : Handle Missing Categorical Values
# Function to calculate mode

calculate_mode <- function(x)
{
  
  # Remove missing values
  x <- x[!is.na(x)]
  
  # Find frequency of each value
  frequency <- table(x)
  
  # Return the most frequent value
  mode_value <- names(frequency)[which.max(frequency)]
  
  return(mode_value)
}

# Missing values before replacement

missing_before <- sum(is.na(air_data$wd))

cat("Missing values before replacement:", missing_before, "\n")

# Calculate mode

mode_wd <- calculate_mode(air_data$wd)

cat("Mode of wd:", mode_wd, "\n")

# Replace missing values with mode

air_data$wd[is.na(air_data$wd)] <- mode_wd

# Missing values after replacement

missing_after <- sum(is.na(air_data$wd))

wd_before <- missing_before
wd_after <- missing_after

cat("Missing values after replacement:", missing_after, "\n")

# TASK 7 : Error Handling using tryCatch()

clean_variable <- function(data, variable_name)
{
  tryCatch(
    {
      # Check whether the variable exists
      if(!(variable_name %in% names(data)))
      {
        stop("Variable does not exist.")
      }
      # Check whether the variable is numeric
      if(!is.numeric(data[[variable_name]]))
      {
        stop("Variable is not numerical.")
      }
      
      # Check whether all values are missing
      if(all(is.na(data[[variable_name]])))
      {
        stop("Variable contains only missing values.")
      }
      # Calculate median
      median_value <- median(data[[variable_name]], na.rm = TRUE)
      # Check whether median can be calculated
      if(is.na(median_value))
      {
        stop("Median cannot be calculated.")
      }
      # Replace missing values
      data[[variable_name]][is.na(data[[variable_name]])] <- median_value
      
      cat(variable_name,
          "cleaned successfully.\n")
      
      return(data[[variable_name]])
      
    },
    
    error = function(e)
    {
      cat("Error:", e$message, "\n")
      return(NULL)
    })
  
}

clean_variable(air_data, "PM2.5")
clean_variable(air_data, "ABC")
clean_variable(air_data, "wd")
air_data$Test <- NA
clean_variable(air_data, "Test")
air_data$Test <- NULL

# TASK 8 : Comparison Table
# TASK 9 : Visualization

# Reload the original dataset to get missing values BEFORE cleaning
original_data <- read.csv("data/PRSA_Data_Aotizhongxin_20130301-20170228.csv")

# Variables required by the assignment
numeric_variables <- c("PM2.5", "PM10", "SO2", "NO2", "TEMP", "WSPM")

# Store missing values before cleaning
missing_before_vector <- c()

for(variable in numeric_variables)
{
  missing_before_vector <- c(
    missing_before_vector,
    sum(is.na(original_data[[variable]]))
  )
}

wd_before <- sum(is.na(original_data$wd))

# Store missing values after cleaning
missing_after_vector <- c()

for(variable in numeric_variables)
{
  missing_after_vector <- c(
    missing_after_vector,
    sum(is.na(air_data[[variable]]))
  )
}

wd_after <- sum(is.na(air_data$wd))

# Create comparison table
comparison_table <- data.frame(
  Variable = c(numeric_variables, "wd"),
  Missing_Before = c(missing_before_vector, wd_before),
  Missing_After = c(missing_after_vector, wd_after)
)

comparison_table$Values_Replaced <-
  comparison_table$Missing_Before -
  comparison_table$Missing_After

# Display comparison table
print(comparison_table)

# Interpretation
cat("\nInterpretation:\n")
cat("All selected numerical variables were cleaned using the median,")
cat(" while the categorical variable 'wd' was cleaned using the mode.\n")
cat("After cleaning, the missing values for all selected variables became zero.\n")

# TASK 9 : Bar Chart
# Convert comparison table into matrix
plot_data <- as.matrix(
  comparison_table[, c("Missing_Before", "Missing_After")]
)

# Transpose matrix
plot_data <- t(plot_data)

# Set variable names
colnames(plot_data) <- comparison_table$Variable

# Create bar chart
barplot(
  plot_data,
  beside = TRUE,
  col = c("red", "green"),
  main = "Missing Values Before and After Cleaning",
  xlab = "Variables",
  ylab = "Number of Missing Values",
  legend.text = c("Before Cleaning", "After Cleaning"),
  args.legend = list(x = "topright")
)

# Save the chart (optional but recommended)
png("Missing_Value_BarChart.png", width = 900, height = 600)

barplot(
  plot_data,
  beside = TRUE,
  col = c("red", "green"),
  main = "Missing Values Before and After Cleaning",
  xlab = "Variables",
  ylab = "Number of Missing Values",
  legend.text = c("Before Cleaning", "After Cleaning"),
  args.legend = list(x = "topright")
)

dev.off()

# TASK 10 : Export Cleaned Dataset
# Export the cleaned dataset

write.csv(
  air_data,
  "cleaned_air_quality_data.csv",
  row.names = FALSE
)

cat("Cleaned dataset exported successfully.\n")