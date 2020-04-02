branco [ \t\n]+
pL    [a-z]|ç|ã|á|à|â|é|

commentList \<(ol).+
commentExpanded \<(form).+
commentAuthor \<(h5).+\>[\n\r]*\<(a).+\<\/(a)\>
data \<(time).+
timeStamp \<a{branco}(class)\=\"(comment__permalink).+
content .+{branco}\<\/p\>

%x ler comment reply

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

char *id;
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

char *idR;
char *userR;
int likesR =0;
char *dateR = NULL;
char *timestampR;
char *commentTextR = NULL;

CommentThread *comentario = NULL;
CommentThread **replys   = NULL;


%}
%option noyywrap

%%

BEGIN 0;

{commentList}\<li.+   {BEGIN comment; printf("######SEJA BEM VINDO#######\nID: %s \n",yytext);};

<ler>\<li.+ {if(hasReplies==1){numberOfReplies++;BEGIN reply;}else{BEGIN comment;}; printf(" ID: %s Resposta nr : %d \n ", retiraID(yytext), numberOfReplies);};

<ler>{commentList} {hasReplies=1; replys = (CommentThread *) malloc(sizeof(CommentThread));BEGIN reply; }

<ler>{commentExpanded} {;hasReplies = 0; numberOfReplies =0; };

<ler>.+ ;
<ler>\n ;

<ler><<EOF>>   {printf("Ate a uma proxima!\n"); exit(0);};

<comment>\<li.+ {if(hasReplies==1){numberOfReplies++;}; printf(" ID: %s Resposta nr : %d \n ", retiraID(yytext), numberOfReplies);};

<comment>{commentAuthor} {printf("Autor: %s\n", retiraUser(yytext)); user = retiraUser(yytext);};

<comment>{data} {printf(" Data: %s \n", retiraData(yytext));};

<comment>{timeStamp} {printf(" TimeStamp: %s \n",retirarTimeStamp(yytext));};

<comment>{content} { printf(" Conteudo: %s \nFim comentário\n",retiraCommentText(yytext)); BEGIN ler;};

<comment>{branco} ;
<comment>.+ ;

<reply>\<li.+ {if(hasReplies==1){numberOfReplies++;}; printf("#### REPLY ### ID: %s Resposta nr : %d \n ", retiraID(yytext), numberOfReplies);};

<reply>{commentAuthor} {printf("Autor: %s\n", retiraUser(yytext)); user = retiraUser(yytext);};

<reply>{data} {printf(" Data: %s \n", retiraData(yytext));};

<reply>{timeStamp} {printf(" TimeStamp: %s \n",retirarTimeStamp(yytext));};

<reply>{content} {printf(" Conteudo: %s \nFim comentário\n",retiraCommentText(yytext)); BEGIN ler;};


<reply>{branco} ;
<reply>.+ ;

%%

int main(int argc, char **argv){
  comentario = (CommentThread *) malloc(sizeof(CommentThread));
  yyin = fopen("Publico_extraction_portuguese_comments_4.html","r");
  json = fopen("analise.json","w+");

  yylex();

  fclose(yyin);
  return 0;
}
