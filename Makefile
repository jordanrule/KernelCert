COQFLAGS := -Q theories KernelCert
NTKFILES := \
	theories/NTK/Core.v \
	theories/NTK/Asymptotic.v \
	theories/NTK/Affine.v \
	theories/NTK/JacobianMap.v \
	theories/NTK/Examples.v

QUANTUMFILES := \
	theories/Quantum/Entanglement.v \
	theories/Quantum/Superposition.v \
	theories/Quantum/KernelProof.v

RIEMANNFILES := \
	theories/Riemann/Roadmap.v

.PHONY: all ntk quantum riemann rh-pdf clean

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

riemann:
	@for file in $(RIEMANNFILES); do \
		echo "coqc $(COQFLAGS) $$file"; \
		coqc $(COQFLAGS) $$file || exit $$?; \
	done

all: ntk quantum riemann

rh-pdf:
	@command -v pdflatex >/dev/null 2>&1 || { echo "pdflatex not found; install a TeX distribution first."; exit 1; }
	@echo "pdflatex -interaction=nonstopmode -halt-on-error riemann_hypothesis.tex"
	@pdflatex -interaction=nonstopmode -halt-on-error riemann_hypothesis.tex

clean:
	@find theories -type f \( -name '*.vo' -o -name '*.glob' -o -name '*.aux' -o -name '*.vos' -o -name '*.vok' \) -delete
