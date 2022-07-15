-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_remessa_spc ( nr_seq_lote_p bigint, nm_usuario_p text) AS $body$
DECLARE


ds_conteudo_w			varchar(600);
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
nr_cpf_w			pessoa_fisica.nr_cpf%type;
cd_pessoa_fisica_w		varchar(10);
cd_cgc_w			varchar(14);
nm_contato_w			compl_pessoa_fisica.nm_contato%type;
ie_sexo_w			pessoa_fisica.ie_sexo%type;
nr_seq_linha_w			bigint := 0;
				
c01 CURSOR FOR
	SELECT	a.nr_seq_cheque,
		a.nr_seq_cobranca
	from	cheque_cr_orgao_cobr a
	where 	a.nr_seq_lote = nr_seq_lote_p
	
union

	SELECT	b.nr_titulo,
		b.nr_seq_cobranca
	from 	titulo_receber_orgao_cobr b
	where 	b.nr_seq_lote = nr_seq_lote_p;

outros CURSOR FOR
	SELECT	null,
		c.nr_seq_cobranca
	from	outros_orgao_cobr c
	where 	c.nr_seq_lote = nr_seq_lote_p;
	
vet02	c01%rowtype;
vet03	outros%rowtype;
	

BEGIN

delete from w_envio_orgao_cobranca where nm_usuario = nm_usuario_p;

open c01;
loop
fetch c01 into	
	vet02;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	
	select	d.nr_cpf,
		c.cd_pessoa_fisica,
		c.cd_cgc,
		elimina_caractere_especial(substr(obter_nome_pf_pj(c.cd_pessoa_fisica,null),1,60)),
		coalesce(to_char(d.dt_nascimento,'YYYYMMDD'),'0'),
		d.nr_identidade,
		substr(obter_dados_pf_pj(c.cd_pessoa_fisica,null,'UF'),1,2),
		d.ie_sexo,
		substr(obter_naturalidade_pf(c.cd_pessoa_fisica,'M'),1,40),	
		substr(obter_naturalidade_pf(c.cd_pessoa_fisica,'UF'),1,2),
		CASE WHEN d.cd_nacionalidade=10 THEN  'B'  ELSE 'E' END ,
		CASE WHEN d.ie_estado_civil='1' THEN 's' WHEN d.ie_estado_civil='2' THEN 'c' WHEN d.ie_estado_civil='3' THEN 'd' WHEN d.ie_estado_civil='5' THEN 'v' WHEN d.ie_estado_civil='7' THEN 'a' WHEN d.ie_estado_civil='9' THEN 'i' END ,
		substr(obter_compl_pf(c.cd_pessoa_fisica,6,'N'),1,40),
		substr(obter_dados_pf_pj(c.cd_pessoa_fisica,c.cd_cgc,'NR'),1,6),
		substr(obter_dados_pf_pj(c.cd_pessoa_fisica,c.cd_cgc,'CO'),1,10),
		substr(obter_dados_pf_pj(c.cd_pessoa_fisica,c.cd_cgc,'B'),1,20),
		substr(obter_dados_pf_pj(c.cd_pessoa_fisica,c.cd_cgc,'CEP'),1,8),
		substr(obter_dados_pf_pj(c.cd_pessoa_fisica,c.cd_cgc,'CI'),1,40),
		substr(obter_dados_pf_pj(c.cd_pessoa_fisica,c.cd_cgc,'UF'),1,2),
		substr(p.ds_razao_social,1,255),
		to_char(p.dt_criacao,'YYYYMMDD'),
		substr(p.nm_fantasia,1,40),
		substr(p.nr_inscricao_estadual,1,16),
		substr(p.nr_seq_tipo_logradouro,1,15)
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
		ds_razao_social_w,
		dt_fundacao_w,
		nm_fantasia_w,
		nr_inscricao_estadual_w,
		nr_seq_tipo_logradouro_w
	FROM titulo_receber c
LEFT OUTER JOIN pessoa_fisica d ON (c.cd_pessoa_fisica = d.cd_pessoa_fisica)
LEFT OUTER JOIN pessoa_juridica p ON (c.cd_cgc = p.cd_cgc)
WHERE c.nr_titulo		= vet02.nr_seq_cheque
	
