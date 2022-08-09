-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE adicionar_emite_prescricao_log ( NM_USUARIO_P text, DS_FILTROS_P text, NR_PRESCRICAO_P bigint, NR_SEQ_PRESCRICAO_P bigint, DS_OBSERVACAO_ERRO_P text, DS_OBSERVACAO_P text, NM_COMPUTADOR_P text) AS $body$
DECLARE

NR_SEQUENCIA_W emite_prescricao_log.nr_sequencia%type;

BEGIN
    select nextval('emite_prescricao_log_seq') into STRICT NR_SEQUENCIA_W;
	insert into emite_prescricao_log(
        NR_SEQUENCIA,
        DT_ATUALIZACAO,
        NM_USUARIO,
        DT_ATUALIZACAO_NREC,
        NM_USUARIO_NREC,
        DS_FILTROS,
        CD_PERFIL,
        NR_PRESCRICAO,
        NR_SEQ_PRESCRICAO,
        DS_OBSERVACAO_ERRO,
        DS_OBSERVACAO,
        NM_COMPUTADOR)
	values (
        NR_SEQUENCIA_W,
        clock_timestamp(),
        NM_USUARIO_P,
        clock_timestamp(),
        NM_USUARIO_P,
        DS_FILTROS_P,
        Obter_perfil_Ativo,
        NR_PRESCRICAO_P,
        NR_SEQ_PRESCRICAO_P,
        DS_OBSERVACAO_ERRO_P,
        DS_OBSERVACAO_P,
        NM_COMPUTADOR_P);
	commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE adicionar_emite_prescricao_log ( NM_USUARIO_P text, DS_FILTROS_P text, NR_PRESCRICAO_P bigint, NR_SEQ_PRESCRICAO_P bigint, DS_OBSERVACAO_ERRO_P text, DS_OBSERVACAO_P text, NM_COMPUTADOR_P text) FROM PUBLIC;
