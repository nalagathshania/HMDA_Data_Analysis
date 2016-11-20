#data munging
#Different libraries being used for the analysis
library(csvread)
library(data.table)
library(stringr)
library(dplyr)
library(reshape2)
library(magrittr)

#setting the working directory
setwd("C:\\Users\\farheen\\Documents\\project")

#reading the institution_data and storing it in another object
instit_file <- fread("C:\\Users\\farheen\\Documents\\project\\institutions_data.csv",
                     na.strings = c("NA","N/A","null"),stringsAsFactors=FALSE) 

#Padding the values of respondant_id to match it with the loan_data and create a "KEY" by appending
#the Agency_code and the Respondant ID.
instit_file <- transform(instit_file, R_ID = str_pad(instit_file$Respondent_ID, 10, "left", pad = "0"))
instit_file <- transform(instit_file,KEY = interaction(Agency_Code,R_ID,sep=''))

#reading the loan_data and storing it in the object and creating the "KEY" 
loan_file <- transform(fread("C:\\Users\\farheen\\Documents\\project\\loans_data.csv",sep = ',',
                             nrows = -1,
                             na.strings = c("NA","N/A","null"),
                             stringsAsFactors=FALSE, colClasses=list(character=c(5,7:9,11:13), numeric = c("Loan_Amount_000"), factor = c("State"))),
                       KEY = interaction(Agency_Code,Respondent_ID,sep=''))
#Merging the 2 datasets in order to have the corresponding institution name for each loan_amount entered
setkey(loan_file,KEY)
setkey(instit_file,KEY)
loan_file[instit_file[!duplicated(Respondent_Name_TS)], Respondent_Name_TS := i.Respondent_Name_TS, allow.cartesian = TRUE] #%>% 

#Data visualization
#melted the data in order to group it and summarize to get the count and sum of the total loans by state and year.
melted <- melt(loan_file, id.vars=c("As_of_Year", "State"), measure.vars = c("Loan_Amount_000"))
Group_loan <- group_by(melted,As_of_Year,State) 
nsum_loan <- summarize(Group_loan, total.count=n(), Loan_Amount = sum(as.numeric(value))) %>%
  mutate(State=as.factor(as.character(State)))  

#created subsets for each year to plot the data
sub_12 <- subset(nsum_loan, nsum_loan$As_of_Year == "2012") %>% arrange(desc(Loan_Amount))
sub_13 <- subset(nsum_loan, nsum_loan$As_of_Year == "2013") %>% arrange(desc(Loan_Amount))
sub_14 <- subset(nsum_loan, nsum_loan$As_of_Year == "2014") %>% arrange(desc(Loan_Amount))

#plotting 1
#this is the plot for the Total loan amount by each state and year
dev.new()
plot(sub_12$Loan_Amount, type = "b", ylim = c(0, max(sub_12$Loan_Amount)),axes = FALSE, col="red",lty=3,
     xlab="States", ylab="Total Loan in 000$")  

title(main="Total Loan distributions by state ", sub="By HMDA from 2012-'14", 
      font.main = 4, font.sub = 2)
axis(1,at=1:5,pos = 0, labels=c("VA", "MD", "DC", "DE", "WV"), las = 0, col.axis = "Dark green")
axis(2,at=sub_12$Loan_Amount,pos = 1, las = 0, col.axis = "dark green")
lines(sub_13$Loan_Amount, type="b", pch=22, col="blue", lty=2, lwd = 1)
lines(sub_14$Loan_Amount, type="b", pch=22, col="green", lty=5, lwd = 2)
legend("topright", title = "years", c("2012","2013","2014"), lty=c(3,1,2), lwd=c(1,1,2),col=c("red","blue","green"), horiz = TRUE, bty = "n")

#plotting 2
#this is the plot for the Total no. of loans by each state and year
dev.new()
plot(sub_12$total.count, type = "b", ylim = c(0, max(sub_12$total.count)),axes = FALSE, col="red",lty=3,
     xlab="States", ylab="Total No. of Loans")  
title(main="Total No. of Loans by state", sub="By HMDA from 2012-'14", 
      font.main = 4, font.sub = 2)
axis(1,at=1:5,pos = 0, labels=c("VA", "MD", "DC", "DE", "WV"), las = 0, col.axis = "Dark green")
axis(2,at=sub_12$total.count,pos = 1, las = 0, col.axis = "dark green")
lines(sub_13$total.count, type="b", pch=22, col="blue", lty=2, lwd = 1)
lines(sub_14$total.count, type="b", pch=22, col="green", lty=5, lwd = 2)
legend("topright", title = "years", c("2012","2013","2014"), lty=c(3,1,2), lwd=c(1,1,2),col=c("red","blue","green"), horiz = TRUE, bty = "n")
