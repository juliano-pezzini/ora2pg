-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ultimo_atend_internado (nr_sequencia_p bigint) RETURNS bigint AS $body$
DECLARE


ds_retorno_w	integer(15);


BEGIN

select	max(a.nr_atendimento)
into STRICT	ds_retorno_w
from	UNIDADE_ATEND_HIST a
where	a.nr_sequencia		< nr_sequencia_p
and	a.IE_STATUS_UNIDADE	= 'P'
and	a.DT_HISTORICO	= (	SELECT	max(x.DT_HISTORICO)
				from	unidade_atend_hist x
				where	x.nr_sequencia		< nr_sequencia_p
				and	x.IE_STATUS_UNIDADE	= 'P');

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ultimo_atend_internado (nr_sequencia_p bigint) FROM PUBLIC;
