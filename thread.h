#include <stdio.h>

typedef struct CommentThread{
    int id;
	char *user;
	char *date;
	char* timestamp;
	char *commentText;
	int likes;
	int hasReplies;
	int numberOfReplies;
	char **replies;
}CommentThread;   	

CommentThread* newCommentThread(int i, char* user, char* date, char* timestamp, char* commentText, int likes, int hasReplies, int numberOfReplies, char** replies);

void writeCommentThread(CommentThread* c, FILE* json);

char* retiraUser(char* str);

char* retiraData(char* str);

char* retirarTimeStamp(char* str);

char* retiraCommentText(char* str);