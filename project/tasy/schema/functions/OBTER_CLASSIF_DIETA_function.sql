-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_classif_dieta (cd_dieta_p bigint) RETURNS bigint AS $body$
DECLARE


cd_classif_dieta_w	bigint;


BEGIN

select	b.nr_sequencia
into STRICT 	cd_classif_dieta_w
from 	dieta_classif b,
	dieta a
where 	a.nr_seq_classif = b.nr_sequencia
and 	a.cd_dieta  = cd_dieta_p;

return 	cd_classif_dieta_w;

end 	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_classif_dieta (cd_dieta_p bigint) FROM PUBLIC;
