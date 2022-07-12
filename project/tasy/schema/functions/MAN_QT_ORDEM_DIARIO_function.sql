-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION man_qt_ordem_diario ( qt_dia_p text, dt_mes_referencia_p timestamp, ie_status_p text, nr_grupo_trabalho_p bigint) RETURNS bigint AS $body$
DECLARE


qt_total_w	bigint;


BEGIN

select	coalesce(sum(CASE WHEN substr(trunc(a.dt_atualizacao,'dd'),1,2)=qt_dia_p THEN 1  ELSE 0 END ),0)
into STRICT	qt_total_w
from	man_ordem_serv_estagio a,
	man_ordem_servico b
where	a.nr_seq_ordem = b.nr_sequencia
and	((ie_status_p = 'S' AND b.ie_status_ordem <> '3') or
	(ie_status_p = 'E' AND b.ie_status_ordem = '3') or (ie_status_p = 'T'))
and	trunc(a.dt_atualizacao,'mm') = trunc(dt_mes_referencia_p,'month')
and (b.nr_grupo_trabalho = nr_grupo_trabalho_p or coalesce(nr_grupo_trabalho_p,0) = 0);

RETURN	qt_total_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION man_qt_ordem_diario ( qt_dia_p text, dt_mes_referencia_p timestamp, ie_status_p text, nr_grupo_trabalho_p bigint) FROM PUBLIC;

