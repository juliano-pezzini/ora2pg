-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION qua_obter_qt_os ( ie_status_p text, dt_inicial_p timestamp, dt_final_p timestamp, nr_seq_estagio_p text, ie_tipo_ordem_p bigint ) RETURNS bigint AS $body$
DECLARE


cont_os_w 	bigint;


BEGIN

select	CASE WHEN count(q.nr_sequencia)=0 THEN  1  ELSE count(q.nr_sequencia) END
into STRICT 	cont_os_w
from	man_ordem_servico q
where	(((ie_status_p = 'N') and q.ie_status_ordem in ('1','2')) or (q.ie_status_ordem = ie_status_p))
and	q.dt_ordem_servico between dt_inicial_p and dt_final_p + 86399/86400
and exists(	SELECT	1
		FROM man_ordem_servico d, man_estagio_processo b, man_ordem_serv_estagio a
LEFT OUTER JOIN man_tipo_solucao c ON (a.nr_seq_tipo_solucao = c.nr_sequencia)
WHERE b.nr_sequencia 		= a.nr_seq_estagio  and d.nr_sequencia 		= a.nr_seq_ordem and a.nr_seq_ordem 		= q.nr_sequencia and ((a.nr_seq_estagio 	= nr_seq_estagio_p) or (nr_seq_estagio_p = '0')) and ((d.ie_tipo_ordem	= ie_tipo_ordem_p) or (ie_tipo_ordem_p = '0')) );

return	cont_os_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION qua_obter_qt_os ( ie_status_p text, dt_inicial_p timestamp, dt_final_p timestamp, nr_seq_estagio_p text, ie_tipo_ordem_p bigint ) FROM PUBLIC;
