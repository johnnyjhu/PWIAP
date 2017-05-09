
dashboardPage(title="PWIAP",
              skin = "blue",
              dashboardHeader(title="Public Art Program KPI Generation",titleWidth = 300),
              dashboardSidebar(
                disable = TRUE,
                width = 300,
        
                br(),
                p(strong(":: Main Control Panel ::"))
                  
              ),
              dashboardBody(
                
                box(
                  title = "About",
                  solidHeader = FALSE,
                  status = "primary",
                  collapsible = TRUE,
                  width = 600,
                  "The Department of Cultural Affairs Public Art Division is 
                  in need of an analytic model to measure progress and demonstrate 
                  the impact of the Public Works Improvements Arts 
                  Program (PWIAP). PWIAP creates arts amenities, facilities 
                  and services in connection with all city capital improvement 
                  projects. The Program’s mission is to provide publicly accessible 
                  works of art, arts and cultural facilities, and services for the 
                  cultural benefit of the city, its citizens and its visitors.",
                  br(),
                  br(),
                  "Since its inception 26 years ago, the program has collected output 
                  and outcome data related to artist profile (ethnicity, gender, place 
                  of residence, degrees accomplished, artistic merit and experience), 
                  project finances (budget, expenditure, contractual employment), artworks 
                  (value of assets, locations/council district, launch date), community/stakeholder 
                  meetings, and partnered city departments and facilities.",
                  br(),
                  br(),
                  "Developers: Jyong-An Jhu/Shujia Huang/Keiichiro Abe/Xinjian Li/Wen Zhong/Yuan Hu"
                ),  
                
                fluidRow(
                  box(
                    title = "Project Frequency (Geography)",
                    solidHeader = TRUE,
                    status = "primary",
                    collapsible = TRUE,
                    #width = 600,
                    plotOutput(outputId = "output_plot_8")
                  ),
                  
                  box(
                    title = "Configuration",
                    solidHeader = TRUE,
                    status = "primary",
                    collapsible = TRUE,
                    sliderInput(inputId = "pro_freq_bin_range",
                                label = "Select the bin size",
                                min = 10,
                                max = 50,
                                value = 23
                    ),
                    
                    sliderInput(inputId = "pro_freq_alpha_range",
                                label = "Select the transparency",
                                min = 0,
                                max = 1,
                                value = 0.78
                    )
                  )
                ),
                
                fluidRow(
                  
                  box(
                    title = "Project Frequency (Month)",
                    solidHeader = TRUE,
                    status = "primary",
                    collapsible = TRUE,
                    #width = 600,
                    plotOutput(outputId = "output_plot_7")
                  ),
                  
                  box(
                    title = "Configuration",
                    solidHeader = TRUE,
                    status = "primary",
                    collapsible = TRUE,
                    selectInput(inputId = "pro_freq_month_order",
                                choices = c("Disable", "Enable - Descending", "Enable - Ascending"),
                                label = "Select the order type",
                                selected = "Disable"
                    )
                  )
                ),
                
                fluidRow(
                  
                  box(
                    title = "Budget Control Overview",
                    solidHeader = TRUE,
                    status = "primary",
                    collapsible = TRUE,
                    #width = 600,
                    plotOutput(outputId = "output_plot_1")
                  ),
                  
                  box(
                    title = "Configuration",
                    solidHeader = TRUE,
                    status = "primary",
                    collapsible = TRUE,
                    selectInput(inputId = "budget_control_color",
                                choices = c("Simple", "Agency"),
                                label = "Select the color filling type",
                                selected = "Simple"
                    ),
                    
                    selectInput(inputId = "project_name_list",
                                choices = data_delta_money$Project_Name,
                                label = "Select which project you would like to investigate"#,
                                #selected = "Lib"
                    ),

                    textOutput(outputId = "output_proj_name")
                  )
                ), 
                
                fluidRow(
                  box(
                    title = "Budget Control By Agency",
                    solidHeader = TRUE,
                    status = "primary",
                    collapsible = TRUE,
                    #width = 600,
                    plotOutput(outputId = "output_plot_2")
                  ),
                  
                  box(
                    title = "Configuration",
                    solidHeader = TRUE,
                    status = "primary",
                    collapsible = TRUE,
                    selectInput(inputId = "budget_ctrl_agency_order",
                                choices = c("Descending", "Ascending"),
                                label = "Select the order type",
                                selected = "Descending"
                    )
                  )
                ),
#                fluidRow(
#                  box(
#                    title = "Actual Expenditure By Agency",
#                    solidHeader = TRUE,
#                    status = "primary",
#                    collapsible = TRUE,
#                    #width = 600,
#                    plotOutput(outputId = "output_plot_3")
#                  ),
#                  box(
#                    title = "Configuration",
#                    solidHeader = TRUE,
#                    status = "primary",
#                    collapsible = TRUE,
#                    selectInput(inputId = "act_exp_agency_order",
#                                choices = c("Descending", "Ascending"),
#                                label = "Select the order type",
#                                selected = "Descending"
#                    )
#                  )
#                ),
                fluidRow(
                  
                  box(
                    title = "Schedule Control",
                    solidHeader = TRUE,
                    status = "primary",
                    collapsible = TRUE,
                    #width = 600,
                    plotOutput(outputId = "output_plot_4")
                  ),
                  
                  box(
                    title = "Configuration",
                    solidHeader = TRUE,
                    status = "primary",
                    collapsible = TRUE,
                    selectInput(inputId = "schedule_ctrl_agency_order",
                      choices = c("Descending", "Ascending"),
                      label = "Select the order type",
                      selected = "Descending"
                    )
                  )
                ),

                fluidRow(
                  
                  box(
                    title = "Schedule Control vs Budget Control Overview",
                    solidHeader = TRUE,
                    status = "primary",
                    collapsible = TRUE,
                    #width = 600,
                    plotOutput(outputId = "output_plot_5")
                  ),
                  
                  box(
                    title = "Configuration",
                    solidHeader = TRUE,
                    status = "primary",
                    collapsible = TRUE,
                    sliderInput(inputId = "schedule_budget_overview_size_range",
                                label = "Select the bin size",
                                min = 1,
                                max = 25,
                                value = 20
                    )
                  )
                ),

                fluidRow(
                  box(
                    title = "Schedule Control vs Budget Control (By Agency)",
                    solidHeader = TRUE,
                    status = "primary",
                    collapsible = TRUE,
                    #width = 600,
                    plotOutput(outputId = "output_plot_6")
                  ),
                  
                  box(
                    title = "Configuration",
                    solidHeader = TRUE,
                    status = "primary",
                    collapsible = TRUE,
                    sliderInput(inputId = "ctrl_budget_size_range",
                                label = "Select the agency size",
                                min = 1,
                                max = 15,
                                value = 5
                    ),
                    
                    sliderInput(inputId = "ctrl_budget_alpha_range",
                                label = "Select the transparency",
                                min = 0,
                                max = 1,
                                value = 0.4
                    )
                  )
                ),

                fluidRow(
                  box(
                    title = "Neighborhood Income",
                    solidHeader = TRUE,
                    status = "primary",
                    collapsible = TRUE,
                    #width = 600,
                    plotOutput(outputId = "output_plot_9")
                  ),
                  
                  box(
                    title = "Configuration",
                    solidHeader = TRUE,
                    status = "primary",
                    collapsible = TRUE,
                    selectInput(inputId = "neighborhood_income_agency_order",
                                choices = c("Descending", "Ascending"),
                                label = "Select the order type",
                                selected = "Descending"
                    )
                  )
                ),

                fluidRow(
                  box(
                    title = "Neighborhood Income (Geography)",
                    solidHeader = TRUE,
                    status = "primary",
                    collapsible = TRUE,
                    #width = 600,
                    plotOutput(outputId = "output_plot_10")
                  ),
                  
                  box(
                    title = "Configuration",
                    solidHeader = TRUE,
                    status = "primary",
                    collapsible = TRUE,
                    radioButtons(inputId = "income_all_agency",
                                 label = "Select all or single agency",
                                 choices = c("All Agency", "Single Agency"),
                                 selected = "All Agency"
                    ),
                    
                    selectInput(inputId = "income_agency",
                                choices = data_address$Agency,
                                label = "Select which agency you would like to show",
                                selected = "Lib"
                    ),
                    
                    sliderInput(inputId = "income_range",
                                label = "Select the circle size of neighborhood income",
                                min = 1,
                                max = 15,
                                value = 10
                    ),
                    
                    selectInput(inputId = "income_color",
                                choices = c("yellow", "orange", "red", "darkred", "blue", "darkblue", "green", "darkgreen"),
                                label = "Select the color of neighborhood income",
                                selected = "darkblue"
                    )
                  )
                ),

                fluidRow(
                  box(
                    title = "Neighborhood Age",
                    solidHeader = TRUE,
                    status = "primary",
                    collapsible = TRUE,
                    #width = 600,
                    plotOutput(outputId = "output_plot_11")
                  ),
                  
                  box(
                    title = "Configuration",
                    solidHeader = TRUE,
                    status = "primary",
                    collapsible = TRUE,
                    selectInput(inputId = "neighborhood_age_agency_order",
                                choices = c("Descending", "Ascending"),
                                label = "Select the order type",
                                selected = "Descending"
                    )
                  )
                ),

                fluidRow(
                  box(
                    title = "Neighborhood Age (Geography)",
                    solidHeader = TRUE,
                    status = "primary",
                    collapsible = TRUE,
                    #width = 600,
                    plotOutput(outputId = "output_plot_12")
                  ),
                  
                  box(
                    title = "Configuration",
                    solidHeader = TRUE,
                    status = "primary",
                    collapsible = TRUE,
                    radioButtons(inputId = "age_all_agency",
                                 label = "Select all or single agency",
                                 choices = c("All Agency", "Single Agency"),
                                 selected = "All Agency"
                    ),
                    
                    selectInput(inputId = "age_agency",
                                choices = data_address$Agency,
                                label = "Select which agency you would like to show",
                                selected = "Lib"
                    ),
                    
                    sliderInput(inputId = "age_range",
                                label = "Select the circle size of neighborhood age",
                                min = 1,
                                max = 15,
                                value = 10
                    ),
                    
                    selectInput(inputId = "age_color",
                                choices = c("yellow", "orange", "red", "darkred", "blue", "darkblue", "green", "darkgreen"),
                                label = "Select the color of neighborhood age",
                                selected = "darkgreen"
                    )
                  )
                ),

                fluidRow(
                  box(
                    title = "Neighborhood Education Level (Geography)",
                    solidHeader = TRUE,
                    status = "primary",
                    collapsible = TRUE,
                    #width = 600,
                    plotOutput(outputId = "output_plot_13")
                  ),
                  
                  box(
                    title = "Configuration",
                    solidHeader = TRUE,
                    status = "primary",
                    collapsible = TRUE,
                    radioButtons(inputId = "edu_all_agency",
                                 label = "Select all or single agency",
                                 choices = c("All Agency", "Single Agency"),
                                 selected = "All Agency"
                    ),
                    
                    selectInput(inputId = "edu_agency",
                                choices = data_address$Agency,
                                label = "Select which agency you would like to show",
                                selected = "Lib"
                    ),
                    
                    sliderInput(inputId = "edu_range",
                                label = "Select the circle size of neighborhood education level",
                                min = 1,
                                max = 15,
                                value = 8
                    ),
                    
                    selectInput(inputId = "edu_color",
                                choices = c("yellow", "orange", "red", "darkred", "blue", "darkblue", "green", "darkgreen"),
                                label = "Select the color of neighborhood education level",
                                selected = "darkred"
                    )
                  )
                )
              )
)