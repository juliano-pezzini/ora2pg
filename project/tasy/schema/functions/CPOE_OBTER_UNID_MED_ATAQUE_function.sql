-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cpoe_obter_unid_med_ataque (cd_unidade_medida_p cpoe_material.cd_unidade_medida%type, ie_controle_tempo_p cpoe_material.ie_controle_tempo%type) RETURNS varchar AS $body$
DECLARE


ds_retorno_w  	varchar(255);


BEGIN

if (ie_controle_tempo_p = 'S') then
	begin
	ds_retorno_w := wheb_mensagem_pck.get_texto(332319, null);
	end;
else

	if (cd_unidade_medida_p IS NOT NULL AND cd_unidade_medida_p::text <> '') then
		begin
		select 	max(ds_unidade_medida)
		into STRICT	ds_retorno_w
		from 	unidade_medida
		where 	cd_unidade_medida = cd_unidade_medida_p;
		end;
	end if;
end if;

return	ds_retorno_w;



end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cpoe_obter_unid_med_ataque (cd_unidade_medida_p cpoe_material.cd_unidade_medida%type, ie_controle_tempo_p cpoe_material.ie_controle_tempo%type) FROM PUBLIC;

