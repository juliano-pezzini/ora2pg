-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qt_erro_max_permitido ( nr_sequencia_p bigint) RETURNS bigint AS $body$
DECLARE


qt_erro_max_permitido_w			double precision;


BEGIN

select	coalesce(qt_erro_max_permitido, 0)
into STRICT	qt_erro_max_permitido_w
from	man_equip_calib_escala
where	nr_sequencia = nr_sequencia_p;

return qt_erro_max_permitido_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qt_erro_max_permitido ( nr_sequencia_p bigint) FROM PUBLIC;

