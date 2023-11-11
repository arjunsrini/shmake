<a name="logo"/>
<div align="center">
<a href="https://github.com/arjunsrini/shmake" target="_blank">
<img src="docs/logo/GreenShellMK8.webp" alt="shmake logo" width="210" height="180"></img>
</a>
</div>

<table>
    <!-- Docs -->
    <tr>
        <td>Documentation</td>
        <td>
            <a href="#"><img src='https://img.shields.io/badge/docs-v1-blue.svg'/></a>
        </td>
    </tr>
    <!-- Continuous integration
    To change the badge to point to a different pipeline, it is not sufficient to simply change the `?branch=` part.
    You need to go to the Buildkite website and get the SVG URL for the correct pipeline. -->
<!--     <tr>
        <td>Continuous integration</td>
        <td>
            <a href="#"><img src='https://badge.buildkite.com/f28e0d28b345f9fad5856ce6a8d64fffc7c70df8f4f2685cd8.svg?branch=master'/></a>
        </td>
    </tr> -->
    <!-- Coverage -->
<!--     <tr>
        <td>Code coverage</td>
        <td>
            <a href='https://coveralls.io/github/JuliaLang/julia?branch=master'><img src='https://coveralls.io/repos/github/JuliaLang/julia/badge.svg?branch=master' alt='Coverage Status'/></a>
            <a href="https://codecov.io/gh/JuliaLang/julia"><img src="https://codecov.io/gh/JuliaLang/julia/branch/master/graph/badge.svg?token=TckCRxc7HS"/></a>
        </td>
    </tr> -->
</table>

## shmake

shmake (shell make) is a shell implementation of [`gslab_make`](https://github.com/gslab-econ/gslab_make)

## Dependencies

_Note: This has only been tested on Mac using `zsh`._

* `make`

Optional:

* Stata
* TeX installation

## Installation 

`shmake` should be added to your project as a git submodule.

To do this, either run `install.sh` from the root of your project's repo or follow [this guide](https://git-scm.com/book/en/v2/Git-Tools-Submodules) on git submodules.

## License

See [here](https://github.com/arjunsrini/shmake/blob/main/LICENSE.txt).
