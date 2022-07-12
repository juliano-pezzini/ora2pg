-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE dashboard_html5_pck.insert_funcoes_html5_resumo (nr_seq_agrupamento_p bigint, ie_tipo_informacao_p text, qt_hora_previsto_p bigint, qt_hora_realizado_p bigint, pr_previsto_baseline_p bigint, pr_previsto_p bigint, pr_realizado_p bigint) AS $body$
DECLARE

        nr_sequencia_rem_w bigint;

BEGIN
        $if $$tasy_local_dict=true $then
        nr_sequencia_rem_w := get_remote_sequence('seq:funcoes_html5_resumo_seq');
        $else
        select nextval('funcoes_html5_resumo_seq') into STRICT nr_sequencia_rem_w;
        $end

        insert into funcoes_html5_resumo(nr_sequencia,
             dt_atualizacao,
             nm_usuario,
             dt_atualizacao_nrec,
             nm_usuario_nrec,
             nr_seq_agrupamento,
             ie_tipo_informacao,
             qt_hora_previsto,
             qt_hora_realizado,
             pr_previsto_baseline,
             pr_previsto,
             pr_realizado)
        values (nr_sequencia_rem_w, --funcoes_html5_resumo_seq.nextval,
             clock_timestamp(),
             'tasy',
             clock_timestamp(),
             'tasy',
             nr_seq_agrupamento_p,
             ie_tipo_informacao_p,
             qt_hora_previsto_p,
             qt_hora_realizado_p,
             pr_previsto_baseline_p,
             pr_previsto_p,
             pr_realizado_p);

    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE dashboard_html5_pck.insert_funcoes_html5_resumo (nr_seq_agrupamento_p bigint, ie_tipo_informacao_p text, qt_hora_previsto_p bigint, qt_hora_realizado_p bigint, pr_previsto_baseline_p bigint, pr_previsto_p bigint, pr_realizado_p bigint) FROM PUBLIC;