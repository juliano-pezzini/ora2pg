-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cml_obter_regra_lib_prospect ( nm_usuario_prospect_p text, nm_usuario_p text) RETURNS varchar AS $body$
DECLARE


cd_setor_w			integer;
ie_acao_w			varchar(1);
nm_usuario_prospect_w		varchar(15);
nm_usuario_regra_w		varchar(15);
qt_regras_w			bigint;


c01 CURSOR FOR
SELECT	coalesce(a.ie_acao, 'S'),
	a.nm_usuario_prospect,
	a.cd_setor_atendimento,
	a.nm_usuario_regra
from	cml_prospect_regra a
where	coalesce(nm_usuario_prospect, nm_usuario_prospect_p)	= nm_usuario_prospect_p
and	coalesce(nm_usuario_regra, nm_usuario_p)			= nm_usuario_p
order by	coalesce(nm_usuario_regra, 'A'),
	coalesce(cd_setor_atendimento, 0);

BEGIN

ie_acao_w			:= 'S';

/*Se existir regras de lib para prospects deste usuario*/

select	count(*)
into STRICT	qt_regras_w
from	cml_prospect_regra
where	nm_usuario_prospect		= nm_usuario_prospect_p
and	coalesce(nm_usuario_regra, nm_usuario_p)	= nm_usuario_p;

if (qt_regras_w > 0) then
	begin

	ie_acao_w		:= 'N';
	open C01;
	loop
	fetch C01 into
		ie_acao_w,
		nm_usuario_prospect_w,
		cd_setor_w,
		nm_usuario_regra_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		if (coalesce(nm_usuario_regra_w::text, '') = '') and (cd_setor_w IS NOT NULL AND cd_setor_w::text <> '') then

			select	coalesce(max(ie_acao_w), 'S')
			into STRICT	ie_acao_w
			from	usuario_setor_v b
			where	b.cd_setor_atendimento	= cd_setor_w
			and	b.nm_usuario		= nm_usuario_p;

		end if;

		ie_acao_w	:= ie_acao_w;
		end;
	end loop;
	close C01;

	end;
end if;

return	ie_acao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cml_obter_regra_lib_prospect ( nm_usuario_prospect_p text, nm_usuario_p text) FROM PUBLIC;
