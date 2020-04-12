RUN cat /pacman.conf >> /etc/pacman.conf

# setup keyring
RUN rm -rf /etc/pacman.d/gnupg
RUN pacman-key --init
RUN pacman-key --populate archlinux
RUN pacman -Sy --noconfirm archlinux-keyring archlinuxcn-keyring

# reinstall packages to restore all its files
RUN pacman -Sy --noconfirm pacman pacman-contrib
RUN pacman -Sy --noconfirm man-db man-pages
RUN pacman -Qqn | pacman -S --noconfirm  -
RUN pacman -Sy --noconfirm base base-devel linux linux-firmware

# install packages
USER user
RUN yaourt -Sy --noconfirm zasdfgbnmsystem-basic




