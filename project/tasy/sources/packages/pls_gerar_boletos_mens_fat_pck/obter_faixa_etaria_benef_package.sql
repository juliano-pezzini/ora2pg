-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_gerar_boletos_mens_fat_pck.obter_faixa_etaria_benef ( qt_idade_p bigint, ie_tipo_p text) RETURNS bigint AS $body$
DECLARE


	/*ie_tipo_p
	I = Inicial
	F = Final*/
	index_w					bigint := 0;

	
BEGIN

	if (qt_idade_p	>= 0) then
		for index_w in 1..reg_faixas_etarias_w.count loop
			if (qt_idade_p >= current_setting('pls_gerar_boletos_mens_fat_pck.reg_faixas_etarias_w')::reg_faixas_etarias_v[index_w].qt_idade_inicial) and (qt_idade_p <= current_setting('pls_gerar_boletos_mens_fat_pck.reg_faixas_etarias_w')::reg_faixas_etarias_v[index_w].qt_idade_final) then

				if (ie_tipo_p = 'I') then
					return current_setting('pls_gerar_boletos_mens_fat_pck.reg_faixas_etarias_w')::reg_faixas_etarias_v[index_w].qt_idade_inicial;
				elsif (ie_tipo_p = 'F') then
					return current_setting('pls_gerar_boletos_mens_fat_pck.reg_faixas_etarias_w')::reg_faixas_etarias_v[index_w].qt_idade_final;
				end if;
			end if;
		end loop;
	end if;

	return null;

	end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_gerar_boletos_mens_fat_pck.obter_faixa_etaria_benef ( qt_idade_p bigint, ie_tipo_p text) FROM PUBLIC;
