#!/usr/bin/env python3
import argparse
import sys
try:
    from PyPDF2 import PdfReader, PdfWriter
except ImportError:
    from pyPdf import PdfFileReader, PdfFileWriter

def pdf_cat(input_files, output_filename):
    input_streams = []
    try:
        for input_file in input_files:
            input_streams.append(open(input_file, 'rb'))
        writer = PdfWriter()
        for reader in map(PdfReader, input_streams):
            for n in range(len(reader.pages)):
                writer.add_page(reader.pages[n])
        with open(output_filename, 'wb') as output_stream:
            writer.write(output_stream)
    finally:
        for f in input_streams:
            f.close()

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Concatenate PDF files.')
    parser.add_argument('-o', '--output', help='Output filename', required=True)
    parser.add_argument('input_files', nargs='+', help='Input files')
    args = parser.parse_args()

    pdf_cat(args.input_files, args.output)
