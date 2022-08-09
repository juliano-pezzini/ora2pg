-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_baixar_aih_paga ( nr_seq_protocolo_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
nr_aih_w		bigint;
vl_pago_w		double precision;

nr_titulo_w		bigint;
cd_estabelecimento_w	smallint;

nr_seq_trans_w		bigint;
cd_banco_w		smallint	:= null;
cd_agencia_w		varchar(8)	:= null;
cd_tipo_receb_w		integer;

cd_moeda_w		integer;

nr_sequencia_w		bigint;

C01 CURSOR FOR 
	SELECT	nr_aih, 
		sum(coalesce(VL_SH,0) + coalesce(VL_SP,0) + coalesce(VL_SADT,0) + coalesce(VL_SANGUE,0) + coalesce(VL_OPM,0) + 
		  coalesce(VL_RNATO,0) + coalesce(VL_S_RATEIO,0) + coalesce(VL_ANALG,0) + coalesce(VL_PEDCON,0)) 
	from sus_aih_paga 
	where nr_seq_protocolo = nr_seq_protocolo_p;

BEGIN
select	nr_titulo, 
	cd_estabelecimento 
into STRICT	nr_titulo_w, 
	cd_estabelecimento_w 
from	titulo_receber 
where	nr_seq_protocolo = nr_seq_protocolo_p;
 
select max(a.nr_seq_trans_fin_conv_ret), 
	max(a.cd_tipo_receb_conv_ret) 
into STRICT	nr_seq_trans_w, 
	cd_tipo_receb_w 
from	parametro_contas_receber a 
where a.cd_estabelecimento = cd_estabelecimento_w;
 
select cd_moeda_padrao 
into STRICT cd_moeda_w 
from parametro_contas_receber 
where cd_estabelecimento = cd_estabelecimento_w;
 
open C01;
loop 
fetch C01 into	nr_aih_w, 
		vl_pago_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
 
	select coalesce(max(nr_sequencia),0) + 1 
	into STRICT nr_sequencia_w 
	from titulo_receber_liq 
	where nr_titulo = nr_titulo_w;
 
	insert into titulo_receber_liq(nr_titulo, 
		nr_sequencia, 
		dt_recebimento, 
		vl_recebido, 
		vl_descontos, 
		vl_juros, 
		vl_multa, 
		cd_moeda, 
		dt_atualizacao, 
		nm_usuario, 
		cd_tipo_recebimento, 
		ie_acao, 
		cd_serie_nf_devol, 
		nr_nota_fiscal_devol, 
		cd_banco, 
		cd_agencia_bancaria, 
		nr_documento, nr_lote_banco, 
		cd_cgc_emp_cred, 
		nr_cartao_cred, 
		nr_adiantamento, 
		nr_lote_contabil, 
		nr_seq_trans_fin, 
		vl_rec_maior, 
		vl_glosa, 
		nr_seq_retorno, 
		vl_adequado, 
		nr_seq_ret_item, 
		ie_lib_caixa, 
		nr_lote_contab_antecip, 
		nr_lote_contab_pro_rata) 
	values (nr_titulo_w, 
		nr_sequencia_w, 
		clock_timestamp(), 
		vl_pago_w, 0, 
		0, 
		0, 
		cd_moeda_w, 
		clock_timestamp(), 
		nm_usuario_p, 
		cd_tipo_Receb_w, 
		'I', 
		null, 
		null, 
		cd_banco_w, 
		cd_agencia_w, 
		nr_aih_w, 
		null, 
		null, 
		null, 
		null, 
		null, 
		nr_seq_trans_w, 
		0, 
		0, 
		null, 
		0, 
		null, 
		'S', 
		0, 
		0);
	 
	CALL atualizar_saldo_tit_rec(nr_titulo_w, nm_usuario_p);
 
end loop;
close C01;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_baixar_aih_paga ( nr_seq_protocolo_p bigint, nm_usuario_p text) FROM PUBLIC;
