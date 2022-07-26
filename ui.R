
title <- "Training Survey"

header <- reqSignin(dashboardHeader(
  title = reqSignin(
    bs4Dash::dashboardBrand(
      title = "Training Survey",
      color = "primary",
      href = "#"
    )
  )
))

sidebar <- dashboardSidebar(
  shinyjs::useShinyjs(),
  sidebarMenu(
    id = "tabs",
    menuItem(
      startExpanded = F,
      "Form",
      tabName = "Form",
      icon = icon("file"),
      column(
        width = 3,
        actionButton("reload", "Reload", icon = icon("sync"))
      )
    )
  )
)


body2 <- dashboardBody(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
  ),
  reqSignin(actionButton("signout", "Sign out", icon = icon("sign-out-alt"))),
  tabsetPanel(
    id = "dashtabs",
    type = "tabs",
    tabPanel(
      "Form",
      box(
        id = "mybox",
        width = 12,
        title = textOutput("box_state"),
        # title = "Please, complete this form & click Submit button",
        fluidRow(
          column(
            width = 6,
            textInput("name_in", "Full Name:"),
            selectInput("age_group_in", "Age Group",
              choices = c(
                "Children (0-11)",
                "Youth (12-24)",
                "Young adults (25-39)",
                "Middle-aged adults (40-59)",
                "Old adults (60+)"
              ),
              selected = "Young adults (25-39)"
            ),
            selectInput("gender_in", "Gender:", choices = c("Male", "Female", "Other")),
            selectInput("country_in", "Country:", choices = country_list$country_name_en, selected = "Nepal"),
            textInput("address_in", "Address (City only)")
          ),
          column(
            width = 6,


            selectInput("academic_qual", "What is your current academic qualification?",
                        choices = c("High School", "Bachelor", "Master", "MD", "PhD", "Post Doc")),

            selectInput("field_involved", "Which field are you involved in?",
                        choices = c("Health", "Finance", "Business",
                                    "Journalism", "Banking", "Academia"
                                    )),

            selectInput("programming_level", "What's your understanding level of Programming?",
                        choices = c("Novice", "Fundamental", "Intermediate")),

            selectInput("os_type_in", "Operating System",
              choices = c("Windows", "Mac", "Linux")
            )
          )
        ),

        fluidRow(
          column(width = 6,
                 actionButton("submit", "Submit") #,
                 #actionButton("view_map", "View Map")
                 )

        )
      )
    ),
    tabPanel(
      "Map",
      box(
        width = 12,
        title = column(width = 12, ),
        leafletOutput("map")
      )
    ),
    tabPanel(
      "Plot",
      box(
        width = 12,
        title = column(
          width = 12,
          selectInput("col_choice", "Select Variable",
            choices = c(
              "Age Group" = "age_group",
              "Gender" = "gender",
              "Country" = "country",
              "Address" = "address",
              "Academic Qualification" = "academic_qual",
              "Field Involved" = "field_involved",
              "Programming Level" = "programming_level",
              "Operating System" = "os_type"

            ),
          )
        ),
        plotOutput("plot")
      )
    ),

    tabPanel(
      "About",
      box(
        width = 12,
        title = column(width = 12, ),

        p(  "Training Survey App is an interactive dashboard to track details audience of Training / workshops.
"),

        p("
The dashboard credits:

- R / RStudio for data analytics
- Leaflet / Mapbox / Open Streets Map for Mapping
- GitHub for Code hosting
- Google Firebase for Authentication
- Google Sheet as Database
- Shinyapps.io for Shiny app hosting"),

p("Shiny App by Binod Jung Bogati")

      )
    )


  )
)


login_page <- div(
  id = "loginpage",
  wellPanel(
    icon("poll", class = "icons"),
    tags$h2("Training Survey App", class = "text-center stitle"), br(),
    textInput("email_signin",
      placeholder = "Your email",
      label = tagList(icon("user"), "Email")
    ),
    passwordInput("password_signin",
      placeholder = "Your password",
      label = tagList(icon("unlock-alt"), "Password")
    ),
    br(),
    div(
      style = "text-align: center;",
      actionButton("signin", "SIGN IN", icon = icon("sign-in-alt")),
      shinyjs::hidden(
        div(
          id = "nomatch",
          tags$p("Oops! Incorrect username or password!",
            style = "color: red; font-weight: 600;padding-top: 5px;font-size:16px;",
            class = "text-center"
          )
        )
      ),
      br(), br(), br(),
      p("Email: admin@test.com, Password: admin123"),
      tags$h6("Powered by ", icon("r-project"), "Shiny | © Binod Jung Bogati")
    )
  )
)



ui <- fluidPage(
  useFirebase(),
  reqSignout(login_page),
  dashboardPage(
    title = title, header = header,
    sidebar = reqSignin(sidebar),
    body = reqSignin(body2), skin = "blue"
  )
)

