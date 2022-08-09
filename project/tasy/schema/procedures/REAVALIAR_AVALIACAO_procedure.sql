-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE reavaliar_avaliacao ( ie_tipo_p text, nr_seq_avaliacao_p bigint, nm_usuario_p text) AS $body$
DECLARE

		 
nr_sequencia_avaliacao_w	bigint;
cd_pessoa_fisica_w		bigint;
nr_atendimento_w		bigint;
nr_seq_tipo_avaliacao_w		bigint;
nr_seq_atend_checklist_w	bigint;
nr_seq_checklist_item_w		bigint;	
cd_medico_w			bigint;
	
C01 CURSOR FOR 	--Busca dependencia do item atual reavaliado; 
	SELECT	max(b.nr_seq_avaliacao), 
		max(b.nr_sequencia)		 
	FROM	checklist_proc_item_depend a, 
		checklist_processo_item b 
	WHERE	b.nr_sequencia = a.nr_seq_item_dependencia 
	AND	a.nr_seq_check_proc_item = nr_seq_checklist_item_w;

	 

BEGIN 
if (coalesce(nr_seq_avaliacao_p,0) > 0) then 
	 
	SELECT	MAX(a.cd_pessoa_fisica), 
		MAX(a.nr_atendimento), 
		MAX(a.nr_seq_tipo_avaliacao), 
		MAX(a.nr_seq_atend_checklist), 
		MAX(a.nr_seq_checklist_item), 
		MAX(a.cd_medico) 
	INTO STRICT	cd_pessoa_fisica_w, 
		nr_atendimento_w, 
		nr_seq_tipo_avaliacao_w, 
		nr_seq_atend_checklist_w, 
		nr_seq_checklist_item_w, 
		cd_medico_w 
	FROM	med_avaliacao_paciente a 
	WHERE	a.nr_sequencia = nr_seq_avaliacao_p;
	 
	if (coalesce(nr_seq_checklist_item_w,0) > 0) THEN 
	 
		SELECT nextval('med_avaliacao_paciente_seq') 
		INTO STRICT 	nr_sequencia_avaliacao_w 
		;		
		 
		INSERT INTO med_avaliacao_paciente(nr_sequencia,			 
			dt_atualizacao, 
			nm_usuario, 
			dt_atualizacao_nrec, 
			nm_usuario_nrec, 
			dt_avaliacao, 
			cd_pessoa_fisica, 
			cd_medico, 
			nr_atendimento,			 
			nr_seq_tipo_avaliacao, 
			nr_seq_atend_checklist, 
			nr_seq_checklist_item, 
			ie_atualiza_macro) 
		VALUES ( 
			nr_sequencia_avaliacao_w, 
			clock_timestamp(), 
			nm_usuario_p, 
			clock_timestamp(), 
			nm_usuario_p, 
			clock_timestamp(), 
			cd_pessoa_fisica_w, 
			cd_medico_w, 
			nr_atendimento_w, 
			nr_seq_tipo_avaliacao_w, 
			nr_seq_atend_checklist_w, 
			nr_Seq_checklist_item_w, 
			'S');				
	END IF;
		 
	IF ((ie_tipo_p = 'D') AND (coalesce(nr_seq_checklist_item_w,0) > 0)) THEN --criar registros de reavaliação para as avaliações dependentes 
		 
		OPEN C01;
		LOOP 
		FETCH C01 INTO 
			nr_seq_tipo_avaliacao_w, 
			nr_seq_checklist_item_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			BEGIN	 
			if (coalesce(nr_seq_tipo_avaliacao_w, 0) > 0) and (coalesce(nr_seq_checklist_item_w, 0) > 0) then 
			 
				SELECT nextval('med_avaliacao_paciente_seq') 
				INTO STRICT 	nr_sequencia_avaliacao_w 
				;		
			 
				INSERT INTO med_avaliacao_paciente(nr_sequencia,			 
					dt_atualizacao, 
					nm_usuario, 
					dt_atualizacao_nrec, 
					nm_usuario_nrec, 
					dt_avaliacao, 
					cd_pessoa_fisica, 
					cd_medico, 
					nr_atendimento,				 
					nr_seq_tipo_avaliacao, 
					nr_seq_atend_checklist, 
					nr_seq_checklist_item, 
					ie_atualiza_macro) 
				VALUES ( 
					nr_sequencia_avaliacao_w, 
					clock_timestamp(), 
					nm_usuario_p, 
					clock_timestamp(), 
					nm_usuario_p, 
					clock_timestamp(), 
					cd_pessoa_fisica_w, 
					cd_medico_w, 
					nr_atendimento_w, 
					nr_seq_tipo_avaliacao_w, 
					nr_seq_atend_checklist_w, 
					nr_Seq_checklist_item_w, 
					'S');									
			END IF;
			END;
		END LOOP;
		CLOSE C01;				
		END IF;	
	END IF;
COMMIT;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE reavaliar_avaliacao ( ie_tipo_p text, nr_seq_avaliacao_p bigint, nm_usuario_p text) FROM PUBLIC;
