-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_d301_segmento_rec ( nr_seq_dataset_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_301_indic_cobr_w     	d301_segmento_rec.nr_seq_301_indic_cobr%type;
nr_seq_301_indic_cobr_ped_w 	d301_segmento_rec.nr_seq_301_indic_cobr_ped%type;
nr_seq_dataset_ret_w       	d301_segmento_rec.nr_seq_dataset_ret%type := null;
nr_conta_banc_hosp_w		d301_segmento_rec.nr_conta_banc_hosp%type;
nr_ik_cobranca_w		d301_segmento_rec.nr_ik_cobranca%type;

  c01 CURSOR FOR


SELECT	a.nr_interno_conta,
	to_char(a.dt_acerto_conta,'yyyymmdd') ds_dt_conta,
	to_char(b.dt_entrada,'yyyymmdd') ds_dt_adimissao,
	coalesce(obter_valor_conta(a.nr_interno_conta, 0),0) vl_cobranca_conta,
	a.nr_seq_tipo_cobranca,
	a.cd_estabelecimento
from	conta_paciente a,
	atendimento_paciente b,
	d301_dataset_envio c
where	c.nr_sequencia		= nr_seq_dataset_p
and	c.nr_interno_conta	= a.nr_interno_conta
and	a.nr_atendimento	= b.nr_atendimento;

c01_w	c01%rowtype;


BEGIN

open C01;
loop
fetch C01 into
	c01_w;
EXIT WHEN NOT FOUND; /* apply on C01 */

	select	max(a.cd_cnes),
		substr(max(b.nr_conta),1,9)
	into STRICT	nr_ik_cobranca_w,
		nr_conta_banc_hosp_w
	FROM estabelecimento c, pessoa_juridica a
LEFT OUTER JOIN pessoa_juridica_conta b ON (a.cd_cgc = b.cd_cgc)
WHERE c.cd_estabelecimento	= c01_w.cd_estabelecimento and a.cd_cgc		= c.cd_cgc  and b.ie_situacao		= 'A';

	nr_seq_301_indic_cobr_w := obter_seq_valor_301('C301_11_INDIC_COBR','IE_INDICADOR','5');
	nr_seq_301_indic_cobr_ped_w := obter_seq_valor_301('C301_11_INDIC_COBR_PEDIDO','IE_PEDIDO',obter_conversao_301('C301_11_INDIC_COBR_PEDIDO','TIPO_COBRANCA_CONTA',null,c01_w.nr_seq_tipo_cobranca,'I'));

	insert into d301_segmento_rec(nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_ident_conta,
		ds_dt_conta,
		nr_seq_301_indic_cobr,
		nr_seq_301_indic_cobr_ped,
		ds_dt_admissao,
		vl_cobranca_conta,
		nr_conta_banc_hosp,
		nr_referencia_hosp,
		nr_ik_cobranca,
		nr_seq_dataset,
		nr_seq_dataset_ret)
	values (nextval('d301_segmento_rec_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		c01_w.nr_interno_conta,
		c01_w.ds_dt_conta,
		nr_seq_301_indic_cobr_w,
		nr_seq_301_indic_cobr_ped_w,
		c01_w.ds_dt_adimissao,
		c01_w.vl_cobranca_conta,
		nr_conta_banc_hosp_w,
		c01_w.nr_interno_conta,
		nr_ik_cobranca_w,
		nr_seq_dataset_p,
		nr_seq_dataset_ret_w);

end loop;
close C01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_d301_segmento_rec ( nr_seq_dataset_p bigint, nm_usuario_p text) FROM PUBLIC;
