-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ppm_obter_user_objetivo_result (nr_seq_result_p bigint) RETURNS varchar AS $body$
DECLARE

nm_usuario_w varchar(15);

BEGIN

select	a.nm_usuario_nrec
into STRICT	nm_usuario_w
from	ppm_objetivo a,
	ppm_objetivo_meta b,
	ppm_objetivo_metrica c,
	ppm_objetivo_result d
where	d.nr_sequencia = nr_seq_result_p
and	d.nr_Seq_metrica = c.nr_sequencia
and	c.nr_seq_meta = b.nr_sequencia
and	b.nr_seq_objetivo = a.nr_sequencia;

return	nm_usuario_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ppm_obter_user_objetivo_result (nr_seq_result_p bigint) FROM PUBLIC;
