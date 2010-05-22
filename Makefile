VERSION=0.1.1-dev
DISTNAME=latex2image-${VERSION}

.PHONY: dist
dist:
	rm -rf dist
	mkdir dist
	mkdir dist/latex2image
	cp latex2image.sh dist/latex2image/latex2image
	chmod 755 dist/latex2image/latex2image
	cp latex2image.php template.tex README deny.png dist/latex2image
	mkdir dist/latex2image/tmp
	mkdir dist/latex2image/cache
	cd dist && tar czvf ${DISTNAME}.tar.gz latex2image 

.PHONY: clean
clean:
	rm -rf dist

