-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_gerar_lote_digitacao ( nr_sequencia_p ctb_mes_ref.nr_sequencia%type, cd_estabelecimento_p lote_contabil.cd_estabelecimento%type, nm_usuario_p lote_contabil.nm_usuario%type, nr_lote_contabil_p INOUT lote_contabil.nr_lote_contabil%type, cd_tipo_lote_contabil_p lote_contabil.cd_tipo_lote_contabil%type default null) AS $body$
DECLARE


cd_tipo_lote_w		lote_contabil.cd_tipo_lote_contabil%type;
dt_referencia_w		lote_contabil.dt_referencia%type;
nr_lote_contabil_w	lote_contabil.nr_lote_contabil%type;


BEGIN

cd_tipo_lote_w := cd_tipo_lote_contabil_p;

if (coalesce(cd_tipo_lote_w, 0)  = 0) then
	select	max(campo_numerico(coalesce(vl_parametro, vl_parametro_padrao)))
	into STRICT	cd_tipo_lote_w
	from	funcao_parametro
	where	cd_funcao = 923
	and		nr_sequencia = 3;
end if;

if (cd_tipo_lote_w <> 0) then
	select	dt_referencia
	into STRICT	dt_referencia_w
	from	ctb_mes_ref
	where	nr_sequencia	= nr_sequencia_p;

	if (cd_tipo_lote_w = 59 and to_char(dt_referencia_w,'mm') <> 12) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(1214573);
	end if;

	select	coalesce(max(nr_lote_contabil),0) + 1
	into STRICT	nr_lote_contabil_w
	from	lote_contabil;

	insert into lote_contabil(
		nr_lote_contabil,
		dt_referencia,
		cd_tipo_lote_contabil,
		dt_atualizacao,
		nm_usuario,
		cd_estabelecimento,
		ie_situacao,
		vl_debito,
		vl_credito,
		dt_integracao,
		dt_atualizacao_saldo,
		dt_consistencia,
		nm_usuario_original,
		nr_seq_mes_ref,
		ie_encerramento,
		ds_observacao)
	values (	nr_lote_contabil_w,
		dt_referencia_w,
		cd_tipo_lote_w,
		clock_timestamp(),
		nm_usuario_p,
		cd_estabelecimento_p,
		'A', 0, 0, null, null, null,
		nm_usuario_p,
		nr_sequencia_p,
		'N',
		'');
end if;

commit;

nr_lote_contabil_p	:= nr_lote_contabil_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_gerar_lote_digitacao ( nr_sequencia_p ctb_mes_ref.nr_sequencia%type, cd_estabelecimento_p lote_contabil.cd_estabelecimento%type, nm_usuario_p lote_contabil.nm_usuario%type, nr_lote_contabil_p INOUT lote_contabil.nr_lote_contabil%type, cd_tipo_lote_contabil_p lote_contabil.cd_tipo_lote_contabil%type default null) FROM PUBLIC;

