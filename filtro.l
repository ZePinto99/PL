branco [ \t\n]+
pL    [a-z]|ç|ã|á|à|â|é|

commentList \<(ol).+
commentExpanded \<(form).+
commentAuthor \<(h5).+\>[\n\r]*\<(a).+\<\/(a)\>
data \<(time).+
timeStamp \<a{branco}(class)\=\"(comment__permalink).+
content \<(p)\>{branco}.+{branco}+\<\/p\>

%x ler comment replys

%s ol
%s h5
%s time
%s class
%s comment__permalink
%s form
%s div

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

\[\</(h3)   {BEGIN ler; printf("######SEJA BEM VINDO#######\n");};

<ler>{commentList} {BEGIN comment; hasReplies = 0; printf(" ID: %s ", yytext);};

<ler>{commentExpanded} {BEGIN comment; hasReplies = 0; printf(" ID: %s ",yytext);};

<ler>\n ;

<ler><<EOF>>   {printf("Ate a uma proxima!\n"); exit(0);};

<comment>{commentAuthor} {printf("Autor\n");};

<comment>{data} {printf("Data\n");};

<comment>{timeStamp} {printf("TimeStamp\n");};

<comment>{content} {printf("Conteudo \n");};

<comment>\<\/div\>{branco}\<\/div\> {BEGIN ler; printf("Fim do comentário \n");};

<comment>\n ;
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
