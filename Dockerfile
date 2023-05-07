# Use centos7 docker official image from https://hub.docker.com/_/centos
# Note: no longer maintained
FROM centos:7

ENV container docker

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;

VOLUME [ "/sys/fs/cgroup" ]

# Update YUM
RUN yum -y update

# Install kernel headers
RUN yum -y install kernel-headers

# Install Ansible
RUN yum install -y epel-release
RUN yum install -y ansible

# Install net-tools for ifconfig command
RUN yum install -y net-tools

# Install iproute for ip command
RUN yum -y install iproute

# Install initscripts for /sbin/service command
RUN yum -y install initscripts

# Tools required by Stepup deploy scripts
RUN yum -y install bzip2

# Set keepcache=1 in /etc/yum.conf
RUN sed -i 's/keepcache=0/keepcache=1/g' /etc/yum.conf
# Exclude kernel packages from update in /etc/yum.conf
RUN sed -i 's/\]$/\]\nexclude=kernel\*/g' /etc/yum.conf

# Start systemd
CMD ["/usr/sbin/init"]