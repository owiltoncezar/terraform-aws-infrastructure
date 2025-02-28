# 🚀 Projeto Terraform para Infraestrutura na AWS

Este projeto utiliza o **Terraform** para provisionar e gerenciar recursos na **AWS**. Ele inclui módulos para configurar um backend local ou remoto usando **S3** e **DynamoDB**, criar uma chave **SSH** e provisionar uma instância **EC2**. 

A instância EC2 será provisionada com **Docker**, **Kubectl**, **Kind** e **Helm** pré-instalados. Além disso, um cluster Kubernetes será criado automaticamente usando o Kind, com o nome 'asatech'. Nesse cluster, será realizado o deploy de um Nginx básico, mas ele poderá receber outros deploys de aplicações conforme necessário."

---

## 📦 Módulos Utilizados

| 🏷 Nome | 📂 Fonte |
|---------|----------|
| 🔹 [s3_backend](#module_s3_backend) | `./backend/s3` |
| 🔹 [dynamodb_backend](#module_dynamodb_backend) | `./backend/dynamodb` |
| 🔹 [key-par](#module_key-par) | `./infrastructure/key-par` |
| 🔹 [ec2_instance](#module_ec2_instance) | `./infrastructure/ec2` |

### 📝 Descrição dos Módulos

#### 📌 `s3_backend`
🔹 Cria um **bucket S3** para armazenar o estado do Terraform.

**Parâmetros:**
- `profile`: Perfil AWS.
- `region`: Região AWS.
- `bucket_name`: Nome do bucket.
- `state_key`: Caminho do arquivo de estado.
- `managed_by`: Ferramente que criouou gerencia o recurso.
- `account_id`: ID da conta AWS.

#### 📌 `dynamodb_backend`
🔹 Cria uma **tabela DynamoDB** para lock do estado.

**Parâmetros:**
- `profile`: Perfil AWS.
- `region`: Região AWS.
- `dynamodb_table_name`: Nome da tabela.
- `managed_by`: Ferramente que criouou gerencia o recurso.

#### 📌 `key-par`
🔹 Cria uma **chave SSH** para acessar a instância EC2.

**Parâmetros:**
- `profile`: Perfil AWS.
- `region`: Região AWS.
- `name`: Nome da chave SSH.
- `public_key`: Chave pública SSH.
- `managed_by`: Ferramente que criouou gerencia o recurso.

#### 📌 `ec2_instance`
🔹 Provisiona uma **instância EC2**.

**Parâmetros:**
- `name`: Nome da instância.
- `profile`: Perfil AWS.
- `region`: Região AWS.
- `managed_by`: Ferramente que criouou gerencia o recurso.
- `ami`: ID da AMI.
- `instance_type`: Tipo da instância.
- `key_name`: Nome da chave SSH.
- `disable_api_termination`:Quando habilitado protege contra remoção acidental da instância.
- `volume_type`: Tipo do disco Ebs.
- `volume_size`: Tamanho do disco Ebs.
- `delete_on_termination`: Define se o disco será deletado junto com a instância.

---
## 📌 Como Usar
### Clone o Repositório
```bash
git clone https://github.com/owiltoncezar/terraform-configs-poc.gitt
cd "pasta-onde-clonou"
```

### Configuração do Backend
Se você ainda não possui um bucket S3 e uma tabela DynamoDB para armazenar os estados do Terraform, siga os passos abaixo:

1️⃣ Acesse a pasta backend edite o arquivo main.tf conforme suas preferências.
```hcl
module "s3_backend" {
  source      = "./s3"
  profile     = "nome-do-profile-configurado-para-o-awscli"
  region      = "regiao-que-deseja-criar-o-recurso"
  bucket_name = "nome-do-bucket-para-armazenar-os-states-do-terraform"
  state_key   = "terraform/state.tfstate"
  managed_by  = "Terraform"
  account_id  = "id da conta da aws"
}

module "dynamodb_backend" {
  source              = "./dynamodb"
  profile             = "nome-do-profile-configurado-para-o-awscli"
  region              = "regiao-que-deseja-criar-o-recurso"
  dynamodb_table_name = "nome-da-tabela-para-armazenar-os-states-lock"
  managed_by          = "Terraform"
}
```

2️⃣ Execute os comandos abaixo para criar o bucket S3 e a tabela DynamoDB necessários:
```bash
terraform init
terraform apply
```
Isso criará o bucket S3 e a tabela DynamoDB com os nomes especificados nos módulos s3_backend e dynamodb_backend.

3️⃣ Atualize o backend para usar os recursos remotos
Após a criação do bucket S3 e da tabela DynamoDB, acesse a pasta infrastructure e atualize o arquivo backend_remote_config.tf com os valores reais dos recursos criados:
```hcl
terraform {
  backend "s3" {
    bucket         = "nome-do-bucket-criado"
    region         = "us-east-1"
    key            = "terraform/state.tfstate"
    dynamodb_table = "nome-da-tabela-criada"
    encrypt        = true
  }
}
```
4️⃣ Migre o estado para o backend remoto. 
Execute o comando abaixo para migrar o estado do backend local para o backend remoto:
```bash
terraform init -migrate-state
```
Agora o Terraform usa o backend no S3 com lock no DynamoDB.  

ℹ️ **Nota:** Caso já tenha um bucket S3 e uma tabela DynamoDB criados, basta atualizar o arquivo backend_remote_config.tf e executar um comando ```terraform init```.


### Configuração do Infrastructure
Para criar o Key-par e a instância EC2, siga os passos abaixo:

1️⃣ Acesse a pasta infrastructure edite o arquivo main.tf conforme suas preferências.
```hcl
module "key-par" {
  source     = "./key-par"
  profile    = "nome-do-profile-configurado-para-o-awscli"
  region     = "regiao-que-deseja-criar-o-recurso"
  name       = "nome-da-chave-key-par"
  public_key = "chave-publica"
  managed_by = "Terraform"
}

module "ec2_instance" {
  source                  = "./ec2"
  name                    = "nome-da-instancia"
  profile                 = "nome-do-profile-configurado-para-o-awscli"
  region                  = "regiao-que-deseja-criar-o-recurso"
  managed_by              = "Terraform"
  ami                     = "id-da-imagem"
  instance_type           = "tipo-da-instância"
  key_name                = module.key-par.key
  disable_api_termination = "true ou false, para proteger contra remoção acidental da instância"
  volume_type             = "tipo-do-ebs"
  volume_size             = "tamanho-do-ebs"
  delete_on_termination   = "true ou false, para que o disco seja deletado junto com a instância"
}
```
2️⃣ Execute os comandos abaixo para criar a Key-Par e a instância EC2:
```bash
terraform apply
```
## ⚠️ Atenção
Os comandos do Kind devem ser utilizado com o `sudo`, como por exemplo:
```bash
sudo kind get clusters
```
⏳ O script leva de 4 a 8 minutos para instalar todas as ferramentas e criar o cluster no Kind, então caso acesse o sevidor e receba erros como os mostrados abaixo, é porque o cluster ainda não foi criado totalmente:

```hcl
$ kubectl get nodes
E0228 02:54:38.722630   15574 memcache.go:265] "Unhandled Error" err="couldn't get current server API group list: Get \"http://localhost:8080/api?timeout=32s\": dial tcp 127.0.0.1:8080: connect: connection refused"
E0228 02:54:38.724144   15574 memcache.go:265] "Unhandled Error" err="couldn't get current server API group list: Get \"http://localhost:8080/api?timeout=32s\": dial tcp 127.0.0.1:8080: connect: connection refused"
E0228 02:54:38.725508   15574 memcache.go:265] "Unhandled Error" err="couldn't get current server API group list: Get \"http://localhost:8080/api?timeout=32s\": dial tcp 127.0.0.1:8080: connect: connection refused"
E0228 02:54:38.727079   15574 memcache.go:265] "Unhandled Error" err="couldn't get current server API group list: Get \"http://localhost:8080/api?timeout=32s\": dial tcp 127.0.0.1:8080: connect: connection refused"
E0228 02:54:38.728503   15574 memcache.go:265] "Unhandled Error" err="couldn't get current server API group list: Get \"http://localhost:8080/api?timeout=32s\": dial tcp 127.0.0.1:8080: connect: connection refused"
The connection to the server localhost:8080 was refused - did you specify the right host or port?
```
```hcl
$ sudo kind get clusters
No kind clusters found.
```

## 🔧 Configuração Extras

### Script

Exsite um arquivo chamado template_file.tf na pasta `infrastructure/ec2` que possui um script bash que faz a instalção das ferramente Docker, Kubectl, Kind, Helm e faz o deploy de uma aplicação simples do Nginx do respositório `https://owiltoncezar.github.io/generic-app/`. Ele está configurado com comandos para o Ubuntu. Caso utilize outro S.O., será necessário ajustá-lo.

Para testar esse deploy é necessário acessar a instância via ssh e rodar os comandos:

Para verificar se o pod está rodando:
```bash
kubectl get pods -n nginx
```

Redirecionar a porta para acesso externo:
```bash
kubectl port-forward -n nginx --address 0.0.0.0 svc/nginx-service 8080:80
```

Após a execução do comando basta colocar no navegador o Ip publico da instância direcionando para a porta 8080:
```bash
http://<IP_publico_da_instância>:8080
```
ℹ️ **Nota:** Caso prefira instalar manualmente ou alterar algum valor do helm, basta comentar ou remover as linhas abaixo do script:
```bash
helm repo add generic-app https://owiltoncezar.github.io/generic-app/
helm repo update
helm install nginx generic-app/generic-app --namespace nginx --create-namespace
```
Instale o Git (o ubuntu já vem com o git instalado).

Siga os passo desse procedimento - [Instalar Helm a partir de uma pasta local](https://github.com/owiltoncezar/generic-app?tab=readme-ov-file#instalar-a-partir-de-uma-pasta-local)

Verificar se o pod está rodando:
```bash
kubectl get pods -n "nome-do-seu-namespace"
```

Redirecionar a porta para acesso externo:
```bash
kubectl port-forward -n "nome-do-seu-namespace" --address 0.0.0.0 svc/"nome-do-seu-service" 8080:80
```

Após a execução do comando o endereço:
```bash
http://<IP_publico_da_instância>:8080
```

Para desinstalar executar os comandos:
```bash
helm uninstall "nome-do-seu-app" --namespace "nome-do-namespace"
```
```bash
kubectl delete namespace "nome-do-namespace"
```

### 🔑 Par de Chaves SSH

Caso você não tenha um par de chave ssh, execute o seguinte comando no terminal para gerar um par de chaves SSH:

```bash
ssh-keygen -t rsa -b 4096 -C "seu-email@exemplo.com" -f ~/.ssh/asatech_key
```
-t rsa: Define o tipo de chave como RSA.  
-b 4096: Define o tamanho da chave como 4096 bits (recomendado para maior segurança).  
-C "seu-email@exemplo.com": Adiciona um comentário à chave (geralmente um e-mail ou identificador).  
-f ~/.ssh/asatech_key: Define o local e o nome do arquivo da chave (neste caso, asatech_key).

**Proteger a Chave Privada**.

Durante a criação, você será solicitado a definir uma senha (passphrase) para proteger a chave privada. Isso adiciona uma camada extra de segurança, porém não é obrigatória mas recomendado.

**Após a execução do comando, duas chaves serão geradas:**

 - Chave Pública: ~/.ssh/asatech_key.pub
 - Chave Privada: ~/.ssh/asatech_key

Você pode visualizar o conteúdo da chave pública com o comando:

```bash
cat ~/.ssh/asatech_key.pub
```
O valor que o comando retornar deve ser informado no Terraform (public_key).