#!/usr/bin/env python3
"""Fallback source checks; NOT a substitute for flutter analyze/test.

Install optional tooling: pip install tree-sitter tree-sitter-dart pyyaml
"""
from pathlib import Path
import json
import plistlib
import re
import sys
import xml.etree.ElementTree as ET

import tree_sitter_dart
from tree_sitter import Language, Parser
import yaml

ROOT = Path(__file__).resolve().parents[1]
parser = Parser(Language(tree_sitter_dart.language()))
errors = []
files = list((ROOT / 'lib').rglob('*.dart')) + list((ROOT / 'test').rglob('*.dart'))
for path in files:
    source = path.read_bytes()
    tree = parser.parse(source)
    if tree.root_node.has_error:
        def visit(node):
            if node.type == 'ERROR' or node.is_missing:
                errors.append(f'{path.relative_to(ROOT)}:{node.start_point.row + 1}: syntax {node.type}')
            for child in node.children:
                visit(child)
        visit(tree.root_node)
    for directive, target in re.findall(r"\b(import|export|part)\s+'([^']+)'", source.decode()):
        if target.startswith('dart:'):
            continue
        if target.startswith('package:punto_plus_app/'):
            resolved = ROOT / 'lib' / target.split('/', 1)[1]
        elif target.startswith('package:'):
            continue
        else:
            resolved = path.parent / target
        if target.endswith(('.g.dart', '.freezed.dart')):
            continue  # build_runner output
        if not resolved.exists():
            errors.append(f'{path}: missing {directive} {target}')

for path in list((ROOT / 'assets').rglob('*.json')):
    json.loads(path.read_text())
for path in list((ROOT / 'ios').rglob('*.plist')):
    plistlib.loads(path.read_bytes())
for path in list((ROOT / 'android').rglob('*.xml')) + list((ROOT / 'assets').rglob('*.svg')) + list((ROOT / 'ios').rglob('*.xcscheme')):
    ET.parse(path)
for path in [ROOT / 'pubspec.yaml', ROOT / 'analysis_options.yaml', ROOT / '.github/workflows/ci.yml']:
    yaml.safe_load(path.read_text())

if errors:
    print('\n'.join(errors))
    sys.exit(1)
print(f'OK: parsed {len(files)} Dart files; checked local imports, JSON, XML, plist and YAML.')
print('Flutter SDK analysis, dependency resolution, codegen and device tests still required.')
