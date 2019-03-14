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

Execute o playbook conforme usuário/senha ou chave ssh do servidor de destino, no meu caso meu servidor de destino é acessado por chave.

```
ansible-playbook /etc/ansible/roles/letsplay/site.yml -u myuser --private-key=/tmp/keyfile.pem
```

Após concluir o deploy da instância de destino, a aplicação node estará acessível através de um proxy reverso (traefik) na porta 80.

Em nosso docker-compose.yml definimos uma política de deployment e rollback seguro, onde a diretiva update_config e rollback_config irá fazer o rollback da imagem caso no deploy da nova imagem o healthcheck não esteja retornando corretamente.

Também configuramos um scaling da aplicação node com base na quantidade de nucleos de processadores da máquina destino.

A monitoração do processo node e do proxy reverso é feita através da diretiva restart_policy.on-failure no docker-compose de cada aplicação, dessa forma quando o healtheck não retornar OK, o container irá ser reiniciado automaticamente.

