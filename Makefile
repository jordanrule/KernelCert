COQFLAGS := -Q theories KernelCert
COQFILES := \
	theories/NTK/Core.v \
	theories/NTK/Affine.v \
	theories/NTK/Examples.v

.PHONY: all clean

all:
	@for file in $(COQFILES); do \
		echo "coqc $(COQFLAGS) $$file"; \
		coqc $(COQFLAGS) $$file || exit $$?; \
	done

clean:
	@find theories -type f \( -name '*.vo' -o -name '*.glob' -o -name '*.aux' -o -name '*.vos' -o -name '*.vok' \) -delete

