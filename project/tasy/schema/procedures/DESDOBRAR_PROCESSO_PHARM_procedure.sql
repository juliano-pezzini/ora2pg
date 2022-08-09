-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE desdobrar_processo_pharm ( nr_processo_p bigint, nr_seq_pmh_p bigint, nr_seq_area_prep_p bigint, nm_usuario_p text, nr_processo_desdobrado_p INOUT bigint) AS $body$
DECLARE


nr_processo_w			bigint;
nr_etiquetas_desdobrar_w	varchar(1000);
tam_lista_w			bigint;
ie_pos_virgula_w		integer;
nr_seq_etiqueta_w		bigint;
nr_prescricao_w			bigint;
cont_w				bigint;
nr_seq_material_w		integer;


BEGIN
IF (nr_processo_p IS NOT NULL AND nr_processo_p::text <> '') AND (nr_seq_pmh_p IS NOT NULL AND nr_seq_pmh_p::text <> '') AND (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') THEN
	BEGIN

	SELECT	nextval('adep_processo_seq')
	INTO STRICT	nr_processo_w
	;

	INSERT INTO adep_processo(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_processo,
		ie_tipo_processo,
		nr_atendimento,
		dt_horario_processo,
		ie_status_processo,
		cd_setor_atendimento,
		cd_local_estoque,
		dt_processo,
		nm_usuario_processo,
		dt_dispensacao,
		nm_usuario_dispensacao,
		dt_retirada,
		nm_usuario_retirada,
		cd_pessoa_retirada,
		dt_leitura,
		nm_usuario_leitura,
		dt_preparo,
		nm_usuario_preparo,
		dt_paciente,
		nm_usuario_paciente,
		cd_funcao_origem,
		ie_origem_processo,
		ie_gedipa,
		ie_urgente,
		cd_intervalo,
		ie_acm,
		ie_se_necessario,
		ie_dose_especial)
	SELECT	nr_processo_w,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_processo_p,
		ie_tipo_processo,
		nr_atendimento,
		dt_horario_processo,
		ie_status_processo,
		cd_setor_atendimento,
		cd_local_estoque,
		clock_timestamp(),
		nm_usuario_p,
		dt_dispensacao,
		nm_usuario_dispensacao,
		dt_retirada,
		nm_usuario_retirada,
		cd_pessoa_retirada,
		null,
		null,
		null,
		null,
		dt_paciente,
		nm_usuario_paciente,
		cd_funcao_origem,
		ie_origem_processo,
		ie_gedipa,
		coalesce(ie_urgente, 'N'),
		cd_intervalo,
		ie_acm,
		ie_se_necessario,
		ie_dose_especial
	FROM	adep_processo
	WHERE	nr_sequencia = nr_processo_p;

	commit;
	nr_seq_etiqueta_w	:= nr_seq_pmh_p;

	select	count(*)
	into STRICT	cont_w
	from	adep_processo
	where	nr_sequencia = nr_processo_w;

		IF (nr_seq_etiqueta_w > 0) and (cont_w > 0) THEN

			SELECT	nr_prescricao,
				nr_seq_material
			INTO STRICT	nr_prescricao_w,
				nr_seq_material_w
			FROM	prescr_mat_hor
			WHERE	nr_sequencia	= nr_seq_etiqueta_w
			AND	Obter_se_horario_liberado(dt_lib_horario, dt_horario) = 'S';

			UPDATE	prescr_mat_hor
			SET	nr_seq_processo	= nr_processo_w
			WHERE	nr_sequencia	= nr_seq_etiqueta_w;

			commit;

			UPDATE	prescr_mat_hor
			SET	nr_seq_processo	= nr_processo_w
			WHERE	nr_seq_processo	= nr_processo_p
			AND	nr_prescricao	= nr_prescricao_w
			AND	nr_seq_superior	= nr_seq_material_w
			AND	Obter_se_horario_liberado(dt_lib_horario, dt_horario) = 'S';

			commit;

			UPDATE	adep_processo_frac a
			SET	a.nr_seq_processo	= nr_processo_w
			WHERE	a.nr_seq_processo	= nr_processo_p
			AND	EXISTS (
					SELECT	1
					FROM	prescr_mat_hor b
					WHERE	b.nr_seq_processo	= nr_processo_w
					AND	b.nr_seq_etiqueta	= a.nr_sequencia);

			commit;

			UPDATE	adep_processo_item a
			SET	a.nr_seq_processo	= nr_processo_w
			WHERE	a.nr_seq_processo	= nr_processo_p
			AND	EXISTS (
					SELECT	1
					FROM	prescr_mat_hor b
					WHERE	b.nr_sequencia		= a.nr_seq_horario
					AND	b.nr_seq_processo	= nr_processo_w);

			commit;

		END IF;

		END;

	commit;

	CALL atual_adep_proc_area_desdobr(nr_processo_p, nr_processo_w, nm_usuario_p);

END IF;

COMMIT;

nr_processo_desdobrado_p	:= nr_processo_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE desdobrar_processo_pharm ( nr_processo_p bigint, nr_seq_pmh_p bigint, nr_seq_area_prep_p bigint, nm_usuario_p text, nr_processo_desdobrado_p INOUT bigint) FROM PUBLIC;
