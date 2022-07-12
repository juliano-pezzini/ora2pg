-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_usuario_conta_banco (nr_seq_conta_banco_p bigint, cd_perfil_p bigint, nm_usuario_p text) RETURNS varchar AS $body$
DECLARE


ie_retorno_w		varchar(1)	:= 'S';
cd_perfil_w		integer;
nm_usuario_param_w	varchar(15);
cont_perfil_w		bigint;
cont_usuario_w		bigint;

c01 CURSOR FOR
SELECT	b.cd_perfil,
	to_char(null) nm_usuario_param
from	banco_estab_perfil b
where	b.nr_seq_conta_banco	= nr_seq_conta_banco_p
and	cd_perfil		= cd_perfil_p

union all

select	(null)::numeric  cd_perfil,
	a.nm_usuario_param
from	banco_estab_usuario a
where	a.nr_seq_conta_banco	= nr_seq_conta_banco_p
and	a.nm_usuario_param	= nm_usuario_p;


BEGIN

if (nr_seq_conta_banco_p IS NOT NULL AND nr_seq_conta_banco_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') and (cd_perfil_p IS NOT NULL AND cd_perfil_p::text <> '') then

	select	count(*)
	into STRICT	cont_perfil_w
	from	banco_estab_perfil
	where	nr_seq_conta_banco	= nr_seq_conta_banco_p;

	select	count(*)
	into STRICT	cont_usuario_w
	from	banco_estab_usuario
	where	nr_seq_conta_banco	= nr_seq_conta_banco_p;

	if (cont_perfil_w + cont_usuario_w = 0) then
		ie_retorno_w	:= 'S';
	else
		ie_retorno_w	:= 'N';

		open	c01;
		loop
		fetch 	c01 into
			cd_perfil_w,
			nm_usuario_param_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
			ie_retorno_w	:= 'S';
		end loop;
		close	c01;
	end if;
end if;

return coalesce(ie_retorno_w,'S');

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_usuario_conta_banco (nr_seq_conta_banco_p bigint, cd_perfil_p bigint, nm_usuario_p text) FROM PUBLIC;
