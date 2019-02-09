# Host provisioning

## Enable SSH

- Run 'Manage Optional Features'
- Click 'Add'
- Install 'OpenSSH Server'
- Optionally, configure it to run on boot in 'Services'

## Build `crater`

I couldn't get `rust-openssl` to work, even after installing via `vcpkg` and
setting `OPENSSL_DIR`. I ended up reverting the commit that switched away from `ring`.

## [Setup Docker]

[Setup Docker]: https://docs.microsoft.com/en-us/visualstudio/install/build-tools-container?view=vs-2017

The build number for the Windows container image (e.g. 17134) must match
exactly with host build number: For example, Windows 10 1809 can only run
Windows Server 2019-based images. Run `ver` in powershell to get the build
number. Microsoft has posted the [compatible versions][good-ver] online.

[good-ver]: https://docs.microsoft.com/en-us/virtualization/windowscontainers/deploy-containers/version-compatibility

By default, Docker Desktop will run windows containers, switch by
right-clicking the icon in the dock, or by running:
```powershell
$Env:ProgramFiles\Docker\Docker\DockerCli.exe -SwitchDaemon .
```

I had to edit `~\.docker\config.json` and remove the `"wincred"` field to be
able to authenticate with docker.

### Docker over TLS

Follow [these instructions](https://docs.docker.com/engine/security/https/) or use
[`dockertls`](https://hub.docker.com/r/stefanscherer/dockertls-windows/).

### Hyper-V

Windows containers require Hyper-V, which means a v3 azure image (these have
vcpus). This can be enabled in [the GUI][hyperv] at the command line with:
```powershell
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
```
A reboot is required for this to take effect.

[hyperv]: https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/quick-start/enable-hyper-v#enable-the-hyper-v-role-through-settings

# Container provisioning

## Visual C++ Tools

Rust requires Visual Studio's [Universal CRT, VC++ build tools, and the Windows
SDK](https://github.com/rust-lang/rustup.rs/issues/1003#issuecomment-289809890).
See [here][tools-build] for the recommended install.

Installing all of Visual Studio isn't necessary, so we follow the instructions
[here][min-build] and use `--includeRecommended` to get the Windows SDK as
well.

[min-build]: https://blogs.msdn.microsoft.com/vcblog/2016/11/16/introducing-the-visual-studio-build-tools/
[tools-build]: https://docs.microsoft.com/en-us/visualstudio/install/build-tools-container?view=vs-2017#step-5-create-and-build-the-dockerfile

## vcpkg

Used to install C and C++ libraries.

