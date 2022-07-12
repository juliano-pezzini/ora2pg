-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_regra_atributo_wcpanel ( nr_seq_wcpanel_p bigint, cd_perfil_p bigint, nm_usuario_p text, ie_mmed text default null) RETURNS varchar AS $body$
DECLARE


nr_seq_atributo_w	bigint;
ie_atributo_w		varchar(1);
ds_regra_wcpanel_w	varchar(3000);
ie_configuravel_w	varchar(1);
ds_titulo_w		varchar(50);

c01 CURSOR FOR
SELECT	a.nr_sequencia,
	a.ie_configuravel
from 	dic_objeto a
where 	a.nr_seq_obj_sup = nr_seq_wcpanel_p
and	a.ie_tipo_objeto = 'AC'
and 	a.ie_configuravel in ('S','P','R')
order by
	a.nr_seq_apres;

c02 CURSOR FOR
SELECT	ie_exibir_atributo,
	ds_titulo
from	wcp_regra_atributo
where	nr_seq_wcpanel = nr_seq_wcpanel
and	nr_seq_atributo = nr_seq_atributo_w
and	coalesce(nm_usuario_regra,nm_usuario_p) = nm_usuario_p
and	coalesce(cd_perfil,cd_perfil_p) = cd_perfil_p
order by
	coalesce(nm_usuario_regra,'AAAAAAAAAAAAAA'),
	coalesce(cd_perfil,0);


BEGIN
if (nr_seq_wcpanel_p IS NOT NULL AND nr_seq_wcpanel_p::text <> '') and (cd_perfil_p IS NOT NULL AND cd_perfil_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin
	open c01;
	loop
	fetch c01 into
		nr_seq_atributo_w,
		ie_configuravel_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		ie_atributo_w	:= null;
		ds_titulo_w	:= null;
		if (ie_configuravel_w = 'P') then
			ie_atributo_w	:= 'S';
		elsif (ie_configuravel_w = 'R') then
			ie_atributo_w	:= 'N';
		end if;

		open c02;
		loop
		fetch c02 into
			ie_atributo_w,
			ds_titulo_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
			begin
			ie_atributo_w	:= ie_atributo_w;
			ds_titulo_w	:= ds_titulo_w;
			end;
		end loop;
		close c02;

		if (coalesce(ie_mmed::text, '') = '') then
			ds_regra_wcpanel_w := ds_regra_wcpanel_w || nr_seq_atributo_w || '=' || coalesce(ie_atributo_w,'N') || '@1' || ds_titulo_w || ';';
		else
			ds_regra_wcpanel_w := ds_regra_wcpanel_w || nr_seq_atributo_w || '=' || coalesce(ie_atributo_w,'N') || '@1;';
		end if;


		end;
	end loop;
	close c01;
	end;
end if;
return ds_regra_wcpanel_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_regra_atributo_wcpanel ( nr_seq_wcpanel_p bigint, cd_perfil_p bigint, nm_usuario_p text, ie_mmed text default null) FROM PUBLIC;
