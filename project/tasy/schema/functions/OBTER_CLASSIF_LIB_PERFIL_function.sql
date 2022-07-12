-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_classif_lib_perfil (nr_seq_classif_padrao_p bigint, cd_perfil_p bigint) RETURNS varchar AS $body$
DECLARE


qt_registro_w bigint;


BEGIN

select 	count(*)
into STRICT	qt_registro_w
from	com_classif_perfil
where	cd_perfil = cd_perfil_p
and		nr_seq_classif_padrao = nr_seq_classif_padrao_p;

if (qt_registro_w = 0) then
	return 'N';
else
	return 'S';
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_classif_lib_perfil (nr_seq_classif_padrao_p bigint, cd_perfil_p bigint) FROM PUBLIC;

