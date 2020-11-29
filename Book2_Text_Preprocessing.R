library(dplyr)
library(tm)
library(textstem)

Book2<-read.csv("Book2.csv")
str(Book2)

Book2<-Book2%>%mutate(new_Text_lower=tolower(Text))
Book2<-Book2%>%mutate(new_Text_noNumbers=gsub('[[:digit:]]','',new_Text_lower))
stopwords_regex=paste(stopwords('en'),collapse='\\b|\\b')
Book2<-Book2%>%mutate(new_Text_noStopwords=gsub(stopwords_regex,'',new_Text_noNumbers))
Book2<-Book2%>%mutate(new_Text_noPunctuation=gsub('[[:punct:]]','',new_Text_noStopwords))
Book2<-Book2%>%mutate(new_Text_noSpaces=gsub('\\s+',' ',new_Text_noPunctuation))
Book2<-Book2%>%mutate(new_Text_Lemma=lemmatize_strings(new_Text_noSpaces))
Book2<-Book2%>%mutate(new_Text_Stem=stem_strings(new_Text_noSpaces))
Book2<-Book2%>%select('Speaker.1','Speaker.2','new_Text_Lemma')

corp<-Corpus(VectorSource(Book2$new_Text_Lemma))

my_tfidf<-DocumentTermMatrix(corp,control=list(weighting=weightTfIdf))
my_tfidf

my_tfidf_small<-removeSparseTerms(my_tfidf,0.99)
my_tfidf_small

my_data_frame<-as.data.frame(as.matrix(my_tfidf_small))