-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_lead_fim_dependencia ( nr_seq_segurado_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, nr_seq_solicitacao_p INOUT bigint) AS $body$
DECLARE

 
nr_seq_solicitacao_w		bigint;
nm_pessoa_fisica_w		varchar(255);
dt_nascimento_w			timestamp;
nr_telefone_w			varchar(40);
ds_email_w			varchar(255);
nr_cpf_w			varchar(14);
nr_ddd_w			varchar(2);
nr_ddi_w			varchar(2);
sg_uf_w				varchar(2);
cd_municipio_ibge_w		varchar(7);
cd_nacionalidade_w		varchar(8);
nr_reg_geral_estrang_w		varchar(30);
nr_seq_agente_motivador_w	bigint;
nm_contato_w			varchar(50);
nr_telefone_celular_w		varchar(40);
ds_endereco_w			varchar(255);
nr_endereco_w			varchar(10);
ds_complemento_w		varchar(100);
cd_pessoa_fisica_w		varchar(10);
ds_observacao_w			varchar(255);
qt_idade_w			bigint;

 

BEGIN 
 
select	max(nr_sequencia) 
into STRICT	nr_seq_solicitacao_w 
from	pls_solicitacao_comercial 
where	cd_estabelecimento	= cd_estabelecimento_p 
and	nr_seq_segurado		= nr_seq_segurado_p;
 
 
if (coalesce(nr_seq_solicitacao_w::text, '') = '') then 
	select	max(nr_seq_agente_motivador) 
	into STRICT	nr_seq_agente_motivador_w 
	from	pls_parametros 
	where	cd_estabelecimento	= cd_estabelecimento_p;
 
	if (coalesce(nr_seq_agente_motivador_w,0) = 0) then 
		select	max(nr_sequencia) 
		into STRICT	nr_seq_agente_motivador_w 
		from	pls_agente_motivador 
		where	cd_estabelecimento	= cd_estabelecimento_p;
	end if;
 
	select	a.nm_pessoa_fisica, 
		a.dt_nascimento, 
		substr(obter_compl_pf(a.cd_pessoa_fisica,1,'T'),1,40), 
		substr(obter_compl_pf(a.cd_pessoa_fisica,1,'M'),1,255), 
		substr(obter_compl_pf(a.cd_pessoa_fisica,1,'C'),1,14), 
		coalesce(substr(obter_compl_pf(a.cd_pessoa_fisica,1,'DDT'),1,2),' '), 
		coalesce(substr(obter_compl_pf(a.cd_pessoa_fisica,1,'DIT'),1,2),' '), 
		substr(obter_compl_pf(a.cd_pessoa_fisica,1,'UF'),1,2), 
		substr(obter_compl_pf(a.cd_pessoa_fisica,1,'CDM'),1,7), 
		a.cd_nacionalidade, 
		a.nr_reg_geral_estrang, 
		substr(obter_primeiro_nome(a.nm_pessoa_fisica),1,50), 
		a.nr_telefone_celular, 
		substr(obter_compl_pf(a.cd_pessoa_fisica,1,'E'),1,40), 
		substr(obter_compl_pf(a.cd_pessoa_fisica,1,'NR'),1,10), 
		substr(obter_compl_pf(a.cd_pessoa_fisica,1,'CO'),1,100), 
		obter_idade(a.dt_nascimento, clock_timestamp(),'A') 
	into STRICT	nm_pessoa_fisica_w, 
		dt_nascimento_w, 
		nr_telefone_w, 
		ds_email_w, 
		nr_cpf_w, 
		nr_ddd_w, 
		nr_ddi_w, 
		sg_uf_w, 
		cd_municipio_ibge_w, 
		cd_nacionalidade_w, 
		nr_reg_geral_estrang_w, 
		nm_contato_w, 
		nr_telefone_celular_w, 
		ds_endereco_w, 
		nr_endereco_w, 
		ds_complemento_w, 
		qt_idade_w 
	from	pessoa_fisica	a, 
		pls_segurado	b 
	where	a.cd_pessoa_fisica	= b.cd_pessoa_fisica 
	and	nr_sequencia		= nr_seq_segurado_p;
 
	select	nextval('pls_solicitacao_comercial_seq') 
	into STRICT	nr_seq_solicitacao_w 
	;
 
	insert into pls_solicitacao_comercial(	nr_sequencia, cd_estabelecimento, ie_status, nm_pessoa_fisica, dt_nascimento, 
		nr_telefone, dt_atualizacao, nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, 
		ds_email, dt_solicitacao, ie_origem_solicitacao, ie_tipo_contratacao, nr_cpf, 
		nr_ddi, nr_ddd, sg_uf_municipio, cd_municipio_ibge, cd_nacionalidade, 
		nr_reg_geral_estrang, nr_seq_agente_motivador, nm_contato, ie_etapa_solicitacao, nr_celular, 
		ds_endereco, nr_endereco, ds_complemento, ds_observacao, nr_seq_segurado, 
		qt_idade) 
	values (	nr_seq_solicitacao_w, cd_estabelecimento_p, 'PE', nm_pessoa_fisica_w, dt_nascimento_w, 
		coalesce(nr_telefone_w,' '), clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p, 
		ds_email_w, clock_timestamp(), 'F', 'I', nr_cpf_w, 
		nr_ddi_w, nr_ddd_w, sg_uf_w, cd_municipio_ibge_w, cd_nacionalidade_w, 
		nr_reg_geral_estrang_w, nr_seq_agente_motivador_w, nm_contato_w, 'T', nr_telefone_celular_w, 
		ds_endereco_w, nr_endereco_w, ds_complemento_w, 'Gerado atráves do fim de dependência do beneficiário', nr_seq_segurado_p, 
		qt_idade_w);
	CALL pls_atualizar_atividades_canal(nr_seq_solicitacao_w,null,'N',nm_usuario_p);
end if;
 
nr_seq_solicitacao_p	:= nr_seq_solicitacao_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_lead_fim_dependencia ( nr_seq_segurado_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, nr_seq_solicitacao_p INOUT bigint) FROM PUBLIC;
