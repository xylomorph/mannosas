.PHONY: all html pdf clean preview help

# Default target: render both HTML and PDF
all: pdf docx html

# Render HTML output (landing_page.qmd → index.qmd)
html:
	@echo "Rendering HTML output..."
	quarto render source --profile html --to html

# Render PDF output (einleitung.qmd → index.qmd)
# Use temporary output directory to avoid cleaning docs/ (in case they contain freshly generated html output), then move PDF
pdf:
	@echo "Rendering PDF output..."
	@mkdir -p .tmp-pdf
	quarto render source --profile pdf --to pdf --output-dir ../.tmp-pdf
	@mv .tmp-pdf/*.pdf docs/
	@rm -rf .tmp-pdf

docx:
	@echo "Rendering DOCX output..."
	@mkdir -p .tmp-docx
	quarto render source --profile pdf --to docx --output-dir ../.tmp-docx
	@mv .tmp-docx/*.docx docs/
	@rm -rf .tmp-docx:


# Start live preview server (HTML only)
preview:
	@echo "Starting preview server..."
	quarto preview source --profile html

# Clean generated output
clean:
	@echo "Cleaning output directory..."
	rm -rf docs/*
	rm -rf .quarto

# Show available targets
help:
	@echo "Available targets:"
	@echo "  make         - Render both HTML and PDF (default)"
	@echo "  make all     - Render both HTML and PDF"
	@echo "  make html    - Render HTML output only"
	@echo "  make pdf     - Render PDF output only"
	@echo "  make preview - Start live preview server (HTML)"
	@echo "  make clean   - Remove generated output"
	@echo "  make help    - Show this help message"
