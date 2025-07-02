library(shiny)
library(shinyjs) # Tambahkan untuk reset file input

# Functions untuk uji statistik (tetap sama)
perform_sign_test <- function(sample1, sample2, alpha = 0.05) {
  differences <- sample1 - sample2
  differences <- differences[differences != 0]
  n <- length(differences)
  positive_signs <- sum(differences > 0)
  negative_signs <- sum(differences < 0)
  test_stat <- min(positive_signs, negative_signs)
  p_value <- 2 * pbinom(test_stat, n, 0.5)
  critical_value <- qbinom(alpha / 2, n, 0.5)
  conclusion <- ifelse(p_value < alpha, "Menolak H0", "Gagal menolak H0")
  interpretation <- ifelse(p_value < alpha,
    paste("Terdapat perbedaan signifikan antara kedua sampel pada α =", alpha),
    paste("Tidak ada perbedaan signifikan antara kedua sampel pada α =", alpha)
  )
  return(list(
    testStatistic = test_stat,
    pValue = round(p_value, 4),
    criticalValue = critical_value,
    positiveSign = positive_signs,
    negativeSign = negative_signs,
    zeroSign = length(sample1) - n,
    sampleSize = length(sample1),
    effectiveN = n,
    conclusion = conclusion,
    interpretation = interpretation,
    differences = sample1 - sample2,
    alpha = alpha,
    testType = "sign"
  ))
}

perform_wilcoxon_test <- function(sample1, sample2, alpha = 0.05) {
  differences <- sample1 - sample2
  original_n <- length(differences)
  differences <- differences[differences != 0]
  n <- length(differences)
  abs_diff <- abs(differences)
  ranks <- rank(abs_diff)
  positive_ranks <- ranks[differences > 0]
  negative_ranks <- ranks[differences < 0]
  sum_positive <- sum(positive_ranks)
  sum_negative <- sum(negative_ranks)
  test_stat <- min(sum_positive, sum_negative)
  expected <- n * (n + 1) / 4
  variance <- n * (n + 1) * (2 * n + 1) / 24
  z_score <- (test_stat - expected) / sqrt(variance)
  p_value <- 2 * pnorm(abs(z_score), lower.tail = FALSE)
  effect_size <- abs(z_score) / sqrt(n)
  critical_value <- qnorm(alpha / 2) * sqrt(variance) + expected
  mean_diff <- mean(sample1 - sample2)
  median_diff <- median(sample1 - sample2)
  conclusion <- ifelse(p_value < alpha, "Menolak H0", "Gagal menolak H0")
  interpretation <- ifelse(p_value < alpha,
    paste("Terdapat perbedaan signifikan antara kedua sampel pada α =", alpha),
    paste("Tidak ada perbedaan signifikan antara kedua sampel pada α =", alpha)
  )
  return(list(
    testStatistic = test_stat,
    pValue = round(p_value, 4),
    zScore = round(z_score, 2),
    sumPositiveRanks = sum_positive,
    sumNegativeRanks = sum_negative,
    sampleSize = original_n,
    effectiveN = n,
    effectSize = round(effect_size, 3),
    criticalValue = round(critical_value, 0),
    conclusion = conclusion,
    interpretation = interpretation,
    differences = sample1 - sample2,
    meanDifference = round(mean_diff, 3),
    medianDifference = round(median_diff, 3),
    alpha = alpha,
    testType = "wilcoxon"
  ))
}

