from distutils.core import setup
from distutils.extension import Extension
from Cython.Distutils import build_ext

ext_modules = [Extension("osc", ["osc.pyx"], libraries = ["lo"])]

setup(
    name = 'OpenSound Control',
    cmdclass = {'build_ext': build_ext},
    ext_modules = ext_modules
)