union

	SELECT	d.nr_cpf,
		c.cd_pessoa_fisica,
		c.cd_cgc,
		elimina_caractere_especial(substr(obter_nome_pf_pj(c.cd_pessoa_fisica,null),1,60)),
		coalesce(to_char(d.dt_nascimento,'YYYYMMDD'),'0'),
		d.nr_identidade,
		substr(obter_dados_pf_pj(c.cd_pessoa_fisica,null,'UF'),1,2),
		d.ie_sexo,
		substr(obter_naturalidade_pf(c.cd_pessoa_fisica,'M'),1,40),	
		substr(obter_naturalidade_pf(c.cd_pessoa_fisica,'UF'),1,2),
		CASE WHEN d.cd_nacionalidade=10 THEN  'B'  ELSE 'E' END ,
		CASE WHEN d.ie_estado_civil='1' THEN 's' WHEN d.ie_estado_civil='2' THEN 'c' WHEN d.ie_estado_civil='3' THEN 'd' WHEN d.ie_estado_civil='5' THEN 'v' WHEN d.ie_estado_civil='7' THEN 'a' WHEN d.ie_estado_civil='9' THEN 'i' END ,
		'',
		substr(obter_dados_pf_pj(c.cd_pessoa_fisica,c.cd_cgc,'NR'),1,6),
		substr(obter_dados_pf_pj(c.cd_pessoa_fisica,c.cd_cgc,'CO'),1,10),
		substr(obter_dados_pf_pj(c.cd_pessoa_fisica,c.cd_cgc,'B'),1,20),
		substr(obter_dados_pf_pj(c.cd_pessoa_fisica,c.cd_cgc,'CEP'),1,8),
		substr(obter_dados_pf_pj(c.cd_pessoa_fisica,c.cd_cgc,'CI'),1,40),
		substr(obter_dados_pf_pj(c.cd_pessoa_fisica,c.cd_cgc,'UF'),1,2),
		substr(p.ds_razao_social,1,60),
		coalesce(to_char(p.dt_criacao,'YYYYMMDD'),'0'),
		substr(p.nm_fantasia,1,40),
		substr(p.nr_inscricao_estadual,1,16),
		substr(p.nr_seq_tipo_logradouro,1,15)
	FROM cheque_cr c
