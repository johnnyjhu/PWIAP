# Source the file for global use
source('global.R', local = FALSE)

shinyServer(function(input, output) {
  # Filter out the data and create a reactive event
  plot_data = eventReactive(input$submit, {
    #    police_deaths %>%
    #      filter(cause_of_death == input$cause)
  })
  
  # Render plot
  output$output_plot_1 = renderPlot({
      
    if(input$budget_control_color == "Simple"){    
      
      data_delta_money$budget_outcome <- ifelse(data_delta_money$delta >= 0, "Under-budget", "Over-budget")
        ggplot(data_delta_money, aes(x=reorder(Project_Name, delta), y = delta, fill = budget_outcome)) +
          geom_bar(stat = "identity") +
          geom_point(aes(x = input$project_name_list, y = 0)) +
          theme(axis.ticks.x = element_blank(),
                axis.text.x = element_blank(),
                panel.grid.major.x = element_blank()) +
          scale_y_continuous(limits = c(-50000,300000), breaks= seq(-50000,300000, 50000)) +
          scale_fill_manual(values = c("red","darkgreen")) +
          ggtitle("Budget Control Overview") +
          xlab("Projects") +
          ylab("Final Budget Outcome (USD)") +
          theme(plot.title = element_text(hjust = 0.5)) 
        
    } else{

      ggplot(data_delta_money, aes(x=reorder(Project_Name, delta), y = delta, fill = Agency)) +
        geom_bar(stat = "identity") +
        geom_point(aes(x = input$project_name_list, y = 0)) +
        theme(axis.ticks.x = element_blank(),
              axis.text.x = element_blank(),
              panel.grid.major.x = element_blank()) +
        scale_y_continuous(limits = c(-50000,300000), breaks= seq(-50000,300000, 50000)) +
        ggtitle("Budget Control Overview") +
        xlab("Projects") +
        ylab("Final Budget Outcome (USD)") +
        theme(plot.title = element_text(hjust = 0.5)) 
    }
  })
  
  # Render plot
  output$output_plot_2 = renderPlot({
    
    data = data %>%
      mutate(delta = Full_1p_Amount - Art_Contract) %>%
      mutate(length = End_Date - Project_Start_Date) 
    
    Avg_Agen = data %>%
      group_by(Agency) %>%
      summarise(avg = mean(delta)) 
    
    Avg_Agen$pos <- Avg_Agen$avg >= 0
    
    if(input$budget_ctrl_agency_order == "Descending"){
      
      ggplot(Avg_Agen, aes(x = reorder(Agency, avg), y = avg, fill = pos)) +
        geom_bar(stat = "identity") +
        scale_fill_manual(values = c("lightblue","pink"), guide = FALSE) +
        coord_flip() +
        scale_y_continuous(limits = c(-5000, 150000)) +
        geom_text(aes(label = as.integer(avg)), vjust = 0.5, hjust = -0.25, color = "gray") +
        ggtitle("Budget Control By Agency") +
        xlab("Agency") +
        ylab("Final Budget Outcome (Average, USD)") +
        theme(plot.title = element_text(hjust = 0.5)) 
      
    } else{
      
      ggplot(Avg_Agen, aes(x = reorder(Agency, -avg), y = avg, fill = pos)) +
        geom_bar(stat = "identity") +
        scale_fill_manual(values = c("lightblue","pink"), guide = FALSE) +
        coord_flip() +
        scale_y_continuous(limits = c(-5000, 150000)) +
        geom_text(aes(label = as.integer(avg)), vjust = 0.5, hjust = -0.25, color = "gray") +
        ggtitle("Budget Control By Agency") +
        xlab("Agency") +
        ylab("Final Budget Outcome (Average, USD)") +
        theme(plot.title = element_text(hjust = 0.5)) 
      
    }
    
  })
  
  # Render plot
#  output$output_plot_3 = renderPlot({
#  
#    ggplot(data, aes(x = factor(Agency), y = Art_Contract), na.rm = TRUE) +  
#      geom_bar(stat = "identity", fill = "lightblue") +
#      ggtitle("Actual Expenditure by Agency") +
#      xlab("Agency") +
#      ylab("Actual Expenditure (Art Contract, USD)") +
#      theme(plot.title = element_text(hjust = 0.5)) +
#      coord_flip()
#  })
  
  # Render plot
  output$output_plot_4 = renderPlot({
    
    data = data %>%
      mutate(length = End_Date - Project_Start_Date) %>%
      filter(!is.na(length))
    
    time_cnt = data %>%
      group_by(Agency) %>%
      summarise(time_avg = mean(length))
    
    if(input$schedule_ctrl_agency_order == "Descending"){
    
    ggplot(time_cnt,aes(x=reorder(Agency, time_avg), y=time_avg))+
      geom_bar(stat = "identity", fill = "lightblue")+
      
      ggtitle("Schedule Control") +
      xlab("Agency") +
      ylab("Project Time (Average, Days)") +
      theme(plot.title = element_text(hjust = 0.5)) +
      coord_flip() +
      scale_y_continuous(limits = c(0, 1750)) +
      geom_text(aes(label = as.integer(time_avg)), vjust = 0.5, hjust = -0.25, color = "gray")    
   
       }else{
      
      ggplot(time_cnt,aes(x=reorder(Agency, -time_avg), y=time_avg))+
        geom_bar(stat = "identity", fill = "lightblue")+
        
        ggtitle("Schedule Control") +
        xlab("Agency") +
        ylab("Project Time (Average, Days)") +
        theme(plot.title = element_text(hjust = 0.5)) +
        coord_flip() +
        scale_y_continuous(limits = c(0, 1750)) +
        geom_text(aes(label = as.integer(time_avg)), vjust = 0.5, hjust = -0.25, color = "gray")    
      
    }
  })
  
  # Render plot
  output$output_plot_5 = renderPlot({
    
    data = data %>%
      mutate(delta = Full_1p_Amount - Art_Contract) %>%
      filter(!is.na(delta)) %>%
      mutate(length = End_Date - Project_Start_Date) %>%
      filter(!is.na(length))
    
    ggplot(data, aes(x = delta, y = length)) +
      stat_bin2d(data = data,
                 aes(x = delta, y = length),
                 alpha = 1,
                 bins = input$schedule_budget_overview_size_range) +
      ggtitle("Schedule Control vs Budget Control Overview") +
      xlab("Final Budget Outcome (Average, USD)") +
      ylab("Project Time (Days)") +
      theme(plot.title = element_text(hjust = 0.5)) +
      scale_fill_gradient(low = "orange", high = "darkblue")      
    
  })
  
  # Render plot
  output$output_plot_6 = renderPlot({
    
    data = data %>%
      mutate(delta = Full_1p_Amount - Art_Contract) %>%
      filter(!is.na(delta)) %>%
      mutate(length = End_Date - Project_Start_Date) %>%
      filter(!is.na(length))
    
    ggplot(data, aes(x = delta, y = length, color = Agency)) +
      geom_point(alpha = input$ctrl_budget_alpha_range, 
                 size = input$ctrl_budget_size_range) +
      
      ggtitle("Schedule Control vs Budget Control (By Agency)") +
      xlab("Final Budget Outcome (USD)") +
      ylab("Project Time (Days)") +
      theme(plot.title = element_text(hjust = 0.5))
    
  })
  
  # Render plot
  output$output_plot_7 = renderPlot({
    
    data = data %>%
      filter(!is.na(Month)) %>%
      group_by(Month) %>%
      summarise(count = n())
  
    if(input$pro_freq_month_order == "Disable"){  
      
        ggplot(data, aes(x = Month, y = count)) + 
        geom_bar(stat = "identity", fill = "lightblue") +
        geom_text(aes(label = count), vjust = -1, color = "gray") +
        scale_y_continuous(limits = c(0, 35)) +
        xlab("Month") +
        ylab("Number of Projects Started") + 
        ggtitle("Project Frequency Analysis") +
        theme(plot.title = element_text(hjust = 0.5))    
      
    }else if(input$pro_freq_month_order == "Enable - Ascending"){
      
      ggplot(data, aes(x = reorder(Month, count), y = count)) + 
        geom_bar(stat = "identity", fill = "lightblue") +
        geom_text(aes(label = count), vjust = -1, color = "gray") +
        scale_y_continuous(limits = c(0, 35)) +
        xlab("Month") +
        ylab("Number of Projects Started") + 
        ggtitle("Project Frequency Analysis") +
        theme(plot.title = element_text(hjust = 0.5))
      
    }else{
      
      ggplot(data, aes(x = reorder(Month, -count), y = count)) + 
        geom_bar(stat = "identity", fill = "lightblue") +
        geom_text(aes(label = count), vjust = -1, color = "gray") +
        scale_y_continuous(limits = c(0, 35)) +
        xlab("Month") +
        ylab("Number of Projects Started") + 
        ggtitle("Project Frequency Analysis") +
        theme(plot.title = element_text(hjust = 0.5))
      
    }
  })
  
  # Render plot
  output$output_plot_8 = renderPlot({
    
    la_gmap +
      stat_bin2d(data = data_address,
                 aes(x = Pro_Location_lon, y = Pro_Location_lat),
                 alpha = input$pro_freq_alpha_range,
                 bins = input$pro_freq_bin_range) +
      ggtitle("Project Frequency (Geography)") +
      theme(plot.title = element_text(hjust = 0.5)) +
      scale_fill_gradient(low = "pink", high = "red")    
    
  })
  
  # Render plot
  output$output_plot_9 = renderPlot({
    
    if(input$neighborhood_income_agency_order == "Descending"){
    
    ggplot(agency_income, aes(x = reorder(Agency,avg_income), y = avg_income)) +
      geom_bar(stat = "identity", fill = "lightblue") +
      scale_y_continuous(limits = c(0, 100000)) +
      xlab("Agency") +
      ylab("Average Income (USD)") +
      ggtitle("Neighborhood Income") +
      theme(plot.title = element_text(hjust = 0.5)) +
      geom_text(aes(label = as.integer(avg_income)), vjust = 0.5, hjust = -0.25, color = "gray") +
      coord_flip()  
      
    }else{
      
      ggplot(agency_income, aes(x = reorder(Agency,-avg_income), y = avg_income)) +
        geom_bar(stat = "identity", fill = "lightblue") +
        scale_y_continuous(limits = c(0, 100000)) +
        xlab("Agency") +
        ylab("Average Income (USD)") +
        ggtitle("Neighborhood Income") +
        theme(plot.title = element_text(hjust = 0.5)) +
        geom_text(aes(label = as.integer(avg_income)), vjust = 0.5, hjust = -0.25, color = "gray") +
        coord_flip()  
      
    }
  })
  
  # Render plot
  output$output_plot_10 = renderPlot({
    
    if(input$income_all_agency == "All Agency"){
      
      la_gmap +
        geom_point(data = data_income,
                   aes(x = longitude, y = latitude, size = Average_Income, alpha = Average_Income),
                   color = input$income_color) +
        scale_size_continuous(range = c(1, input$income_range)) +
        geom_point(data = data_address,
                   aes(x = Pro_Location_lon, 
                       y = Pro_Location_lat, 
                       color = Agency)) +
        ggtitle("Neighborhood Income (Geography)") +
        theme(plot.title = element_text(hjust = 0.5))
      
    } else {
      
      data_by_agency = data_address %>%
        filter(Agency == input$income_agency)
      
      la_gmap +
        geom_point(data = data_income,
                   aes(x = longitude, y = latitude, size = Average_Income, alpha = Average_Income),
                   color = input$income_color) +
        scale_size_continuous(range = c(1, input$income_range)) +
        geom_point(data = data_by_agency,
                   aes(x = Pro_Location_lon, 
                       y = Pro_Location_lat, 
                       color = Agency)) +
        ggtitle("Neighborhood Income (Geography)") +
        theme(plot.title = element_text(hjust = 0.5))
      
    }    
  })
  
  # Render plot
  output$output_plot_11 = renderPlot({
    
    if(input$neighborhood_age_agency_order == "Descending"){
      
      ggplot(agency_age, aes(x = reorder(Agency,-avg_age), y = avg_age)) +
        geom_bar(stat = "identity", fill = "lightblue") +
        geom_text(aes(label = as.integer(avg_age)), vjust = -1, color = "gray") +
        scale_y_continuous(limits = c(0, 45)) +
        xlab("Agency") +
        ylab("Average Age") +
        ggtitle("The Average Neighborhood Age") +
        theme(plot.title = element_text(hjust = 0.5))    
      
    }else{
      
      ggplot(agency_age, aes(x = reorder(Agency,avg_age), y = avg_age)) +
        geom_bar(stat = "identity", fill = "lightblue") +
        geom_text(aes(label = as.integer(avg_age)), vjust = -1, color = "gray") +
        scale_y_continuous(limits = c(0, 45)) +
        xlab("Agency") +
        ylab("Average Age") +
        ggtitle("The Average Neighborhood Age") +
        theme(plot.title = element_text(hjust = 0.5))      
      
    }
  })
  
  # Render plot
  output$output_plot_12 = renderPlot({
    
    if(input$age_all_agency == "All Agency"){
      
      la_gmap +
        geom_point(data = data_age,
                   aes(x = longitude, y = latitude, size = Average_Age, alpha = Average_Age),
                   color = input$age_color) +
        scale_size_continuous(range = c(1, input$age_range)) +
        
        geom_point(data = data_address,
                   aes(x = Pro_Location_lon, y = Pro_Location_lat, color = Agency)) +
        ggtitle("Neighborhood Age (Geography)") +
        theme(plot.title = element_text(hjust = 0.5))
      
    } else {
      
      age_data_by_agency = data_address %>%
        filter(Agency == input$age_agency)
      
      la_gmap +
        geom_point(data = data_age,
                   aes(x = longitude, y = latitude, size = Average_Age, alpha = Average_Age),
                   color = input$age_color) +
        scale_size_continuous(range = c(1, input$age_range)) +
        
        geom_point(data = age_data_by_agency,
                   aes(x = Pro_Location_lon, y = Pro_Location_lat, color = Agency)) +
        ggtitle("Neighborhood Age (Geography)") +
        theme(plot.title = element_text(hjust = 0.5))
      
    }    
    
  })
  
  # Render plot
  output$output_plot_13 = renderPlot({
    
    if(input$edu_all_agency == "All Agency"){
      
      la_gmap +
        geom_point(data = edu_map,
                   aes(x = longitude, y = latitude, size = edu_index, alpha = edu_index),
                   color = input$edu_color) +
        scale_size_continuous(range = c(1, input$edu_range)) +
        
        geom_point(data = data_address,
                   aes(x = Pro_Location_lon, y = Pro_Location_lat, color = Agency)) +
        ggtitle("Neighborhood Education Level (Geography)") +
        theme(plot.title = element_text(hjust = 0.5))
      
    } else {
      
      data_by_agency = data_address %>%
        filter(Agency == input$edu_agency)
      
      la_gmap +
        geom_point(data = edu_map,
                   aes(x = longitude, y = latitude, size = edu_index, alpha = edu_index),
                   color = input$edu_color) +
        scale_size_continuous(range = c(1, input$edu_range)) +
        
        geom_point(data = data_by_agency,
                   aes(x = Pro_Location_lon, y = Pro_Location_lat, color = Agency)) +
        ggtitle("Neighborhood Education Level (Geography)") +
        theme(plot.title = element_text(hjust = 0.5))
      
    }    
  })
  
  output$output_proj_name = renderText({
    
    paste(
      "Budget Outcome:",
      data_delta_money$delta[data_delta_money$Project_Name == input$project_name_list],
      "(USD),",
      "Agency:",
      data_delta_money$Agency[data_delta_money$Project_Name == input$project_name_list],
      sep = " "
    )
    
  })
})