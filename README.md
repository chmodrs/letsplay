# letsplay

**Deploy do ambiente utilizando o gerenciador de configuração Ansible na versão 2.7.8 em Sistema Operacional CENTOS 7.**

Nesse howto, vamos definir que você já está com o ansible instalado seu diretório padrão das roles fica em /etc/ansible/roles

Faça o clone do repositório

```
git clone https://github.com/chmodrs/letsplay.git
```

Acesse o diretório e copie a pasta ansible/roles/letsplay para a pasta roles da sua máquina

```
cp -rp ansible/roles/letsplay /etc/ansible/roles/
```

Defina o servidor de destino onde sera aplicada a role "letsplay" e altere o IP 192.168.0.5 para o ip da sua instância de destino

```
cat << EOF >> /etc/ansible/hosts
[host]
192.168.0.5
EOF
```