LEFT OUTER JOIN pessoa_fisica d ON (c.cd_pessoa_fisica = d.cd_pessoa_fisica)
LEFT OUTER JOIN pessoa_juridica p ON (c.cd_cgc = p.cd_cgc)
WHERE c.nr_seq_cheque		= vet02.nr_seq_cheque;

	if (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') then
		nr_seq_linha_w := nr_seq_linha_w + 1;
		ds_conteudo_w	:=	'SIRC010' ||
					'01' ||
					rpad(' ',10,' ') ||--Identificacao da solicitacao
					rpad(' ',6,' ') ||--Codigo da entidade
					rpad(' ',8,' ') ||--Logon do usuario
					rpad(' ',8,' ') ||--Senha do usuario
					lpad(coalesce(nr_cpf_w,'0'),11,'0') ||-- CPF
					rpad(coalesce(ds_nome_cliente_w,' '),60,' ') ||--Nome do cliente
					lpad(coalesce(dt_nascimento_w,'0'),8,'0') ||--Data de nascimento do cliente
					rpad(coalesce(nr_identidade_w,' '),16,' ') ||--Numero identidade
					rpad(coalesce(ds_uf_w,' '),2,' ') ||--UF da identidade
					rpad(coalesce(ie_sexo_w,' '),1,' ') ||--Sexo
					rpad(coalesce(ds_naturalidade_w,' '),40,' ') ||--Naturalidade Municipio
					rpad(coalesce(ds_naturalidade_uf_w,' '),2,' ') ||--Naturalidade UF
					rpad(coalesce(ds_nacionalidade_w,' '),1,' ') ||--Nacionalidade
					rpad(coalesce(ie_estado_civil_w,' '),1,' ') || --Estado civil
					rpad(' ',40,' ') || --Nome do conjuge
					lpad('0',8,'0') ||--Data nascimento conjuge
					rpad(' ',40,' ') || --Nome da mae
					rpad(' ',40,' ') ||--Nome do pai
					rpad(' ',15,' ') ||--Endereco  
					rpad(' ',40,' ') ||--Endereco  LogradouroTipo de logradouro
					rpad(coalesce(nr_numero_w,' '),6,' ') || --Endereco  Numero
					rpad(coalesce(ds_complemento_w,' '),10,' ') ||--Endereco  Complemento
					rpad(coalesce(ds_bairro_w,' '),20,' ') || --Endereco  Bairro
					lpad(coalesce(ds_cep_w,'0'),8,'0') || --Endereco  CEP
					rpad(coalesce(ds_cidade_w,' '),40,' ') || --Endereco  Cidade
					rpad(coalesce(ds_uf,' '),2,' '); --Endereco  UF
					
	elsif (cd_cgc_w IS NOT NULL AND cd_cgc_w::text <> '') then
		nr_seq_linha_w := nr_seq_linha_w + 1;
		ds_conteudo_w	:=	'SIRC011' ||
					'01' ||
					rpad(' ',10,' ') ||--Identificacao da solicitacao
					rpad(' ',6,' ') ||--Codigo da entidade
					rpad(' ',8,' ') ||--Logon do usuario
					rpad(' ',8,' ') ||--Senha do usuario
					lpad(coalesce(cd_cgc_w,'0'),14,'0') || --CNPJ
					rpad(coalesce(ds_razao_social_w,' '),255,' ') || --Razao social
					lpad(coalesce(dt_fundacao_w,'0'),8,'0') || --Data fundacao
					rpad(coalesce(nm_fantasia_w,' '),40,' ') || --Nome de fantasia
					rpad(coalesce(nr_inscricao_estadual_w,' '),16,' ') || --Inscricao estadual
					rpad(coalesce(nr_seq_tipo_logradouro_w,' '),15,' ') ||--Endereco  Tipo de logradouro
					rpad(' ',40,' ') ||--Endereco  Logradouro
					rpad(coalesce(nr_numero_w,' '),6,' ') || --Endereco  Numero
					rpad(coalesce(ds_complemento_w,' '),10,' ') ||--Endereco  Complemento
					rpad(coalesce(ds_bairro_w,' '),20,' ') || --Endereco  Bairro
					lpad(coalesce(ds_cep_w,'0'),8,'0') || --Endereco  CEP
					rpad(coalesce(ds_cidade_w,' '),40,' ') || --Endereco  Cidade
					rpad(coalesce(ds_uf,' '),2,' '); --Endereco  UF
					
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
close c01;

open outros;
loop
fetch outros into	
	vet03;
EXIT WHEN NOT FOUND; /* apply on outros */
	begin
	nr_seq_linha_w := nr_seq_linha_w + 1;
	ds_conteudo_w	:=	'SIRC020' ||
				'01' ||
				rpad(' ',10,' ') ||--Identificacao da solicitacao
				rpad(' ',6,' ') ||--Codigo da entidade
				rpad(' ',8,' ') ||--Logon do usuario
				rpad(' ',8,' ') ||--Senha do usuario
				rpad(' ',1,' ') ||--Tipo documento
				lpad('0',14,'0') ||--CPF/CNPJ
				rpad(' ',10,' ') ||--ID da Solicitacao
				rpad(' ',1,' ')||--Tipo da ocorrencia
				lpad('0',2,'0') ||--Codigo do motivo da ocorrencia
				lpad('0',8,'0') ||--Data da compra
				lpad('0',8,'0') ||---Data do vencimento
				rpad(' ',16,' ') ||--Contrato
				rpad(' ',3,' ') ||---Parcela
				rpad(' ',1,' ') ||--Tipo do devedor
				rpad(' ',40,' ') ||--Afiancado
				lpad('0',17,'0') ||--Valor do debito
				rpad(' ',3,' ') ||--Banco
				lpad('0',4,'0') ||--Agencia
				rpad(' ',2,' ') ||--Praca
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
-- REVOKE ALL ON PROCEDURE gerar_remessa_spc ( nr_seq_lote_p bigint, nm_usuario_p text) FROM PUBLIC;

