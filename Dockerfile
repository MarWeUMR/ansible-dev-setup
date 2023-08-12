
# Use the official image as a parent image
FROM ubuntu:latest

# Update the system
RUN apt-get update && apt-get upgrade -y

# Install OpenSSH Server
RUN apt-get install -y openssh-server sudo

# Set up configuration for SSH
RUN mkdir /var/run/sshd
RUN echo "root:root" | chpasswd
RUN sed -i 's/#\?PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise, user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile


# Create a new user 'myuser' and add it to the 'sudo' group
RUN useradd -m marwe && echo "marwe:root" | chpasswd && adduser marwe sudo

# Allow 'myuser' to run sudo commands without a password prompt
RUN echo 'marwe ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers


# Expose the SSH port
EXPOSE 22


# Run SSH
CMD ["/usr/sbin/sshd", "-D"]

