branco [ \t\n]+
pL    [a-z]|ç|ã|á|à|â|é|

commentList \<(ol).+
commentExpanded \<(form).+
commentAuthor \<(h5).+\>[\n\r]*\<(a).+\<\/(a)\>
data \<(time).+
timeStamp \<a{branco}(class)\=\"(comment__permalink).+
content .+{branco}\<\/p\>

%x ler comment

%s ol
%s h5
%s time
%s class
%s comment__permalink
%s form
%s li

%{
#include<stdio.h>
#include<string.h>
#include"thread.h"

int id;
char *user;
int likes =0;
char *date = NULL;
char *timestamp;
char *commentText = NULL;
int hasReplies =0;
int numberOfReplies =0;
char **replies = NULL;
FILE *yyin;
FILE *json;

CommentThread *comentario = NULL;

%}
%option noyywrap

%%

BEGIN 0;

{commentList}\<li.+   {BEGIN ler; printf("######SEJA BEM VINDO#######\nID: %s \n",yytext);};

<ler>\<li.+ {BEGIN comment; if(hasReplies==1) numberOfReplies++; printf(" ID: %s, Resposta nr : %d \n ", yytext, numberOfReplies);};

<ler>{commentList} {hasReplies=1;}

<ler>{commentExpanded} {hasReplies = 0; numberOfReplies =0;};

<ler>.+ ;
<ler>\n ;

<ler><<EOF>>   {printf("Ate a uma proxima!\n"); exit(0);};

<comment>{commentAuthor} {printf("Autor: %s\n", retiraUser(yytext));};

<comment>{data} {printf(" Data: %s \n", yytext);};

<comment>{timeStamp} {printf(" TimeStamp: %s \n",retirarTimeStamp(yytext));};

<comment>{content} {BEGIN ler; printf("Conteudo: %s \nFim comentário\n",yytext); comentario = newCommentThread(id, user, date, timestamp, commentText, likes, hasReplies, numberOfReplies, replies); writeCommentThread(comentario, json);};

<comment>{branco} ;
<comment>.+ ;

%%

int main(int argc, char **argv){
  comentario = (CommentThread *) malloc(sizeof(CommentThread));
  yyin = fopen("Publico_extraction_portuguese_comments_4.html","r");
  json = fopen("analise.json","w+");

  yylex();

  fclose(yyin);
  return 0;
}
