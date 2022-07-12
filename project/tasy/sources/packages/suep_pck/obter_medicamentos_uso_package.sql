-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION suep_pck.obter_medicamentos_uso (cd_pessoa_fisica_p text, nr_atendimento_p bigint, nr_seq_suep_p bigint, nm_usuario_p text) RETURNS SETOF T_MEDICAMENTO_USO_ROW_DATA AS $body$
DECLARE

 
t_medicamento_row_w			t_medicamento_row;

C01 CURSOR FOR 
		SELECT a.cd_material, 
			a.ds_medicamento, 
			a.dt_inicio, 
			a.cd_unid_med, 
			a.qt_dose, 
			a.cd_intervalo 
		FROM paciente_medic_uso a 
		WHERE cd_pessoa_fisica = cd_pessoa_fisica_p 
		AND (dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') 
		AND (dt_inicio IS NOT NULL AND dt_inicio::text <> '') 
		AND coalesce(dt_fim::text, '') = '' 
	ORDER BY dt_atualizacao DESC;

 
BEGIN 
 
FOR r_c01 IN c01 LOOP 
	BEGIN 
	t_medicamento_row_w.cd_material				:= r_c01.cd_material;
	t_medicamento_row_w.ds_medicamento			:= r_c01.ds_medicamento;
	t_medicamento_row_w.dt_inicio				:= r_c01.dt_inicio;
	t_medicamento_row_w.cd_unid_med				:= r_c01.cd_unid_med;
	t_medicamento_row_w.qt_dose					:= r_c01.qt_dose;
	t_medicamento_row_w.cd_intervalo			:= r_c01.cd_intervalo;
	 
	RETURN NEXT t_medicamento_row_w;
 
	END;
END LOOP;
 
RETURN;
 
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION suep_pck.obter_medicamentos_uso (cd_pessoa_fisica_p text, nr_atendimento_p bigint, nr_seq_suep_p bigint, nm_usuario_p text) FROM PUBLIC;
