  #this program shows how votes in number and percent per election district

  library(shiny)
  library(httr)
  library(ggplot2)
  library(dplyr)
  library(readxl)
  library(curl)


  #Votes from each municipality
#' MunicipalityInput
#' @import ggplot2
#'
#' @param MunicipalityInput takes in this argument and plots a graph.
#' @return returns a plot with votecount
#' @export
#'
#' @references "google.com"
#'
  Municipality <- function(MunicipalityInput){

    url<-"https://data.val.se/val/val2014/statistik/2014_landstingsval_per_kommun.xls"

    retrieve_data<-GET(url = url, write_disk(tempo<- tempfile(fileext = ".xls")))
    get_data_tempo <- read_excel(tempo, skip = 2, col_names = TRUE)
    get_data_dataframe<-get_data_tempo[,-c(1,23:110,117:118)]
    colnames(get_data_dataframe) <- c(get_data_dataframe[1,])
    get_data_dataframe <- as.data.frame(get_data_dataframe)
    colnames(get_data_dataframe) <- c("County","Municipality","County_name","M votes","M%","C votes","C%","FP votes","FP %","KD votes","KD%","S votes","S%","V votes","V%","MP votes","MP%","SD votes","SD%","FI votes","FI%","OVR votes","%OVR","BLANK votes","BLANK%","OG votes","OG%","Voter Turnout","Turnout %")

    #MunicipalityInput = "Kronobergs län"
    if( is.character(MunicipalityInput)){

      municipality_temp <- get_data_dataframe[get_data_dataframe$Municipality == MunicipalityInput,]
      Municipality_df <- municipality_temp[,-c(1,3,5,7,9,11,13,15,17,19,21,23,25,27,28,29)]


     Municipality_df <- Municipality_df[-1,]
     #print(Municipality_df)
      trans_Muni_df<-t(Municipality_df)
      #print(trans_Muni_df[,])
      row.names(trans_Muni_df) <-c("Municipality","M","C","FP","KD","S","V","MP","SD","FI","OVR","BLANK","OG")

      x_axis<-as.vector( names(trans_Muni_df[,1])[-(1:1)])

      yvalues = c()
      for(x in x_axis)
      {
        yvalues = c(yvalues,mean(as.numeric(trans_Muni_df[x,])))
      }
      y_axis<-yvalues
      Partynames<-vector()
      Votecount<-vector()
      fdf<-data.frame(Partynames= x_axis, Votecount =  y_axis)
      #print(fdf)
      g<-ggplot(data =fdf,aes (x=Partynames,y = Votecount)) + geom_bar(stat="identity") + geom_text(aes(label=Votecount), vjust=1.6, color="black", size=3.5) +
        theme_minimal() + labs(title = "Municipality Result")



      return(g)
    } else print("Error:Input type invalid")
  }



#Municipality(MunicipalityInput ="Kronobergs län")
