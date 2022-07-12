-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_just_contra_atend (nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


cd_just_contraste_w	bigint;
ds_justificativa_w	varchar(255);
ds_justificativa_ww	varchar(2000);

C01 CURSOR FOR
	SELECT	coalesce(cd_justi_contraste,0)
	from	material_atend_paciente
	where	nr_atendimento = nr_atendimento_p
	and	(cd_justi_contraste IS NOT NULL AND cd_justi_contraste::text <> '');


BEGIN

ds_justificativa_ww := '';

if (coalesce(nr_atendimento_p,0) > 0) then

	open C01;
	loop
	fetch C01 into
		cd_just_contraste_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		if (cd_just_contraste_w > 0) then
			select	substr(ds_justificativa,1,255)
			into STRICT	ds_justificativa_w
			from	justif_uso_contraste
			where	nr_sequencia = cd_just_contraste_w;

			if (coalesce(ds_justificativa_ww::text, '') = '') then

				ds_justificativa_ww := ds_justificativa_w;
			else
				ds_justificativa_ww := substr(ds_justificativa_ww || chr(13) || chr(10) || ds_justificativa_w,1,2000);

			end if;
		end if;
		end;
	end loop;
	close C01;

end if;
return	ds_justificativa_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_just_contra_atend (nr_atendimento_p bigint) FROM PUBLIC;

