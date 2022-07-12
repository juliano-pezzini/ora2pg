-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_os_retornou_mmed ( nr_seq_os_p bigint) RETURNS varchar AS $body$
DECLARE

ie_retorno_w	varchar(1);

BEGIN

select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
into STRICT	ie_retorno_w
from	man_ordem_servico a
where	a.nr_sequencia = nr_seq_os_p
and		a.nr_seq_grupo_sup in (50,52)
and		exists (	SELECT	1
				from	man_ordem_log_grupo_sup b
				where	a.nr_sequencia = b.nr_seq_ordem_serv
				and		nr_seq_grupo_sup = 52
				and		exists (select	1
								from	man_ordem_log_grupo_sup c
								where	b.nr_seq_ordem_serv = c.nr_seq_ordem_serv
								and		c.nr_seq_grupo_sup = 50
								and		c.dt_atualizacao < b.dt_atualizacao));
return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_os_retornou_mmed ( nr_seq_os_p bigint) FROM PUBLIC;

