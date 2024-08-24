#!/usr/bin/env python3

"""
Overview:
The script takes command-line arguments such as quit, print, delete, and substitute combined using semicolons or new lines and uses a feature of sed on them.

Operations:
Quit q: Exits the input after a certain line number or a matching pattern
Print p: Prints specified lines based based off line number or a pattern. Multiple lines can also be printed.
Delete d: Deletes lines from the output.
Substitute s: Replaces text in the input according to a regex pattern using optional flags.

Input and Output:
Input is taken from stdin, allowing the script to be use pipelines and output is printed to stdout.
"""
import argparse
import re
import sys

def quit(command, lines):
    # Extracts address and evaluates each line to find when to stop
    address = command[:-1]
    total_lines = len(lines)
    for i, line in enumerate(lines):
        print(line, end='')
        if matching(address, line, i + 1, total_lines, lines):
            break  # Stops after finding the first matching line

def printing(command, lines, print_lines):
    # Processes the print command and prints specific lines
    address = command[:-1] if command != 'p' else None
    duplicate_every_line = command == 'p'
    total_lines = len(lines)
    for i, line in enumerate(lines):
        if duplicate_every_line or print_lines:
            print(line, end='')
        if duplicate_every_line or (address and matching(address, line, i + 1, total_lines, lines)):
            print(line, end='')
            
def subbing(command, lines):
    # Substitutes regex patterns
    address = None
    if command[0].isdigit() or command[0] == '/':
        address_end_idx = command.find('s')
        address = command[:address_end_idx] if address_end_idx != -1 else None
        command = command[address_end_idx:] if address_end_idx != -1 else command
    delimiter = command[1]
    parts = command.split(delimiter)
    if len(parts) < 4:
        print(f"eddy: command line: invalid command")
        sys.exit(1)
    pattern = parts[1]
    replacement = parts[2]
    flags = parts[3] if len(parts) > 3 else ''
    updated_lines = []
    total_lines = len(lines)
    for i, line in enumerate(lines):
        apply_substitution = True if not address else matching(address, line, i + 1, total_lines, lines)
        if apply_substitution:
            line = re.sub(pattern, replacement, line, 0 if 'g' in flags else 1)
        updated_lines.append(line)
    return updated_lines

def address_str(address, lines):
    # Makes address into a line number
    if address.isdigit():
        return int(address)
    if address == '$':
        return len(lines)
    if address.startswith('/') and address.endswith('/'):
        regex = re.compile(address[1:-1])
        for i, line in enumerate(lines):
            if regex.search(line):
                return i + 1
    print("Test for unsupported addresses")
    sys.exit(1)

def matching(address, line, line_number, total_lines, lines):
    # Checks a line matches an address
    if ',' in address:
        start_address, end_address = address.split(',', 1)
        start_resolved = address_str(start_address, lines)
        end_resolved = address_str(end_address, lines)
        return start_resolved <= line_number <= end_resolved
    if address.isdigit():
        return int(address) == line_number
    if address == '$':
        return line_number == total_lines
    if address.startswith('/') and address.endswith('/'):
        return re.search(address[1:-1], line)
    return False

def splitting(command_string):
    # Splits string into into semicolons, bars and newlines
    return [cmd.strip() for cmd in re.split(r';|\n', command_string) if cmd.strip()]

def processing(commands, lines, print_lines):
    # Processes commands
    for cmd in commands:
        if cmd.endswith('q'):
            quit(cmd, lines)
            break
        elif cmd.endswith('d'):
            lines = delete_process(cmd, lines)
        elif cmd.endswith('p'):
            printing(cmd, lines, print_lines)
        elif 's' in cmd:
            lines = subbing(cmd, lines)
    return lines

def delete_process(command, lines):
    # Deletes lines based off the address
    if command == 'd':
        return []
    address = command[:-1]
    total_lines = len(lines)
    should_delete = [False] * total_lines
    for i, line in enumerate(lines):
        if matching(address, line, i + 1, total_lines, lines):
            if ',' in address:
                start, end = address.split(',', 1)
                start_index = address_str(start, lines) - 1
                end_index = address_str(end, lines)
                for j in range(start_index, min(end_index, total_lines)):
                    should_delete[j] = True
            else:
                should_delete[i] = True
    return [line for i, line in enumerate(lines) if not should_delete[i]]

def main():
    # Executes eddy commands
    parser = argparse.ArgumentParser(description='Eddy: A simplified sed-like text processor for Subset 0')
    parser.add_argument('-n', action='store_true', help='Suppress automatic printing of input lines')
    parser.add_argument('command', type=str, help='Single Eddy command to process')
    args = parser.parse_args()
    input_lines = list(sys.stdin)
    if args.command.endswith('q'):
        quit(args.command, input_lines)
    elif args.command.endswith('d'):
        input_lines = delete_process(args.command, input_lines)
        if not args.n:
            for line in input_lines:
                print(line, end='')
    elif args.command.endswith('p'):
        printing(args.command, input_lines, not args.n)
    elif 's' in args.command:
        input_lines = subbing(args.command, input_lines)
        if not args.n:
            for line in input_lines:
                print(line, end='')

if __name__ == '__main__':
    main()