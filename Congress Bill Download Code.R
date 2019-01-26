#Gov Track 

#Library
library(dplyr)
library(httr)
library(XML)
library(rvest)
library(xml2)
library(ggplot2)
library(purrr)
library(stringr)
library(gtools)

#Individual Bill####
#XML Address
base<-"https://www.govinfo.gov/bulkdata/BILLSTATUS/114/hr/"
bill<-"BILLSTATUS-114hr999.xml"
url<-paste0(base,bill)

#Read File
xml<-read_xml(url)
xmldoc<-xmlParse(xml)
rootNode<-xmlRoot(xmldoc)
data<-xmlSApply(rootNode,function(x) xmlSApply(x, xmlValue))
data_df<-data.frame(t(data$bill), row.names=NULL)
hr<-data_df

#Clean Results####
#Clean sponsor
hr$sponsors<-str_extract(hr$sponsors, "\\[[:alpha:]\\-[:alpha:].\\-[:digit:].")
hr$sponsors<-str_remove_all(hr$sponsors, "\\[")
hr$sponsors<-str_remove_all(hr$sponsors, "\\]")
hr$sponsors

#Extract all cosponsors
hr$cosponsors<-str_extract_all(hr$cosponsors, "\\[[:alpha:]\\-[:alpha:].\\-[:digit:].")
hr$cosponsors

#Sitemap####
bulkdata/BILLSTATUS/114/hr/
#Get list of files
url<-"https://www.govinfo.gov/sitemap/bulkdata/BILLSTATUS/114hr/sitemap.xml"
xml<-read_xml(url)
xmldoc<-xmlParse(xml)
rootNode<-xmlRoot(xmldoc)
data<-xmlSApply(rootNode,function(x) xmlSApply(x, xmlValue))
data_df<-data.frame(t(data), row.names=NULL)
sitemap<-data_df

#Get all URLs as separate df
loc_df<-as_tibble(sitemap$loc)
names(loc_df)<-"loc"
loc_df$loc<-as.character(loc_df$loc)

#Loop####
for (i in 1:10){
  tryCatch({
    start<-Sys.time()
    print(paste("start loop", sep="", start))
    url<-loc_df$loc[i]
    xml<-read_xml(url)
    xmldoc<-xmlParse(xml)
    rootNode<-xmlRoot(xmldoc)
    data<-xmlSApply(rootNode,function(x) xmlSApply(x, xmlValue))
    data_df<-data.frame(t(data$bill), row.names=NULL)
    data_df$loc<-loc_df$loc[i]
    data_df$cosponsors<-as.character(data_df$cosponsors)
    data_df$sponsors<-as.character(data_df$sponsors)
    hr<-smartbind(hr,data_df)
    end<-Sys.time()
    print(paste("end loop", loc_df$loc[i], sep="", end))
    Sys.sleep(1)      
  }, error=function(e){})
}
