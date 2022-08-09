-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gravar_solic_alt_analise ( vl_campo_old_p text, vl_campo_new_p text, nm_campo_p text, nm_tabela_p text, cd_pessoa_fisica_p text, nm_usuario_p text, ie_tipo_solicitacao_p text, nr_seq_contrato_p bigint, ie_tipo_login_solic_p text, ie_tipo_complemento_p text, cd_estabelecimento_p bigint, cd_funcao_origem_p bigint, nr_seq_solicitacao_p INOUT bigint) AS $body$
DECLARE

 
nr_seq_solic_w		bigint;
ds_chave_simples_w	varchar(255);
ds_chave_composta_w	varchar(500);
qt_alteracoes_w		bigint;


BEGIN 
 
select	max(a.nr_sequencia) 
into STRICT	nr_seq_solic_w 
from	tasy_solic_alteracao a, 
	tasy_solic_alt_campo b 
where	a.nr_sequencia = b.nr_seq_solicitacao 
and	upper(nm_tabela)	= upper(nm_tabela_p) 
and	upper(nm_atributo)	= upper(nm_campo_p) 
and	((ds_chave_simples	= cd_pessoa_fisica_p) 
or (substr(ds_chave_composta,1,length('CD_PESSOA_FISICA='||cd_pessoa_fisica_p)) = 'CD_PESSOA_FISICA='||cd_pessoa_fisica_p)) 
and	ds_valor_old		= vl_campo_old_p 
and	ds_valor_new		= vl_campo_new_p 
and	coalesce(dt_analise::text, '') = '';
 
 
if (coalesce(nr_seq_solic_w,0) = 0) then 
 
	select	max(a.nr_sequencia) 
	into STRICT	nr_seq_solic_w 
	from	tasy_solic_alteracao a, 
		tasy_solic_alt_campo b 
	where	coalesce(a.dt_analise::text, '') = '' 
	and	a.nr_sequencia = b.nr_seq_solicitacao 
	and	b.nm_tabela in ('PESSOA_FISICA', 'COMPL_PESSOA_FISICA') 
	and (b.ds_chave_simples = cd_pessoa_fisica_p 
		or substr(ds_chave_composta,1,length('CD_PESSOA_FISICA='||cd_pessoa_fisica_p)) = 'CD_PESSOA_FISICA='||cd_pessoa_fisica_p);
 
	/* Se não encontrar uma solicitação em aberto, abre uma nova */
 
	if (coalesce(nr_seq_solic_w,0) = 0) then 
		 
		select	nextval('tasy_solic_alteracao_seq') 
		into STRICT	nr_seq_solic_w 
		;
		 
		insert into tasy_solic_alteracao( 
			nr_sequencia, 
			dt_atualizacao, 
			nm_usuario, 
			dt_atualizacao_nrec, 
			nm_usuario_nrec, 
			ie_processo, 
			ie_tipo_solicitacao, 
			nr_seq_contrato, 
			ie_status, 
			cd_estabelecimento, 
			cd_funcao 
		) values ( 
			nr_seq_solic_w, 
			clock_timestamp(), 
			substr(nm_usuario_p,1,15), 
			clock_timestamp(), 
			substr(nm_usuario_p,1,15), 
			'M', 
			ie_tipo_solicitacao_p, 
			nr_seq_contrato_p, 
			'A', 
			cd_estabelecimento_p, 
			cd_funcao_origem_p 
		);
		 
		commit;
		 
	end if;
 
	/* Monta a chave das tabelas */
 
	if (upper(nm_tabela_p) = 'PESSOA_FISICA') then 
		ds_chave_simples_w := cd_pessoa_fisica_p;
	elsif (upper(nm_tabela_p) = 'COMPL_PESSOA_FISICA') then 
		ds_chave_composta_w := 'CD_PESSOA_FISICA='||cd_pessoa_fisica_p||'#@#@IE_TIPO_COMPLEMENTO='||coalesce(ie_tipo_complemento_p,1);
	end if;
 
	/* Insere o campo alterado na solicitação em aberto */
 
	insert into tasy_solic_alt_campo( 
		nr_sequencia, 
		nm_tabela, 
		nm_atributo, 
		ds_chave_simples, 
		ds_chave_composta, 
		nr_seq_solicitacao, 
		ie_status, 
		ds_valor_old, 
		ds_valor_new, 
		dt_atualizacao, 
		nm_usuario, 
		dt_atualizacao_nrec, 
		nm_usuario_nrec, 
		ie_tipo_login_solic 
	) values ( 
		nextval('tasy_solic_alt_campo_seq'), 
		upper(nm_tabela_p), 
		upper(nm_campo_p), 
		ds_chave_simples_w, 
		ds_chave_composta_w, 
		nr_seq_solic_w, 
		'P', 
		vl_campo_old_p, 
		vl_campo_new_p, 
		clock_timestamp(), 
		substr(nm_usuario_p,1,15), 
		clock_timestamp(), 
		substr(nm_usuario_p,1,15), 
		ie_tipo_login_solic_p 
	);
		 
	commit;
	 
	CALL pls_gerar_ci_solic_portal_web(4,null,null,null,cd_pessoa_fisica_p,null,substr(nm_usuario_p,1,15));
end if;
 
nr_seq_solicitacao_p := nr_seq_solic_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gravar_solic_alt_analise ( vl_campo_old_p text, vl_campo_new_p text, nm_campo_p text, nm_tabela_p text, cd_pessoa_fisica_p text, nm_usuario_p text, ie_tipo_solicitacao_p text, nr_seq_contrato_p bigint, ie_tipo_login_solic_p text, ie_tipo_complemento_p text, cd_estabelecimento_p bigint, cd_funcao_origem_p bigint, nr_seq_solicitacao_p INOUT bigint) FROM PUBLIC;
