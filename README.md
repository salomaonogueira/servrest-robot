## 🤖 Automação com Robot Framework

Este projeto inclui testes automatizados com **Robot Framework + Python + Selenium** para API e UI do ServeRest.

### Estrutura dos Testes

```
servrest/
├── .github/workflows/
│   ├── api-tests.yml       # CI para testes de API
│   ├── ui-tests.yml        # CI para testes de UI (Selenium)
│   └── all-tests.yml       # Workflow orquestrador
├── resources/
│   ├── api/                # Keywords de API (login, usuarios, produtos, carrinhos)
│   └── ui/                 # Keywords de UI (páginas via Selenium)
├── tests/
│   ├── api/                # Testes de API (login, usuarios, produtos, carrinhos)
│   └── ui/                 # Testes de UI (login, cadastro, produtos)
└── requirements.txt
```

### Como executar localmente

```bash
pip install -r requirements.txt

# Testes de API
robot --outputdir results/api tests/api/

# Testes de UI (modo headless)
robot --outputdir results/ui --variable HEADLESS:true tests/ui/

# Todos os testes
robot --outputdir results tests/

# Filtrar por tag
robot --include smoke tests/
```

### Tags disponíveis
- `smoke` — testes essenciais do caminho feliz
- `negativo` — cenários de erro e validação
- `ui` — apenas testes de interface
- `login`, `usuarios`, `produtos`, `carrinhos` — por domínio

---

## 📌 Sobre o Projeto  

