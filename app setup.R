#Shiny app 
library(shiny)

#Generate fake data for testing
fakedata <- c('Bob','Mary','Inoki')%>%
  sapply(., function(x)arima.sim(n = 30, list(ar = c(0.8897, -0.4858), ma = c(-0.2279, 0.2488)),
                                            sd = sqrt(0.1796)))%>% #create autocorrelated timeseries for each individual
  as.data.frame()%>%
  tibble::rowid_to_column(var = 'time')%>% #set row index as time
  pivot_longer(cols = -1, names_to = 'Name', values_to = 'Rating')%>%
  mutate(Notes = sample(c("Had ice cream", "Nothing"), size = 90,replace = TRUE, prob = c(0.1, 0.9))) #Add notes

#Setup color palette
pal <- wesanderson::wes_palette("Chevalier1")

#Assign color to names
color_table <- data.frame(Name = unique(fakedata$Name))%>%
  mutate(col = pal[1:length(unique(fakedata$Name))])

#ggplot
fakedata%>%
  ggplot(aes(x = time, y = Rating, group = Name, col = Name)) + 
  geom_point()+
  geom_line()+
  scale_color_manual(values = color_table$col)+ 
  theme_classic()+
  theme(axis.text = element_text(size = 15),
        axis.title = element_text(size = 15))


####################################
########  Shiny app code   #########
####################################

#Version 1: Static with selection tool to subset data

# Define UI for application that draws a histogram
ui <- fluidPage(
  h1("How R you feeling today?"),
  sidebarPanel(pickerInput("name","Person", choices=unique(fakedata$Name),
                options = list(`actions-box` = TRUE),multiple = T)),
  mainPanel(plotOutput("distPlot"))
)

unique(fakedata$Name)
# Define server logic required to draw a histogram
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
            axis.title = element_text(size = 15))},
    height=600
  )
}

# Run the application 
shinyApp(ui = ui, server = server)



#Future updates:
# 1) Add hover tooltip to see notes on each point
