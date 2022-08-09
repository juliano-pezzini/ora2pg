-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE loc_obj_inserir_w_loc_obj ( CD_FUNCAO_P bigint, NR_SEQ_OBJ_P bigint, NR_SEQ_OBJ_SUP_P bigint, NM_USUARIO_P text, NR_SEQ_DIC_OBJ_P bigint, IE_MARCADO_P text, NR_SEQ_EVT_P bigint, NR_SEQ_DIC_DADOS_P bigint ) AS $body$
BEGIN

    MERGE INTO w_localizador_objetos lo
    USING(SELECT NULL               AS nr_sequencia
                , CD_FUNCAO_P        AS cd_funcao
                , NR_SEQ_OBJ_P       AS nr_seq_obj
                , NR_SEQ_OBJ_SUP_P   AS nr_seq_obj_sup
                , NM_USUARIO_P       AS nm_usuario
                , NR_SEQ_DIC_OBJ_P   AS nr_seq_dic_obj
                , IE_MARCADO_P       AS ie_marcado
                , NR_SEQ_EVT_P       AS nr_seq_evt
                , clock_timestamp()            AS dt_atualizacao
                , NR_SEQ_DIC_DADOS_P AS nr_seq_dic_dados
        ) x
    ON ( lo.cd_funcao = x.cd_funcao
        AND lo.nm_usuario = x.nm_usuario
        AND Coalesce(lo.nr_seq_obj, lo.nr_seq_dic_obj, lo.nr_seq_evt, lo.nr_seq_dic_dados) = Coalesce(x.nr_seq_obj, x.nr_seq_dic_obj, x.nr_seq_evt, x.nr_seq_dic_dados)
        AND (lo.nr_seq_obj_sup = x.nr_seq_obj_sup OR coalesce(lo.nr_seq_obj_sup::text, '') = '') )
    WHEN matched THEN
    UPDATE SET lo.ie_marcado = IE_MARCADO_P
    WHEN NOT matched THEN
    INSERT(nr_sequencia
            , cd_funcao
            , nr_seq_obj
            , nr_seq_obj_sup
            , nm_usuario
            , nr_seq_dic_obj
            , ie_marcado
            , nr_seq_evt
            , nr_seq_dic_dados)
    VALUES ( nextval('w_localizador_objetos_seq')
            , CD_FUNCAO_P
            , NR_SEQ_OBJ_P
            , NR_SEQ_OBJ_SUP_P
            , NM_USUARIO_P
            , NR_SEQ_DIC_OBJ_P
            , IE_MARCADO_P
            , NR_SEQ_EVT_P
            , NR_SEQ_DIC_DADOS_P);

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE loc_obj_inserir_w_loc_obj ( CD_FUNCAO_P bigint, NR_SEQ_OBJ_P bigint, NR_SEQ_OBJ_SUP_P bigint, NM_USUARIO_P text, NR_SEQ_DIC_OBJ_P bigint, IE_MARCADO_P text, NR_SEQ_EVT_P bigint, NR_SEQ_DIC_DADOS_P bigint ) FROM PUBLIC;
