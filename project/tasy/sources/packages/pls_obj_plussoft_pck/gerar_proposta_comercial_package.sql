-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_obj_plussoft_pck.gerar_proposta_comercial ( cd_pessoa_fisica_p bigint, cd_cgc_p bigint, nm_usuario_p text, --Parametros de saida
 ie_retorno_p INOUT bigint, ds_mensagem_erro_p INOUT text) AS $body$
DECLARE


nr_seq_cliente_w		bigint;
current_setting('pls_obj_plussoft_pck.cd_estabelecimento_w')::smallint		bigint;
qt_prospect_w			bigint;


BEGIN

select	count(1)
into STRICT	qt_prospect_w
from (SELECT	nr_sequencia
	from	pls_comercial_cliente
	where	cd_cgc = cd_cgc_p
	and	ie_status = 'C'
	
union all

	SELECT	nr_sequencia
	from	pls_comercial_cliente
	where	cd_pessoa_fisica = cd_pessoa_fisica_p
	and	ie_status = 'C') alias1;

ie_retorno_p := 0;

if (qt_prospect_w = 0) then
	begin
	--Usando fixo estabelecimento 1
	PERFORM set_config('pls_obj_plussoft_pck.cd_estabelecimento_w', 1, false);
	
	select 	nextval('pls_comercial_cliente_seq')
	into STRICT	nr_seq_cliente_w
	;
	
	insert into pls_comercial_cliente(nr_sequencia, ie_status, ie_fase_venda,
		dt_aprovacao, dt_proposta, ie_classificacao,
		cd_pessoa_fisica, cd_cgc, dt_atualizacao,
		nm_usuario, nm_usuario_nrec, dt_atualizacao_nrec,
		ie_origem_cliente, cd_estabelecimento)
	values (nr_seq_cliente_w, 'C', 'PA',
		clock_timestamp(), clock_timestamp(), 'P',
		cd_pessoa_fisica_p, cd_cgc_p, clock_timestamp(),
		nm_usuario_p, nm_usuario_p, clock_timestamp(),
		'PW', current_setting('pls_obj_plussoft_pck.cd_estabelecimento_w')::smallint);
	
	insert into pls_comercial_historico(nr_sequencia, nr_seq_cliente, dt_atualizacao,
		dt_atualizacao_nrec, nm_usuario, nm_usuario_nrec,
		nm_usuario_historico, ds_titulo, ie_tipo_atividade,
		ds_historico, dt_historico, cd_estabelecimento)
	values (nextval('pls_comercial_historico_seq'), nr_seq_cliente_w, clock_timestamp(),
		clock_timestamp(), nm_usuario_p, nm_usuario_p,
		nm_usuario_p, wheb_mensagem_pck.get_texto(1110542), 3,
		wheb_mensagem_pck.get_texto(1110543), clock_timestamp(), current_setting('pls_obj_plussoft_pck.cd_estabelecimento_w')::smallint);
	
	insert into pls_solicitacao_vendedor(nr_sequencia, dt_atualizacao, nm_usuario,
		dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_vendedor_canal,
		nr_seq_cliente, nr_seq_vendedor_vinculado, cd_estabelecimento)
	values (nextval('pls_solicitacao_vendedor_seq'), clock_timestamp(), nm_usuario_p,
		clock_timestamp(), nm_usuario_p, null,
		nr_seq_cliente_w, null, current_setting('pls_obj_plussoft_pck.cd_estabelecimento_w')::smallint);

	--Sucesso
	if (ie_retorno_p = 0) then
		commit;
	end if;
	exception
	when others then
		--Erro
		ie_retorno_p := 1;
		ds_mensagem_erro_p := substr(wheb_mensagem_pck.get_texto(1110544, 'DS_ERRO=' || sqlerrm(SQLSTATE)) ,1,255);
		rollback;
	end;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_obj_plussoft_pck.gerar_proposta_comercial ( cd_pessoa_fisica_p bigint, cd_cgc_p bigint, nm_usuario_p text,  ie_retorno_p INOUT bigint, ds_mensagem_erro_p INOUT text) FROM PUBLIC;