############

#   App for machine learning model visualization

############

library(shiny)
library(ggplot2)
library(caret)
library(ISLR2)
library(tidyverse)


dat<-ISLR2::Boston%>%
      mutate(chas = as.factor(chas))

coln<-colnames(dat)

###################################################
shinyUI(fluidPage(

    
    # Application title
    titlePanel("Non-Parametric Regression for Housing Data"),
    
  
    sidebarLayout(
      #makes a grey panel for options on slider
      sidebarPanel(
        numericInput("seednum","Seet Seed:",value=314,
                     min=1,
                     max=1000),
        # various inputs for user in the panel
        # y var
        selectInput("stat2plot","Statistics to Plot (Y)",coln,selected = "medv"),
        # x var 
        selectInput("wrtVar","With Respect to Variable (X)",coln,selected = "lstat"),
        # train test split
        sliderInput(
          "tr_prop", label = "Proportion of Data in Training Set",
          min = 0, value = .8, max = 1),
        
          sliderInput("numk",
                      "What is the number of K Nieghboors?",
                      min=1,
                      value=20,
                      max=50)
      
      ),
      
      
    
  
      mainPanel(
        
      plotOutput("Data2Plot"),
      verbatimTextOutput("MSE_test")
        
  
      )
    
    
    )
))

