-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE desfazer_liberar_resultado (nr_seq_resultado_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_w				bigint;

c01 CURSOR FOR
SELECT	a.nr_seq_resultado,
				a.nr_seq_exame,
				clock_timestamp(),
				nm_usuario_p,
				a.qt_resultado,
				a.ds_resultado,
				a.nr_seq_metodo,
				a.nr_seq_material,
				a.pr_resultado,
				a.ie_status,
				b.dt_liberacao,
				a.nm_usuario_aprovacao,
				a.nr_seq_prescr,
				a.pr_minimo,
				a.pr_maximo,
				a.qt_minima,
				a.qt_maxima,
				a.ds_observacao,
				a.ds_referencia,
				a.ds_unidade_medida,
				a.qt_decimais,
				a.ds_regra,
				a.dt_coleta,
				a.nr_seq_reagente,
				a.nr_seq_formato,
				a.cd_medico_resp,
				a.dt_impressao,
				a.nr_seq_unid_med,
				a.cd_equipamento
		from 	exame_lab_result_item a,
				exame_lab_resultado b
		where 	a.nr_seq_resultado	= nr_seq_resultado_p
		and 	a.nr_seq_resultado = b.nr_seq_resultado;

BEGIN

for item in c01 loop
   select  coalesce(max(nr_sequencia),0)+1
        into STRICT    nr_seq_w
        from    w_exame_lab_result_item
        where     nr_seq_resultado    = nr_seq_resultado_p;

  insert into w_exame_lab_result_item(
        nr_seq_resultado,
        nr_sequencia,
        nr_seq_exame,
        dt_atualizacao,
        nm_usuario,
        qt_resultado,
        ds_resultado,
        nr_seq_metodo,
        nr_seq_material,
        pr_resultado,
        ie_status,
        dt_aprovacao,
        nm_usuario_aprovacao,
        nr_seq_prescr,
        pr_minimo,
        pr_maximo,
        qt_minima,
        qt_maxima,
        ds_observacao,
        ds_referencia,
        ds_unidade_medida,
        qt_decimais,
        ds_regra,
        dt_coleta,
        nr_seq_reagente,
        nr_seq_formato,
        cd_medico_resp,
        dt_impressao,
        nr_seq_unid_med,
        cd_equipamento
      )
      values (
          item.nr_seq_resultado,
          nr_seq_w,
          item.nr_seq_exame,
          clock_timestamp(),
          nm_usuario_p,
          item.qt_resultado,
          item.ds_resultado,
          item.nr_seq_metodo,
          item.nr_seq_material,
          item.pr_resultado,
          item.ie_status,
          item.dt_liberacao,
          item.nm_usuario_aprovacao,
          item.nr_seq_prescr,
          item.pr_minimo,
          item.pr_maximo,
          item.qt_minima,
          item.qt_maxima,
          item.ds_observacao,
          item.ds_referencia,
          item.ds_unidade_medida,
          item.qt_decimais,
          item.ds_regra,
          item.dt_coleta,
          item.nr_seq_reagente,
          item.nr_seq_formato,
          item.cd_medico_resp,
          item.dt_impressao,
          item.nr_seq_unid_med,
          item.cd_equipamento
    );
end loop;

update	EXAME_LAB_RESULTADO
set	dt_liberacao  = NULL,
	dt_atualizacao		= clock_timestamp(),
	nm_usuario		= nm_usuario_p
where	nr_seq_resultado	= nr_seq_resultado_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE desfazer_liberar_resultado (nr_seq_resultado_p bigint, nm_usuario_p text) FROM PUBLIC;

