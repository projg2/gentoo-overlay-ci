FROM gentoo/stage3-amd64-nomultilib

ENV LANG=C.UTF-8
RUN echo '*/* ~amd64' >> /etc/portage/package.accept_keywords \
 && echo '*/* PYTHON_TARGETS: -python2_7' >> /etc/portage/package.use/python \
 && printf 'dev-vcs/git -perl\ndev-util/pkgcheck perl' >> /etc/portage/package.use/stuffs \
 && echo 'FEATURES="-usersync"' >> /etc/portage/make.conf \
 && wget --progress=dot:mega -O - https://github.com/gentoo-mirror/gentoo/archive/master.tar.gz | tar -xz \
 && mv gentoo-master /var/db/repos/gentoo \
 && printf '[gentoo]\nlocation = /var/db/repos/gentoo\n' > /etc/portage/repos.conf \
 && emerge -1vnt --jobs app-eselect/eselect-repository dev-util/pkgcheck dev-vcs/git

CMD eselect repository enable ${REPO} \
 && pmaint sync ${REPO} \
 && pkgcheck scan -r ${REPO}
