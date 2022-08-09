-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE rep_copia_banco_sangue (nr_prescricao_orig_p bigint, nr_prescricao_p bigint, ie_copia_bs_p text, nr_seq_solic_p INOUT bigint, nr_seq_regra_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_bco_w		bigint;


BEGIN

if (ie_copia_bs_p = 'S') then
	begin
	select	nextval('prescr_solic_bco_sangue_seq')
	into STRICT	nr_seq_bco_w
	;

	nr_seq_solic_p	:= nr_seq_bco_w;

	insert into prescr_solic_bco_sangue(
		nr_sequencia,
		nr_prescricao,
		dt_atualizacao,
		nm_usuario,
		ds_diagnostico,
		qt_transf_anterior,
		nr_seq_reacao,
		ie_tipo_paciente,
		ie_porte_cirurgico,
		ie_tipo,
		dt_programada,
		qt_plaqueta,
		qt_hemoglobina,
		qt_hematocrito,
		qt_tap,
		qt_tap_inr,
		ds_coagulopatia,
		ie_trans_anterior,
		nr_prescricao_original,
		ie_gravidez)
	SELECT	nr_seq_bco_w,
		nr_prescricao_p,
		clock_timestamp(),
		nm_usuario_p,
		ds_diagnostico,
		qt_transf_anterior,
		nr_seq_reacao,
		ie_tipo_paciente,
		ie_porte_cirurgico,
		ie_tipo,
		NULL,
		qt_plaqueta,
		qt_hemoglobina,
		qt_hematocrito,
		qt_tap,
		qt_tap_inr,
		ds_coagulopatia,
		ie_trans_anterior,
		nr_prescricao_orig_p,
		ie_gravidez
	from	prescr_solic_bco_sangue
	where	nr_prescricao	= nr_prescricao_orig_p
	and	nr_sequencia	= (	SELECT	max(a.nr_sequencia)
					from	prescr_solic_bco_sangue a
					where	a.nr_prescricao = nr_prescricao_orig_p)
	and	not exists (	select	1
				from	prescr_solic_bco_sangue b
				where	b.nr_prescricao = nr_prescricao_p);

	insert into prescr_sol_bs_indicacao(
		nr_sequencia,
		nr_seq_solic_bs,
		dt_atualizacao,
		nm_usuario,
		nr_seq_indicacao,
		ds_indicacao_adic,
		ie_grupo_hemocom)
	SELECT	nextval('prescr_sol_bs_indicacao_seq'),
		nr_seq_bco_w,
		clock_timestamp(),
		nm_usuario_p,
		b.nr_seq_indicacao,
		b.ds_indicacao_adic,
		b.ie_grupo_hemocom
	from	prescr_sol_bs_indicacao b,
		prescr_solic_bco_sangue a
	where	a.nr_prescricao	= nr_prescricao_orig_p
	and	b.nr_seq_solic_bs = a.nr_sequencia
	and	exists (	SELECT	1
				from	prescr_solic_bco_sangue x
				where	x.nr_sequencia = nr_seq_bco_w);
	end;

	commit;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE rep_copia_banco_sangue (nr_prescricao_orig_p bigint, nr_prescricao_p bigint, ie_copia_bs_p text, nr_seq_solic_p INOUT bigint, nr_seq_regra_p bigint, nm_usuario_p text) FROM PUBLIC;
