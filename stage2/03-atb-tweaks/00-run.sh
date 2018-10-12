#!/bin/bash -e


install -v files/atb-service.jar 	"${ROOTFS_DIR}/usr/bin"
install -v -m 744 files/atb 		"${ROOTFS_DIR}/usr/bin"
install -v -m 664 files/atb.service 	"${ROOTFS_DIR}/lib/systemd/system/"
install -v files/001-atb.conf 		"${ROOTFS_DIR}/etc/apache2/sites-available"
install -v -d -m 755			"${ROOTFS_DIR}/var/www/atb"
cp -r files/build/* 			"${ROOTFS_DIR}/var/www/atb"

sed -i "s/Listen 80/Listen 5001/g" 	"${ROOTFS_DIR}/etc/apache2/ports.conf"

on_chroot << EOF
a2enmod rewrite
a2ensite 001-atb.conf
a2dissite 000-default.conf
systemctl enable atb
EOF

