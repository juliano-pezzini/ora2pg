-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION man_obter_se_os_projeto ( nr_seq_os_p bigint) RETURNS varchar AS $body$
DECLARE




nr_seq_proj_cron_etapa_w	man_ordem_servico.nr_seq_proj_cron_etapa%type;
nr_seq_projeto_w			man_ordem_servico.nr_seq_projeto%type;
ie_retorno_w				varchar(1) := 'N';

BEGIN

select	max(a.nr_seq_Proj_cron_etapa),
		max(a.nr_seq_projeto)
into STRICT	nr_seq_proj_cron_etapa_w,
		nr_seq_projeto_w
from	man_ordem_servico a
where	a.nr_sequencia	= nr_seq_os_p;
/*Identifica se a OS é de projeto - OS original e OS da etapa */

if (nr_seq_Proj_cron_etapa_w IS NOT NULL AND nr_seq_Proj_cron_etapa_w::text <> '') or (nr_seq_projeto_w IS NOT NULL AND nr_seq_projeto_w::text <> '') then
	ie_retorno_w	:= 'S';
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION man_obter_se_os_projeto ( nr_seq_os_p bigint) FROM PUBLIC;

