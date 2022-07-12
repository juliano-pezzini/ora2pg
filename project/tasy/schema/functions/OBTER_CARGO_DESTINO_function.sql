-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_cargo_destino ( nr_sequencia_p bigint, nm_usuario_param_p text, cd_pessoa_fisica_p text ) RETURNS bigint AS $body$
DECLARE


nr_seq_destino_w	bigint;
cd_cargo_w		bigint;


BEGIN

cd_cargo_w	:= 0;

select	min(coalesce(nr_sequencia,0))
into STRICT	nr_seq_destino_w
from	usuario_setor_cargo
where (nm_usuario_param	= nm_usuario_param_p or cd_pessoa_fisica = cd_pessoa_fisica_p)
and 	nr_sequencia 		> nr_sequencia_p;

if (nr_seq_destino_w > 0) then
	select	max(cd_cargo)
	into STRICT	cd_cargo_w
	from	usuario_setor_cargo
	where	nr_sequencia	= nr_seq_destino_w;
end if;

return	cd_cargo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_cargo_destino ( nr_sequencia_p bigint, nm_usuario_param_p text, cd_pessoa_fisica_p text ) FROM PUBLIC;

