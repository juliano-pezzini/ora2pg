-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE dashboard_html5_pck.obter_dados_os_tre (nr_seq_ordem_serv_p bigint, dt_inicio_prev_tre_p INOUT timestamp, dt_fim_prev_tre_p INOUT timestamp, dt_inicio_real_tre_p INOUT timestamp, dt_fim_real_tre_p INOUT timestamp, qt_ordem_serv_tre_p INOUT bigint) AS $body$
BEGIN

        select max(dt_inicio_previsto),
               max(dt_fim_previsto),
               max(dt_inicio_real),
               max(dt_fim_real)
          into STRICT dt_inicio_prev_tre_p,
               dt_fim_prev_tre_p,
               dt_inicio_real_tre_p,
               dt_fim_real_tre_p
          from man_ordem_servico
         where nr_sequencia = nr_seq_ordem_serv_p;

        select count(*)
          into STRICT qt_ordem_serv_tre_p
          from man_ordem_serv_vinc a,
               man_ordem_servico   b
         where a.nr_seq_os_vinculada = b.nr_sequencia
           and a.nr_seq_ordem_servico = nr_seq_ordem_serv_p
           and b.ie_status_ordem <> 3;

    END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE dashboard_html5_pck.obter_dados_os_tre (nr_seq_ordem_serv_p bigint, dt_inicio_prev_tre_p INOUT timestamp, dt_fim_prev_tre_p INOUT timestamp, dt_inicio_real_tre_p INOUT timestamp, dt_fim_real_tre_p INOUT timestamp, qt_ordem_serv_tre_p INOUT bigint) FROM PUBLIC;