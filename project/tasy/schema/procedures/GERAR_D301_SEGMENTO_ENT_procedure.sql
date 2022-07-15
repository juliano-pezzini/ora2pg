-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_d301_segmento_ent ( nr_seq_dataset_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_dataset_ret_w d301_segmento_ent.nr_seq_dataset_ret%type := null;
cd_cobranca_w        d301_segmento_ent.cd_cobranca%type;

c01 CURSOR FOR
SELECT 	a.dt_procedimento ds_dt_inicio_cobranca,
	a.nr_sequencia nr_sequencia,
	a.qt_procedimento qt_dias_calculo,
	a.vl_procedimento as vl_cobranca,
	null qt_item,
	null qt_dias_fora_calculo,
	null ds_dt_cura,
	null ds_dt_fim_cobranca
from 	d301_dataset_envio b,
	procedimento_paciente a
where	a.nr_interno_conta	= b.nr_interno_conta
and	b.nr_sequencia		= nr_seq_dataset_p
and	coalesce(a.cd_motivo_exc_conta::text, '') = '';

c01_w c01%rowtype;


BEGIN

open C01;
loop
fetch C01 into
	c01_w;
EXIT WHEN NOT FOUND; /* apply on C01 */

	cd_cobranca_w	:= obter_codigo_fat_301(c01_w.nr_Sequencia);

	insert into d301_segmento_ent(nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		cd_cobranca,
		vl_cobranca,
		ds_dt_inicio_cobranca,
		ds_dt_fim_cobranca,
		qt_dias_calculo,
		qt_dias_fora_calculo,
		ds_dt_cura,
		nr_seq_dataset,
		qt_item,
		nr_seq_dataset_ret)
	values (nextval('d301_segmento_ent_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		cd_cobranca_w,
		c01_w.vl_cobranca,
		to_char(c01_w.ds_dt_inicio_cobranca,'YYYYMMDD'),
		to_char(c01_w.ds_dt_inicio_cobranca,'YYYYMMDD'),
		c01_w.qt_dias_calculo,
		c01_w.qt_dias_fora_calculo,
		c01_w.ds_dt_cura,
		nr_seq_dataset_p,
		c01_w.qt_item,
		nr_seq_dataset_ret_w);

end loop;
close C01;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_d301_segmento_ent ( nr_seq_dataset_p bigint, nm_usuario_p text) FROM PUBLIC;

