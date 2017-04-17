CC  := gcc
CXX := g++
RM  := rm -rf
CP  := cp -r
MKDIR := mkdir -p

# TODO 1. 测试; 2. C和C++混合

#编译选项在这里修改
#TARGET := LINUX
IS_DEBUG := DEBUG
#IS_DEBUG :=

PROGRAME := programe-name
VERSION := v0.0.1

APP := $(PROGRAME)-$(VERSION)

CFLAGS   := -DVERSION=\"$(VERSION)\" -MMD -MP
CXXFLAGS := -DVERSION=\"$(VERSION)\" -MMD -MP
LDFLAGS :=

CFLAGS_WIN := -DWINDOWS
LDFLAGS_WIN :=
CFLAGS_DEBUG := -DDEBUG -g -O0 -Wall -Wno-unused
LDFLAGS_DEBUG :=
CFLAGS_RELEASE := -O2 -W -Wall -DNDEBUG

CSRCS := $(wildcard src/*.c)
COBJS := $(CSRCS:.c=.c.o)
CDEPS := $(CSRCS:.c=.c.d)
CXXSRCS := $(wildcard src/*.cpp)
CXXOBJS := $(CXXSRCS:.cpp=.cpp.o)
CXXDEPS := $(CXXSRCS:.cpp=.cpp.d)

ifeq ($(TARGET), WIN)
	CFLAGS += $(CFLAGS_WIN)
	LDFLAGS += $(LDFLAGS_WIN)
	APP := $(APP)-win
else
	CFLAGS += -DLINUX
	APP := $(APP)-linux
endif
ifeq ($(IS_DEBUG), DEBUG)
	CFLAGS += $(CFLAGS_DEBUG)
else	# not debug
ifeq ($(TARGET), WIN)
	LDFLAGS += -mwindows
endif	# windows && not debug
	CFLAGS += $(CFLAGS_RELEASE)
endif

$(PROGRAME): $(COBJS)
	$(CC) -o $@ $^ $(LDFLAGS)
-include $(CDEPS) $(CXXDEPS)

clean:
	$(RM) $(COBJS) $(CXXOBJS) $(PROGRAME)
distclean: clean
	$(RM) $(APP) $(APP).zip
	$(RM) $(TEST_OBJS) $(TEST_DEPS) $(TEST_APP)

.PHONY: clean distclean test all
