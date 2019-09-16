#!/usr/bin/env python
from setuptools import setup, find_packages


setup(
    name="katsdpcam2telstate",
    description="MeerKAT sensor capture",
    author="MeerKAT SDP team",
    author_email="sdpdev@ska.ac.za",
    packages=find_packages(),
    scripts=['scripts/cam2telstate.py'],
    setup_requires=['katversion'],
    install_requires=[
        'numpy',
        'aiokatcp',
        'aiomonitor',
        'katsdpservices[argparse,aiomonitor]',
        'katsdptelstate',
        'katportalclient',
        # Tornado is not used directly, but katportalclient uses it and we need
        # 5.0+ to get seamless asyncio integration.
        'tornado>=5.0',
    ],
    python_requires='>=3.6',
    use_katversion=True
)
