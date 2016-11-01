#pragma once
#include "windows.h"
#include"string"
#include "iostream"

class Locker {
public:
	Locker();
	~Locker();
private:
	Locker(const Locker&) {};
	Locker& operator=(const Locker&) {};
	CRITICAL_SECTION m_CriticalSection;
};

namespace CSLocker{

class CriticalSection {
public:
	CriticalSection();
	~CriticalSection();
	void Lock();
	void UnLock();
private:
	CriticalSection(const CriticalSection&) {};
	CriticalSection& operator=(const CriticalSection&) {};
	CRITICAL_SECTION m_CriticalSection;
};

class Locker {
public:
	Locker(CriticalSection& cs);
	~Locker();
private:
	Locker& operator=(const Locker&) {};
	CriticalSection& m_CriticalSectionObj;
};

}

class Helper {
public:
	Helper(const std::string& sOwnerThreadName) :m_ThreadName(sOwnerThreadName) {
		std::cout << m_ThreadName << " thread begin!" << std::endl;
	}
	~Helper() {
		std::cout << m_ThreadName << " thread finish!" << std::endl;
	}
private:
	std::string m_ThreadName;
};