A **[ServRest API](https://serverest.dev/)** é uma API REST gratuita que simula um **e-commerce**, permitindo testes de requisições HTTP. Esta API possibilita a prática de **testes manuais** e **testes automatizados** com **Postman** e **GitHub Actions**, abrangendo funcionalidades como:  

- 📌 **Gerenciamento de Usuários** (cadastro, autenticação, listagem)  
- 🛍️ **Produtos** (CRUD completo)  
- 🛒 **Carrinho de Compras** (criação, edição e finalização)  

📢 **Objetivo:** Automatizar testes da API utilizando **Postman** e **Newman**, além de garantir a qualidade contínua via **GitHub Actions**.  

---

## 📂 Estrutura do Projeto

### ServeRest (Coleção de Testes)

#### 01_usuários
- **POST** usuarios  
- **POST** login  
- **GET** lista de usuários  
- **GET** usuarios_id  
- **DELETE** usuarios  

#### 02_produtos
- 📁 **dependência**  
- 📁 **caminho_feliz**  
  - **GET** lista_produtos  
  - **POST** produto  
  - **GET** produto_id  
  - **PUT** atualizar_produto  
  - **DELETE** produto  
- 📁 **dependência_delete**  
  - **DELETE** usuario  

#### 03_carrinho
- 📁 **dependência**  
  - **POST** usuário  
  - **POST** login  
  - **POST** produto  
  - **POST** produto_2  
- 📁 **caminho_feliz**  
  - **GET** lista_carrinho  
  - **POST** carrinho  
  - **GET** carrinho_id  
  - **DELETE** excluir_carrinho  
  - **DELETE** excluir_carrinho_cancelar  
- 📁 **dependência_delete**  
  - **DELETE** produto  
  - **DELETE** produto_2  
  - **DELETE** usuario  


### 🔹 **Coleção de Testes – Postman**  

## 🌐 URL Base da API  

📌 A API está disponível em **[https://serverest.dev/](https://serverest.dev/)**, e seus principais endpoints são:  

### 🔹 Usuários (`/usuarios`)  
- `POST /usuarios` → Criar um novo usuário  
- `POST /login` → Realizar login  
- `GET /usuarios` → Listar usuários  
- `GET /usuarios/{_id}` → Buscar usuário por ID  
- `DELETE /usuarios/{_id}` → Excluir usuário  
- `PUT /usuarios/{_id}` → Editar usuário  

### 🔹 Produtos (`/produtos`)  
- `GET /produtos` → Listar produtos  
- `POST /produtos` → Criar um produto  
- `GET /produtos/{_id}` → Buscar produto por ID  
- `PUT /produtos/{_id}` → Editar produto  
- `DELETE /produtos/{_id}` → Excluir produto  

### 🔹 Carrinhos (`/carrinhos`)  
- `GET /carrinhos` → Listar carrinhos  
- `POST /carrinhos` → Criar carrinho  
- `GET /carrinhos/{_id}` → Buscar carrinho por ID  
- `DELETE /carrinhos/concluir-compra` → Finalizar compra  
- `DELETE /carrinhos/cancelar-compra` → Cancelar compra  

---

## 🛠️ Ferramentas Utilizadas  

### 📌 Por que utilizar Postman?
O Postman é uma das ferramentas mais populares para testes de API, pois oferece um ambiente intuitivo e poderoso para criar, gerenciar e automatizar requisições. No caso da ServRest API, ele foi utilizado para:

✅ Criar e organizar requisições de teste
✅ Simular diferentes cenários de uso da API
✅ Automatizar os testes com Newman, a CLI do Postman
✅ Gerar relatórios de execução de testes

Além disso, a coleção de testes do Postman pode ser facilmente compartilhada com outros desenvolvedores e testadores, tornando o processo mais colaborativo.

### 🚀 Automação com GitHub Actions  

Para garantir a qualidade contínua, foi configurado um workflow no GitHub Actions para rodar testes automaticamente a cada push no repositório.

## 📜 Como funciona o workflow?
O GitHub Actions executa os testes da API utilizando o Newman. Toda vez que um novo código é enviado para o repositório, ele:

1️⃣ Configura o ambiente com Node.js e Newman
2️⃣ Baixa a coleção de testes do Postman
3️⃣ Executa os testes e gera relatórios
4️⃣ Exibe os resultados diretamente no GitHub

## 📜 Workflow (`.github/workflows/api-tests.yml`)  

### 📄 Exemplo de Workflow  

name: API Tests

on:
  push:
    branches:
      - main
  pull_request:
    branches:
      - main

jobs:
  test-api:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout do Código
        uses: actions/checkout@v3

      - name: Instalar Node.js
        uses: actions/setup-node@v3
        with:
          node-version: '18'

      - name: Instalar Newman
        run: npm install -g newman

      - name: Rodar Testes com Newman
        run: newman run ./collections/servrest.postman_collection.json \
          -e ./environments/servrest.postman_environment.json \
          --reporters cli,htmlextra

      - name: Upload dos Relatórios de Testes
        uses: actions/upload-artifact@v3
        with:
          name: relatorio-testes
          path: ./results/report.html

## ✅ Benefícios da Automação com GitHub Actions  
- ✔️ Detecta problemas rapidamente ao validar os endpoints  
- ✔️ Mantém a API sempre funcional após alterações no código  
- ✔️ Garante histórico de execuções no repositório  

## 🚀 Como Executar os Testes  

### 1️⃣ Clone o Repositório  

git clone https://github.com/salomaonogueira/ServRest-Api  
cd ServRest-Api  

# 🛠️ 2. Instale o Newman (caso ainda não tenha)
Se ainda não tiver o Newman instalado globalmente, rode:
npm install -g newman

## 📝 Executar Testes Específicos
🔹 Testes de Usuários:
newman run usuarios.json \
  -e ./environment.json \
  -g ./globals.json \
  --reporters cli,htmlextra

🔹 Testes de Produtos:
newman run ./produtos.json \
  -e ./environment.json \
  -g ./globals.json \
  --reporters cli,htmlextra

🔹 Testes de Carrinho:
newman run ./carrinho.json \
  -e ./environment.json \
  -g ./globals.json \
  --reporters cli,htmlextra

## 🔗 Links Importantes
📌 API Oficial → https://serverest.dev/
📂 Repositório GitHub → https://github.com/salomaonogueira/ServRest-Api
🧑‍💻 Postman → https://www.postman.com/
⚡ Newman → https://www.npmjs.com/package/newman
🔧 GitHub Actions → https://docs.github.com/en/actions
