#include <string>

extern "C" const char* encode (const char* text , int shift){
	static std::string result;
	result=text;

	for (char& c : result){
		if (c>='a' && c<='z'){
			c=(c-'a' + shift)%26+'a';
		}else if(c>='A' && c<='Z'){
			c=(c-'A' +shift )%26+'A';
		}
	}
	return result.c_str();
}
