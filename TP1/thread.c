#include "thread.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>

CommentThread* newCommentThread(char i[], char user[], char date[], char timestamp[], char* commentText, int likes) {
    CommentThread* c = (CommentThread*)malloc(sizeof(CommentThread));
    sprintf(c->id,"%s",i);
    sprintf(c->user,"%s",user);
    sprintf(c->date,"%s",date);
    sprintf(c->timestamp,"%s",timestamp);
    c->commentText = commentText;
    c->likes = likes;
    return c;
}


void writeCommentThread(CommentThread** c, FILE* json, int size) {
    fprintf(json, "\"replys\" [");
    for (int i = 0; i < size; i++) {
        fprintf(json, "{\n");
        fprintf(json, "\"id\" : \"%s\"\n", c[i]->id);
        fprintf(json, "\"user\" : \"%s\"\n", c[i]->user);
        printf("%s\n", c[i]->user);
        fprintf(json, "\"date\" : \"%s\"\n", c[i]->date);
        fprintf(json, "\"timestamp\" : \"%s\"\n", c[i]->timestamp);
        fprintf(json, "\"commentText\" : \"%s\"\n", c[i]->commentText);
        if (size == 1) { fprintf(json, "\"likes\" : \"%d\"\n}\n", c[i]->likes); }
        else {
            if (i == size - 1) fprintf(json, "\"likes\" : \"%d\"\n}", c[i]->likes);
            else { fprintf(json, "\"likes\" : %d},", c[i]->likes); }
        }
    }
}


//char* retira id <li class="comment" data-comment-id="8f949889-2606-4749-1c42-08d7471cb23d">
char* retiraID(char* str) {
    const char s[3] = "\"";
    char* last, * token;
    char* token2;
    token = strtok(str, s);
    while (token != NULL) {
        token2 = last;
        last = token;
        token = strtok(NULL, s);
    }
    token = strtok(token2, "\">");
    return token;
}

char* retiraUser(char* str) {
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
char* retiraData(char* str) {
    const char s[3] = "\"";
    char* last, * token;
    char* token2;
    token = strtok(str, s);
    while (token != NULL) {
        token2 = last;
        last = token;
        token = strtok(NULL, s);
    }
    token = strtok(token2, "T");
    return token;
}

//int timestamp
char* retirarTimeStamp(char* str) {
    const char s[3] = "<";
    char* last, * token;
    char* token2, * token3, * token4;
    token = strtok(str, s);
    while (token != NULL) {
        token2 = last;
        last = token;
        token = strtok(NULL, s);
    }
    token3 = strtok(token2, ">");
    token3 = strtok(NULL, ">");
    //   printf( " %s\n", token3);
    return(token3);
}

//char* retiraCommentText
char* retiraCommentText(char* str) {
    char* token; char* token2; char* tok;
    token = strtok(str, ">");
    token = strtok(NULL, " ");
    token = strtok(NULL, "<");
    while (token[0] == ' ') token++;
    int i = 0;
    token2 = (char*)malloc(sizeof(char*) * (strlen(token)));
    while (token[i + 1] != '\0') {
        token2[i] = token[i];
        i++;
    }
    int k = 0;
    tok = (char*)malloc(sizeof(char*) * i);
    while (token2[k] != '\0') {
        for (int f = k; f < 8 + k; f++) {
            if (token2[f] != '\0' && (token2[f] != ' ' && token2[f] != '\n')) {
                break;
            }
            if (f == k + 7) return tok;
        }
        tok[k] = token2[k];
        k++;
    }
    //printf(token2);
    return(tok);
}

