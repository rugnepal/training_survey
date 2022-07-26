function(input, output, session) {

  # firebase email auth objects
  f <- FirebaseEmailPassword$new(persistence = "session")

  # sign in
  observeEvent(input$signin, {
    # removeModal()
    f$sign_in(input$email_signin, input$password_signin)

    showNotification("Welcome, Dear Guest", duration = 5, type = "message")
  })

  # sign out
  observeEvent(input$signout, {
    f$sign_out()

    showNotification("See you, next time", duration = 5, type = "message")
  })

  # submit data

  observeEvent(input$submit,
    {
      tdf <- tibble(
        date_time = Sys.time(),
        full_name = input$name_in,
        age_group = input$age_group_in,
        gender = input$gender_in,
        country = input$country_in,
        address = input$address_in,
        academic_qual = input$academic_qual,
        field_involved = input$field_involved,
        programming_level = input$programming_level,
        os_type = input$os_type_in
      )

      data_final <- reactiveValues(df = tdf %>%
        geocode(address,
          method = "osm",
          lat = lat, long = long
        ))

      readRDS("./data/training_survey.rds") %>%
        bind_rows(data_final$df) %>%
        saveRDS("./data/training_survey.rds")

      updateBox("mybox", action = "toggle")

      showNotification("Data is saved",
        duration = 5,
        type = "message"
      )

      ss %>% googlesheets4::sheet_append(data_final$df)
    },
    ignoreNULL = TRUE,
    ignoreInit = TRUE
  )

  observeEvent(input$submit || input$reload, {
    showNotification("Data is reloading",
      duration = 5,
      type = "message"
    )
    updateTabsetPanel(session, "dashtabs",
      selected = "Map"
    )

    data_df <-  reactiveValues(df =
      # read_sheet(ss)
      readRDS("./data/training_survey.rds")
    )

    showNotification("Map is loaded",
      duration = 5,
      type = "message"
    )

    output$map <- renderLeaflet({
      req(data_df$df, f$req_sign_in())
      leaflet(data_df$df) %>%
        # addTiles() %>%
        addProviderTiles(providers$CartoDB.Positron) %>%
        addMarkers(~long, ~lat,
          popup = ~ htmlEscape(full_name),
          clusterOptions = markerClusterOptions()
        )
    })

    data_filter <- reactive({
      data_df$df %>%
        count(!!rlang::sym(input$col_choice), name = "count", sort = T) %>%
        mutate(!!rlang::sym(input$col_choice) :=
                 forcats::fct_reorder(!!rlang::sym(input$col_choice), count))
    }) %>%
      bindCache(input$col_choice, data_df$df, cache = "app") %>%
      bindEvent(input$col_choice, data_df$df)

    output$plot <- renderPlot({
      req(input$col_choice, data_filter(), f$req_sign_in())

      ggplot(data_filter()) +
        geom_col(aes_string(y = input$col_choice, x = "count", fill = input$col_choice)) +
        # bbplot::bbc_style() +

        theme_minimal() +
        theme(legend.position = "",
            axis.title=element_blank(),
            axis.text = element_text(size = 15))
    })

  })


  ## box state

  output$box_state <- renderText({
    ifelse(input$mybox$collapsed,
      "Thank you for submission",
      "Please, complete this form & click Submit"
    )
  })






}
