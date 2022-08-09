-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE carga_custo_procedimento (cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_tabela_custo_p bigint, nr_seq_proc_interno_p bigint, qt_dias_prazo_p bigint, nr_seq_exame_p bigint, vl_presente_p bigint, vl_cotado_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, nr_seq_tabela_p bigint, ds_observacao_p text) AS $body$
BEGIN

    insert into CUSTO_PROCEDIMENTO(
        nr_sequencia,
        nr_seq_proc_interno,
        nr_seq_tabela,
        cd_estabelecimento,
        cd_tabela_custo,
        cd_procedimento,
        ie_origem_proced,
        nm_usuario,
        dt_atualizacao,
        qt_dias_prazo,
        vl_cotado,
        vl_presente,
        ds_observacao,
        nr_seq_exame,
        dt_atualizacao_nrec,
        nm_usuario_nrec
    ) VALUES (
        nextval('custo_procedimento_seq'),
        nr_seq_proc_interno_p,
        nr_seq_tabela_p,
        cd_estabelecimento_p,
        cd_tabela_custo_p,
        cd_procedimento_p,
        ie_origem_proced_p,
        nm_usuario_p,
        clock_timestamp(),
        qt_dias_prazo_p,
        vl_cotado_p,
        vl_presente_p,
        ds_observacao_p,
        nr_seq_exame_p,
        clock_timestamp(),
        nm_usuario_p
    );

    commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE carga_custo_procedimento (cd_procedimento_p bigint, ie_origem_proced_p bigint, cd_tabela_custo_p bigint, nr_seq_proc_interno_p bigint, qt_dias_prazo_p bigint, nr_seq_exame_p bigint, vl_presente_p bigint, vl_cotado_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, nr_seq_tabela_p bigint, ds_observacao_p text) FROM PUBLIC;
