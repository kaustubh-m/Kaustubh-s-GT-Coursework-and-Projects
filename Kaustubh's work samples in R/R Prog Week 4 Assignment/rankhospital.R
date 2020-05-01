
rankhospital <- function(state, outcome, num = "best") 
{
  
  valid_st_names <- unique(Outcomes[[7]])
  lookup_state <- valid_st_names[valid_st_names == state]
  
  if(length(lookup_state)==0) 
  {
    stop("invalid state")
  }
  
  if(toupper(outcome) != 'HEART ATTACK' & toupper(outcome) != 'HEART FAILURE' & toupper(outcome) != 'PNEUMONIA')
  {
    stop('invalid outcome')
  }
  
  Outcomes <- read.csv("outcome-of-care-measures.csv", colClasses="character")
  
  Outcomes_st <- Outcomes[Outcomes$State == toupper(state),]
  
  if(toupper(outcome) == 'HEART ATTACK')
  {
    Outcomes_st <- Outcomes_st[,c(1,2,7,11)]
    
  }
  if(toupper(outcome) == 'HEART FAILURE')
  {
    Outcomes_st <- Outcomes_st[,c(1,2,7,17)]
    
  }
  if(toupper(outcome) == 'PNEUMONIA')
  {
    Outcomes_st <- Outcomes_st[,c(1,2,7,23)]
    
  }
  
  Outcomes_st_ailmt <- Outcomes_st[Outcomes_st[[4]] != 'Not Available',]
  Outcomes_st_ailmt[,4] <- as.numeric(Outcomes_st_ailmt[,4])
  Outcomes_st_ailmt_compl <- Outcomes_st_ailmt[complete.cases(Outcomes_st_ailmt),]
  Outcomes_st_ailmt_compl <- Outcomes_st_ailmt_compl[order(Outcomes_st_ailmt_compl[,4], Outcomes_st_ailmt_compl[,2]),]
  Outcomes_hosp_rank <- cbind(Outcomes_st_ailmt_compl, 1:nrow(Outcomes_st_ailmt_compl))
  
  if(toupper(num) == 'BEST')
  {
    Outcomes_best_row <- Outcomes_st_ailmt_compl[which.min(Outcomes_st_ailmt_compl[,4]),]
    return(Outcomes_best_row[,2])
  }
  
  if(toupper(num) == 'WORST')
  {
    Outcomes_worst_row <- Outcomes_st_ailmt_compl[which.max(Outcomes_st_ailmt_compl[,4]),]
    return(Outcomes_worst_row[,2])
  }
  
  if(!is.na(as.numeric(num)))
  {
    Outcomes_hosp_rank_op <- Outcomes_hosp_rank[Outcomes_hosp_rank[[5]] == as.numeric(num),]
    
    if(nrow(Outcomes_hosp_rank_op) == 0)
    {
      return (NA)
    }
    return(Outcomes_hosp_rank_op[[2]])
  }
  
}

