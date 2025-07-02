# run_both.R - Unified launcher for API and Shiny app
# This script runs both the Plumber API and Shiny app simultaneously

# Install required packages if not already installed
required_packages <- c("plumber", "shiny", "future", "promises", "jsonlite", "dplyr", "readr")
missing_packages <- required_packages[!required_packages %in% installed.packages()[, "Package"]]
if (length(missing_packages)) {
    install.packages(missing_packages, repos = "https://cloud.r-project.org/")
}

library(plumber)
library(shiny)
library(future)
library(promises)

# Set up future for async execution
plan(multisession, workers = 2)

cat("Starting Greenhouse Gas Emissions Dashboard...\n")
cat("===============================================\n")

# Function to start the API
start_api <- function() {
    cat("Starting Plumber API on http://127.0.0.1:8000\n")
    pr <- plumb("api.R")

    # Enable CORS for all routes
    pr$filter("cors", function(req, res) {
        res$setHeader("Access-Control-Allow-Origin", "*")
        res$setHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
        res$setHeader("Access-Control-Allow-Headers", "Content-Type, Authorization")

        if (req$REQUEST_METHOD == "OPTIONS") {
            res$status <- 200
            return(list())
        }

        plumber::forward()
    })

    pr$run(port = 8000, host = "127.0.0.1")
}

# Function to start the Shiny app
start_shiny <- function() {
    cat("Starting Shiny App on http://127.0.0.1:3838\n")
    shiny::runApp(
        appDir = ".",
        port = 3838,
        host = "127.0.0.1",
        launch.browser = FALSE
    )
}

# Start API in background
api_future <- future({
    start_api()
})

# Give API time to start
Sys.sleep(2)

# Start Shiny app in background
shiny_future <- future({
    start_shiny()
})

cat("\n")
cat("Both services are starting...\n")
cat("API will be available at: http://127.0.0.1:8000\n")
cat("Shiny App will be available at: http://127.0.0.1:3838\n")
cat("\n")
cat("Press Ctrl+C to stop both services\n")
cat("===============================================\n")

# Keep the main process alive and monitor both services
tryCatch(
    {
        while (TRUE) {
            # Check if either service has stopped
            if (resolved(api_future)) {
                cat("API service stopped!\n")
                break
            }
            if (resolved(shiny_future)) {
                cat("Shiny service stopped!\n")
                break
            }
            Sys.sleep(1)
        }
    },
    interrupt = function(e) {
        cat("\nShutting down services...\n")
    }
)

cat("Services stopped.\n")
