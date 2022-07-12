-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_unidade_medida_sv2 ( nr_seq_sv_p bigint, ds_atributo_p text, ie_um_sv_p text default null) RETURNS varchar AS $body$
DECLARE



ds_retorno_w	varchar(255);


BEGIN
if ((trim(both ds_atributo_p) IS NOT NULL AND (trim(both ds_atributo_p))::text <> '')) then

	if (nr_seq_sv_p = 12) then -- Peso
		/*  --------- O VALOR PASSADO SEMPRE SERÁ EM GRAMAS ---------   */

		if (coalesce(ie_um_sv_p,'Kg') = 'Kg') then

			ds_retorno_w := (ds_atributo_p / 1000);

		else

			ds_retorno_w := ds_atributo_p;

		end if;

		ds_retorno_w := ds_retorno_w || ' ' || ie_um_sv_p;

	elsif (nr_seq_sv_p = 13) then -- Altura
		/*  --------- O VALOR PASSADO SEMPRE SERÁ EM CENTÍMETROS ---------   */

		if (coalesce(ie_um_sv_p,'cm') = 'm') then

			ds_retorno_w := (ds_atributo_p / 100);

		else

			ds_retorno_w := ds_atributo_p;

		end if;

		ds_retorno_w := ds_retorno_w || ' ' || ie_um_sv_p;

	end if;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_unidade_medida_sv2 ( nr_seq_sv_p bigint, ds_atributo_p text, ie_um_sv_p text default null) FROM PUBLIC;