perform_run_test <- function(sample1, sample2, alpha = 0.05) {
  differences <- sample1 - sample2
  n <- length(differences)

  # Convert differences to binary sequence (+ and -)
  binary_seq <- ifelse(differences > 0, "+", ifelse(differences < 0, "-", "0"))

  # Remove zeros (tied values)
  binary_seq <- binary_seq[binary_seq != "0"]
  effective_n <- length(binary_seq)

  if (effective_n < 2) {
    stop("Tidak cukup data untuk uji run (minimal 2 observasi non-zero)")
  }

  # Count runs
  runs <- 1
  for (i in 2:effective_n) {
    if (binary_seq[i] != binary_seq[i - 1]) {
      runs <- runs + 1
    }
  }

  # Count positive and negative signs
  n_pos <- sum(binary_seq == "+")
  n_neg <- sum(binary_seq == "-")

  # Handle extreme cases (all same sign)
  if (n_pos == 0 || n_neg == 0) {
    # When all differences have the same sign, pattern is clearly non-random
    z_score <- Inf # Infinite z-score indicates extreme non-randomness
    p_value <- 0.0001 # Very small p-value (practically 0)
    effect_size <- 1.0 # Maximum effect size
    expected_runs <- 1 # Only one run is expected when all signs are same
    variance_runs <- 0 # No variance when all signs are same

    conclusion <- "Menolak H0"
    interpretation <- paste("Semua perbedaan memiliki tanda yang sama - pola sangat non-random pada α =", alpha)
  } else {
    # Normal calculation when both positive and negative signs exist
    expected_runs <- (2 * n_pos * n_neg) / effective_n + 1
    variance_runs <- (2 * n_pos * n_neg * (2 * n_pos * n_neg - effective_n)) /
      (effective_n^2 * (effective_n - 1))

    # Calculate z-score
    z_score <- (runs - expected_runs) / sqrt(variance_runs)

    # Calculate p-value (two-tailed)
    p_value <- 2 * pnorm(abs(z_score), lower.tail = FALSE)

    # Effect size (similar to correlation)
    effect_size <- abs(z_score) / sqrt(effective_n)

    conclusion <- ifelse(p_value < alpha, "Menolak H0", "Gagal menolak H0")
    interpretation <- ifelse(p_value < alpha,
      paste("Urutan data menunjukkan pola non-random pada α =", alpha),
      paste("Urutan data konsisten dengan pola random pada α =", alpha)
    )
  }

  return(list(
    testStatistic = runs,
    expectedRuns = round(expected_runs, 2),
    variance = round(variance_runs, 3),
    zScore = round(z_score, 2),
    pValue = round(p_value, 4),
    positiveCount = n_pos,
    negativeCount = n_neg,
    sampleSize = n,
    effectiveN = effective_n,
    effectSize = round(effect_size, 3),
    conclusion = conclusion,
    interpretation = interpretation,
    differences = differences,
    binarySequence = binary_seq,
    alpha = alpha,
    testType = "run"
  ))
}

perform_mannwhitney_test <- function(sample1, sample2, alpha = 0.05) {
  n1 <- length(sample1)
  n2 <- length(sample2)

  # Perform Wilcoxon rank-sum test (equivalent to Mann-Whitney U)
  wilcox_result <- wilcox.test(sample1, sample2, exact = FALSE)

  # Calculate U statistics manually for detailed output
  combined <- c(sample1, sample2)
  ranks <- rank(combined)

  R1 <- sum(ranks[1:n1]) # Sum of ranks for sample1
  R2 <- sum(ranks[(n1 + 1):(n1 + n2)]) # Sum of ranks for sample2

  # Calculate U statistics
  U1 <- R1 - n1 * (n1 + 1) / 2
  U2 <- R2 - n2 * (n2 + 1) / 2

  # Test statistic is the smaller U
  U <- min(U1, U2)

  # For large samples (n1, n2 > 20), use normal approximation
  mean_U <- n1 * n2 / 2
  var_U <- n1 * n2 * (n1 + n2 + 1) / 12
  z_score <- (U - mean_U) / sqrt(var_U)

  # Effect size (r = Z / sqrt(N))
  effect_size <- abs(z_score) / sqrt(n1 + n2)

  # Medians for comparison
  median1 <- median(sample1)
  median2 <- median(sample2)

  conclusion <- ifelse(wilcox_result$p.value < alpha, "Menolak H0", "Gagal menolak H0")
  interpretation <- ifelse(wilcox_result$p.value < alpha,
    paste("Terdapat perbedaan signifikan antara kedua kelompok independen pada α =", alpha),
    paste("Tidak ada perbedaan signifikan antara kedua kelompok independen pada α =", alpha)
  )

  return(list(
    testStatistic = U,
    U1 = U1,
    U2 = U2,
    rankSum1 = R1,
    rankSum2 = R2,
    zScore = round(z_score, 2),
    pValue = round(wilcox_result$p.value, 4),
    median1 = round(median1, 2),
    median2 = round(median2, 2),
    sampleSize1 = n1,
    sampleSize2 = n2,
    effectSize = round(effect_size, 3),
    conclusion = conclusion,
    interpretation = interpretation,
    sample1 = sample1,
    sample2 = sample2,
    alpha = alpha,
    testType = "mannwhitney"
  ))
}

