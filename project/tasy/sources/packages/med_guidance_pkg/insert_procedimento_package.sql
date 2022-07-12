-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE med_guidance_pkg.insert_procedimento ( cd_procedimento_p PROCEDIMENTO.CD_PROCEDIMENTO%type, ds_procedimento_p PROCEDIMENTO.DS_PROCEDIMENTO%type, ie_situacao_p PROCEDIMENTO.IE_SITUACAO%type, cd_grupo_proc_p PROCEDIMENTO.CD_GRUPO_PROC%type, ie_classificacao_p PROCEDIMENTO.IE_CLASSIFICACAO%type, ie_origem_proced_p PROCEDIMENTO.IE_ORIGEM_PROCED%type, ie_exige_autor_sus_p PROCEDIMENTO.IE_EXIGE_AUTOR_SUS%type, qt_exec_barra_p PROCEDIMENTO.QT_EXEC_BARRA%type, ie_ativ_prof_bpa_p PROCEDIMENTO.IE_ATIV_PROF_BPA%type, ie_alta_complexidade_p PROCEDIMENTO.IE_ALTA_COMPLEXIDADE%type, ie_ignora_origem_p PROCEDIMENTO.IE_IGNORA_ORIGEM%type, ie_classif_custo_p PROCEDIMENTO.IE_CLASSIF_CUSTO%type, ie_localizador_p PROCEDIMENTO.IE_LOCALIZADOR%type, cd_procedimento_loc_p PROCEDIMENTO.CD_PROCEDIMENTO_LOC%type, nm_usuario_p PROCEDIMENTO.NM_USUARIO%type, dt_sysdate_p timestamp ) AS $body$
BEGIN
        INSERT INTO PROCEDIMENTO(
            CD_PROCEDIMENTO,
            DS_PROCEDIMENTO,
            IE_SITUACAO,
            CD_GRUPO_PROC,
            IE_CLASSIFICACAO,
            IE_ORIGEM_PROCED,
            IE_EXIGE_AUTOR_SUS,
            QT_EXEC_BARRA,
            IE_ATIV_PROF_BPA,
            IE_ALTA_COMPLEXIDADE,
            IE_IGNORA_ORIGEM,
            IE_CLASSIF_CUSTO,
            IE_LOCALIZADOR,
            CD_PROCEDIMENTO_LOC,
            NM_USUARIO,
            DT_ATUALIZACAO
        ) VALUES (
            cd_procedimento_p,
            ds_procedimento_p,
            ie_situacao_p,
            cd_grupo_proc_p,
            ie_classificacao_p,
            ie_origem_proced_p,
            ie_exige_autor_sus_p,
            qt_exec_barra_p,
            ie_ativ_prof_bpa_p,
            ie_alta_complexidade_p,
            ie_ignora_origem_p,
            ie_classif_custo_p,
            ie_localizador_p,
            cd_procedimento_loc_p,
            nm_usuario_p,
            dt_sysdate_p
        );
    EXCEPTION WHEN OTHERS THEN
        ROLLBACK;
        CALL WHEB_MENSAGEM_PCK.EXIBIR_MENSAGEM_ABORT(799570, 'DS_ERRO_W=INSERT_PROCEDIMENTO'|| chr(10) ||SQLERRM);
    END;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE med_guidance_pkg.insert_procedimento ( cd_procedimento_p PROCEDIMENTO.CD_PROCEDIMENTO%type, ds_procedimento_p PROCEDIMENTO.DS_PROCEDIMENTO%type, ie_situacao_p PROCEDIMENTO.IE_SITUACAO%type, cd_grupo_proc_p PROCEDIMENTO.CD_GRUPO_PROC%type, ie_classificacao_p PROCEDIMENTO.IE_CLASSIFICACAO%type, ie_origem_proced_p PROCEDIMENTO.IE_ORIGEM_PROCED%type, ie_exige_autor_sus_p PROCEDIMENTO.IE_EXIGE_AUTOR_SUS%type, qt_exec_barra_p PROCEDIMENTO.QT_EXEC_BARRA%type, ie_ativ_prof_bpa_p PROCEDIMENTO.IE_ATIV_PROF_BPA%type, ie_alta_complexidade_p PROCEDIMENTO.IE_ALTA_COMPLEXIDADE%type, ie_ignora_origem_p PROCEDIMENTO.IE_IGNORA_ORIGEM%type, ie_classif_custo_p PROCEDIMENTO.IE_CLASSIF_CUSTO%type, ie_localizador_p PROCEDIMENTO.IE_LOCALIZADOR%type, cd_procedimento_loc_p PROCEDIMENTO.CD_PROCEDIMENTO_LOC%type, nm_usuario_p PROCEDIMENTO.NM_USUARIO%type, dt_sysdate_p timestamp ) FROM PUBLIC;