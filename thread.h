#include <stdio.h>

typedef struct CommentThread{
    int id;
	char *user;
	char *date;
	int timestamp;
	char *commentText;
	int likes;
	int hasReplies;
	int numberOfReplies;
	char **replies;
}CommentThread;   	

CommentThread* newCommentThread(int i, char* user, char* date, int timestamp, char* commentText, int likes, int hasReplies, int numberOfReplies, char** replies);

void writeCommentThread(CommentThread* c, FILE* json);