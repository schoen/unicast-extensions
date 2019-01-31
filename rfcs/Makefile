SOURCE=draft-ietf-aqm-fq-codel-xx.mkd

title=$(shell grep 'docname: ' $(SOURCE) | sed 's/docname: //')

objects=draft-ietf-aqm-fq-codel-??.{xml,html,txt}

all: $(title).html $(title).txt


$(title).xml: $(SOURCE)
	kramdown-rfc2629 $(SOURCE) > $(title).xml

$(title).html: $(title).xml
	xml2rfc $(title).xml --html

$(title).txt: $(title).xml
	xml2rfc $(title).xml --text

.PHONY: clean
clean:
	rm -f $(objects)
