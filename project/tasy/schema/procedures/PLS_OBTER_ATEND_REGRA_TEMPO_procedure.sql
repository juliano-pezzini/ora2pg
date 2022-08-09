-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_obter_atend_regra_tempo ( qt_tempo_p bigint, ds_regra_p INOUT text, ds_cor_p INOUT text, qt_tempo_maximo_p INOUT bigint) AS $body$
DECLARE


ds_regra_w		varchar(255);
ds_cor_w		varchar(40);
qt_tempo_maximo_w	bigint;


C01 CURSOR FOR
	SELECT	ds_regra,
			ds_cor,
			qt_tempo_maximo
	from (
			SELECT	ds_regra,
					ds_cor,
					qt_tempo_maximo
			from	pls_atend_regra_tempo
			where	ie_situacao = 'A'
			and		qt_tempo_maximo >= qt_tempo_p
			and (pls_obter_se_controle_estab('GA') = 'S' and (cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento ))
			
union all

			select	ds_regra,
					ds_cor,
					qt_tempo_maximo
			from	pls_atend_regra_tempo
			where	ie_situacao = 'A'
			and		qt_tempo_maximo >= qt_tempo_p
			and (pls_obter_se_controle_estab('GA') = 'N')) alias5
	order by qt_tempo_maximo desc;


BEGIN

open C01;
loop
fetch C01 into
	ds_regra_w,
	ds_cor_w,
	qt_tempo_maximo_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
end loop;
close C01;

if (coalesce(ds_regra_w::text, '') = '') then
	if (pls_obter_se_controle_estab('GA') = 'S') then
		begin
			select	ds_regra,
				ds_cor,
				qt_tempo_maximo
			into STRICT	ds_regra_w,
				ds_cor_w,
				qt_tempo_maximo_w
			from	pls_atend_regra_tempo
			where	ie_situacao = 'A'
			and (cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento )
			and	qt_tempo_maximo = (	SELECT	max(qt_tempo_maximo)
							from	pls_atend_regra_tempo
							where	ie_situacao = 'A'
							and (cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento ));
		exception
		when others then
			ds_regra_w := null;
			ds_cor_w  := 'clBtnFace';
			qt_tempo_maximo_w := 0;
		end;
	else
		begin
			select	ds_regra,
				ds_cor,
				qt_tempo_maximo
			into STRICT	ds_regra_w,
				ds_cor_w,
				qt_tempo_maximo_w
			from	pls_atend_regra_tempo
			where	ie_situacao = 'A'
			and	qt_tempo_maximo = (	SELECT	max(qt_tempo_maximo)
							from	pls_atend_regra_tempo
							where	ie_situacao = 'A');
		exception
		when others then
			ds_regra_w := null;
			ds_cor_w  := 'clBtnFace';
			qt_tempo_maximo_w := 0;
		end;
	end if;
end if;

ds_regra_p		:= ds_regra_w;
ds_cor_p		:= ds_cor_w;
qt_tempo_maximo_p	:= qt_tempo_maximo_w;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_obter_atend_regra_tempo ( qt_tempo_p bigint, ds_regra_p INOUT text, ds_cor_p INOUT text, qt_tempo_maximo_p INOUT bigint) FROM PUBLIC;
