# letsplay

**Deploy do ambiente utilizando o gerenciador de configuração Ansible na versão 2.7.8 em Sistema Operacional CENTOS 7.**

Nesse howto, vamos levar em consideração que você já está com o ansible instalado seu diretório padrão das roles fica em /etc/ansible/roles

Faça o clone do repositório em /opt (caso salve em outro diretório, alterar a variável DIR em buildimage.sh)

```
git clone https://github.com/chmodrs/letsplay.git /opt/letsplay/
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

Para validar o rollback, vamos testá-lo conforme abaixo:

```
# docker build -t nodeapp:v2 -f DockerfileRollback .
Sending build context to Docker daemon  11.99MB
Step 1/5 : FROM node:10.15-slim
 ---> 94f5c7b8aa6a
Step 2/5 : WORKDIR /app
 ---> Using cache
 ---> 0f54f59c559d
Step 3/5 : COPY server.js /app
 ---> Using cache
 ---> a5027f7e65ee
Step 4/5 : CMD node server.js
 ---> Using cache
 ---> a69c5ffafe51
Step 5/5 : EXPOSE 3000
 ---> Using cache
 ---> 4f4b77b113cb
Successfully built 4f4b77b113cb
Successfully tagged nodeapp:v2
```

E atualizando o serviço

```
# docker service update mystack_nodeapp --image nodeapp:v2

mystack_nodeapp
overall progress: 0 out of 2 tasks 
1/2: starting  [============================================>      ] 
2/2:   
service rolled back: rollback completed
```

E podemos ver que imagem que está rodando permanece a v1

```
# docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE                             PORTS
u7qr8d33bwok        mystack_nodeapp     replicated          2/2                 nodeapp:v1                        *:3000->3000/tcp
```
