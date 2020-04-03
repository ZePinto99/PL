branco [ \t\n]+
pL    [A-Za-zçãáàâéêõãú]

commentList \<(ol).+
commentExpanded \<(form).+
commentAuthor \<(h5).+\>[\n\r]*\<(a).+\<\/(a)\>
data \<(time).+
timeStamp \<a{branco}(class)\=\"(comment__permalink).+
content \<(div){branco}(class)\=\"(comment__content).+
paragrafo [ \"\!\?,;.\n\t{pL}-]+{branco}

%x ler comment reply conteudo

%s ol
%s h5
%s time
%s class
%s comment__permalink
%s form
%s li
%s data
%s id
%s div

%{
#include<stdio.h>
#include<string.h>
#include <stdlib.h>
#include"thread.h"


int hasReplies =0;
int likes=0;
int numberOfReplies =0;
char **replies = NULL;
FILE *json;

char *idR;
char *userR;
int likesR =0;
char *dateR = NULL;
char *timestampR;
char *commentTextR = NULL;

CommentThread* reply;
CommentThread** replys = NULL;

int comentarios = 0;

char* texto = " ";

void concat(char* yytext){
          char* aux = retiraCommentText(yytext);
          char* result = (char*) malloc(sizeof(char*)*(strlen(aux) + strlen(texto) + 1));
          strcpy(result, texto);
          strcat(result, yytext);
          texto = result;
}

%}
%option noyywrap

%%

BEGIN 0;

{commentList}\<li.+   {BEGIN comment; fprintf(json, "\"id\" : \"%s\"\n", retiraID(yytext));};

<ler>\<li.+ {if(hasReplies==1){BEGIN reply;} else{BEGIN comment;fprintf(json, "\"id\" : \"%s\",\n", retiraID(yytext));};};

<ler>{commentList} {hasReplies=1;numberOfReplies=1; replys = malloc(sizeof(char*));BEGIN reply; fprintf(json,"\"hasReplies\" : TRUE,\n"); }

<ler>{commentExpanded} { if(hasReplies!=1){
                         fprintf(json,"\"hasReplies\" : FALSE,\n");}
                         fprintf(json,"\"numberOfReplies\" : %d,\n\n",numberOfReplies);
                         writeCommentThread(replys, json, numberOfReplies);
                         fprintf(json,"]\n,");
                         hasReplies = 0; numberOfReplies =0;
                         };


<ler>.+ ;
<ler>\n ;

<ler><<EOF>>   {fprintf(json,"]\n"); exit(0);};

<comment>\<li.+ {fprintf(json, "\"id\" : \"%s\",\n", retiraID(yytext));};

<comment>{commentAuthor} { fprintf(json, "\"user\" : \"%s\",\n", retiraUser(yytext));};

<comment>{data} {fprintf(json, "\"date\" : \"%s\",\n", retiraData(yytext));};

<comment>{timeStamp} {fprintf(json, "\"timestamp\" : \"%s\",\n",retirarTimeStamp(yytext));};

<comment>{content} {texto = "";BEGIN conteudo;};

<comment>{branco} ;
<comment>.+ ;

<conteudo>{paragrafo} {
                        concat(yytext);
                      };
<conteudo>\<\/p> {
                  concat(yytext);
                  //printf("%s\n", texto);
                  if(hasReplies ==1){
                  comentarios++;
                  //printf("%d\n",comentarios);
                  BEGIN reply;
                  replys = malloc(sizeof(CommentThread**));
                  replys[numberOfReplies-1]= newCommentThread(idR,userR,dateR,timestampR,texto,0);
                  }
                  else{
                              comentarios++;
                              printf("%d\n",comentarios);
                              BEGIN ler;
                              fprintf(json,"\"commentText\" : \"%s\",\n", texto);
                              fprintf(json,"\"likes\" : \"%d\",\n",likes);
                              }};

<conteudo>{branco} ;

<reply>\<li {numberOfReplies++; idR = retiraID(yytext);};

<reply>{commentAuthor}  {userR = retiraUser(yytext);};

<reply>{data} {dateR = retiraData(yytext);};

<reply>{timeStamp} { timestampR = retirarTimeStamp(yytext);};

<reply>{content} {texto = ""; BEGIN conteudo;};

<reply>{commentExpanded} {printf("#########SUP MY DUDE########"); BEGIN comment;
                          if(hasReplies!=1){
                          fprintf(json,"\"hasReplies\" : FALSE,\n");}
                          fprintf(json,"\"numberOfReplies\" : %d,\n\n",numberOfReplies);
                          writeCommentThread(replys, json, numberOfReplies);
                          fprintf(json,"]\n,");
                          hasReplies = 0; numberOfReplies =0;};

<reply>{branco} ;
<reply>.+ ;

%%

int main(int argc, char **argv){
  yyin = fopen("Publico_extraction_portuguese_comments_4.html","r");
  json = fopen("commentThread.json","w");
  fprintf(json, "commentThread[\n{\n");
  yylex();
  texto = " ";

  fclose(yyin);
  return 0;
}
