all: slides.html

slides.html: slides.md
	pandoc --offline -s -t slidy -o $@ $<

clean:
	-rm -f slides.html
