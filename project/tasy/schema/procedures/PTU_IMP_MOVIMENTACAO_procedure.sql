-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ptu_imp_movimentacao ( nr_seq_protuto_p bigint, nr_seq_intercambio_p bigint, ds_conteudo_p text, nm_usuario_p text, ie_tipo_retorno_p text) AS $body$
DECLARE


nr_seq_movimento_w		bigint;
cd_unimed_ori_w			varchar(10);
cd_unimed_des_w			varchar(10);
dt_geracao_w			timestamp;
dt_geracao_ww			varchar(10)	:= null;
ie_tipo_mov_w			varchar(1);
dt_mov_ini_w			timestamp;
dt_mov_ini_ww			varchar(10)	:= null;
dt_mov_final_w			timestamp;
dt_mov_final_ww			varchar(10)	:= null;
nr_seq_versao_w			bigint;
ie_tipo_produto_w		varchar(2);
cd_unimed_w			varchar(10);
id_benef_w			varchar(13);
cd_mens_erro_w			smallint;
cd_unimed_cad_w			varchar(10);
id_benef_cad_w			varchar(13);
nr_seq_protuto_w		bigint;
nr_seq_intercambio_w		bigint;
nr_seq_benef_intercambio_w	bigint;


BEGIN
if (substr(ds_conteudo_p,9,3)	= '201') then

	select	CASE WHEN substr(ds_conteudo_p,12,4)='0' THEN ''  ELSE substr(ds_conteudo_p,12,4) END ,
		CASE WHEN substr(ds_conteudo_p,16,4)='0' THEN ''  ELSE substr(ds_conteudo_p,16,4) END ,
		CASE WHEN (substr(ds_conteudo_p,45,2))::numeric ='0' THEN ''  ELSE (substr(ds_conteudo_p,45,2))::numeric  END
	into STRICT	cd_unimed_ori_w,
		cd_unimed_des_w,
		nr_seq_versao_w
	;

	dt_geracao_ww	:= substr(ds_conteudo_p,26,2)||substr(ds_conteudo_p,24,2)||substr(ds_conteudo_p,20,4);
	if (dt_geracao_ww <> '        ') then
		dt_geracao_w	:= to_date(dt_geracao_ww,'dd/mm/yyyy');
	end if;
	ie_tipo_mov_w	:= substr(ds_conteudo_p,28,1);
	dt_mov_ini_ww	:= substr(ds_conteudo_p,35,2)||substr(ds_conteudo_p,33,2)||substr(ds_conteudo_p,29,4);

	if (dt_mov_ini_ww	<> '        ') then
		dt_mov_ini_w	:= to_date(dt_mov_ini_ww,'dd/mm/yyyy');
	end if;
	dt_mov_final_ww	:= substr(ds_conteudo_p,43,2)||substr(ds_conteudo_p,41,2)||substr(ds_conteudo_p,37,4);
	if (dt_mov_final_ww <> '        ') then
		dt_mov_final_w	:= to_date(dt_mov_final_ww,'dd/mm/yyyy');
	end if;
	ie_tipo_produto_w	:= substr(ds_conteudo_p,47,2);

	select	nextval('ptu_retorno_movimentacao_seq')
	into STRICT	nr_seq_movimento_w
	;

	insert into ptu_retorno_movimentacao(nr_sequencia, cd_unimed_destino, cd_unimed_origem,
		dt_geracao, ie_tipo_mov, dt_mov_inicio,
		dt_mov_fim, ie_operacao, dt_atualizacao,
		nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
		nr_versao_transacao, ie_tipo_produto, nr_seq_intercambio,
		nr_seq_mov_produto, ie_tipo_retorno, nr_seq_mov_benef_lote)
	values (nr_seq_movimento_w, cd_unimed_des_w, cd_unimed_ori_w,
		dt_geracao_w, ie_tipo_mov_w, dt_mov_ini_w,
		dt_mov_final_w, 'R' , clock_timestamp(),
		nm_usuario_p, clock_timestamp(), nm_usuario_p,
		nr_seq_versao_w, ie_tipo_produto_w, CASE WHEN ie_tipo_retorno_p='A1300' THEN null  ELSE nr_seq_intercambio_p END ,
		nr_seq_protuto_w, ie_tipo_retorno_p, CASE WHEN ie_tipo_retorno_p='A1300' THEN nr_seq_intercambio_p  ELSE null END );
end if;

if (substr(ds_conteudo_p,9,3)	= '202') then

	select	max(nr_sequencia)
	into STRICT	nr_seq_movimento_w
	from	ptu_retorno_movimentacao;

	select	CASE WHEN substr(ds_conteudo_p,12,4)='0' THEN ''  ELSE substr(ds_conteudo_p,12,4) END ,
		CASE WHEN substr(ds_conteudo_p,19,13)='0' THEN ''  ELSE substr(ds_conteudo_p,19,13) END ,
		CASE WHEN (substr(ds_conteudo_p,32,4))::numeric ='0' THEN ''  ELSE (substr(ds_conteudo_p,32,4))::numeric  END ,
		CASE WHEN substr(ds_conteudo_p,36,4)='0' THEN ''  ELSE substr(ds_conteudo_p,36,4) END ,
		CASE WHEN substr(ds_conteudo_p,40,13)='0' THEN ''  ELSE substr(ds_conteudo_p,40,13) END
	into STRICT	cd_unimed_w,
		id_benef_w,
		cd_mens_erro_w,
		cd_unimed_cad_w,
		id_benef_cad_w
	;

	if (coalesce(id_benef_w::text, '') = '') then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(262489);
		/* Mensagem: O código do beneficiário precisa ser informado! Favor verificar. */

	end if;

	begin
	select	max(a.nr_sequencia)
	into STRICT	nr_seq_benef_intercambio_w
	from	ptu_intercambio			c,
		ptu_intercambio_empresa		b,
		ptu_intercambio_benef		a
	where	a.nr_seq_empresa		= b.nr_sequencia
	and	b.nr_seq_intercambio		= c.nr_sequencia
	and	c.nr_sequencia			= nr_seq_intercambio_p
	and	a.cd_usuario_plano		= id_benef_w;
	exception
	when others then
		nr_seq_benef_intercambio_w	:= null;
	end;

	insert into ptu_retorno_mov_benef(nr_sequencia, nr_seq_retorno_mov, cd_unimed,
		cd_usuario_plano, cd_inconsistencia, dt_atualizacao,
		nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
		cd_unimed_cad, cd_usuario_plano_cad,nr_seq_benef_intercambio)
	values (nextval('ptu_retorno_mov_benef_seq'), nr_seq_movimento_w, cd_unimed_w,
		id_benef_w, cd_mens_erro_w, clock_timestamp(),
		nm_usuario_p, clock_timestamp(), nm_usuario_p,
		cd_unimed_cad_w, id_benef_cad_w,nr_seq_benef_intercambio_w);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ptu_imp_movimentacao ( nr_seq_protuto_p bigint, nr_seq_intercambio_p bigint, ds_conteudo_p text, nm_usuario_p text, ie_tipo_retorno_p text) FROM PUBLIC;

