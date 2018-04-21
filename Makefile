
NAME = spitballs
LOVE_FILE = $(NAME).love

.PHONY: default
default: all

spitballs.love: $(NAME)/*
	cd $(NAME) && zip -9 -r ../$(LOVE_FILE) .

all: spitballs.love
