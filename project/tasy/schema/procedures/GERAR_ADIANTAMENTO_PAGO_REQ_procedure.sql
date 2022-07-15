-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_adiantamento_pago_req (nr_requisicao_p bigint, cd_cgc_p text, vl_adiantamento_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_estabelecimento_w		integer;
cd_moeda_padrao_w			integer;
nr_adiantamento_w			bigint;


BEGIN

select	a.cd_estabelecimento,
		b.cd_moeda_padrao
into STRICT	cd_estabelecimento_w,
		cd_moeda_padrao_w
from	requisicao_material a,
		parametros_contas_pagar b
where	a.cd_estabelecimento = b.cd_estabelecimento
and		a.nr_requisicao = nr_requisicao_p;

select 	nextval('adiantamento_pago_seq')
into STRICT	nr_adiantamento_w
;

insert into adiantamento_pago(nr_adiantamento,
			cd_estabelecimento,
			dt_atualizacao,
			nm_usuario,
			dt_adiantamento,
			vl_adiantamento,
			vl_saldo,
			cd_moeda,
			cd_pessoa_fisica,
			cd_cgc,
			cd_banco,
			nr_lote_contabil,
			ds_observacao,
			dt_baixa,
			nr_seq_trans_fin,
			nr_titulo_original)
		values (nr_adiantamento_w,
			cd_estabelecimento_w,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			vl_adiantamento_p,
			vl_adiantamento_p,
			cd_moeda_padrao_w,
			null,
			cd_cgc_p,
			null,
			null,
			wheb_mensagem_pck.get_texto(300879, 'NR_REQUISICAO=' || nr_requisicao_p),
			null,
			null,
			null);

update	requisicao_material
set		nr_adiantamento = nr_adiantamento_w
where	nr_requisicao = nr_requisicao_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_adiantamento_pago_req (nr_requisicao_p bigint, cd_cgc_p text, vl_adiantamento_p bigint, nm_usuario_p text) FROM PUBLIC;

