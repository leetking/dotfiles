import platform
import os, re
import subprocess
from operator import add
from functools import reduce
from distutils.sysconfig import get_python_inc

import ycm_core

HEADER_EXTENSIONS = ['.h', '.hh', 'hpp', 'hxx']
C_SOURCE_EXTENSIONS = ['.c', ]
CPP_SOURCE_EXTENSIONS = ['.cc', '.cpp', '.cxx', '.C', '.m', '.mm' ]

def pkg_config(pkg):
    try:
        output = subprocess.check_output(['pkg-config', '--cflags', pkg], universal_newlines=True)
    except:
        return []
    return output.split()

def gcc_version():
    output = subprocess.check_output(['gcc', '--version']).decode()
    version = re.search(r'\d\.\d\.\d', output).group(0)
    return version

PKGS = ('sdl2', 'SDL2_image', 'SDL2_mixer', 'gtk+-3.0', 'gtkmm-3.0',)
#kernel_version = subprocess.check_output(['uname', '-r'], universal_newlines=True).strip()

flags = [
    '-Wall',
    '-Wno-unused',
    '-Wno-format-truncation',
    '-Wformat',
    '-fexceptions',
    '-DDEBUG',

    '-I./',
    '-I/usr/include/',
]
flags += reduce(add, [pkg_config(pkg) for pkg in PKGS], [])

c_flags = flags + [
    '-x', 'c',
]

cpp_flags = flags + [
    '-I/usr/include/c++/'+gcc_version(),
    '-x', 'c++',
    '-std=c++11',
]


compilation_database_folder = ''

if os.path.exists(compilation_database_folder):
    database = ycm_core.CompilationDatabase(compilation_database_folder)
else:
    database = None


def is_header_file(filename):
    extension = os.path.splitext(filename)[1]
    return extension in HEADER_EXTENSIONS


def is_cfile(filename):
    extension = os.path.splitext(filename)[1]
    return extension in C_SOURCE_EXTENSIONS


def is_cppfile(filename):
    extension = os.path.splitext(filename)[1]
    return extension in CPP_SOURCE_EXTENSIONS


def generate_specificial_settings(filename):
    basename = os.path.splitext(filename)[0]
    settings = {
            'flags': flags,
            #include_paths_relative_to_dir': os.path.abspath(os.path.dirname(filename)),
            'override_filename': filename,
            }

    if is_cfile(filename) and os.path.exists(filename):
        settings['flags'] = c_flags
        return settings

    if is_cppfile(filename) and os.path.exists(filename):
        settings['flags'] = cpp_flags
        return settings

    if is_header_file(filename):
        for extension in C_SOURCE_EXTENSIONS:
            replacement_file = basename + extension
            if os.path.exists(replacement_file):
                settings['flags'] = c_flags
                settings['override_filename'] = replacement_file
                return settings
        for extension in CPP_SOURCE_EXTENSIONS:
            replacement_file = basename + extension
            if os.path.exists(replacement_file):
                settings['flags'] = cpp_flags
                settings['override_filename'] = replacement_file
                return settings
    return {}

# entry function
def Settings( **kwargs ):
    if kwargs[ 'language' ] != 'cfamily':
        return {}

    settings = generate_specificial_settings(kwargs['filename'])

    if not database:
        return settings

    # generate settings from compile_commands.json file
    compilation_info = database.GetCompilationInfoForFile(filename)
    if not compilation_info.compiler_flags_:
        return {}

    final_flags = list(compilation_info.compiler_flags_)

    return {
        'flags': final_flags,
        'include_paths_relative_to_dir': compilation_info.compiler_working_dir_,
        'override_filename': filename,
    }

# old fanshion
def FlagsForFile(filename, **kwargs):
    kwargs['filename'] = filename
    kwargs['language'] = 'cfamily'
    kwargs['do_cache'] = True
    return Settings(**kwargs)
