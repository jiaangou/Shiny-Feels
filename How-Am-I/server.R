#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

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

})
