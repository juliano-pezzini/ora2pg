-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION hd_obter_dif_peso (nr_seq_dialise_p bigint) RETURNS bigint AS $body$
DECLARE

qt_retorno_w	double precision;
qt_peso_pre_w	real;
qt_peso_pos_w	real;

BEGIN
if (nr_Seq_dialise_p IS NOT NULL AND nr_Seq_dialise_p::text <> '') then
	select	max(qt_peso_pre),
		max(qt_peso_pos)
	into STRICT	qt_peso_pre_w,
		qt_peso_pos_w
	from   	hd_dialise
	where  	nr_sequencia = nr_seq_dialise_p;


	if (qt_peso_pre_w IS NOT NULL AND qt_peso_pre_w::text <> '') and (qt_peso_pos_w IS NOT NULL AND qt_peso_pos_w::text <> '') then
		qt_retorno_w := qt_peso_pre_w - qt_peso_pos_w;
	else
		qt_retorno_w := 0;
	end if;

end if;
return	qt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION hd_obter_dif_peso (nr_seq_dialise_p bigint) FROM PUBLIC;

