

		
	
		library(shiny)

		library(data.table)
		dtQtrGm <- fread("qtrGmSmaller.txt", sep = " ", header = FALSE)
		dtQtrGm[, V1 := NULL]
		setkey( dtQtrGm , V2, V3, V4 )

		dtTriGm <- fread("triGmSmaller.txt", sep = " ", header = FALSE)
		dtTriGm[, V1 := NULL]
		setkey( dtTriGm , V2, V3)

		dtBiGm <- fread("biGmSmaller.txt", sep = " ", header = FALSE)
		dtBiGm[, V1 := NULL]
		setkey( dtBiGm , V2)

		dtUniGm <- fread("uniGmSmaller.txt", sep = " ", header = FALSE)
		dtUniGm[, V1 := NULL]
		setkey( dtUniGm , V2)

predWord <- function(ipLine)
{

		ipTemp1 <- gsub("n't", "nt", as.character(ipLine))
		ipTemp2 <- gsub("&", "and", ipTemp1)
		ipTemp3 <- gsub("'ll|'l", " will", ipTemp2)
		ipTemp4 <- gsub("[^[:alpha:]]", " ", ipTemp3)
		ipTemp5 <- gsub(" +", " ", ipTemp4)
		ipTemp6 <- tolower(ipTemp5) 
	
		rm(ipTemp1, ipTemp2, ipTemp3, ipTemp4, ipTemp5)
	
		leadWords <- tail(strsplit(ipTemp6, " ")[[1]], 3)
		if(length(leadWords) == 0)
			return("")
		qtrGmPredWord <- dtQtrGm[J(leadWords[1], leadWords[2], leadWords[3]), mult = "first"][, V5]
	
		if(!is.na(qtrGmPredWord))
		{
			return(qtrGmPredWord)
		}
		else
		{
			triGmPredWord <- dtTriGm[J(leadWords[2], leadWords[3]), mult = "first"][, V4]
			if(!is.na(triGmPredWord))
			{
				return(triGmPredWord)
			}
			else
			{
				biGmPredWord <- dtBiGm[J(leadWords[3]), mult = "first"][, V3]
				if(!is.na(biGmPredWord))
				{
					return(biGmPredWord)
				}
				else
				{
					triGmPredWord1 <- dtTriGm[J(leadWords[1],leadWords[3]), mult = "first"][, V3]
					if(!is.na(triGmPredWord1))
					{
						return(triGmPredWord1)
					}
					else
					{
						biGmPredWord1 <- dtBiGm[J(leadWords[1]), mult = "first"][, V3]
						if(!is.na(biGmPredWord1))
						{
							return(biGmPredWord1)
						}
						else
						{						
							if (exists("leadWords"))
							{
								#uniGmPredWord <- sample(dtUniGm$V2, 1)
								uniGmPredWord <- "the"
								return(uniGmPredWord)
							}
							else
							{
								return("")
							}
						}
					}
				}
			}
		
		}
	}
	




shinyServer(
  function(input, output) {
	observeEvent(input$submit,
	{
	
    output$inputValue1 <- renderPrint({input$ipLine})
	#predWordOP <- eventReactive(input$submit, {predWord(input$ipLine)})
    output$predWord <-  renderPrint({predWord(input$ipLine)}) 
	}
	)
	}

)
  
  
  
  
  
