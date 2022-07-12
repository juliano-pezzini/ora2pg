-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_incosistencia_lib ( cd_inconsistencia_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(10);
qt_registros_w			bigint;
nr_seq_inconsistencia_w		bigint;


BEGIN

begin
select	CASE WHEN ie_situacao='A' THEN 'S' WHEN ie_situacao='I' THEN 'N' END ,
	nr_sequencia
into STRICT	ds_retorno_w,
	nr_seq_inconsistencia_w
from	sib_inconsistencia
where	cd_inconsistencia	= cd_inconsistencia_p;
exception
when others then
	ds_retorno_w	:= 'N';
	nr_seq_inconsistencia_w	:= null;
end;

if (ds_retorno_w = 'S') then
	select	count(1)
	into STRICT	qt_registros_w
	from	pls_regra_sib_inconsist
	where	nr_seq_inconsistencia	= nr_seq_inconsistencia_w;

	if (qt_registros_w	> 0) then
		if (coalesce(obter_perfil_ativo,0) = 0) then /* Se for pelo portal deve consistir, porém não tem perfil */
			return 'S';
		else
			select	count(1)
			into STRICT	qt_registros_w
			from	pls_regra_sib_inconsist
			where	nr_seq_inconsistencia	= nr_seq_inconsistencia_w
			and	cd_perfil		= obter_perfil_ativo;
		end if;

		if (qt_registros_w = 0) then
			return 'N';
		else
			return 'S';
		end if;
	end if;
	return	'S';
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_incosistencia_lib ( cd_inconsistencia_p bigint) FROM PUBLIC;
