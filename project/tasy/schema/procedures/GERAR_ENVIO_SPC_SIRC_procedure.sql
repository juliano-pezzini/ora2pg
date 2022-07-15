-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_envio_spc_sirc ( nr_seq_lote_p bigint, nm_usuario_p text, nr_seq_orgao_cobr_p bigint, cd_estabelecimento_p bigint) AS $body$
DECLARE

 
ds_conteudo_w			varchar(1024);
ds_nome_cliente_w		varchar(60);
ds_uf_w				varchar(2);
ds_naturalidade_w		varchar(40);
ds_naturalidade_uf_w		varchar(2);
ds_nacionalidade_w		varchar(1);
ie_estado_civil_w		varchar(1);	
nr_numero_w			varchar(6);
ds_complemento_w		varchar(10);
ds_bairro_w			varchar(20);
ds_cep_w			integer;
ds_cidade_w			varchar(40);
ds_uf				varchar(2);
ds_razao_social_w		pessoa_juridica.ds_razao_social%type;
dt_fundacao_w			varchar(8);
nm_fantasia_w			pessoa_juridica.nm_fantasia%type;
nr_inscricao_estadual_w		varchar(16);
nr_seq_tipo_logradouro_w	varchar(15);
dt_nascimento_w			varchar(8);
nr_identidade_w			pessoa_fisica.nr_identidade%type;
nr_cpf_w			varchar(20);
cd_pessoa_fisica_w		varchar(10);
cd_cgc_w			varchar(14);
nm_contato_w			compl_pessoa_fisica.nm_contato%type;
ie_sexo_w			pessoa_fisica.ie_sexo%type;
ds_entidade_cobr_w		orgao_cobranca.ds_entidade_cobr%type;
ds_rua_w			compl_pessoa_fisica.ds_endereco%type;
nr_seq_linha_w			bigint := 0;
				
cheque CURSOR FOR 
	SELECT	a.nr_seq_cheque, 
		a.nr_seq_cobranca 
	from	cheque_cr_orgao_cobr a 
	where 	a.nr_seq_lote = nr_seq_lote_p 
	
union
 
	SELECT	a.nr_seq_cheque, 
		a.nr_seq_cobranca 
	from	cheque_cr_orgao_cobr a 
	where 	a.nr_seq_lote_exc = nr_seq_lote_p;

titulo CURSOR FOR 
	SELECT	b.nr_titulo, 
		b.nr_seq_cobranca 
	from 	titulo_receber_orgao_cobr b 
	where 	b.nr_seq_lote = nr_seq_lote_p 
	
union
 
	SELECT	b.nr_titulo, 
		b.nr_seq_cobranca 
	from 	titulo_receber_orgao_cobr b 
	where 	b.nr_seq_lote_exc = nr_seq_lote_p;

outros CURSOR FOR 
	SELECT	c.nr_sequencia, 
		c.nr_seq_cobranca 
	from	outros_orgao_cobr c 
	where 	c.nr_seq_lote = nr_seq_lote_p 
	
union
 
	SELECT	c.nr_sequencia, 
		c.nr_seq_cobranca 
	from	outros_orgao_cobr c 
	where 	c.nr_seq_lote_exc = nr_seq_lote_p;
	
vet01	cheque%rowtype;
vet02	titulo%rowtype;
vet03	outros%rowtype;
	

BEGIN 
 
delete from w_envio_orgao_cobranca where nm_usuario = nm_usuario_p;
 
select	substr(max(ds_entidade_cobr),1,6) 
into STRICT	ds_entidade_cobr_w	 
from	orgao_cobranca 
where	nr_sequencia = nr_seq_orgao_cobr_p;
 
open cheque;
loop 
fetch cheque into	 
	vet01;
