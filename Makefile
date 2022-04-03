
NAME = InevitableSummoning
DIST = dist
SRC  = src
VERSION = 0.0.1
LOVE_FILE = $(DIST)/$(NAME).love
MAC_VER = $(DIST)/$(NAME)-macos.zip
DEB_VER = $(DIST)/$(NAME)-$(VERSION)_all.deb
WIN_32_VER = $(DIST)/$(NAME)-win32.zip
WIN_64_VER = $(DIST)/$(NAME)-win64.zip
AUTHOR = AddiekinStudio

.PHONY: default
default: all

$(DIST):
	mkdir $(DIST)

$(LOVE_FILE): $(DIST) $(SRC)/*
	cd $(SRC) && zip -9 -r ../$(LOVE_FILE) .

$(MAC_VER): $(LOVE_FILE)
	cd $(SRC) && love-release -D -M -W

$(DIST)/.uploaded: $(WIN_32_VER) $(WIN_64_VER) $(DEB_VER) $(MAC_VER) $(LOVE_FILE)
	butler push $(MAC_VER) "$(AUTHOR)/$(NAME):mac" --userversion=$(VERSION)
	butler push $(WIN_32_VER) "$(AUTHOR)/$(NAME):win32" --userversion=$(VERSION)
	butler push $(WIN_64_VER) "$(AUTHOR)/$(NAME):win64" --userversion=$(VERSION)
	butler push $(DEB_VER) "$(AUTHOR)/$(NAME):deb" --userversion=$(VERSION)
	butler push $(LOVE_FILE) "$(AUTHOR)/$(NAME):love" --userversion=$(VERSION)
	touch $(DIST)/.uploaded

clean:
	rm -rf $(DIST)

all: $(MAC_VER) $(LOVE_FILE) $(DIST)/.uploaded
