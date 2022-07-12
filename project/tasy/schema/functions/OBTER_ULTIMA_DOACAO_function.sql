-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ultima_doacao ( cd_pessoa_fisica_p text, nr_seq_doacao_p bigint) RETURNS timestamp AS $body$
DECLARE


dt_ultima_doacao_w		timestamp;
dt_ultima_doacao_ww		timestamp;
ie_considera_doacao_w	varchar(1);
ie_doacao_w				varchar(1);

BEGIN

select ie_contar_doacao
into STRICT	ie_considera_doacao_w
from 	san_parametro
where 	cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento;

if (ie_considera_doacao_w = 'S') then

	select	max(dt_doacao)
	into STRICT	dt_ultima_doacao_w
	from 	san_doacao
	where 	ie_avaliacao_final 	= 'A'
	and	cd_pessoa_fisica 	= cd_pessoa_fisica_p;
else

	begin
	select 	CASE WHEN count(*)=0 THEN 'S'  ELSE 'N' END
	into STRICT	ie_doacao_w
	from	san_doacao
	where	nr_sequencia = nr_seq_doacao_p
	and 	ie_status in (1,5);

	if (ie_doacao_w = 'S') then
		select	max(dt_doacao)
		into STRICT	dt_ultima_doacao_w
		from 	san_doacao
		where 	ie_avaliacao_final 	= 'A'
		and	cd_pessoa_fisica 	= cd_pessoa_fisica_p
		and	nr_sequencia <> nr_seq_doacao_p;
	else
		select	max(dt_doacao)
		into STRICT	dt_ultima_doacao_w
		from 	san_doacao
		where 	ie_avaliacao_final 	= 'A'
		and	cd_pessoa_fisica 	= cd_pessoa_fisica_p;
	end if;

		-- verifica última doação mesmo que a mesma não tenha sido considerada apta
	select	max(dt_doacao)
	into STRICT	dt_ultima_doacao_ww
	from 	san_doacao
	where 	1 = 1
	and		cd_pessoa_fisica 	= cd_pessoa_fisica_p;

	if ((dt_ultima_doacao_ww > dt_ultima_doacao_w)  or (coalesce(dt_ultima_doacao_w::text, '') = '')) then
		dt_ultima_doacao_w := dt_ultima_doacao_ww;
	end if;
	end;
end if;

return	dt_ultima_doacao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ultima_doacao ( cd_pessoa_fisica_p text, nr_seq_doacao_p bigint) FROM PUBLIC;
