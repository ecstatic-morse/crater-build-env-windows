**A Windows build environment for rust crates.**

This repo describes a Windows container with all the prerequisites for running
`rustc`.

The host must be a Windows system with containerization and Hyper-V enabled
(Windows 10 Pro or Windows Server >=2016) and have build number [equal to
that of the image][build] (presently `mcr.microsoft.com/windows/servercore:1803`).  See
`NOTES.md` for more details.

[build]: https://docs.microsoft.com/en-us/virtualization/windowscontainers/deploy-containers/version-compatibility
