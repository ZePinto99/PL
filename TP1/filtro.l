branco [ \t\n]+
pL    [A-Za-zçãáàâéêõãú]

commentList \<(ol).+
commentExpanded \<(form).+
commentAuthor \<(h5).+\>[\n\r]*\<(a).+\<\/(a)\>
data \<(time).+
timeStamp \<a{branco}(class)\=\"(comment__permalink).+
content \<(div){branco}(class)\=\"(comment__content).+
paragrafo <p[ "!?,;\-.\n\t-(A-Za-zçãáàâéêõãÚôúíóÉ)0-9:/=>'ªº%?“—]+[ \t\n]+

%x ler comment reply conteudo

%s ol
%s h5
%s time
%s class
%s comment__permalink
%s form
%s li
%s div

%{
#include<stdio.h>
#include<string.h>
#include <stdlib.h>
#include"thread.h"


int hasReplies =0;
int likes=0;
int numberOfReplies =0;
FILE *json;

char idR[1024];
char userR[1024];
int likesR =0;
char dateR[50];
char timestampR[30];
CommentThread** replys = NULL;

int comentarios = 0;

char* texto = " ";

void concat(char* yytext){
          char* result = (char*) malloc(sizeof(char*)*(strlen(yytext) + strlen(texto) + 1));
          strcpy(result, texto);
          strcat(result, yytext);
          texto = result;
}

%}
%option noyywrap

%%

BEGIN 0;

{commentList}\<li.+   {BEGIN comment; fprintf(json, "\"id\" : \"%s\"\n", retiraID(yytext));};

<ler>\<li.+ {if(hasReplies==1){sprintf(idR, "%s", retiraID(yytext)); BEGIN reply;numberOfReplies++;}
             else{BEGIN comment; fprintf(json, "\"id\" : \"%s\",\n", retiraID(yytext));};};

<ler>{commentList} {hasReplies=1;numberOfReplies=1; replys = malloc(sizeof(CommentThread**));
                    BEGIN reply; fprintf(json,"\"hasReplies\" : \"TRUE\",\n");}

<ler>{commentExpanded} { if(hasReplies!=1){
                            fprintf(json,"\"hasReplies\" : \"FALSE\",\n");}
                         fprintf(json,"\"numberOfReplies\" : %d,\n",numberOfReplies);
                         writeCommentThread(replys, json, numberOfReplies);
                         if(comentarios<84){
                            fprintf(json,"],\n\n");
                            }
                         else{fprintf(json,"]\n"); }
                         hasReplies = 0; numberOfReplies =0;};


<ler>.+ ;
<ler>\n ;

<ler><<EOF>>   {fprintf(json,"\n}\n]"); exit(0);};


<comment>\<(h5).+\>[ \n\r]*(Conta) {fprintf(json, "\"user\" : \"Conta desactivada\",\n");};

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
                  comentarios++;
                  concat(yytext);
                  texto=retiraCommentText(texto);
                  if(hasReplies ==1){
                  replys[numberOfReplies-1]= newCommentThread(idR,userR,dateR,timestampR,texto,0);
                  BEGIN ler;
                  }
                  else{
                  comentarios++;
                  BEGIN ler;
                  fprintf(json,"\"commentText\" : \"%s\",\n", texto);
                  fprintf(json,"\"likes\" : \"%d\",\n",likes);
                  }};

<conteudo>{branco} ;


<reply>\<li.+ {sprintf(idR, "%s", retiraID(yytext));};

<reply>\<(h5).+\>[ \n\r]*(Conta) {sprintf(userR, "%s", "Conta desactivada");};

<reply>{commentAuthor}  {sprintf(userR, "%s", retiraUser(yytext));};

<reply>{data} {sprintf(dateR, "%s", retiraData(yytext));};

<reply>{timeStamp} {sprintf(timestampR, "%s", retirarTimeStamp(yytext));};

<reply>{content} {texto = ""; BEGIN conteudo;};


<reply>{branco} ;
<reply>.+ ;

%%

int main(int argc, char **argv){
  yyin = fopen("Publico_extraction_portuguese_comments_4.html","r");
  json = fopen("commentThread.json","w");
  fprintf(json, "\"commentThread\" : [\n{\n");
  yylex();
  texto = " ";

  fclose(yyin);
  return 0;
}
