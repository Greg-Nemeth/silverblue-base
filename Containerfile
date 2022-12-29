ARG FEDORA_MAJOR_VERSION=37

FROM ghcr.io/cgwalters/fedora-silverblue:${FEDORA_MAJOR_VERSION}
# See https://pagure.io/releng/issue/11047 for final location

COPY etc /etc
COPY usr /usr

COPY ublue-firstboot /usr/bin

# Fix rpm-ostree, see: https://bodhi.fedoraproject.org/updates/FEDORA-2022-4ad713eb82
RUN rpm-ostree override replace https://kojipkgs.fedoraproject.org//packages/rpm-ostree/2022.19/2.fc37/x86_64/rpm-ostree-{libs-,}2022.19-2.fc37.x86_64.rpm

RUN wget https://copr.fedorainfracloud.org/coprs/lyessaadi/blackbox/repo/fedora-37/lyessaadi-blackbox-fedora-37.repo -O /etc/yum.repos.d/lyessaadi-blackbox.repo

RUN rpm-ostree override remove firefox firefox-langpacks && \
    rpm-ostree install distrobox gnome-tweaks \
    gnome-shell-extension-appindicator gnome-shell-extension-dash-to-dock yaru-theme \
    openssl gnome-shell-extension-gsconnect nautilus-gsconnect blackbox-terminal && \
    fc-cache -f /usr/share/fonts/ubuntu && \
    sed -i 's/#AutomaticUpdatePolicy.*/AutomaticUpdatePolicy=stage/' /etc/rpm-ostreed.conf && \
    systemctl enable rpm-ostreed-automatic.timer && \
    systemctl enable flatpak-automatic.timer && \
    systemctl unmask dconf-update.service && \
    systemctl enable dconf-update.service && \
    systemctl enable rpm-ostree-countme.service && \
    ostree container commit
