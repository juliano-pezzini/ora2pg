-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_exibe_int_sae ( cd_intervalo_p text) RETURNS varchar AS $body$
DECLARE


ie_exibe_w					varchar(1);
IE_MOSTRAR_SAE_W			varchar(1) := 'S';
cd_estab_w					bigint;

c01 CURSOR FOR
SELECT	coalesce(IE_MOSTRAR_SAE,'S')
from	INTERVALO_ESTABELECIMENTO
where	((coalesce(CD_ESTAB::text, '') = '') or (CD_ESTAB = cd_estab_w))
and		cd_intervalo		= cd_intervalo_p
order by CD_ESTAB DESC;


BEGIN

if (cd_intervalo_p IS NOT NULL AND cd_intervalo_p::text <> '') then

cd_estab_w := coalesce(wheb_usuario_pck.get_cd_estabelecimento,1);

	select	coalesce(max('N'),'S')
	into STRICT	ie_exibe_w
	from	INTERVALO_ESTABELECIMENTO
	where	cd_intervalo = cd_intervalo_p;

	if (ie_exibe_w = 'N') then

		ie_exibe_w := 'S';

		open C01;
		loop
		fetch C01 into
			ie_exibe_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin
			ie_exibe_w	:= ie_exibe_w;
			end;
		end loop;
		close C01;

	end if;
end if;

return ie_exibe_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_exibe_int_sae ( cd_intervalo_p text) FROM PUBLIC;