EXIT WHEN NOT FOUND; /* apply on cheque */
	begin 
	 
	select	max(d.nr_cpf), 
		max(d.cd_pessoa_fisica), 
		max(c.cd_cgc), 
		max(elimina_caractere_especial(substr(obter_nome_pf_pj(c.cd_pessoa_fisica,null),1,60))), 
		max(coalesce(to_char(d.dt_nascimento,'YYYYMMDD'),'0')), 
		max(d.nr_identidade), 
		max(substr(obter_dados_pf_pj(c.cd_pessoa_fisica,null,'UF'),1,2)), 
		max(d.ie_sexo), 
		max(substr(obter_naturalidade_pf(c.cd_pessoa_fisica,'M'),1,40)),	 
		max(substr(obter_naturalidade_pf(c.cd_pessoa_fisica,'UF'),1,2)), 
		max(CASE WHEN d.cd_nacionalidade=10 THEN  'B'  ELSE 'E' END ), 
		max(CASE WHEN d.ie_estado_civil='1' THEN 's' WHEN d.ie_estado_civil='2' THEN 'c' WHEN d.ie_estado_civil='3' THEN 'd' WHEN d.ie_estado_civil='5' THEN 'v' WHEN d.ie_estado_civil='7' THEN 'a' WHEN d.ie_estado_civil='9' THEN 'i' END ), 
		max(substr(obter_dados_pf_pj(c.cd_pessoa_fisica,null,'NR'),1,6)), 
		max(substr(obter_dados_pf_pj(c.cd_pessoa_fisica,null,'CO'),1,10)), 
		max(substr(obter_dados_pf_pj(c.cd_pessoa_fisica,null,'B'),1,20)), 
		max(substr(obter_dados_pf_pj(c.cd_pessoa_fisica,null,'CEP'),1,8)), 
		max(substr(obter_dados_pf_pj(c.cd_pessoa_fisica,null,'CI'),1,40)), 
		max(substr(obter_dados_pf_pj(c.cd_pessoa_fisica,null,'UF'),1,2)), 
		max(substr(l.ds_endereco,1,40)) 
	into STRICT	nr_cpf_w, 
		cd_pessoa_fisica_w, 
		cd_cgc_w, 
		ds_nome_cliente_w, 
		dt_nascimento_w, 
		nr_identidade_w, 
		ds_uf_w, 
		ie_sexo_w, 
		ds_naturalidade_w, 
		ds_naturalidade_uf_w, 
		ds_nacionalidade_w, 
		ie_estado_civil_w, 
		nr_numero_w, 
		ds_complemento_w, 
		ds_bairro_w, 
		ds_cep_w, 
		ds_cidade_w, 
		ds_uf, 
		ds_rua_w 
	FROM cheque_cr c, pessoa_fisica d
