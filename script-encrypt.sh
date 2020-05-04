#!/bin/bash

set -euo pipefail;

## Variables

RECP="$1";
INPUT="$2";
OUTPUT="$3";

## Helpers

error() {
	echo "$@" >&2;
}

encrypt() {
	gpg2 --quiet --debug-level 0 --armor --encrypt --recipient "$RECP" -
}

## Code

# Check for missing arguments
if [ "$#" -lt 1 ]; then
	error "Missing arguments: <key> [<input> [<output>]]";
	exit 2;
fi

# Define input if not given explicit
if [ \( -z "$INPUT" \) -o \( "$INPUT" = "-" \) ]; then
	INPUT="/dev/stdin";
fi

# Write self-decrypting header
cat > "$OUTPUT" <<EOF
#!/bin/bash
tmp="\$(mktemp)"
chmod u=rwx,g=,o= "\$tmp"
<<% gpg2 --quiet --debug-level 0 --decrypt - > "\$tmp"
EOF

# Implement encrypted script
< "$INPUT" encrypt >> "$OUTPUT"

# Write self-decrypting footer
cat >> "$OUTPUT" <<EOF
%
"\$tmp" "\$@"
RET="\$?"
rm "\$tmp"
exit \$RET
EOF

# Mark output file as runable if possible
[ "$OUTPUT" != "/dev/stdout" ] && chmod +x "$OUTPUT";
