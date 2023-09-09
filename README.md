Репозиторий по автоматизации с помощью Ansible, отечественных решений инфраструктуры.!!!

Для РедОС:

Предварительно на хостах и управляемом сервере необходимо выполнить следующие действия:

1) Установить необходимые пакеты:
   ``````
   #yum update -y; yum install -y sshd ansible python3
 
   ``````

2) Создать пользователя и добавить в группу wheel (sudo), выполнив команду:
   ``````
   #useradd deployer; passwd deployer; usermod -aG wheel deployer

   ``````

3) Настроить SSH аутентификацию по ключам, выполнив команды и приведя файл к виду:
    ``````
    # nano /etc/ssh/sshd_config

    PubkeyAuthentication yes
    AuthorizedKeysFile .ssh/authorized_keys

    # systemctl restart sshd
    ``````

4) Сгенерируйте RSA ключи на управляющем сервере, и отправить на управляемые хосты:
    ``````
    # ssh-keygen -t rsa
    # ssh-copy-id deployer@<ip_v4>
    ``````
