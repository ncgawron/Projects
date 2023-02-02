############

#   App for machine learning model visualization

# Server: running model

############


library(shiny)
library(ggplot2)
library(caret)
library(ISLR2)
library(tidyverse)


dat<-ISLR2::Boston%>%
  mutate(chas = as.factor(chas))





# Define server logic required create figures and ideas
shinyServer(function(input, output) {
  
  
  #allows for an object to be changing via inputs reactive({})
#  trid<- reactive({
#    if(1:nrow(dat) %in% sample(1:nrow(dat),round(input$tr_prop*nrow(dat)),replace = F),
#       "Train",
#       "Test")

  #train id 

 
  
  
  
  output$Data2Plot<-renderPlot({
    
    set.seed(as.numeric(input$seednum))
   
   # traintest<-trid()
    
    plottingvar <-  input$stat2plot
    inputvar<- input$wrtVar
    
    
    dat[,"Train_Split"]=ifelse(1:nrow(dat) %in% sample(1:nrow(dat),round(input$tr_prop*nrow(dat)),replace = F),
              "Train",
              "Test")
    

    
    kgrid<-expand.grid(k=as.numeric(input$numk))
    
    
  
    
    knn_model<-train(as.formula(paste(plottingvar,"~",inputvar)),
                     data=dat%>%filter(Train_Split=="Train"),
                     method="knn",
                     tuneGrid=kgrid)
    
    dat[,"Preds"]<-predict(knn_model,dat)
    
    dotplot<-ggplot(dat, 
                    aes(x = .data[[input$wrtVar]],y = .data[[plottingvar]],
                               color=Train_Split))
    g<- dotplot+geom_point()+theme_classic()
    #makes plot
    
 
    
    g+geom_line(aes(y =Preds),size=1)+
      labs(title="Housing Data with Test and Train Split")
    

    
    
  })
  
  
  
  
  
  
  output$MSE_test<-renderText({
    
    set.seed(as.numeric(input$seednum))
    
    # traintest<-trid()
    
    plottingvar <-  input$stat2plot
    inputvar<- input$wrtVar
    
    
    dat[,"Train_Split"]=ifelse(1:nrow(dat) %in% sample(1:nrow(dat),round(input$tr_prop*nrow(dat)),replace = F),
                               "Train",
                               "Test")
    
    traind<-dat%>%filter(Train_Split=="Train")
    testd<-dat%>%filter(Train_Split=="Test")
    

    
    kgrid<-expand.grid(k=as.numeric(input$numk))
    
  
    
    knn_model<-train(as.formula(paste(plottingvar,"~",inputvar)),
                     data=traind,
                     method="knn",
                     tuneGrid=kgrid)
    
    testd[,"Preds"]<-predict(knn_model,testd)
    
    
    test_mse<-mean((testd[,plottingvar]-testd[,"Preds"])^2)
    
    
    textout<- "The MSE on the Test Set is: %s"
    
    sprintf(textout,round(test_mse,4))
    
  })
  
  
  
  
  
  #closes shiny server
})