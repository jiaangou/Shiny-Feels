#Shiny app 
library(shiny)
library(shinyWidgets)
library(dplyr)

#Generate fake data for testing--------
#fakedata <- c('Bob','Mary','Inoki')%>%
#  sapply(., function(x)arima.sim(n = 30, list(ar = c(0.8897, -0.4858), ma = c(-0.2279, 0.2488)),
#                                            sd = sqrt(0.1796)))%>% #create autocorrelated timeseries for each individual
#  as.data.frame()%>%
#  tibble::rowid_to_column(var = 'time')%>% #set row index as time
#  pivot_longer(cols = -1, names_to = 'Name', values_to = 'Rating')%>%
#  mutate(Notes = sample(c("Had ice cream", "Nothing"), size = 90,replace = TRUE, prob = c(0.1, 0.9))) #Add notes

#write.csv(fakedata,file = 'fakedata.csv')



#Download file from googledrive
library(googledrive)
drive_auth(email = "oujiaang@gmail.com")
drive_find(n_max = 10)

#list sheets and get ID of sheet of interest
sheets <- drive_find(type = "spreadsheet")
sheet_id <- sheets$id[which(sheets$name == 'fakedata')]

#download the files and overwrite in case for updates
drive_download(as_id(sheet_id), type = "csv", overwrite = TRUE)

#
fakedata <- read.csv('fakedata.csv',row.names = 1)%>%
  mutate(Notes = plyr::mapvalues(Notes, from = 'Had ice cream',to = 'icecream'))


#Setup color palette
pal <- wesanderson::wes_palette("Chevalier1")

#Assign color to names
color_table <- data.frame(Name = unique(fakedata$Name))%>%
  mutate(col = pal[1:length(unique(fakedata$Name))])

#ggplot
library(ggplot2)
library(ggiraph)
#devtools::install_github("dill/emoGG")
library(emoGG)
#emoji_search("icecream")

#interactive_plot <- girafe(
#  ggobj = demo_plot,
#  width_svg = 6,
#  height_svg = 6*.618
#)


####################################
########  Shiny app code   #########
####################################

#Version 1: Static with selection tool to subset data

# Define UI for application that draws a histogram
ui <- fluidPage(
  h1("How R you feeling today?"),
  sidebarPanel(pickerInput("name","Person", choices=unique(fakedata$Name),
                           selected = unique(fakedata$Name),
                options = list(`actions-box` = TRUE),multiple = T)),
  mainPanel(plotOutput("distPlot"))
)


#Radio buttons
#ui <- fluidPage(
#  radioButtons("radioInput", "Display ice cream:",
#               c("No" = "No",
#                 "Yes" = "Yes")),
#  plotOutput("distPlot")
#)



# Define server logic
server <- function(input, output) {
  #plot output
  output$distPlot <- renderPlot({

    fakedata%>%
        filter(Name %in% input$name) %>%
        ggplot(aes(x = time, y = Rating, group = Name, col = Name)) + 
        geom_point()+
        geom_line()+
        scale_color_manual(values = color_table%>%
                             filter(Name %in% input$name)%>%
                             .$col)+
        theme_classic()+
        theme(axis.text = element_text(size = 15),
              axis.title = element_text(size = 15))
      }
    
  )
}

# Run the application 
shinyApp(ui = ui, server = server)



#Future updates:
# 1) Add hover tooltip to see notes on each point
