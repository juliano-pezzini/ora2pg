-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_mov_evento_cirurgia ( nr_seq_aten_pac_unid_p bigint) AS $body$
DECLARE

			
ie_alter_status_pas_cc_w 	varchar(1);
cd_unidade_basica_w			atend_paciente_unidade.cd_unidade_basica%TYPE;	
cd_unidade_compl_w			atend_paciente_unidade.cd_unidade_compl%TYPE;
cd_setor_atendimento_w		atend_paciente_unidade.cd_setor_atendimento%TYPE;


BEGIN

	BEGIN
		SELECT 	coalesce(c.ie_alter_status_pas_cc, 'N'),
				a.cd_unidade_basica,
				a.cd_unidade_compl,
				a.cd_setor_atendimento
		INTO STRICT 	ie_alter_status_pas_cc_w,
				cd_unidade_basica_w,
				cd_unidade_compl_w,
				cd_setor_atendimento_w
		FROM 	atend_paciente_unidade a,
				evento_cirurgia_paciente b,
				evento_cirurgia c
		WHERE 	a.nr_seq_interno	= b.nr_seq_aten_pac_unid
		AND		b.nr_seq_evento		= c.nr_sequencia
		AND 	a.nr_seq_interno 	= nr_seq_aten_pac_unid_p;
	EXCEPTION
	WHEN OTHERS THEN
		ie_alter_status_pas_cc_w := 'N';
	END;

	BEGIN
		DELETE
		FROM	atend_paciente_unidade
		WHERE 	nr_seq_interno = nr_seq_aten_pac_unid_p;

		IF (coalesce(ie_alter_status_pas_cc_w, 'N') = 'S'
				AND (cd_unidade_basica_w IS NOT NULL AND cd_unidade_basica_w::text <> '')
				AND (cd_unidade_compl_w IS NOT NULL AND cd_unidade_compl_w::text <> '')
				AND (cd_setor_atendimento_w IS NOT NULL AND cd_setor_atendimento_w::text <> '')) THEN
		
			UPDATE  unidade_atendimento a
			SET     a.ie_status_unidade   	= 	a.ie_status_ant_unidade
			WHERE	a.cd_unidade_basica 	=  	cd_unidade_basica_w
			AND 	a.cd_unidade_compl  	= 	cd_unidade_compl_w
			AND		a.cd_setor_atendimento 	= 	cd_setor_atendimento_w;
		
		END IF;

	EXCEPTION
	WHEN OTHERS THEN
		CALL wheb_mensagem_pck.Exibir_Mensagem_Abort(1091751);
	END;

	COMMIT;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_mov_evento_cirurgia ( nr_seq_aten_pac_unid_p bigint) FROM PUBLIC;
