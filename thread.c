#include "thread.h"
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

CommentThread* newCommentThread(int i, char *user,char *date, int timestamp, char *commentText, int likes, int hasReplies, int numberOfReplies, char **replies){
			CommentThread *c = (CommentThread *) malloc(sizeof(CommentThread));
			c->id = i;
			c->user = user;
			c->date = date;
			c->timestamp=timestamp;
			c->commentText = commentText;
			c->likes = likes;
			c->hasReplies =hasReplies;
			c->numberOfReplies = numberOfReplies;
			c->replies = replies;
			return c;
}

void writeCommentThread(CommentThread *c, FILE *json){
	
	fprintf(json, "commentThread[\n{\n");
	fprintf(json, "id : %d\n", c->id);
	fprintf(json, "user : %s\n", c->user);
	fprintf(json, "date : %s\n", c->date);
	fprintf(json, "timestamp : %d\n", c->timestamp);
	fprintf(json, "commentText : %s\n", c->commentText);
	fprintf(json, "likes : %d\n", c->likes);
	if (c->hasReplies ==1)
	{
		fprintf(json, "hasReplies : TRUE\n");
	} else fprintf(json, "id : FALSE\n");
	fprintf(json, "numberOfReplies : %d\n", c->numberOfReplies);

	fprintf(json, "replies[\n");
	for(int i=0; i < c->numberOfReplies; i++)
		fprintf(json, "->%s\n", (c->replies)[i]);
	fprintf(json, "]\n}........\n]\n");
}

//char* retira id <li class="comment" data-comment-id="8f949889-2606-4749-1c42-08d7471cb23d">

  char*  retiraUser(char *str) {
	const char s[3] = "\">";
		char* last, * token;
	token = strtok(str, s);
	while (token != NULL) {
		last = token;
		token = strtok(NULL, s);
	}
	token = strtok(last, "<");
	printf(" %s\n", token);
	return(token);
}

//char* retiraData <time class="dateline comment__dateline" datetime="2019-10-02T22:50:07.08">
  /*Exemplo de input:
  <time class="dateline comment__dateline" datetime="2019-10-02T22:37:46.487">
  */


//int timestamp 
  /*Exemplo de input:
  <a class="comment__permalink">02.10.2019 22:50</a>
  */

//char* retiraCommentText
/*Exemplo de input:
  Para esclarecer os eleitores � crucial saber-se qual a qualidade dos candidatos que ir�o aplicar o programa eleitoral. As suspeitas sobre Costa deviam ser discutidas agora, antes das elei��es.
                    </p>
 */

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