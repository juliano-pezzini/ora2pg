-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_exibir_funcao_dic_obj ( cd_funcao_p bigint, ie_favoritos_p text, ds_favoritos_p text, ie_chamada_p text, cd_funcao_chamada_p bigint) RETURNS varchar AS $body$
DECLARE


ie_exibir_w	varchar(1) := 'S';


BEGIN
if (cd_funcao_p IS NOT NULL AND cd_funcao_p::text <> '') then
	begin
	if (ie_chamada_p = 'S') and (cd_funcao_p = cd_funcao_chamada_p) then
		begin
		ie_exibir_w := 'S';
		end;
	elsif (ie_chamada_p = 'N') then
		begin
		if (ie_favoritos_p IS NOT NULL AND ie_favoritos_p::text <> '') and (ds_favoritos_p IS NOT NULL AND ds_favoritos_p::text <> '') then
			begin
			if (ie_favoritos_p = 'S') then
				begin
				ie_exibir_w := obter_se_contido(cd_funcao_p,ds_favoritos_p);
				end;
			else
				begin
				ie_exibir_w := 'S';
				end;
			end if;
			end;
		else
			begin
			ie_exibir_w := 'S';
			end;
		end if;
		end;
	else
		begin
		ie_exibir_w := 'N';
		end;
	end if;
	end;
end if;
return ie_exibir_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_exibir_funcao_dic_obj ( cd_funcao_p bigint, ie_favoritos_p text, ds_favoritos_p text, ie_chamada_p text, cd_funcao_chamada_p bigint) FROM PUBLIC;
