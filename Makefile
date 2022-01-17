PKGNAME = `sed -n "s/Package: *\([^ ]*\)/\1/p" DESCRIPTION`
PKGVERS = `sed -n "s/Version: *\([^ ]*\)/\1/p" DESCRIPTION`

all: check clean

activate:
	Rscript -e 'source("renv/activate.R")'

build: activate document
	@rm -rf bin
	@mkdir bin

	Rscript \
	-e 'devtools::build(path = "bin", binary = F, vignettes = T, manual = T)'

binary: activate document
	@rm -rf bin
	@mkdir bin

	Rscript \
	-e 'devtools::build(path = "bin", binary = T, vignettes = T, manual = T)'

document: activate
	Rscript \
		-e 'devtools::document()'

check: activate document
	
	Rscript \
	-e 'options(crayon.enabled = TRUE)' \
	-e 'rcmdcheck::rcmdcheck(args = c("--no-manual", "--as-cran"), error_on = "warning", check_dir = "check")'

restore: activate
	Rscript \
	-e 'source("renv/activate.R")' \
	-e 'renv::restore()'

install: build
	R CMD INSTALL bin/$(PKGNAME)_$(PKGVERS).tar.gz

clean:
	@rm -rf $(PKGNAME)_$(PKGVERS).tar.gz $(PKGNAME).Rcheck
	@rm -rf check
	@rm -rf bin