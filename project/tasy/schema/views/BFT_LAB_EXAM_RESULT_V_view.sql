-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW bft_lab_exam_result_v (result_id, exame_id, exam_name, exam_code, exam_interface_code, exam_date, exam_comments, units, references_range, exam_numeric_result, exam_description_result, value_type) AS select	a.nr_seq_resultado result_id,
	a.nr_sequencia exame_id,
	b.nm_exame exam_name,
	b.cd_exame exam_code,
	b.cd_exame_integracao exam_interface_code,
	a.dt_aprovacao exam_date,
	a.ds_observacao exam_comments,
	a.ds_unidade_medida units,
	a.ds_referencia references_range,
	a.qt_resultado exam_numeric_result,
	null exam_description_result,
	'NM' value_type
FROM	exame_lab_result_item a,
	exame_laboratorio b
where	a.nr_seq_exame	= b.nr_seq_exame
and (a.qt_resultado is not null)

union all

select	a.nr_seq_resultado result_id,
	a.nr_sequencia exame_id,
	b.nm_exame exam_name,
	b.cd_exame exam_code,
	b.cd_exame_integracao exam_interface_code,
	a.dt_aprovacao exam_date,
	a.ds_observacao exam_comments,
	a.ds_unidade_medida units,
	a.ds_referencia references_range,
	a.pr_resultado exam_numeric_result,
	null exam_description_result,
	'NM' value_type
from	exame_lab_result_item a,
	exame_laboratorio b
where	a.nr_seq_exame	= b.nr_seq_exame
and (a.pr_resultado is not null)

union all

select	a.nr_seq_resultado result_id,
	a.nr_sequencia exame_id,
	b.nm_exame exam_name,
	b.cd_exame exam_code,
	b.cd_exame_integracao exam_interface_code,
	a.dt_aprovacao exam_date,
	a.ds_observacao exam_comments,
	a.ds_unidade_medida units,
	a.ds_referencia references_range,
	null exam_numeric_result,
	a.ds_resultado exam_description_result,
	'ST' value_type
from	exame_lab_result_item a,
	exame_laboratorio b
where	a.nr_seq_exame	= b.nr_seq_exame
and (a.ds_resultado is not null);
