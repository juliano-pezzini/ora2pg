-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_os_npi (nr_seq_ordem_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(1);


BEGIN

select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
into STRICT	ds_retorno_w
from	proj_cronograma e,
		prp_processo_fase p,
		prp_fase_processo f,
		proj_cron_etapa d,
		man_ordem_servico c
where	p.nr_Sequencia = e.nr_seq_processo_fase
and		f.nr_sequencia = p.nr_seq_fase_processo
and		e.nr_sequencia = d.nr_seq_cronograma
and		c.nr_seq_proj_cron_etapa = d.nr_sequencia
and		c.nr_sequencia = nr_seq_ordem_p;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_os_npi (nr_seq_ordem_p bigint) FROM PUBLIC;

