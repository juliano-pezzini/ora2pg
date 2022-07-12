-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION gpi_obter_estagio_crit (nr_sequencia_p bigint) RETURNS bigint AS $body$
DECLARE


qt_w		bigint;


BEGIN

	select  count(*)
	Into STRICT	qt_w
	from	gpi_estagio a,
		gpi_lib_estagio b
	where   a.nr_sequencia = b.nr_Seq_Estagio
	and	a.nr_sequencia = nr_sequencia_p;


return qt_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION gpi_obter_estagio_crit (nr_sequencia_p bigint) FROM PUBLIC;

