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
