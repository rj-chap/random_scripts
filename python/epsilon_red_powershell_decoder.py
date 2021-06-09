# Crude, no-error-checking, hey-it-works Epsilon Red encoded PS script decoder
# Written under macOS via Python 3.8.2 -- may require fiddlin'
# by @rj_chap, 2021.06.09

import sys
import os
import re

# Ensure we have been provided an argument (which is hopefully a dir)
try:
    dir_name=sys.argv[1]
except:
    print('Please provide directory with scripts as argument')
    exit()

script_done_pattern = '^\$a\=\$a\.Replace'	# Pattern indicates the obfuscated script is done

# Loop through files in the provided directory
for file in os.listdir(dir_name):
	# Ignore hidden files and ensure we have an actual file
	if not file.startswith('.') and os.path.isfile(os.path.join(dir_name, file)):
		print('Decoding: ' + file)

		# Setup input & output files
		obf_file = open(os.path.join(dir_name, file), 'r')
		deobf_file = open(os.path.join(dir_name, file) + '-deobfuscated.ps1', 'w')

		obf_code = ''	# ini string

		# Take each line of the obfuscated script until we hit the decoding portion
		for obf_line in obf_file:
			if not re.match(script_done_pattern, obf_line):
				obf_code += obf_line
			else:
				continue

		'''
		$a=$a.Replace('[','');
		$a=$a.Replace(']','');
		$a=$a.Replace('{}{}-{}{}','"');
		$a=$a.Replace('{}{}---{}{}',"'");
		'''
		deobf_code = obf_code.replace('[', '').replace(']', '').replace('{}{}-{}{}', '"').replace('{}{}---{}{}', "'").replace("$a=@'", '').replace("'@", '')

		deobf_file.write(deobf_code)	# Write our output file

		obf_file.close()	# Close the input file
		deobf_file.close()	# Close the output file