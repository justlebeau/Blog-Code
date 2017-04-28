######################
##This works well#####
######################
library(httr)
library(rvest)
library(htmltools)
library(dplyr)
##Prep for things used later
url<-"https://www.lexile.com/fab/results/?keyword="
url2<-"https://lexile.com/book/details/"
##CSV file with ISBN numbers
dat1<-read.csv("~isbns.csv",header=FALSE)
##dat1<-data.frame(dat1[203:634,])
dat<-as.character(dat1[,1])%>%trimws()
##dat<-dat[41:51]
blank<-as.character("NA")
blank1<-as.character("NA")
##blank2<-as.character("NA")
##blank3<-as.character("NA")
all<-data.frame("A","B","C")
colnames(all)<-c("name","lexiledat","num")
all<-data.frame(all[-1,])

for(i in dat) {
  
sites<-paste(url,i,sep="")

x <- GET(sites, add_headers('user-agent' = 'r'))

webpath<-x$url%>%includeHTML%>%read_html()

##Book Name
name<-webpath%>%html_nodes(xpath="///div[2]/div/div[2]/h4/a")%>%html_text()%>%trimws()

##Lexile Range
lexile<-webpath%>%html_nodes(xpath="///div[2]/div/div[3]/div[1]")%>%html_text()%>%trimws()%>%as.character()

##CSS change sometimes 
lexiledat<-ifelse(is.na(lexile[2])==TRUE,lexile,lexile[2])

test1<-data.frame(lexiledat,NA)

##Breaks every now and then when adding Author/Pages
##Author Name
##author<-webpath%>%html_nodes(xpath='///div[2]/div/div[2]/span')%>%html_text()%>%as.character()%>%trimws()

##author<-sub("by: ","",author)

##Pages
##pages<-webpath%>%html_nodes(xpath='///div[2]/div/div[2]/div/div[1]')%>%html_text()%>%as.character()%>%trimws()

##pages<-sub("Pages: ","",pages)


##Some books not found, this excludes them and replaces with NA values
df<-if(is.na(test1)) data.frame(blank,blank1) else data.frame(name,lexiledat,stringsAsFactors = FALSE)

colnames(df)<-c("name","lexiledat")
df$num <- i

all<-bind_rows(all,df)

}

master<-rbind(all1,all)


