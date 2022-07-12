-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_consistir_regra_rep (nr_seq_regra_p bigint, cd_perfil_p bigint) RETURNS varchar AS $body$
DECLARE


ie_regra_existe_w		varchar(1);
ie_consistir_w		varchar(1);
ie_forma_consistencia_w	varchar(15);
ie_regra_lib_wheb_w	varchar(15);
ie_regra_lib_perfil_w	varchar(15);

c01 CURSOR FOR
SELECT	ie_forma_consistencia
from	regra_consiste_prescr_par
where	nr_seq_regra 		= nr_seq_regra_p
and	coalesce(cd_perfil,cd_perfil_p)	= cd_perfil_p
order by coalesce(cd_perfil,0),
	nr_sequencia;


BEGIN
if (nr_seq_regra_p IS NOT NULL AND nr_seq_regra_p::text <> '') then

	select	coalesce(max('S'),'N'),
		max(ie_forma_consistencia),
		max(ie_libera_prescr)
	into STRICT	ie_regra_existe_w,
		ie_forma_consistencia_w,
		ie_regra_lib_wheb_w
	from	regra_consiste_prescr
	where	nr_sequencia = nr_seq_regra_p;

	if (ie_regra_existe_w = 'S') then
		if (ie_forma_consistencia_w = 'R') then
			open c01;
			loop
			fetch c01 into ie_regra_lib_perfil_w;
			EXIT WHEN NOT FOUND; /* apply on c01 */
				begin
				ie_regra_lib_perfil_w	:= ie_regra_lib_perfil_w;
				end;
			end loop;
			close c01;

			if (ie_regra_lib_perfil_w IS NOT NULL AND ie_regra_lib_perfil_w::text <> '') then
				if (ie_regra_lib_perfil_w = 'X') then
					ie_consistir_w	:= 'N';
				else
					ie_consistir_w	:= 'S';
				end if;
			elsif (ie_regra_lib_wheb_w = 'X') then
				ie_consistir_w	:= 'N';
			else
				ie_consistir_w	:= 'S';
			end if;
		else
			ie_consistir_w	:= 'S';
		end if;
	else
		ie_consistir_w	:= 'N';
	end if;
else
	ie_consistir_w	:= 'N';
end if;

return ie_consistir_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_consistir_regra_rep (nr_seq_regra_p bigint, cd_perfil_p bigint) FROM PUBLIC;

