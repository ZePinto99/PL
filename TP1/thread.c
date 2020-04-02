﻿#include "thread.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

CommentThread* newCommentThread(char* i, char *user,char *date, char* timestamp, char *commentText, int likes){
			CommentThread *c = (CommentThread *) malloc(sizeof(CommentThread));
			c->id = i;
			c->user = user;
			c->date = date;
			c->timestamp=timestamp;
			c->commentText = commentText;
			c->likes = likes;
			return c;
}

char *saveReply(char *user,char *date){
    char* token;
    sprintf(token, "ID %s and date: %s \n", user, date);
    return token;
}

void writeCommentThread(CommentThread** c, FILE* json, int size) {

    fprintf(json, "\"replys\" [");
    for (int i = 0; i < size; i++) {
        fprintf(json, "{\n");
        fprintf(json, "id : %s\n", c[i]->id);
        fprintf(json, "user : %s\n", c[i]->user);
        fprintf(json, "date : %s\n", c[i]->date);
        fprintf(json, "timestamp : %s\n", c[i]->timestamp);
        fprintf(json, "commentText : %s\n", c[i]->commentText);
        fprintf(json, "likes : %d}\n", c[i]->likes);
    }
}


//char* retira id <li class="comment" data-comment-id="8f949889-2606-4749-1c42-08d7471cb23d">
char*  retiraID(char *str) {
    const char s[3] = "\"";
    char *last, *token;
    char *token2;
    token = strtok(str, s);
    while( token != NULL ) {
        token2=last;
        last = token;
        token = strtok(NULL, s);
    }
    token = strtok(token2,"\">");
    return token;
}

char*  retiraUser(char *str) {
	const char s[3] = "\">";
	char* last, * token;
	token = strtok(str, s);
	while (token != NULL) {
		last = token;
		token = strtok(NULL, s);
	}
	token = strtok(last, "<");
	//printf(" %s\n", token);
	return token;
}

//char* retiraData <time class="dateline comment__dateline" datetime="2019-10-02T22:50:07.08">
char*  retiraData(char *str) {
    const char s[3] = "\"";
    char *last, *token;
    char *token2;
    token = strtok(str, s);
    while( token != NULL ) {
        token2=last;
        last = token;
        token = strtok(NULL, s);
    }
    token = strtok(token2,"T");
    return token;
}

//int timestamp
char*  retirarTimeStamp(char *str) {
   	const char s[3] = "<";
    char *last, *token;
    char *token2, *token3, *token4;
    token = strtok(str, s);
    while( token != NULL ) {
        token2=last;
        last = token;
        token = strtok(NULL, s);
    }
    token3 = strtok(token2,">");
    token3 = strtok(NULL,">");
 //   printf( " %s\n", token3);
    return(token3);
}

//char* retiraCommentText
char* retiraCommentText(char * str){
    const char s[3] = "\n";
    char *token;
    token = strtok(str, s);
    return token;
}


//int retiraLikes

//int hasReplies

//int number of replies

//char** replies

/*
int main(int argc, char const *argv[])
{
	FILE *json = fopen("analise.json","w+");
	CommentThread *teste = newCommentThread(1,"Ze","14/03/20",8,"Hello world!",100,1,0,NULL);
	writeCommentThread(teste, json);
	return 0;
}*/
