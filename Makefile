COQFLAGS := -Q theories KernelCert
NTKFILES := \
	theories/NTK/Core.v \
	theories/NTK/Asymptotic.v \
	theories/NTK/Affine.v \
	theories/NTK/Examples.v

QUANTUMFILES := \
	theories/Quantum/KernelProof.v

.PHONY: all ntk quantum clean

ntk:
	@for file in $(NTKFILES); do \
		echo "coqc $(COQFLAGS) $$file"; \
		coqc $(COQFLAGS) $$file || exit $$?; \
	done

quantum:
	@for file in $(QUANTUMFILES); do \
		echo "coqc $(COQFLAGS) $$file"; \
		coqc $(COQFLAGS) $$file || exit $$?; \
	done

all: ntk quantum

clean:
	@find theories -type f \( -name '*.vo' -o -name '*.glob' -o -name '*.aux' -o -name '*.vos' -o -name '*.vok' \) -delete

