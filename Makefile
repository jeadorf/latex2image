VERSION=0.1.dev
DISTNAME=latex2image-${VERSION}

.PHONY: dist
dist:
	rm -rf dist
	mkdir dist
	mkdir dist/${DISTNAME}
	cp latex2image.sh dist/${DISTNAME}/latex2image
	chmod 755 dist/${DISTNAME}/latex2image
	cp latex2image.php template.tex README deny.png dist/${DISTNAME}
	touch dist/${DISTNAME}/whitelist
	mkdir dist/${DISTNAME}/tmp
	mkdir dist/${DISTNAME}/cache
	cd dist && tar czvf ${DISTNAME}.tar.gz ${DISTNAME}

.PHONY: clean
clean:
	rm -rf dist

