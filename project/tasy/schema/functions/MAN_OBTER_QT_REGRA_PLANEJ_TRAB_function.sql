-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION man_obter_qt_regra_planej_trab ( nr_seq_grupo_planej_p bigint) RETURNS bigint AS $body$
DECLARE


qt_regra_w	bigint;


BEGIN

select	count(*)
into STRICT	qt_regra_w
from	man_grupo_planej_trab t
where	t.nr_seq_grupo_planej	= nr_seq_grupo_planej_p;

return	qt_regra_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION man_obter_qt_regra_planej_trab ( nr_seq_grupo_planej_p bigint) FROM PUBLIC;
