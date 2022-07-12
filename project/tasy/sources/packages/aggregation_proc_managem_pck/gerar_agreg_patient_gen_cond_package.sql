-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE aggregation_proc_managem_pck.gerar_agreg_patient_gen_cond (NR_SEQ_DAILY_REPORT_P bigint, CD_ESTABELECIMENTO_P bigint, IE_MAIN_FLAG_P bigint) AS $body$
DECLARE


IE_GENDER_W                 varchar(10);
IE_CLASSIFICATION_W         varchar(15);
QT_AGE_W                    bigint;
CD_WARD_W                   bigint;
IE_EXIST_W                  bigint;
CD_PATIENT_W                ATENDIMENTO_PACIENTE.CD_PESSOA_FISICA%TYPE;
DT_ENTRADA_W                ATENDIMENTO_PACIENTE.DT_ENTRADA%TYPE;
CD_DEPARTMENT_W				ATEND_PACIENTE_UNIDADE.CD_DEPARTAMENTO%TYPE;

C01 CURSOR FOR
	SELECT
		AP.CD_PESSOA_FISICA, 
		OBTER_IDADE_PF(AP.CD_PESSOA_FISICA, clock_timestamp(), 'A'),
		OBTER_SEXO_PF(AP.CD_PESSOA_FISICA, 'D'),
		AP.DT_ENTRADA,
		APU.CD_DEPARTAMENTO
	FROM 
		ATENDIMENTO_PACIENTE AP, 
		ATEND_PACIENTE_UNIDADE APU
	WHERE 
		TRUNC(AP.DT_ENTRADA) = TRUNC(clock_timestamp() - interval '1 days') 
		AND AP.NR_ATENDIMENTO = APU.NR_ATENDIMENTO
		AND (APU.CD_DEPARTAMENTO IS NOT NULL AND APU.CD_DEPARTAMENTO::text <> '');


BEGIN
	OPEN C01;
		LOOP
			FETCH C01 INTO
			CD_PATIENT_W,
			QT_AGE_W,
			IE_GENDER_W,
			DT_ENTRADA_W,
			CD_DEPARTMENT_W;
			EXIT WHEN NOT FOUND; /* apply on C01 */
			
			--VALIDA SE JA FOI GERADO O RELATORIO NO DIA, CASO JA EXISTIR O RELATORIO, ELE DEVERA SER DELETADO PARA QUE SEJA GERADO O NOVO RELATORIO
			SELECT COUNT(*)
			INTO STRICT IE_EXIST_W
			FROM AGREG_PATIENT_GENERAL_COND
			WHERE TRUNC(DT_TARGET) = TRUNC(clock_timestamp())
			AND CD_DEPARTMENT = CD_DEPARTMENT_W;

			IF (IE_EXIST_W > 0) THEN
				DELETE from AGREG_PATIENT_GENERAL_COND
				WHERE TRUNC(DT_TARGET) = TRUNC(clock_timestamp())
				AND CD_DEPARTMENT = CD_DEPARTMENT_W;
			END IF;

			INSERT INTO AGREG_PATIENT_GENERAL_COND(
				NR_SEQUENCIA,
				DT_ATUALIZACAO,
				NM_USUARIO,
				NM_USUARIO_NREC,
				DT_ATUALIZACAO_NREC,
				NR_SEQ_MAIN_DAILY_REP,
				DT_TARGET,
				CD_DEPARTMENT,
				CD_PATIENT,
				QT_AGE,
				IE_GENDER,
				DT_RECEIVED_TREAT,
				CD_ARRIVAL_METHOD,
				IE_STATUS_TRIAGE,
				IE_OUTCOME,
				DS_ARTICLE,
				IE_MAIN_FLAG)
			VALUES (
				nextval('agreg_disch_transfer_out_seq'),
				clock_timestamp(),
				WHEB_USUARIO_PCK.GET_NM_USUARIO,
				WHEB_USUARIO_PCK.GET_NM_USUARIO,
				clock_timestamp(),
				NR_SEQ_DAILY_REPORT_P,
				clock_timestamp(),
				CD_DEPARTMENT_W,
				CD_PATIENT_W,
				QT_AGE_W,
				IE_GENDER_W,
				DT_ENTRADA_W,
				null, -- campo nao disponivel ainda.
				null, -- campo nao disponivel ainda.
				null, -- campo nao disponivel ainda.
				null, -- campo nao disponivel ainda.
				IE_MAIN_FLAG_P
			);
		END LOOP;
	CLOSE C01;
	
	COMMIT;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE aggregation_proc_managem_pck.gerar_agreg_patient_gen_cond (NR_SEQ_DAILY_REPORT_P bigint, CD_ESTABELECIMENTO_P bigint, IE_MAIN_FLAG_P bigint) FROM PUBLIC;
