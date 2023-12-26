# REAL ESRGAN GUI

A GUI for [REAL ESRGAN](https://github.com/xinntao/Real-ESRGAN)

## Currently Supported Platfrom

- Windows

## Before starting...

### `./bin` Directory

Download the [REAL ESRGAN Portable Executable](https://github.com/xinntao/Real-ESRGAN/releases/download/v0.2.5.0/realesrgan-ncnn-vulkan-20220424-windows.zip), extract it and place the files inside the directory. Your `./bin` directory should looks like:

```
│  .gitkeep
│  realesrgan-ncnn-vulkan.exe
│  vcomp140.dll
│  vcomp140d.dll
│
└─models
        realesr-animevideov3-x2.bin
        realesr-animevideov3-x2.param
        realesr-animevideov3-x3.bin
        realesr-animevideov3-x3.param
        realesr-animevideov3-x4.bin
        realesr-animevideov3-x4.param
        realesrgan-x4plus-anime.bin
        realesrgan-x4plus-anime.param
        realesrgan-x4plus.bin
        realesrgan-x4plus.para
```

## How to build a release

Windows with Powershell:

```powershell
./release.ps1
```
