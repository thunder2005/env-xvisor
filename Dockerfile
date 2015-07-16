#
# This file is part of Xvisor Build Environment.
# Copyright (C) 2015 Institut de Recherche Technologique SystemX
# Copyright (C) 2015 OpenWide
# All rights reserved.
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this Xvisor Build Environment. If not, see
# <http://www.gnu.org/licenses/>.
#
# @file Dockerfile
#

FROM ubuntu:trusty

RUN apt-get update
RUN apt-get install -y git make wget python bc
RUN apt-get install -y realpath fakeroot libtool telnet genext2fs build-essential libncurses5-dev pkg-config libusb-1.0-0-dev gcc-multilib binutils-multiarch 

RUN echo 'cd /root/env-xvisor && ./configure -n && make xvisor-uimage' > /root/make_xvisor_uimage.sh

RUN chmod +x /root/make_xvisor_uimage.sh

