-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION sla_dashboard_pck.obter_se_registro_monit (nr_seq_ordem_serv_p man_sla_monitor.nr_seq_ordem_servico%type) RETURNS bigint AS $body$
DECLARE


qt_sla_monitor_w		bigint;

BEGIN
select 	count(1)
into STRICT	qt_sla_monitor_w
from	man_sla_monitor	
where	nr_seq_ordem_servico = nr_seq_ordem_serv_p;

return qt_sla_monitor_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION sla_dashboard_pck.obter_se_registro_monit (nr_seq_ordem_serv_p man_sla_monitor.nr_seq_ordem_servico%type) FROM PUBLIC;