# Fungsi CSV (tetap sama)
read_csv_robust <- function(file_path) {
  tryCatch(
    {
      all_lines <- readLines(file_path, warn = FALSE, encoding = "UTF-8")
      all_lines <- all_lines[nzchar(all_lines)]

      if (length(all_lines) == 0) {
        stop("File CSV kosong")
      }

      first_line <- all_lines[1]
      separator <- ","
      if (length(grep(";", first_line)) > 0 && length(grep(",", first_line)) == 0) {
        separator <- ";"
      }

      valid_lines <- c()
      for (i in seq_along(all_lines)) {
        line <- trimws(all_lines[i])
        clean_line <- gsub(paste0("\\", separator), "", line)
        clean_line <- gsub("\\s", "", clean_line)

        if (nchar(clean_line) > 0) {
          valid_lines <- c(valid_lines, line)
        }
      }

      if (length(valid_lines) < 2) {
        stop("File CSV harus memiliki minimal 2 baris data valid")
      }

      first_valid <- valid_lines[1]
      parts_first <- strsplit(first_valid, separator)[[1]]
      parts_first <- trimws(parts_first)

      has_header <- FALSE
      if (length(parts_first) >= 2) {
        test_nums <- suppressWarnings(as.numeric(parts_first[1:2]))
        if (any(is.na(test_nums))) {
          has_header <- TRUE
        }
      }

      data_lines <- if (has_header) valid_lines[-1] else valid_lines

      if (length(data_lines) < 5) {
        stop("Minimal 5 baris data numerik diperlukan")
      }

      sample1 <- c()
      sample2 <- c()

      for (i in seq_along(data_lines)) {
        line <- trimws(data_lines[i])
        parts <- strsplit(line, separator)[[1]]
        parts <- trimws(parts)

        non_empty_parts <- parts[nzchar(parts)]
        if (length(non_empty_parts) < 2) {
          next
        }

        val1 <- suppressWarnings(as.numeric(non_empty_parts[1]))
        val2 <- suppressWarnings(as.numeric(non_empty_parts[2]))

        if (!is.na(val1) && !is.na(val2)) {
          sample1 <- c(sample1, val1)
          sample2 <- c(sample2, val2)
        }
      }

      if (length(sample1) < 5 || length(sample2) < 5) {
        stop("Minimal 5 pasang data numerik valid diperlukan")
      }

      if (length(sample1) != length(sample2)) {
        stop("Jumlah data valid di kedua kolom tidak sama")
      }

      return(list(
        sample1 = sample1,
        sample2 = sample2,
        n = length(sample1),
        separator = separator,
        has_header = has_header
      ))
    },
    error = function(e) {
      stop(e$message)
    }
  )
}

