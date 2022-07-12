-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ps_obter_gestor ( nr_seq_cliente_p bigint, cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE


qt_gestor_w		bigint;
ds_retorno_w	varchar(1);

BEGIN
select	count(*)
into STRICT	qt_gestor_w
from	com_cliente_gestor a
where	a.cd_pessoa_fisica = cd_pessoa_fisica_p
and		a.nr_seq_cliente = nr_seq_cliente_p
and		((coalesce(a.dt_final::text, '') = '') or (trunc(a.dt_final) >= clock_timestamp()));

if (qt_gestor_w > 0) then
	ds_retorno_w := 'S';
else
	select	count(*)
	into STRICT	qt_gestor_w
	from	com_cliente_conta a
	where	a.cd_pessoa_fisica = cd_pessoa_fisica_p
	and		a.nr_seq_cliente = nr_seq_cliente_p
	and		((coalesce(a.dt_final::text, '') = '') or (trunc(a.dt_final) >= clock_timestamp()));

	if (qt_gestor_w > 0) then
		ds_retorno_w	:= 'S';
	else
		ds_retorno_w	:= 'N';
	end if;
end if;

return ds_retorno_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ps_obter_gestor ( nr_seq_cliente_p bigint, cd_pessoa_fisica_p text) FROM PUBLIC;

