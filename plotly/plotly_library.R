library(plotly)



mtcars



p= plot_ly( data= mtcars,
            x=~wt,   #need to give ~ for assignment
            y=~mpg,
            type = "scatter",
            mode = "markers",
           marker = list(color="green", size = 10) ) # or color = I("black")


p


#Styling


p= plot_ly( data= mtcars,
            x=~wt,   #need to give ~ for assignment
            y=~mpg,
            type = "scatter",
            mode = "markers",
            marker = list(size = 7,
                          color = 'rgba(225, 182, 193, .9)',
                          line = list(color = 'rgba(152, 0, 0, .8)',
                                      width = 3)))


p


# Set color based on cylinder variable
# Data point color based on discrete variable

p = plot_ly(data=mtcars,
            x=~wt,   #need to give ~ for assignment
            y=~mpg,
            type = "scatter",
            mode = "markers",
            color = ~as.factor(cyl), # Data point color based on discrete variable
            colors= "Set1")  # for Legend pallete : -- colors= "Set1"
p


##ata point color based on continuous variable

p = plot_ly(data=mtcars,
            x=~wt,   #need to give ~ for assignment
            y=~mpg,
            type = "scatter",
            mode = "markers",
            color = ~disp, # Data point color based on continuous variable
            colors= "Set1")  # for Legend pallete : -- colors= "Set1"
p


# Data point color based on discrete variable and size based on continuous variable

p = plot_ly(data=mtcars,
            x=~wt,   #need to give ~ for assignment
            y=~mpg,
            type = "scatter",
            mode = "markers",
            color = ~as.factor(cyl), # Data point color based on discrete variable
            size = ~hp)  # size depends on horsepower
p

## CHanging data points shape and symbol

p = plot_ly(data=mtcars,
            x=~wt,   #need to give ~ for assignment
            y=~mpg,
            type = "scatter",
            mode = "markers",
            symbol = ~as.factor(cyl),
            symbols = c('circle', 'x', 'o'),
            marker = list(size=5))  # for Legend pallete : -- colors= "Set1"
p




# Show legend 

p = plot_ly(data=mtcars,
            x=~wt,   #need to give ~ for assignment
            y=~mpg,
            type = "scatter",
            mode = "markers",
            symbol = ~as.factor(cyl),
            symbols = c('circle', 'x', 'o'),
            marker = list(size=5)) %>% 
  layout(showlegend = FALSE)

p

p = plot_ly(data=mtcars,
            x=~wt,   #need to give ~ for assignment
            y=~mpg,
            type = "scatter",
            mode = "markers",
            symbol = ~as.factor(cyl),
            symbols = c('circle', 'x', 'o'),
            marker = list(size=5)) %>% 
  layout(legend = list(orientation = 'h')) #h for forizontol legend place along x axos
                                          #legend = list(x= 0.8,, y= 0.9) , legend on particular place
p



#Title

p = plot_ly(data=mtcars,
            x=~wt,   #need to give ~ for assignment
            y=~mpg,
            type = "scatter",
            mode = "markers",
            symbol = ~as.factor(cyl),
            symbols = c('circle', 'x', 'o'),
            marker = list(size=5)) %>% 
  layout(title="Scatter plot",
         xaxis = list(title="Weight", showgrid = FALSE), #showgrid = FALSE for background lines
         yaxis=list(title="MPG",showgrid = FALSE))
p




#Customising mouse hover text

p2 = plot_ly(data=mtcars,
            x=~wt,   #need to give ~ for assignment
            y=~mpg,
            type = "scatter",
            mode = "markers",
            hoverinfo = "text",
            text= paste("Miles per gallon: ", mtcars$mpg,
                        "<br>",
                        "Weight: ", mtcars$wt)) %>% # this text apper for each point
add_annotations(      #adding text to particular points
  x= mtcars$mpg[which.max(mtcars$mpg)],
  y=mtcars$wt[which.max(mtcars$mpg)],
  text = "Good mileage"
)
p2












