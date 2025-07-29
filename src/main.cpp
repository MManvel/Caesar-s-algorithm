#include <iostream>
#include <dlfcn.h>

int main(){
	
	void* handle = dlopen("./libcaesar.so",RTLD_LAZY);//➤ RTLD_LAZY Սա մի flag է, որը ասում է՝"lazy loading" արա, այսինքն՝ գրադարանի ֆունկցիաները ներբեռնի միայն երբ դրանք իրականում կանչվում են (ոչ անմիջապես)։


	if(!handle){
		std::cerr<<"Չհաջողվեց բացել գրադարանը"<<dlerror()<<std::endl;
		return 1;
	}
	
	typedef const char* (*func_t)(const char*,int);
	func_t encode =(func_t) dlsym(handle,"encode");
	func_t decode =(func_t) dlsym(handle,"decode");

	const char* msg = "HELLO";

	const char* encrypted = encode(msg,3);
	const char* decrypted = decode(encrypted,3);

	std::cout<<"Original: "<<msg<<"\n";
	std::cout<<"Encoded: "<<encrypted<<"\n";
	std::cout<<"Decoded: "<<decrypted<<"\n";

	dlclose(handle);
	
}
