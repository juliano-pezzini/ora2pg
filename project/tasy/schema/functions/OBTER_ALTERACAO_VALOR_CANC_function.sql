-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_alteracao_valor_canc (nr_titulo_p bigint) RETURNS bigint AS $body$
DECLARE


vl_cancelado_w	double precision;


BEGIN

select	sum(CASE WHEN a.ie_aumenta_diminui='A' THEN a.vl_alteracao WHEN a.ie_aumenta_diminui='D' THEN a.vl_alteracao * -1 END )
into STRICT	vl_cancelado_w
from	alteracao_valor a
where	a.nr_titulo		= nr_titulo_p
and	a.cd_motivo	= 3;

return	vl_cancelado_w;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_alteracao_valor_canc (nr_titulo_p bigint) FROM PUBLIC;

