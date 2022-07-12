-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE med_guidance_pkg.upsert_proc_interno ( ds_proc_exame_p PROC_INTERNO.DS_PROC_EXAME%type, ds_exame_curto_p PROC_INTERNO.DS_EXAME_CURTO%type, ds_laudo_p PROC_INTERNO.DS_LAUDO%type, cd_procedimento_p PROC_INTERNO.CD_PROCEDIMENTO%type, cd_procedimento_loc_p PROC_INTERNO.CD_PROCEDIMENTO_LOC%type, ie_orientacao_p PROC_INTERNO.IE_ORIENTACAO%type, ie_tipo_util_p PROC_INTERNO.IE_TIPO_UTIL%type, ie_exige_lado_p PROC_INTERNO.IE_EXIGE_LADO%type, ie_tipo_p PROC_INTERNO.IE_TIPO%type, ie_situacao_p PROC_INTERNO.IE_SITUACAO%type, ie_origem_proced_p PROC_INTERNO.IE_ORIGEM_PROCED%type, nm_usuario_p PROC_INTERNO.NM_USUARIO%type, nr_seq_edition_p JPN_MEDICAL_GUIDANCE.NR_SEQ_EDITION%type, qt_records_p bigint, dt_sysdate_p timestamp, dt_end_date_p timestamp default null) AS $body$
DECLARE


    ie_inativado_s      varchar(1) := 'I';
    ie_localizador_s    varchar(1) := 'S';
    dt_end_date_w       timestamp;
    ds_erro_tst_w       varchar(4000);


BEGIN
        IF qt_records_p = 0 THEN
            BEGIN
                INSERT INTO PROC_INTERNO(
                    NR_SEQUENCIA,
                    DS_PROC_EXAME,
                    DS_EXAME_CURTO,
                    DS_LAUDO,
                    CD_PROCEDIMENTO,
                    CD_PROCEDIMENTO_LOC,
                    IE_ORIGEM_PROCED,
                    IE_ORIENTACAO,
                    IE_TIPO_UTIL,
                    IE_EXIGE_LADO,
                    IE_TIPO,
                    IE_LOCALIZADOR,
                    IE_SITUACAO,
                    DT_ATUALIZACAO,
                    DT_ATUALIZACAO_NREC,
                    NM_USUARIO,
                    NM_USUARIO_NREC
                ) VALUES (
                    nextval('proc_interno_seq'),
                    ds_proc_exame_p,
                    ds_exame_curto_p,
                    ds_laudo_p,
                    cd_procedimento_p,
                    cd_procedimento_loc_p,
                    ie_origem_proced_p,
                    ie_orientacao_p,
                    ie_tipo_util_p,
                    ie_exige_lado_p,
                    ie_tipo_p,
                    ie_localizador_s,
                    ie_situacao_p,
                    dt_sysdate_p,
                    dt_sysdate_p,
                    nm_usuario_p,
                    nm_usuario_p
                );
            EXCEPTION WHEN OTHERS THEN
                ROLLBACK;
                CALL WHEB_MENSAGEM_PCK.EXIBIR_MENSAGEM_ABORT(799570, 'DS_ERRO_W=UPSERT_PROC_INTERNO'|| chr(10) ||SQLERRM);
            END;
        ELSE
            BEGIN

	        UPDATE  PROC_INTERNO	
	        SET     DS_PROC_EXAME = ds_proc_exame_p,
			DS_EXAME_CURTO = ds_exame_curto_p,
			DS_LAUDO = ds_laudo_p,
			NM_USUARIO = nm_usuario_p,
			DT_ATUALIZACAO = dt_sysdate_p			    
	       WHERE    CD_PROCEDIMENTO = cd_procedimento_p
	       AND	IE_ORIGEM_PROCED = ie_origem_proced_p;
		
            EXCEPTION WHEN OTHERS THEN
                ROLLBACK;
                CALL WHEB_MENSAGEM_PCK.EXIBIR_MENSAGEM_ABORT(799647, 'DS_ERRO_W=UPSERT_PROC_INTERNO'|| chr(10) || SQLERRM);
            END;
        END IF;
    END;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE med_guidance_pkg.upsert_proc_interno ( ds_proc_exame_p PROC_INTERNO.DS_PROC_EXAME%type, ds_exame_curto_p PROC_INTERNO.DS_EXAME_CURTO%type, ds_laudo_p PROC_INTERNO.DS_LAUDO%type, cd_procedimento_p PROC_INTERNO.CD_PROCEDIMENTO%type, cd_procedimento_loc_p PROC_INTERNO.CD_PROCEDIMENTO_LOC%type, ie_orientacao_p PROC_INTERNO.IE_ORIENTACAO%type, ie_tipo_util_p PROC_INTERNO.IE_TIPO_UTIL%type, ie_exige_lado_p PROC_INTERNO.IE_EXIGE_LADO%type, ie_tipo_p PROC_INTERNO.IE_TIPO%type, ie_situacao_p PROC_INTERNO.IE_SITUACAO%type, ie_origem_proced_p PROC_INTERNO.IE_ORIGEM_PROCED%type, nm_usuario_p PROC_INTERNO.NM_USUARIO%type, nr_seq_edition_p JPN_MEDICAL_GUIDANCE.NR_SEQ_EDITION%type, qt_records_p bigint, dt_sysdate_p timestamp, dt_end_date_p timestamp default null) FROM PUBLIC;