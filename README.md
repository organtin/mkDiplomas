# mkDiplomas
A tool to make diplomas or letters in batch. 

This tool generates a number of PDF documents based on a template. Tags in the template are substituted with values in a CSV file, which is completely open.

The CSV file must contain a row with the comma separated list of arbitrary tag names, followed by N rows, each of which containing as many fields as tags. The tool reads the template, for each line in the CSV file substitute the tag name with the corresponding values, then compile the modified file using latex and generates a PDF file whose name is composed after the first tag value for each row.

Two examples are provided: a letter and a diploma.

Usage:

`mkDiplomas.pl`

Options:

`mkDiplomas.pl [--verbose] [--template <template name>] [--latex <latex command>] [--csvfile <CSV file>]`
