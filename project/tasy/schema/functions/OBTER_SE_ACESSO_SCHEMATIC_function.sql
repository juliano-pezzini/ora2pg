-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_acesso_schematic (nr_seq_func_schematic_p bigint, nm_usuario_p text) RETURNS varchar AS $body$
DECLARE


dt_liberacao_w	timestamp;
ie_acesso_w	varchar(1);
ds_retorno_w	varchar(1);


BEGIN

select	max(dt_liberacao)
into STRICT	dt_liberacao_w
from	funcao_schematic
where	nr_sequencia	= nr_seq_func_schematic_p;

if (coalesce(dt_liberacao_w::text, '') = '') then
	ds_retorno_w	:= 'S';
else
	select	max(ie_acesso)
	into STRICT	ie_acesso_w
	from	funcao_schematic_lib
	where	nr_seq_funcao_schematic = nr_seq_func_schematic_p
	and	nm_usuario_liberado 	= nm_usuario_p;

	if (ie_acesso_w = 'T') then
		ds_retorno_w := 'S';
	else
		ds_retorno_w := 'N';
	end if;

end if;

return 	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_acesso_schematic (nr_seq_func_schematic_p bigint, nm_usuario_p text) FROM PUBLIC;
