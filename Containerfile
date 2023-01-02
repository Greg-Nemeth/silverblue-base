ARG FEDORA_MAJOR_VERSION=37

FROM ghcr.io/cgwalters/fedora-silverblue:${FEDORA_MAJOR_VERSION}
# See https://pagure.io/releng/issue/11047 for final location

COPY etc /etc
COPY usr /usr

COPY ublue-firstboot /usr/bin


RUN wget https://copr.fedorainfracloud.org/coprs/lyessaadi/blackbox/repo/fedora-37/lyessaadi-blackbox-fedora-37.repo -O /etc/yum.repos.d/lyessaadi-blackbox.repo

RUN rpm-ostree override remove firefox firefox-langpacks && \
    rpm-ostree install distrobox gnome-tweaks \
    gnome-shell-extension-appindicator yaru-theme \
    gnome-shell-extension-workspace-indicator gnome-shell-extension-auto-move-windows \
    gnome-shell-extension-pop-shell \
    gnome-shell-extension-user-theme \
    gnome-shell-extension-blur-my-shell \
    openssl gnome-shell-extension-gsconnect nautilus-gsconnect blackbox-terminal && \
    gnome-extensions install widget@aylur && gnome-extensions install rounded-window-corners@yilozt \
    horizontal-workspace-indicator@tty2.io && \
    fc-cache -f /usr/share/fonts/ubuntu && \
    sed -i 's/#AutomaticUpdatePolicy.*/AutomaticUpdatePolicy=stage/' /etc/rpm-ostreed.conf && \
    systemctl enable rpm-ostreed-automatic.timer && \
    systemctl enable flatpak-automatic.timer && \
    systemctl unmask dconf-update.service && \
    systemctl enable dconf-update.service && \
    systemctl enable rpm-ostree-countme.service && \
    ostree container commit
