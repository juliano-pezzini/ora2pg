-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_inconsis_inserida ( nr_seq_procedimento_p bigint, nr_seq_material_p bigint, cd_inconsistencia_p bigint, cd_transacao_p text) RETURNS varchar AS $body$
DECLARE


ie_retorno_w			varchar(2)	:= 'N';
nr_seq_inconsistencia_w		bigint;
qt_registros_w			bigint;


BEGIN

select	max(nr_sequencia)
into STRICT	nr_seq_inconsistencia_w
from	ptu_inconsistencia
where	cd_inconsistencia	= cd_inconsistencia_p;

if (nr_seq_procedimento_p	<> 0) then
	select	count(*)
	into STRICT	qt_registros_w
	from	ptu_intercambio_consist
	where	nr_seq_procedimento	= nr_seq_procedimento_p
	and	cd_transacao		= cd_transacao_p
	and	nr_seq_inconsistencia	= nr_seq_inconsistencia_w;
elsif (nr_seq_material_p	<> 0) then
	select	count(*)
	into STRICT	qt_registros_w
	from	ptu_intercambio_consist
	where	nr_seq_material		= nr_seq_material_p
	and	cd_transacao		= cd_transacao_p
	and	nr_seq_inconsistencia	= nr_seq_inconsistencia_w;
end if;

if (qt_registros_w	> 0) then
	ie_retorno_w	:= 'S';
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_inconsis_inserida ( nr_seq_procedimento_p bigint, nr_seq_material_p bigint, cd_inconsistencia_p bigint, cd_transacao_p text) FROM PUBLIC;

