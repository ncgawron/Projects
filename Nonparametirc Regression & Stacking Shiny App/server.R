############

#   App for machine learning model visualization

# Server: running model

############


library(shiny)
library(ggplot2)
library(caret)
library(ISLR2)
library(tidyverse)
library(h2o)


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
  
  
  
  
  
  output$STACKING_test<-renderText({
    
    
    
    set.seed(as.numeric(input$seednum))
    
    # traintest<-trid()
    
    plottingvar <-  input$stat2plot
    
    
    dat[,"Train_Split"]=ifelse(1:nrow(dat) %in% sample(1:nrow(dat),round(input$tr_prop*nrow(dat)),replace = F),
                               "Train",
                               "Test")
    
    traind<-dat%>%filter(Train_Split=="Train")
    testd<-dat%>%filter(Train_Split=="Test")
    
    # Init h2o
    h2o.init()
    # Convert train/test sets to h2o format
    Bos_train <- as.h2o(traind)
    Bos_test <- as.h2o(testd)
    
    
    Y <- input$stat2plot
    X <- setdiff(names(Bos_train), Y)
    
    
    
    nfolds <- 5
    seed <- as.numeric(input$seednum)
    # Lasso
    hit_glm <- h2o.glm(
      x = X, y = Y, training_frame = Bos_train,
      nfolds = nfolds, seed = seed,
      keep_cross_validation_predictions = TRUE,
      fold_assignment = "Modulo",
      alpha = 1, remove_collinear_columns = TRUE
    )
    # Random forest
    hit_rf <- h2o.randomForest(
      x = X, y = Y, training_frame = Bos_train,
      nfolds = nfolds, seed = seed,
      keep_cross_validation_predictions = TRUE,
      fold_assignment = "Modulo",
      ntrees = 1000, mtries = 5, max_depth = 30,
      sample_rate = 0.8, stopping_rounds = 50,
      stopping_metric = "RMSE", stopping_tolerance = 0
    )
    # GBM
    hit_gbm <- h2o.gbm(
      x = X, y = Y, training_frame = Bos_train,
      nfolds = nfolds, seed = seed,
      keep_cross_validation_predictions = TRUE,
      fold_assignment = "Modulo",
      ntrees = 5000, learn_rate = 0.01,
      max_depth = 7, min_rows = 5, sample_rate = 0.8,
      stopping_rounds = 50, stopping_metric = "RMSE",
      stopping_tolerance = 0
    )
    
    
    
    bos_hit_ensemble <- h2o.stackedEnsemble(
      x = X, y = Y, training_frame = Bos_train,
      model_id = "hitters_ensemble",
      base_models = list(hit_glm, hit_rf, hit_gbm),
      metalearner_algorithm = "AUTO"
    )
    
    
    
    # Function to extract rmse
    get_rmse <- function(model){
      perf <- h2o.performance(model,
                              newdata = Bos_test)
      return(perf@metrics$RMSE)
    }
    # model list
    mod_list <- list(GLM = hit_glm, RF = hit_rf,
                     GBM = hit_gbm, STACK = bos_hit_ensemble)
    # apply function to model list
    error_rmse<-purrr::map_dbl(mod_list, get_rmse)
  
  
    textout<- "The MSE on the Test Set for the Stacked (Lasso,GLM,GBM) model 
    using all other variables as predictors is: %s"
    
    sprintf(textout,round(error_rmse[[4]]^2,4))
   
    
    
  })
  
  
  
  #closes shiny server
})