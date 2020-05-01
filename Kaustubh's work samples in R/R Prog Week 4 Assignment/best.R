best <- function(state, outcome) 
{
  
  valid_st_names <- unique(Outcomes[[7]])
  lookup_state <- valid_st_names[valid_st_names == state]
  
  if(length(lookup_state)==0) 
  {
    stop("invalid state")
  }
  
  Outcomes <- read.csv("outcome-of-care-measures.csv", colClasses="character")
  
  Outcomes_st <- Outcomes[Outcomes$State == toupper(state),]
  
  if(toupper(outcome) == 'HEART ATTACK')
  {
    Outcomes_st_tmp <- Outcomes_st[,c(1,2,7,11)]
    Outcomes_st_ailmt <- Outcomes_st_tmp[Outcomes_st_tmp[[4]] != 'Not Available',]
    Outcomes_st_ailmt[,4] <- as.numeric(Outcomes_st_ailmt[,4])
    Outcomes_st_ailmt_compl <- Outcomes_st_ailmt[complete.cases(Outcomes_st_ailmt),]
    Outcomes_best_row <- Outcomes_st_ailmt_compl[which.min(Outcomes_st_ailmt_compl[,4]),]
    return(Outcomes_best_row[,2])
  }
  
  if(toupper(outcome) == 'HEART FAILURE')
  {
    Outcomes_st_tmp <- Outcomes_st[,c(1,2,7,17)]
    Outcomes_st_ailmt <- Outcomes_st_tmp[Outcomes_st_tmp[[4]] != 'Not Available',]
    Outcomes_st_ailmt[,4] <- as.numeric(Outcomes_st_ailmt[,4])
    Outcomes_st_ailmt_compl <- Outcomes_st_ailmt[complete.cases(Outcomes_st_ailmt),]
    Outcomes_best_row <- Outcomes_st_ailmt_compl[which.min(Outcomes_st_ailmt_compl[,4]),]
    return(Outcomes_best_row[,2])
    
  }
  
  if(toupper(outcome) == 'PNEUMONIA')
  {
    Outcomes_st_tmp <- Outcomes_st[,c(1,2,7,23)]
    Outcomes_st_ailmt <- Outcomes_st_tmp[Outcomes_st_tmp[[4]] != 'Not Available',]
    Outcomes_st_ailmt[,4] <- as.numeric(Outcomes_st_ailmt[,4])
    Outcomes_st_ailmt_compl <- Outcomes_st_ailmt[complete.cases(Outcomes_st_ailmt),]
    Outcomes_best_row <- Outcomes_st_ailmt_compl[which.min(Outcomes_st_ailmt_compl[,4]),]
    return(Outcomes_best_row[,2])
  }
  
  stop("invalid outcome")
}

