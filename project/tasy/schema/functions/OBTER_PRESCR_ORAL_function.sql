-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_prescr_oral (nr_seq_serv_dia_p bigint) RETURNS bigint AS $body$
DECLARE


ds_retorno_w		bigint;


BEGIN

if (nr_seq_serv_dia_p IS NOT NULL AND nr_seq_serv_dia_p::text <> '') then

	select	 max(nr_prescr_oral)
	into STRICT 	 ds_retorno_w
	from	 nut_atend_serv_dia_rep
	where	 nr_seq_serv_dia = nr_seq_serv_dia_p;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_prescr_oral (nr_seq_serv_dia_p bigint) FROM PUBLIC;