LEFT OUTER JOIN compl_pessoa_fisica l ON (d.cd_pessoa_fisica = l.cd_pessoa_fisica)
WHERE c.cd_pessoa_fisica	= d.cd_pessoa_fisica  and c.nr_seq_cheque		= vet01.nr_seq_cheque;
	 
	if (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') then 
		nr_seq_linha_w := nr_seq_linha_w + 1;		
		ds_conteudo_w	:=	'SIRC010' || 
					'01' || 
					rpad(coalesce(to_char(vet01.nr_seq_cheque),' '),10,' ') ||--Identificação da solicitação 
					rpad(coalesce(ds_entidade_cobr_w,' '),6,' ') ||--Código da entidade 
					rpad(' ',8,' ') ||--Logon do usuário 
					rpad(' ',8,' ') ||--Senha do usuário 
					lpad(coalesce(nr_cpf_w,'0'),11,'0') ||-- CPF 
					rpad(coalesce(ds_nome_cliente_w,' '),60,' ') ||--Nome do cliente 
					lpad(coalesce(dt_nascimento_w,'0'),8,'0') ||--Data de nascimento do cliente 
					rpad(coalesce(nr_identidade_w,' '),16,' ') ||--Número identidade 
					rpad(coalesce(ds_uf_w,' '),2,' ') ||--UF da identidade 
					rpad(coalesce(ie_sexo_w,' '),1,' ') ||--Sexo 
					rpad(coalesce(ds_naturalidade_w,' '),40,' ') ||--Naturalidade Município 
					rpad(coalesce(ds_naturalidade_uf_w,' '),2,' ') ||--Naturalidade UF 
					rpad(coalesce(ds_nacionalidade_w,' '),1,' ') ||--Nacionalidade 
					rpad(coalesce(ie_estado_civil_w,' '),1,' ') || --Estado civil 
					rpad(' ',40,' ') || --Nome do cônjuge 
					lpad('0',8,'0') ||--Data nascimento cônjuge 
					rpad(' ',40,' ') || --Nome da mãe 
					rpad(' ',40,' ') ||--Nome do pai 
					rpad(' ',15,' ') ||--Endereço ¿ Tipo de logradouro 
					rpad(coalesce(ds_rua_w,' '),40,' ') ||--Endereço Logradouro 
					rpad(coalesce(nr_numero_w,' '),6,' ') || --Endereço ¿ Número 
					rpad(coalesce(ds_complemento_w,' '),10,' ') ||--Endereço ¿ Complemento 
					rpad(coalesce(ds_bairro_w,' '),20,' ') || --Endereço ¿ Bairro 
					lpad(coalesce(ds_cep_w,'0'),8,'0') || --Endereço ¿ CEP 
					rpad(coalesce(ds_cidade_w,' '),40,' ') || --Endereço ¿ Cidade 
					rpad(coalesce(ds_uf_w,' '),2,' '); --Endereço ¿ UF 
	end if;
	 
	select	max(c.cd_cgc), 
		max(c.cd_pessoa_fisica), 
		max(c.cd_cgc), 
		max(elimina_caractere_especial(substr(obter_nome_pf_pj(null,c.cd_cgc),1,60))), 
		max(coalesce(to_char(p.dt_criacao,'YYYYMMDD'),'0')), 
		max(substr(obter_dados_pf_pj(null,c.cd_cgc,'UF'),1,2)), 
		max(substr(obter_dados_pf_pj(null,c.cd_cgc,'NR'),1,6)), 
		max(substr(obter_dados_pf_pj(null,c.cd_cgc,'CO'),1,10)), 
		max(substr(obter_dados_pf_pj(null,c.cd_cgc,'B'),1,20)), 
		max(substr(obter_dados_pf_pj(null,c.cd_cgc,'CEP'),1,8)), 
		max(substr(obter_dados_pf_pj(null,c.cd_cgc,'CI'),1,40)), 
		max(substr(obter_dados_pf_pj(null,c.cd_cgc,'UF'),1,2)), 
		max(substr(p.ds_razao_social,1,60)), 
		max(coalesce(to_char(p.dt_criacao,'YYYYMMDD'),'0')), 
		max(substr(p.nm_fantasia,1,40)), 
		max(substr(p.nr_inscricao_estadual,1,16)), 
		max(substr(p.nr_seq_tipo_logradouro,1,15)) 
	into STRICT	nr_cpf_w, 
		cd_pessoa_fisica_w, 
		cd_cgc_w, 
		ds_nome_cliente_w, 
		dt_nascimento_w, 
		ds_uf_w, 
		nr_numero_w, 
		ds_complemento_w, 
		ds_bairro_w, 
		ds_cep_w, 
		ds_cidade_w, 
		ds_uf, 
		ds_razao_social_w, 
		dt_fundacao_w, 
		nm_fantasia_w, 
		nr_inscricao_estadual_w, 
		nr_seq_tipo_logradouro_w 
	from	cheque_cr c, 
		pessoa_juridica p 
	where	c.cd_cgc 		= p.cd_cgc 
	and 	c.nr_seq_cheque		= vet01.nr_seq_cheque;
	 
	if (cd_cgc_w IS NOT NULL AND cd_cgc_w::text <> '') then 
		nr_seq_linha_w := nr_seq_linha_w + 1;
		ds_conteudo_w	:=	'SIRC011' || 
					'01' || 
					rpad(coalesce(to_char(vet01.nr_seq_cheque),' '),10,' ') ||--Identificação da solicitação 
					rpad(coalesce(ds_entidade_cobr_w,' '),6,' ') ||--Código da entidade 
					rpad(' ',8,' ') ||--Logon do usuário 
					rpad(' ',8,' ') ||--Senha do usuário 
					lpad(coalesce(cd_cgc_w,'0'),14,'0') || --CNPJ 
					rpad(coalesce(ds_razao_social_w,' '),60,' ') || --Razão social 
					lpad(coalesce(dt_fundacao_w,'0'),8,'0') || --Data fundação 
					rpad(coalesce(nm_fantasia_w,' '),40,' ') || --Nome de fantasia 
					rpad(coalesce(nr_inscricao_estadual_w,' '),16,' ') || --Inscrição estadual 
					rpad(coalesce(nr_seq_tipo_logradouro_w,' '),15,' ') ||--Endereço ¿ Tipo de logradouro 
					rpad(coalesce(ds_rua_w,' '),40,' ') ||--Endereço ¿ Logradouro 
					rpad(coalesce(nr_numero_w,' '),6,' ') || --Endereço ¿ Número 
					rpad(coalesce(ds_complemento_w,' '),10,' ') ||--Endereço ¿ Complemento 
					rpad(coalesce(ds_bairro_w,' '),20,' ') || --Endereço ¿ Bairro 
					lpad(coalesce(ds_cep_w,'0'),8,'0') || --Endereço ¿ CEP 
					rpad(coalesce(ds_cidade_w,' '),40,' ') || --Endereço ¿ Cidade 
					rpad(coalesce(ds_uf_w,' '),2,' '); --Endereço ¿ UF 
					
	end if;
	 
	insert	into	w_envio_orgao_cobranca(nr_sequencia, 
			nr_seq_lote,      
			ds_conteudo,     
			dt_atualizacao, 
			nm_usuario, 
			nr_seq_apres) 
		values (nextval('w_envio_orgao_cobranca_seq'), 
			nr_seq_lote_p, 
			ds_conteudo_w, 
			clock_timestamp(), 
			nm_usuario_p, 
			nr_seq_linha_w);		
	 
	end;
end loop;
close cheque;
 
open titulo;
loop 
fetch titulo into	 
	vet02;
EXIT WHEN NOT FOUND; /* apply on titulo */
	begin 
	 
	select	max(d.nr_cpf), 
		max(c.cd_pessoa_fisica), 
		max(c.cd_cgc), 
		max(elimina_caractere_especial(substr(obter_nome_pf_pj(c.cd_pessoa_fisica,null),1,60))), 
		max(coalesce(to_char(d.dt_nascimento,'YYYYMMDD'),'0')), 
		max(d.nr_identidade), 
		max(substr(obter_dados_pf_pj(c.cd_pessoa_fisica,null,'UF'),1,2)), 
		max(d.ie_sexo), 
		max(substr(obter_naturalidade_pf(c.cd_pessoa_fisica,'M'),1,40)),	 
		max(substr(obter_naturalidade_pf(c.cd_pessoa_fisica,'UF'),1,2)), 
		max(CASE WHEN d.cd_nacionalidade=10 THEN  'B'  ELSE 'E' END ), 
		max(CASE WHEN d.ie_estado_civil='1' THEN 's' WHEN d.ie_estado_civil='2' THEN 'c' WHEN d.ie_estado_civil='3' THEN 'd' WHEN d.ie_estado_civil='5' THEN 'v' WHEN d.ie_estado_civil='7' THEN 'a' WHEN d.ie_estado_civil='9' THEN 'i' END ), 
		max(substr(obter_compl_pf(c.cd_pessoa_fisica,6,'N'),1,40)), 
		max(substr(obter_dados_pf_pj(c.cd_pessoa_fisica,null,'NR'),1,6)), 
		max(substr(obter_dados_pf_pj(c.cd_pessoa_fisica,null,'CO'),1,10)), 
		max(substr(obter_dados_pf_pj(c.cd_pessoa_fisica,null,'B'),1,20)), 
		max(substr(obter_dados_pf_pj(c.cd_pessoa_fisica,null,'CEP'),1,8)), 
		max(substr(obter_dados_pf_pj(c.cd_pessoa_fisica,null,'CI'),1,40)), 
		max(substr(obter_dados_pf_pj(c.cd_pessoa_fisica,null,'UF'),1,2)), 
		max(substr(l.ds_endereco,1,40)) 
	into STRICT	nr_cpf_w, 
		cd_pessoa_fisica_w, 
		cd_cgc_w, 
		ds_nome_cliente_w, 
		dt_nascimento_w, 
		nr_identidade_w, 
		ds_uf_w, 
		ie_sexo_w, 
		ds_naturalidade_w, 
		ds_naturalidade_uf_w, 
		ds_nacionalidade_w, 
		ie_estado_civil_w, 
		nm_contato_w, 
		nr_numero_w, 
		ds_complemento_w, 
		ds_bairro_w, 
		ds_cep_w, 
		ds_cidade_w, 
		ds_uf, 
		ds_rua_w 
	FROM titulo_receber c, pessoa_fisica d
LEFT OUTER JOIN compl_pessoa_fisica l ON (d.cd_pessoa_fisica = l.cd_pessoa_fisica)
WHERE c.cd_pessoa_fisica	= d.cd_pessoa_fisica  and c.nr_titulo		= vet02.nr_titulo;
	 
	if (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') then 
		nr_seq_linha_w := nr_seq_linha_w + 1;
		ds_conteudo_w	:=	'SIRC010' || 
					'01' || 
					rpad(coalesce(to_char(vet02.nr_titulo),' '),10,' ') ||--Identificação da solicitação 
					rpad(coalesce(ds_entidade_cobr_w,' '),6,' ') ||--Código da entidade 
					rpad(' ',8,' ') ||--Logon do usuário 
					rpad(' ',8,' ') ||--Senha do usuário 
					lpad(coalesce(nr_cpf_w,'0'),11,'0') ||-- CPF 
					rpad(coalesce(ds_nome_cliente_w,' '),60,' ') ||--Nome do cliente 
					lpad(coalesce(dt_nascimento_w,'0'),8,'0') ||--Data de nascimento do cliente 
					rpad(coalesce(nr_identidade_w,' '),16,' ') ||--Número identidade 
					rpad(coalesce(ds_uf_w,' '),2,' ') ||--UF da identidade 
					rpad(coalesce(ie_sexo_w,' '),1,' ') ||--Sexo 
					rpad(coalesce(ds_naturalidade_w,' '),40,' ') ||--Naturalidade Município 
					rpad(coalesce(ds_naturalidade_uf_w,' '),2,' ') ||--Naturalidade UF 
					rpad(coalesce(ds_nacionalidade_w,' '),1,' ') ||--Nacionalidade 
					rpad(coalesce(ie_estado_civil_w,' '),1,' ') || --Estado civil 
					rpad(' ',40,' ') || --Nome do cônjuge 
					lpad('0',8,'0') ||--Data nascimento cônjuge 
					rpad(' ',40,' ') || --Nome da mãe 
					rpad(' ',40,' ') ||--Nome do pai 
					rpad(' ',15,' ') ||--Endereço ¿ Tipo de logradouro 
					rpad(coalesce(ds_rua_w,' '),40,' ') ||--Endereço Logradouro 
					rpad(coalesce(nr_numero_w,' '),6,' ') || --Endereço ¿ Número 
					rpad(coalesce(ds_complemento_w,' '),10,' ') ||--Endereço ¿ Complemento 
					rpad(coalesce(ds_bairro_w,' '),20,' ') || --Endereço ¿ Bairro 
					lpad(coalesce(ds_cep_w,'0'),8,'0') || --Endereço ¿ CEP 
					rpad(coalesce(ds_cidade_w,' '),40,' ') || --Endereço ¿ Cidade 
					rpad(coalesce(ds_uf_w,' '),2,' '); --Endereço ¿ UF 
	end if;
 
	select	max(c.cd_cgc), 
		max(c.cd_pessoa_fisica), 
		max(c.cd_cgc), 
		max(elimina_caractere_especial(substr(obter_nome_pf_pj(null,c.cd_cgc),1,60))), 
		max(coalesce(to_char(p.dt_criacao,'YYYYMMDD'),'0')), 
		max(substr(obter_dados_pf_pj(null,c.cd_cgc,'UF'),1,2)), 
		max(substr(obter_dados_pf_pj(null,c.cd_cgc,'NR'),1,6)), 
		max(substr(obter_dados_pf_pj(null,c.cd_cgc,'CO'),1,10)), 
		max(substr(obter_dados_pf_pj(null,c.cd_cgc,'B'),1,20)), 
		max(substr(obter_dados_pf_pj(null,c.cd_cgc,'CEP'),1,8)), 
		max(substr(obter_dados_pf_pj(null,c.cd_cgc,'CI'),1,40)), 
		max(substr(obter_dados_pf_pj(null,c.cd_cgc,'UF'),1,2)), 
		max(substr(p.ds_razao_social,1,60)), 
		max(coalesce(to_char(p.dt_criacao,'YYYYMMDD'),'0')), 
		max(substr(p.nm_fantasia,1,40)), 
		max(substr(p.nr_inscricao_estadual,1,16)), 
		max(substr(p.nr_seq_tipo_logradouro,1,15)) 
	into STRICT	nr_cpf_w, 
		cd_pessoa_fisica_w, 
		cd_cgc_w, 
		ds_nome_cliente_w, 
		dt_nascimento_w, 
		ds_uf_w, 
		nr_numero_w, 
		ds_complemento_w, 
		ds_bairro_w, 
		ds_cep_w, 
		ds_cidade_w, 
		ds_uf, 
		ds_razao_social_w, 
		dt_fundacao_w, 
		nm_fantasia_w, 
		nr_inscricao_estadual_w, 
		nr_seq_tipo_logradouro_w 
	from	titulo_receber c, 
		pessoa_juridica p 
	where	c.cd_cgc 		= p.cd_cgc 
	and 	c.nr_titulo		= vet02.nr_titulo;
					 
	if (cd_cgc_w IS NOT NULL AND cd_cgc_w::text <> '') then 
		nr_seq_linha_w := nr_seq_linha_w + 1;
		ds_conteudo_w	:=	'SIRC011' || 
					'01' || 
					rpad(coalesce(to_char(vet02.nr_titulo),' '),10,' ') ||--Identificação da solicitação 
					rpad(coalesce(ds_entidade_cobr_w,' '),6,' ') ||--Código da entidade 
					rpad(' ',8,' ') ||--Logon do usuário 
					rpad(' ',8,' ') ||--Senha do usuário 
					lpad(coalesce(cd_cgc_w,'0'),14,'0') || --CNPJ 
					rpad(coalesce(ds_razao_social_w,' '),60,' ') || --Razão social 
					lpad(coalesce(dt_fundacao_w,'0'),8,'0') || --Data fundação 
					rpad(coalesce(nm_fantasia_w,' '),40,' ') || --Nome de fantasia 
					rpad(coalesce(nr_inscricao_estadual_w,' '),16,' ') || --Inscrição estadual 
					rpad(coalesce(nr_seq_tipo_logradouro_w,' '),15,' ') ||--Endereço ¿ Tipo de logradouro 
					rpad(coalesce(ds_rua_w,' '),40,' ') ||--Endereço ¿ Logradouro 
					rpad(coalesce(nr_numero_w,' '),6,' ') || --Endereço ¿ Número 
					rpad(coalesce(ds_complemento_w,' '),10,' ') ||--Endereço ¿ Complemento 
					rpad(coalesce(ds_bairro_w,' '),20,' ') || --Endereço ¿ Bairro 
					lpad(coalesce(ds_cep_w,'0'),8,'0') || --Endereço ¿ CEP 
					rpad(coalesce(ds_cidade_w,' '),40,' ') || --Endereço ¿ Cidade 
					rpad(coalesce(ds_uf_w,' '),2,' '); --Endereço ¿ UF 
					
	end if;
	 
	insert	into	w_envio_orgao_cobranca(nr_sequencia, 
			nr_seq_lote,      
			ds_conteudo,     
			dt_atualizacao, 
			nm_usuario, 
			nr_seq_apres) 
		values (nextval('w_envio_orgao_cobranca_seq'), 
			nr_seq_lote_p, 
			ds_conteudo_w, 
			clock_timestamp(), 
			nm_usuario_p, 
			nr_seq_linha_w);	
	 
	end;
end loop;
close titulo;
 
open outros;
loop 
fetch outros into	 
	vet03;
EXIT WHEN NOT FOUND; /* apply on outros */
	begin 
	nr_seq_linha_w := nr_seq_linha_w + 1;
	ds_conteudo_w	:=	'SIRC020' || 
				'01' || 
				rpad(coalesce(to_char(vet03.nr_sequencia),' '),10,' ') ||--Identificação da solicitação 
				rpad(coalesce(ds_entidade_cobr_w,' '),6,' ') ||--Código da entidade 
				rpad(' ',8,' ') ||--Logon do usuário 
				rpad(' ',8,' ') ||--Senha do usuário 
				rpad(' ',1,' ') ||--Tipo documento 
				lpad('0',14,'0') ||--CPF/CNPJ 
				rpad(' ',10,' ') ||--ID da Solicitação 
				rpad(' ',1,' ')||--Tipo da ocorrência 
				lpad('0',2,'0') ||--Código do motivo da ocorrência 
				lpad('0',8,'0') ||--Data da compra 
				lpad('0',8,'0') ||---Data do vencimento 
				rpad(' ',16,' ') ||--Contrato 
				rpad(' ',3,' ') ||---Parcela 
				rpad(' ',1,' ') ||--Tipo do devedor 
				rpad(' ',40,' ') ||--Afiançado 
				lpad('0',17,'0') ||--Valor do débito 
				rpad(' ',3,' ') ||--Banco 
				lpad('0',4,'0') ||--Agência 
				rpad(' ',2,' ') ||--Praça 
				lpad('0',16,'0') ||--Conta corrente 
				lpad('0',7,'0') ||--Cheque 
				rpad(' ',12,' ');--Conta Contrato 
	
	insert	into	w_envio_orgao_cobranca(nr_sequencia, 
			nr_seq_lote,      
			ds_conteudo,     
			dt_atualizacao, 
			nm_usuario, 
			nr_seq_apres) 
		values (nextval('w_envio_orgao_cobranca_seq'), 
			nr_seq_lote_p, 
			ds_conteudo_w, 
			clock_timestamp(), 
			nm_usuario_p, 
			nr_seq_linha_w);	
 
	end;
end loop;
close outros;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_envio_spc_sirc ( nr_seq_lote_p bigint, nm_usuario_p text, nr_seq_orgao_cobr_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;

