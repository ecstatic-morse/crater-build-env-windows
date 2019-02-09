# escape=`

FROM mcr.microsoft.com/windows/servercore:1803

# Install the Visual C++ Build tools
# `cmd` is used to easily check %ERRORLEVEL
# https://docs.microsoft.com/en-us/visualstudio/install/build-tools-container?view=vs-2017
# https://blogs.msdn.microsoft.com/vcblog/2016/11/16/introducing-the-visual-studio-build-tools/
SHELL ["cmd", "/S", "/C"]
ADD https://aka.ms/vs/15/release/vs_buildtools.exe C:\TEMP\vs_buildtools.exe
RUN C:\TEMP\vs_buildtools.exe --quiet --wait --norestart --nocache `
    --add "Microsoft.VisualStudio.Workload.VCTools"                `
    --includeRecommended                                           `
    || IF "%ERRORLEVEL%"=="3010" EXIT 0


SHELL ["powershell", "-Command"]

# Install vcpkg
ADD https://github.com/Microsoft/vcpkg/archive/master.zip .\vcpkg-master.zip
RUN Expand-Archive -Path .\vcpkg-master.zip -DestinationPath .;       `
    cd .\vcpkg-master;                                                `
    .\bootstrap-vcpkg.bat;                                            `
    .\vcpkg integrate install

# Install packages
RUN .\vcpkg-master\vcpkg install curl

# Install rustc
# ADD https://win.rustup.rs/x86_64 C:\TEMP\rustup-init.exe
# RUN C:\TEMP\rustup-init.exe -y --default-host=x86_64-pc-windows-msvc

CMD ["powershell.exe", "-NoLogo", "-ExecutionPolicy", "Bypass"]