# UI - DITAMBAHKAN useShinyjs() dan tombol clear
ui <- fluidPage(
  useShinyjs(), # TAMBAHAN: Enable shinyjs
  titlePanel("Uji Non Parametrik - Sign, Wilcoxon, Run, & Mann Whitney U"),
  fluidRow(
    column(
      4,
      wellPanel(
        h4("Input Data"),
        radioButtons("uji_type", "Pilih Jenis Uji:",
          choices = list(
            "Uji Sign" = "sign",
            "Uji Wilcoxon" = "wilcoxon",
            "Uji Run" = "run",
            "Uji Mann Whitney U" = "mannwhitney"
          ),
          selected = "sign"
        ),
        hr(),

        # SECTION 1: File upload dengan tombol clear
        div(
          h5("📁 Upload File CSV:"),
          fileInput("file_csv", NULL, accept = ".csv"),

          # TAMBAHAN: Tombol untuk clear file dan switch mode
          fluidRow(
            column(
              6,
              downloadButton("download_template", "Download Template",
                class = "btn btn-success btn-sm"
              )
            ),
            column(
              6,
              actionButton("clear_file", "🗑️ Clear File",
                class = "btn btn-warning btn-sm"
              )
            )
          ),

          # TAMBAHAN: Status file
          conditionalPanel(
            condition = "output.file_status != ''",
            div(
              style = "margin-top: 10px; padding: 8px; background-color: #d4edda; border: 1px solid #c3e6cb; border-radius: 4px;",
              strong("📄 File aktif: "),
              textOutput("file_status", inline = TRUE)
            )
          ),
          helpText("Format: 2 kolom data numerik, minimal 5 baris"),
          br()
        ),

        # SECTION 2: Manual input
        div(
          h5("✏️ Atau Input Manual:"),

          # TAMBAHAN: Tombol untuk aktifkan mode manual
          actionButton("use_manual", "🔄 Gunakan Input Manual",
            class = "btn btn-info btn-sm",
            style = "margin-bottom: 10px;"
          ),
          textInput("sample1", "Sampel 1 (pisahkan dengan koma):",
            value = "", placeholder = "78,82,85,79,88"
          ),
          textInput("sample2", "Sampel 2 (pisahkan dengan koma):",
            value = "", placeholder = "75,79,82,76,85"
          ),

          # TAMBAHAN: Info tentang interpretasi data untuk Mann Whitney U
          conditionalPanel(
            condition = "input.uji_type == 'mannwhitney'",
            div(
              style = "background-color: #fff3cd; padding: 8px; border-radius: 4px; border-left: 4px solid #ffc107; margin: 5px 0;",
              HTML("<strong>📝 Catatan Mann Whitney U:</strong><br/>
                          Sampel 1 dan Sampel 2 adalah dua kelompok <em>independen</em> (bukan berpasangan).<br/>
                          Uji ini membandingkan distribusi/median kedua kelompok.")
            )
          ),

          # TAMBAHAN: Info tentang interpretasi data untuk Run test
          conditionalPanel(
            condition = "input.uji_type == 'run'",
            div(
              style = "background-color: #d1ecf1; padding: 8px; border-radius: 4px; border-left: 4px solid #17a2b8; margin: 5px 0;",
              HTML("<strong>📝 Catatan Run Test:</strong><br/>
                          Uji Run menguji randomness urutan perbedaan (Sampel1 - Sampel2).<br/>
                          H0: Urutan perbedaan bersifat random.")
            )
          ),
          actionButton("load_template", "📋 Gunakan Template",
            class = "btn btn-secondary btn-sm"
          ),
          br(), br()
        ),
        numericInput("alpha", "Tingkat Signifikansi (α):",
          value = 0.05, min = 0.01, max = 0.1, step = 0.01
        ),
        br(),
        actionButton("run_test", "🚀 Jalankan Uji", class = "btn btn-primary btn-block btn-lg"),
        br(), br(),

        # Info data yang akan diproses
        conditionalPanel(
          condition = "output.data_info != ''",
          div(
            h6("📊 Data yang akan diproses:"),
            verbatimTextOutput("data_info"),
            style = "background-color: #f8f9fa; padding: 10px; border-radius: 5px; font-size: 12px; border-left: 4px solid #007bff;"
          )
        )
      )
    ),
    column(
      8,
      # Results panel
      conditionalPanel(
        condition = "output.show_results == true",
        div(
          h4("📈 Hasil Analisis"),
          verbatimTextOutput("summary"),
          hr(),
          h4("📊 Visualisasi"),
          fluidRow(
            column(6, plotOutput("main_plot", height = "300px")),
            column(6, plotOutput("diff_plot", height = "300px"))
          )
        )
      ),

      # Placeholder
      conditionalPanel(
        condition = "output.show_results != true",
        div(
          style = "text-align: center; margin-top: 100px;",
          h4("⏳ Siap untuk Analisis", style = "color: #666;"),
          p("Upload file CSV atau masukkan data manual, lalu klik 'Jalankan Uji'.", style = "color: #999;"),
          div(
            style = "margin-top: 30px;",
            span("💡 Tips: ", style = "font-weight: bold; color: #007bff;"),
            "Gunakan tombol 'Clear File' untuk beralih dari CSV ke input manual"
          )
        )
      )
    )
  )
)

# Server - DITAMBAHKAN logika untuk clear file dan mode switching
server <- function(input, output, session) {
  # Reactive values - TAMBAHAN: file_cleared untuk tracking
  values <- reactiveValues(
    results = NULL,
    show_results = FALSE,
    current_data = NULL,
    file_cleared = FALSE, # TAMBAHAN: flag untuk clear file
    force_manual = FALSE # TAMBAHAN: flag untuk force manual mode
  )

  # TAMBAHAN: Clear file function
  observeEvent(input$clear_file, {
    # Reset file input
    reset("file_csv")
    values$file_cleared <- TRUE
    values$force_manual <- FALSE
    showNotification("📁 File CSV telah dihapus. Sekarang bisa menggunakan input manual.", type = "message")
  })

  # TAMBAHAN: Use manual mode
  observeEvent(input$use_manual, {
    reset("file_csv")
    values$file_cleared <- TRUE
    values$force_manual <- TRUE
    showNotification("✏️ Mode input manual diaktifkan. File CSV diabaikan.", type = "message")
  })

  # Template data
  observeEvent(input$load_template, {
    if (input$uji_type == "mannwhitney") {
      # Template untuk Mann Whitney U (dua kelompok independen)
      updateTextInput(session, "sample1", value = "78,82,85,79,88,76,84,87,81,89") # Kelompok A
      updateTextInput(session, "sample2", value = "72,75,80,74,83,70,77,82,76,85") # Kelompok B
    } else {
      # Template untuk uji berpasangan (Sign, Wilcoxon, Run)
      updateTextInput(session, "sample1", value = "78,82,85,79,88,76,84,87,81,89") # Sebelum
      updateTextInput(session, "sample2", value = "75,79,82,76,85,73,81,84,78,86") # Sesudah
    }
    values$force_manual <- TRUE # TAMBAHAN: Force manual ketika load template
  })

  # Download template
  output$download_template <- downloadHandler(
    filename = function() {
      paste0("template-uji-nonparametrik-", Sys.Date(), ".csv")
    },
    content = function(file) {
      template_lines <- c(
        "Sebelum,Sesudah",
        "78,75",
        "82,79",
        "85,82",
        "79,76",
        "88,85",
        "76,73",
        "84,81",
        "87,84",
        "81,78",
        "89,86"
      )
      writeLines(template_lines, file)
    }
  )

  # TAMBAHAN: File status output
  output$file_status <- renderText({
    if (!is.null(input$file_csv) && !values$file_cleared && !values$force_manual) {
      input$file_csv$name
    } else {
      ""
    }
  })

  # Get data function - DIMODIFIKASI dengan logika clear file
  get_data <- reactive({
    # MODIFIKASI: Cek apakah file di-clear atau force manual
    use_csv <- !is.null(input$file_csv) &&
      !is.null(input$file_csv$datapath) &&
      !values$file_cleared &&
      !values$force_manual

    # Priority 1: CSV file (hanya jika tidak di-clear)
    if (use_csv) {
      tryCatch(
        {
          csv_result <- read_csv_robust(input$file_csv$datapath)
          showNotification(
            paste("📁 CSV berhasil dibaca:", csv_result$n, "pasang data"),
            type = "message"
          )
          return(list(sample1 = csv_result$sample1, sample2 = csv_result$sample2, source = "CSV"))
        },
        error = function(e) {
          showNotification(paste("❌ Error CSV:", e$message), type = "error")
          return(NULL)
        }
      )
    }

    # Priority 2: Manual input
    s1_text <- input$sample1
    s2_text <- input$sample2

    if (!is.null(s1_text) && !is.null(s2_text) &&
      nchar(trimws(s1_text)) > 0 && nchar(trimws(s2_text)) > 0) {
      tryCatch(
        {
          sample1 <- as.numeric(strsplit(trimws(s1_text), ",")[[1]])
          sample2 <- as.numeric(strsplit(trimws(s2_text), ",")[[1]])

          if (any(is.na(sample1)) || any(is.na(sample2))) {
            stop("Data harus berupa angka")
          }

          if (length(sample1) != length(sample2)) {
            stop("Jumlah data harus sama")
          }

          if (length(sample1) < 5) {
            stop("Minimal 5 pasang data")
          }

          return(list(sample1 = sample1, sample2 = sample2, source = "Manual"))
        },
        error = function(e) {
          showNotification(paste("❌ Error input manual:", e$message), type = "error")
          return(NULL)
        }
      )
    }

    return(NULL)
  })

  # Update current data
  observe({
    data <- get_data()
    values$current_data <- data
  })

  # TAMBAHAN: Reset file_cleared flag ketika file baru di-upload
  observe({
    if (!is.null(input$file_csv)) {
      values$file_cleared <- FALSE
      values$force_manual <- FALSE
    }
  })

  # Data info output - DIMODIFIKASI dengan emoji dan warna
  output$data_info <- renderText({
    if (!is.null(values$current_data)) {
      source_icon <- ifelse(values$current_data$source == "CSV", "📁", "✏️")
      paste(
        source_icon, "Sumber:", values$current_data$source, "\n",
        "📊 Jumlah data:", length(values$current_data$sample1), "pasang\n",
        "🔢 Sampel 1:", paste(head(values$current_data$sample1, 5), collapse = ", "),
        ifelse(length(values$current_data$sample1) > 5, "...", ""), "\n",
        "🔢 Sampel 2:", paste(head(values$current_data$sample2, 5), collapse = ", "),
        ifelse(length(values$current_data$sample2) > 5, "...", "")
      )
    } else {
      ""
    }
  })

  # Run test
  observeEvent(input$run_test, {
    data <- get_data()

    if (is.null(data)) {
      showNotification("⚠️ Harap masukkan data terlebih dahulu", type = "warning")
      return()
    }

    tryCatch(
      {
        if (input$uji_type == "sign") {
          results <- perform_sign_test(data$sample1, data$sample2, input$alpha)
        } else if (input$uji_type == "wilcoxon") {
          results <- perform_wilcoxon_test(data$sample1, data$sample2, input$alpha)
        } else if (input$uji_type == "run") {
          results <- perform_run_test(data$sample1, data$sample2, input$alpha)
        } else if (input$uji_type == "mannwhitney") {
          results <- perform_mannwhitney_test(data$sample1, data$sample2, input$alpha)
        }

        values$results <- results
        values$show_results <- TRUE
        showNotification("✅ Analisis berhasil!", type = "message")
      },
      error = function(e) {
        showNotification(paste("❌ Error analisis:", e$message), type = "error")
      }
    )
  })

  # Outputs (tetap sama)
  output$show_results <- reactive({
    values$show_results
  })
  outputOptions(output, "show_results", suspendWhenHidden = FALSE)

  output$summary <- renderPrint({
    req(values$results)
    res <- values$results

    cat("=== HASIL UJI", toupper(res$testType), "===\n\n")

    if (res$testType == "sign") {
      cat("Ukuran sampel:", res$sampleSize, "\n")
      cat("Statistik uji:", res$testStatistic, "\n")
      cat("P-value:", res$pValue, "\n")
      cat("Tanda positif:", res$positiveSign, "\n")
      cat("Tanda negatif:", res$negativeSign, "\n")
      cat("Alpha:", res$alpha, "\n")
    } else if (res$testType == "wilcoxon") {
      cat("Ukuran sampel:", res$sampleSize, "\n")
      cat("Statistik uji:", res$testStatistic, "\n")
      cat("P-value:", res$pValue, "\n")
      cat("Z-score:", res$zScore, "\n")
      cat("Effect size:", res$effectSize, "\n")
      cat("Alpha:", res$alpha, "\n")
    } else if (res$testType == "run") {
      cat("Ukuran sampel:", res$sampleSize, "\n")
      cat("Ukuran efektif (non-zero):", res$effectiveN, "\n")
      cat("Jumlah runs:", res$testStatistic, "\n")
      cat("Expected runs:", res$expectedRuns, "\n")
      if (is.finite(res$zScore)) {
        cat("Z-score:", res$zScore, "\n")
      } else {
        cat("Z-score: Extreme case (all signs same)\n")
      }
      cat("P-value:", res$pValue, "\n")
      cat("Tanda positif:", res$positiveCount, "\n")
      cat("Tanda negatif:", res$negativeCount, "\n")
      if (is.finite(res$effectSize)) {
        cat("Effect size:", res$effectSize, "\n")
      } else {
        cat("Effect size: Maximum (1.0)\n")
      }
      cat("Alpha:", res$alpha, "\n")
    } else if (res$testType == "mannwhitney") {
      cat("Ukuran sampel 1:", res$sampleSize1, "\n")
      cat("Ukuran sampel 2:", res$sampleSize2, "\n")
      cat("Statistik U:", res$testStatistic, "\n")
      cat("U1 (sampel 1):", res$U1, "\n")
      cat("U2 (sampel 2):", res$U2, "\n")
      cat("Z-score:", res$zScore, "\n")
      cat("P-value:", res$pValue, "\n")
      cat("Median sampel 1:", res$median1, "\n")
      cat("Median sampel 2:", res$median2, "\n")
      cat("Effect size:", res$effectSize, "\n")
      cat("Alpha:", res$alpha, "\n")
    }

    cat("\nKesimpulan:", res$conclusion, "\n")
    cat("Interpretasi:", res$interpretation, "\n")
  })

  output$main_plot <- renderPlot({
    req(values$results)
    res <- values$results

    if (res$testType == "sign") {
      barplot(c(res$positiveSign, res$negativeSign),
        names.arg = c("Positif", "Negatif"),
        col = c("lightgreen", "lightcoral"),
        main = "Distribusi Tanda - Uji Sign",
        ylab = "Jumlah"
      )
    } else if (res$testType == "wilcoxon") {
      barplot(c(res$sumPositiveRanks, res$sumNegativeRanks),
        names.arg = c("Positive Ranks", "Negative Ranks"),
        col = c("lightgreen", "lightcoral"),
        main = "Distribusi Rank - Uji Wilcoxon",
        ylab = "Sum of Ranks"
      )
    } else if (res$testType == "run") {
      # Plot sequence of signs
      binary_seq <- res$binarySequence
      y_vals <- ifelse(binary_seq == "+", 1, -1)
      plot(1:length(y_vals), y_vals,
        type = "b", pch = 16,
        main = paste("Sequence Plot - Uji Run (", res$testStatistic, "runs )"),
        ylab = "Tanda (+1 / -1)",
        xlab = "Urutan Data",
        col = ifelse(y_vals == 1, "green", "red"),
        ylim = c(-1.5, 1.5)
      )
      abline(h = 0, col = "gray", lty = 2)
      grid()
    } else if (res$testType == "mannwhitney") {
      # Boxplot comparison
      data_combined <- data.frame(
        values = c(res$sample1, res$sample2),
        group = factor(c(
          rep("Sampel 1", length(res$sample1)),
          rep("Sampel 2", length(res$sample2))
        ))
      )
      boxplot(values ~ group,
        data = data_combined,
        col = c("lightblue", "lightgreen"),
        main = "Perbandingan Distribusi - Mann Whitney U",
        ylab = "Nilai",
        xlab = "Kelompok"
      )
    }
  })

  output$diff_plot <- renderPlot({
    req(values$results)
    res <- values$results

    if (res$testType == "mannwhitney") {
      # Histogram comparison for Mann Whitney U
      par(mfrow = c(1, 2))
      hist(res$sample1,
        main = paste("Sampel 1 (n=", res$sampleSize1, ")"),
        xlab = "Nilai", col = "lightblue"
      )
      hist(res$sample2,
        main = paste("Sampel 2 (n=", res$sampleSize2, ")"),
        xlab = "Nilai", col = "lightgreen"
      )
      par(mfrow = c(1, 1))
    } else {
      # Difference plot for paired tests (sign, wilcoxon, run)
      dif <- res$differences
      plot(1:length(dif), dif,
        type = "b",
        main = "Plot Perbedaan Data",
        ylab = "Selisih (Sampel1 - Sampel2)",
        xlab = "Index Data",
        col = ifelse(dif > 0, "green", ifelse(dif < 0, "red", "gray")),
        pch = 16
      )
      abline(h = 0, col = "gray", lty = 2)
      grid()
    }
  })
}

# Run app
shinyApp(ui = ui, server = server)
