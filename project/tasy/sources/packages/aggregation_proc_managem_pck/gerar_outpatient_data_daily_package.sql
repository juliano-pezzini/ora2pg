-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE aggregation_proc_managem_pck.gerar_outpatient_data_daily (NR_SEQ_DAILY_REPORT_P bigint, CD_ESTABELECIMENTO_P bigint, IE_MAIN_FLAG_P bigint,nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


    CD_DEPARTMENT_W             DEPARTAMENTO_SETOR.CD_DEPARTAMENTO%TYPE;
    CD_WARD_W                   bigint;
    CD_PATIENT_W                ATENDIMENTO_PACIENTE.CD_PESSOA_FISICA%TYPE;
    QT_AGE_W                    bigint;
    IE_GENDER_W                 varchar(10);


BEGIN 

        select 
            MAX(APU.CD_SETOR_ATENDIMENTO),
            MAX(AP.CD_PESSOA_FISICA),
            MAX(OBTER_IDADE_PF(AP.CD_PESSOA_FISICA, clock_timestamp(), 'A')),
            MAX(OBTER_SEXO_PF(AP.CD_PESSOA_FISICA, 'D'))
        into STRICT
            CD_WARD_W,
            CD_PATIENT_W,
            QT_AGE_W,
            IE_GENDER_W
        from  
            ATEND_PACIENTE_UNIDADE APU,
            ATENDIMENTO_PACIENTE AP
        where 
            AP.CD_ESTABELECIMENTO             = CD_ESTABELECIMENTO_P
            AND TRUNC(APU.DT_ENTRADA_UNIDADE) = TRUNC(clock_timestamp() - interval '1 days')
            AND APU.NR_ATENDIMENTO            = AP.NR_ATENDIMENTO;

      CD_DEPARTMENT_W := OBTER_DEPARTAMENTO_SETOR(CD_WARD_W);

     IF (NR_SEQ_DAILY_REPORT_P > 0 and (CD_PATIENT_W IS NOT NULL AND CD_PATIENT_W::text <> ''))THEN

        INSERT INTO AGREG_OUTPATIENT_DATA(
            NR_SEQUENCIA,
            DT_ATUALIZACAO,
            NM_USUARIO,
            DT_ATUALIZACAO_NREC,
            NM_USUARIO_NREC,
            NR_SEQ_MAIN_DAILY_REP,
            DT_TARGET,
            CD_DEPARTMENT,
            CD_PATIENT,
            QT_AGE,
            IE_GENDER,
            DS_REMARKS,
            IE_MAIN_FLAG)
              VALUES (
                nextval('agreg_outpatient_data_seq'),
                clock_timestamp(),
                nm_usuario_p,
				clock_timestamp(),
                nm_usuario_p,
                NR_SEQ_DAILY_REPORT_P,
                clock_timestamp(),
                CD_DEPARTMENT_W,
                CD_PATIENT_W,
                QT_AGE_W,
                IE_GENDER_W,
                null,
                IE_MAIN_FLAG_P);
     END IF;
COMMIT;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE aggregation_proc_managem_pck.gerar_outpatient_data_daily (NR_SEQ_DAILY_REPORT_P bigint, CD_ESTABELECIMENTO_P bigint, IE_MAIN_FLAG_P bigint,nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
