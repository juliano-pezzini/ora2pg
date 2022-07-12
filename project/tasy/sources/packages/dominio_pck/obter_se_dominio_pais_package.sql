-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION dominio_pck.obter_se_dominio_pais ( cd_dominio_p bigint, vl_dominio_p text, cd_pais_p bigint) RETURNS varchar AS $body$
DECLARE

	qt_registro_w	bigint;
	chave_w	varchar(100);
	
BEGIN
	chave_w		:= cd_dominio_p||'_'||vl_dominio_p||'_'||cd_pais_p;
	
	if (current_setting('dominio_pck.dominio_pais_w')::vetorDominioPais.exists(chave_w)) then
		return current_setting('dominio_pck.dominio_pais_w')::vetorDominioPais[chave_w].ie_exibir;
	else
		current_setting('dominio_pck.dominio_pais_w')::vetorDominioPais[chave_w].cd_dominio		:= cd_dominio_p;
		current_setting('dominio_pck.dominio_pais_w')::vetorDominioPais[chave_w].vl_dominio		:= vl_dominio_p;
		current_setting('dominio_pck.dominio_pais_w')::vetorDominioPais[chave_w].cd_pais			:= cd_pais_p;	
		current_setting('dominio_pck.dominio_pais_w')::vetorDominioPais[chave_w].ie_exibir		:= 'S';
		
		select	count(1)
		into STRICT	qt_registro_w
		from	valor_dominio_pais
		where	cd_dominio 	= cd_dominio_p
		and	vl_dominio 	= vl_dominio_p;
		
		if (qt_registro_w	> 0) then
			
			select	count(1)
			into STRICT	qt_registro_w
			from	valor_dominio_pais
			where	cd_dominio 	= cd_dominio_p
			and	vl_dominio 	= vl_dominio_p
			and	cd_pais 	= cd_pais_p;
			
			if (qt_registro_w	= 0) then
				current_setting('dominio_pck.dominio_pais_w')::vetorDominioPais[chave_w].ie_exibir		:= 'N';
			end if;
			
		end if;
		
		return current_setting('dominio_pck.dominio_pais_w')::vetorDominioPais[chave_w].ie_exibir;
	end if;
	
	return null;
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION dominio_pck.obter_se_dominio_pais ( cd_dominio_p bigint, vl_dominio_p text, cd_pais_p bigint) FROM PUBLIC;