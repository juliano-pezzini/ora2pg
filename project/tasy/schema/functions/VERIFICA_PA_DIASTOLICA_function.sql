-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION verifica_pa_diastolica ( nr_seq_pa_p bigint, qt_p bigint) RETURNS bigint AS $body$
DECLARE

qt_min_aviso_w	double precision;
qt_max_aviso_w	double precision;


BEGIN

select	coalesce(max(qt_min_aviso),0),
	coalesce(max(qt_max_aviso),0)
into STRICT	qt_min_aviso_w,
	qt_max_aviso_w
from	sinal_vital
where	nr_sequencia = nr_seq_pa_p;

if (qt_p < qt_min_aviso_w) or (qt_p > qt_max_aviso_w) and
	(qt_min_aviso_w <> 0 AND qt_max_aviso_w <> 0) then
	return qt_p;
else
	return null;
end if;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION verifica_pa_diastolica ( nr_seq_pa_p bigint, qt_p bigint) FROM PUBLIC;
