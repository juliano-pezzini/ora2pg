-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE dashboard_html5_pck.inserir_overview_semana (nm_usuario_p text, dt_referencia_p timestamp, nr_seq_agrupamento_p bigint, vl_dominio_p text, dt_periodo_p timestamp, ie_periodo_p text, vl_periodo_p bigint, nr_seq_apresentacao_p bigint) AS $body$
DECLARE

        /* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        Finalidade:  Inserir dados na tabela funcoes_html5_over_semana
        ---------------------------------------------------------------------------------------------------------------------------------------------

        Locais de chamada direta: 
        [  ]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [X] Outros: Procedure gera_overview_tela
         --------------------------------------------------------------------------------------------------------------------------------------------

        Pontos de atencao:
        +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */

        nr_sequencia_rem_w bigint;

BEGIN
        $if $$tasy_local_dict=true $then
        nr_sequencia_rem_w := get_remote_sequence('seq:funcoes_html5_over_semana_seq');
        $else
        select nextval('funcoes_html5_over_semana_seq') into STRICT nr_sequencia_rem_w;
        $end

        insert into funcoes_html5_over_semana(nr_sequencia,
             dt_atualizacao,
             nm_usuario,
             dt_atualizacao_nrec,
             nm_usuario_nrec,
             dt_referencia,
             nr_seq_agrupamento,
             ie_dimensao,
             dt_periodo,
             ie_periodo,
             vl_periodo,
             nr_seq_apresentacao)
        values (nr_sequencia_rem_w, --funcoes_html5_over_semana_seq.nextval,
             clock_timestamp(),
             nm_usuario_p,
             clock_timestamp(),
             nm_usuario_p,
             dt_referencia_p,
             nr_seq_agrupamento_p,
             vl_dominio_p,
             dt_periodo_p,
             ie_periodo_p,
             vl_periodo_p,
             nr_seq_apresentacao_p);

    end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE dashboard_html5_pck.inserir_overview_semana (nm_usuario_p text, dt_referencia_p timestamp, nr_seq_agrupamento_p bigint, vl_dominio_p text, dt_periodo_p timestamp, ie_periodo_p text, vl_periodo_p bigint, nr_seq_apresentacao_p bigint) FROM PUBLIC;
