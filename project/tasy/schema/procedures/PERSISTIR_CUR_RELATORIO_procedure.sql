-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE persistir_cur_relatorio ( nm_usuario_p cur_relatorio.nm_usuario%type, ds_relatorio_p cur_relatorio.ds_relatorio%type, ds_arquivo_p cur_relatorio.ds_arquivo%type, nr_atendimento_p cur_relatorio.nr_atendimento%type ) AS $body$
DECLARE


nr_seq_cur_relatorio_w cur_relatorio.nr_sequencia%type;


BEGIN

    SELECT nextval('cur_relatorio_seq')
    INTO STRICT nr_seq_cur_relatorio_w
;

    insert into cur_relatorio(
        nr_sequencia,
        dt_atualizacao,
        nm_usuario,
        dt_atualizacao_nrec,
        nm_usuario_nrec,
        ds_relatorio,
        ds_arquivo,
        nr_atendimento
    )
    values (
        nr_seq_cur_relatorio_w,
        clock_timestamp(),
        nm_usuario_p,
        clock_timestamp(),
        nm_usuario_p,
        ds_relatorio_p,
        ds_arquivo_p,
        nr_atendimento_p
    );

    commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE persistir_cur_relatorio ( nm_usuario_p cur_relatorio.nm_usuario%type, ds_relatorio_p cur_relatorio.ds_relatorio%type, ds_arquivo_p cur_relatorio.ds_arquivo%type, nr_atendimento_p cur_relatorio.nr_atendimento%type ) FROM PUBLIC;
