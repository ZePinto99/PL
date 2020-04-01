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
char *date = NULL;
int timestamp=0;
char *commentText = NULL;
int hasReplies =0;
int numberOfReplies =0;
FILE *yyin;
int autores =0;

CommentThread *comentarios = NULL;

%}
%option noyywrap

%%

BEGIN 0;

{commentList}   {BEGIN ler; printf("######SEJA BEM VINDO#######\n");};

<ler>\<li.+ {BEGIN comment; hasReplies=1; numberOfReplies++; printf(" ID: %s ", yytext);};

<ler>{commentExpanded} {BEGIN comment; hasReplies = 0; numberOfReplies = 0; printf(" ID: %s ",yytext);};

<ler>.+ ;
<ler>\n ;

<ler><<EOF>>   {printf("Ate a uma proxima!\n"); exit(0);};

<comment>{commentAuthor} {printf("Autor: %s\n",yytext);};

<comment>{data} {printf("data \n");};

<comment>{timeStamp} {printf("TimeStamp\n");};

<comment>{content} {BEGIN ler; printf("Conteudo\nFim comentário\n");};

<comment>{branco} ;
<comment>.+ ;

%%

int main(int argc, char **argv){
  comentarios = (CommentThread *) malloc(sizeof(CommentThread));
  yyin = fopen("Publico_extraction_portuguese_comments_4.html","r");
  FILE *json = fopen("analise.json","w+");

  yylex();

  fclose(yyin);
  return 0;
}
