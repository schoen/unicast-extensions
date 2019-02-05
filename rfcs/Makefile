MMARK := mmark
TWO := "yes"
TXT := $(patsubst %.md,%.txt,$(wildcard *.md))
XML := $(patsubst %.md,%.xml,$(wildcard *.md))
HTML := $(patsubst %.md,%.html,$(wildcard *.md))

all: $(TXT) $(XML) $(HTML)

txt: $(TXT)

xml: $(XML)

%.txt: %.md
	if [ -z $(TWO) ]; then \
	    $(MMARK) $< > $(basename $<).xml; \
	    xml2rfc --text --v3 $(basename $<).xml && rm $(basename $<).xml; \
	else \
	    $(MMARK) -2 $< > $(basename $<).xml; \
	    xml2rfc --text $(basename $<).xml && rm $(basename $<).xml; \
	fi

xml: $(XML)

%.xml: %.md
	if [ -z $(TWO) ]; then \
	    $(MMARK) $< > $(basename $<).xml; \
	else \
	    $(MMARK) -2 $< > $(basename $<).xml; \
	fi

%.html: %.xml
	if [ -z $(TWO) ]; then \
	    xml2rfc --html --v3 $(basename $<).xml && rm $(basename $<).xml; \
	else \
	    xml2rfc --html $(basename $<).xml && rm $(basename $<).xml; \
	fi

.PHONY: clean
clean:
	rm -f *.txt *.xml *.html
