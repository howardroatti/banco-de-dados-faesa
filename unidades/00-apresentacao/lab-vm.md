---
marp: true
theme: faesa
paginate: true
footer: 'Prof. M.Sc. Howard Cruz Roatti · FAESA · Banco de Dados · 2026/2 · [☰ Sumário](../../index.html)'
---

<!-- _class: capa -->
<!-- _paginate: false -->

# Apêndice — Laboratório (VM LabDatabase)

## Preparar o ambiente: VirtualBox, Docker, DBeaver, MongoDB

**Banco de Dados** · 2026/2
Prof. M.Sc. Howard Cruz Roatti

---

## O que é o Lab

A **VM LabDatabase** é uma máquina virtual Ubuntu que já traz, em **containers Docker**, os SGBDs da disciplina:

- **Oracle**, **PostgreSQL**, **MySQL** (relacionais)
- **MongoDB** (documentos) e **Redis** (chave-valor)

<div class="dica">💡 Você <strong>não instala</strong> banco nenhum na sua máquina: importa a VM, sobe os containers e conecta com os clientes.</div>

---

<!-- _class: secao -->

# 1 · Preparar a VM

---

## Importar a VM no VirtualBox

1. Instale o **Oracle VirtualBox** (virtualbox.org).
2. Baixe o arquivo **`LabDatabase.ova`** (link no AVA da disciplina).
3. No VirtualBox: **Arquivo → Importar Appliance…** → selecione o `.ova` → **Próximo → Importar**.

<div class="dica">💡 Reserve à VM pelo menos <strong>4 GB de RAM</strong> e <strong>2 CPUs</strong> — os containers (sobretudo o Oracle) são pesados.</div>

---

## Iniciar a VM e achar o IP

- Selecione a VM e clique em **Iniciar**. Faça login (usuário/senha do **AVA**).
- Descubra o IP da VM (para conectar do seu host), no terminal da VM:

```bash
ip addr        # procure o endereço em enp0s3 / eth0 (ex.: 192.168.x.x)
```

<div class="dica">💡 Alternativa: configurar <strong>redirecionamento de portas</strong> (NAT) no VirtualBox e conectar em <code>localhost</code>. Combine com o professor a forma adotada no lab.</div>

---

<!-- _class: secao -->

# 2 · Os bancos em Docker

---

## Ver e controlar os containers

Dentro da VM (terminal), os SGBDs rodam em containers Docker:

```bash
docker ps            # containers em execução
docker ps -a         # todos (inclusive parados)
docker start oracle  # subir um container (ex.: oracle)
docker stop  oracle  # parar
docker logs  mongo   # ver o log (útil se não conectar)
```

<div class="aviso">Se um banco não conectar, quase sempre o container está <strong>parado</strong> — confira com <code>docker ps</code> e suba com <code>docker start</code>.</div>

---

## Portas padrão dos SGBDs

| SGBD | Porta | Observação |
|---|---|---|
| **Oracle** | 1521 | *service* PDB (ex.: `XEPDB1`) |
| **PostgreSQL** | 5432 | |
| **MySQL** | 3306 | |
| **MongoDB** | 27017 | |
| **Redis** | 6379 | |

<div class="dica">💡 <strong>Host</strong> = IP da VM (ou <code>localhost</code>, se houver redirecionamento). <strong>Usuário/senha</strong>: os fornecidos no AVA.</div>

---

<!-- _class: secao -->

# 3 · Conectar

---

## DBeaver (Oracle · PostgreSQL · MySQL)

Cliente SQL universal para os relacionais:

1. **Nova conexão** → escolha o SGBD (Oracle/PostgreSQL/MySQL).
2. Preencha **Host** (IP da VM), **Porta** (1521/5432/3306), **Database/Service**, **Usuário** e **Senha**.
3. **Test Connection** → **Finish**. Abra um **SQL Editor** e rode suas consultas.

<div class="dica">💡 É o cliente usado no <strong>Roteiro Prático de SQL</strong> — mesmo ambiente para os três SGBDs.</div>

---

## mongosh (shell do MongoDB)

O terminal do MongoDB — usado nos exercícios (Pokémon) e no deck *MongoDB na VM*:

```bash
mongosh "mongodb://<IP-da-VM>:27017"
# já dentro do shell:
show dbs
use bancodedados
db.pokemon.find({ pokemon_name: "Ninetales" })
```

<div class="dica">💡 No <em>mongosh</em> você digita <strong>JavaScript</strong> — ótimo para scripts e automações rápidas.</div>

---

## MongoDB Compass (GUI)

Interface gráfica do MongoDB — ótima para **explorar dados** e **montar consultas complexas**:

1. Instale o **Compass** e informe a *connection string*: `mongodb://<IP-da-VM>:27017`.
2. Navegue por **bancos → coleções → documentos** visualmente.
3. Use o **Aggregation Pipeline Builder**: monte cada estágio (`$match`, `$group`, `$sort`…) com **pré-visualização** dos resultados — e exporte o código pronto para o `mongosh`.

<div class="dica">💡 Para <strong>agregações</strong> (como as dos exercícios Pokémon), o construtor visual do Compass economiza muito tempo.</div>

---

## Resolvendo problemas comuns

- **Não conecta:** o container está parado? (`docker ps` → `docker start`). O IP mudou? (`ip addr`).
- **Oracle demora:** o container leva um tempo para ficar *healthy* na primeira subida — aguarde e veja `docker logs`.
- **Porta ocupada / firewall:** confirme a porta e, se usar redirecionamento, o mapeamento no VirtualBox.
- **Esqueci a senha:** use as credenciais publicadas no **AVA** da sua turma.

---

<!-- _class: secao -->

# Bom laboratório!
### Dúvidas? howard.cruz@faesa.br

<a class="proximo" href="../../index.html">↩ Voltar ao índice<small>todas as unidades</small></a>
