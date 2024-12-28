#!/usr/bin/python3

import json
import subprocess
import itertools

def render(parameters, guide_to_render, wide_mode):
    parameters['wide_mode'] = wide_mode
    parameters['guide_to_render']=guide_to_render
    number = 'All' if guide_to_render == -1 else str(guide_to_render)
    filename='generated/' + parameterSet + (' Wide' if wide_mode == 'true' else '') + ' Cutter Guide - ' + number + '.stl'
    cli = ['openscad','-o',filename,'-q']
    for parameter in parameters:
        cli.append('-D')
        cli.append(parameter + '=' + str(parameters[parameter]))
    cli.append('guide.scad')
    print(cli)
    subprocess.run(cli)

with open('guide.json') as json_data:
    data = json.load(json_data)

for parameterSet in data['parameterSets']:
    parameters = data['parameterSets'][parameterSet]
    start = int(parameters['First_cut_designation'])
    end = start + int(parameters['Number_of_cut_depths'])
    for wide_mode in ['true','false']:
        for guide_to_render in itertools.chain(range(start,end),[-1]):
            render(parameters, guide_to_render, wide_mode)
