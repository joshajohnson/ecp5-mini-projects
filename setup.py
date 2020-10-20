import os
import sys

from setuptools import setup, find_packages

setup(

    # Vitals
    name='ecp5-mini-projects',
    license='BSD',
    url='https://github.com/joshajohnson/ecp5-mini-projects',
    author='Josh Johnson',
    author_email='josh@joshajohnson.com',
    description='ECP5 Mini Projects',

    # Imports / exports / requirements.
    platforms='any',
    packages=find_packages(),
    include_package_data=True,
    python_requires="~=3.8",
    install_requires=['nmigen'],
    setup_requires=['setuptools'],

)
