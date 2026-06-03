# Buildroot source to build smol images, targeting cloud providers

Modified from the QEMU defconfigs. Main usecase I have for this is to make best use of the lowest tier VMs on [TierHive](tierhive.com) (128 MB of RAM, 1GB of storage)

As-is, this will build an OS image that is about 20MB in size and when booted, consumes ~9 MB of RAM.

# 30s how to

1. Go to https://buildroot.org/download.html, grab the latest or stable release, your choice
2. Untar the buildroot archive
3. Clone this repository next to it
4. `cd buildroot*`
5. Run `BR2_EXTERNAL=../tierhive-buildroot make tierhive_defconfig`
6. (Optional) make menuconfig and make linux-menuconfig. Add the applications and kernel modules, as well as update settings like rootfs sizes as you need here
7. Run `make`
8. Check output/images for the result. Profit.

As it is, you should be able to take `bzImage` and `rootfs.cpio` to iPXE (available with most KVM-based providers) and bootstrap the system:

```
set base https://where-ever-you-re-hosting.example.com
linux ${base}/bzImage console=tty1 console=ttyS0 nomodeset
initrd ${base}/rootfs.cpio
boot
```

Then simply write `disk.img` to your disk and reboot.
