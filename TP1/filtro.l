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



%}
%option noyywrap

%%

BEGIN 0;

{commentList}\<li.+   {BEGIN comment; fprintf(json, "\"id\" : \"%s\"\n", retiraID(yytext));};

<ler>\<li.+ {if(hasReplies==1){BEGIN reply; } else{BEGIN comment;fprintf(json, "\"id\" : \"%s\",\n", retiraID(yytext));};};

<ler>{commentList} {;hasReplies=1;numberOfReplies=1; replys = malloc(sizeof(char*));BEGIN reply; fprintf(json,"\"hasReplies\" : TRUE,\n"); }

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

<comment>{content} {fprintf(json,"\"commentText\" : \"%s\",\n",retiraCommentText(yytext));
                    fprintf(json,"\"likes\" : %d,\n",likes) ;BEGIN ler;};

<comment>{branco} ;
<comment>.+ ;

<reply>\<li.+ {numberOfReplies++; idR = retiraID(yytext);};

<reply>{commentAuthor}  {userR = retiraUser(yytext);};

<reply>{data} {dateR = retiraData(yytext);};

<reply>{timeStamp} { timestampR = retirarTimeStamp(yytext);};

<reply>{content} { commentTextR = retiraCommentText(yytext);

replys = malloc(sizeof(CommentThread**));
replys[numberOfReplies-1]= newCommentThread(idR, userR, dateR, timestampR, commentTextR, 0); BEGIN ler;};


<reply>{branco} ;
<reply>.+ ;

%%

int main(int argc, char **argv){
  yyin = fopen("Publico_extraction_portuguese_comments_4.html","r");
  json = fopen("commentThread.json","w");
  fprintf(json, "commentThread[\n{\n");
  yylex();

  fclose(yyin);
  return 0;
}
