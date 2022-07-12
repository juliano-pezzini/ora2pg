-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_regra_partic_pck.obter_qt_grupo_regra (nr_seq_regra_p pls_grupo_partic_tm.nr_seq_regra%type) RETURNS integer AS $body$
DECLARE


qt_grupo_regra_w	integer;


BEGIN

select	count(distinct b.nr_seq_grupo_regra)
into STRICT	qt_grupo_regra_w
from	pls_grupo_partic_tm b
where	b.nr_seq_regra = nr_seq_regra_p;

return qt_grupo_regra_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_regra_partic_pck.obter_qt_grupo_regra (nr_seq_regra_p pls_grupo_partic_tm.nr_seq_regra%type) FROM PUBLIC;
