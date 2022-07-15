-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE anestesistas_questions (NR_SEQ_ANESTESISTA_P bigint, NR_SEQ_DVT_RULE_P bigint default null, IE_OPCAO_P text default null, VL_RESPOSTA_P bigint default null, NR_SEQ_FRASE_P bigint default null, NM_USUARIO_P text DEFAULT NULL, IE_ACTION_OPERACAO_P text DEFAULT NULL) AS $body$
BEGIN

    IF (ie_action_operacao_p = 'I') THEN
        insert into CPOE_ANESTESISTA_DVT(nr_sequencia,
        dt_atualizacao,
        nm_usuario, 
        dt_atualizacao_nrec,
        nm_usuario_nrec, 
        NR_SEQ_ANESTESISTA, 
        NR_SEQ_RULE, 
        IE_OPCAO, 
        VL_RESPOSTA,
        NR_SEQ_ROUTINE) 
        values (
        nextval('cpoe_anestesista_dvt_seq'),
        clock_timestamp(),
        NM_USUARIO_P,
        clock_timestamp(),
        NM_USUARIO_P,
        nr_seq_anestesista_p,
        NR_SEQ_DVT_RULE_P,
        IE_OPCAO_P,
        VL_RESPOSTA_P,
        NR_SEQ_FRASE_P
        );
        COMMIT;
    ELSE
    IF (ie_action_operacao_p = 'U') THEN

        insert into CPOE_ANESTESISTA_DVT(nr_sequencia,
        dt_atualizacao,
        nm_usuario, 
        dt_atualizacao_nrec,
        nm_usuario_nrec, 
        NR_SEQ_ANESTESISTA, 
        NR_SEQ_RULE, 
        IE_OPCAO, 
        VL_RESPOSTA,
        NR_SEQ_ROUTINE) 
        values (
        nextval('cpoe_anestesista_dvt_seq'),
        clock_timestamp(),
        NM_USUARIO_P,
        clock_timestamp(),
        NM_USUARIO_P,
        nr_seq_anestesista_p,
        NR_SEQ_DVT_RULE_P,
        IE_OPCAO_P,
        VL_RESPOSTA_P,
        NR_SEQ_FRASE_P
        );
        COMMIT;
    ELSE
    IF (ie_action_operacao_p = 'D') THEN
        DELETE FROM CPOE_ANESTESISTA_DVT
        WHERE NR_SEQ_ANESTESISTA = NR_SEQ_ANESTESISTA_P;
        COMMIT;
    END IF;
    END IF;
    END IF;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE anestesistas_questions (NR_SEQ_ANESTESISTA_P bigint, NR_SEQ_DVT_RULE_P bigint default null, IE_OPCAO_P text default null, VL_RESPOSTA_P bigint default null, NR_SEQ_FRASE_P bigint default null, NM_USUARIO_P text DEFAULT NULL, IE_ACTION_OPERACAO_P text DEFAULT NULL) FROM PUBLIC;

