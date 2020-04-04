#include <stdio.h>

typedef struct CommentThread{
    char* id;
	char* user;
	char* date;
	char* timestamp;
	char* commentText;
	int likes;
	int hasReplies;
	int numberOfReplies;
	char** replies;
}CommentThread;   	

CommentThread* newCommentThread(char* i, char* user, char* date, char* timestamp, char* commentText, int likes);


void writeCommentThread(CommentThread** c, FILE* json, int size);

char *saveReply(char *user,char *date);

char*  retiraID(char *str);

char* retiraUser(char* str);

char* retiraData(char* str);

char* retirarTimeStamp(char* str);

char* retiraCommentText(char* str);