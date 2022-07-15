-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE excluir_carga_brasindice (dt_inicio_vigencia_p timestamp, ds_filtro_estab_p text, ie_filtro_estab_p text, cd_estabelecimento_p text) AS $body$
BEGIN

if (dt_inicio_vigencia_p IS NOT NULL AND dt_inicio_vigencia_p::text <> '') then
	if (ds_filtro_estab_p <> ' ') then
		begin
		if (ie_filtro_estab_p = '1') then
			begin
			delete
			from	brasindice_preco
			where	dt_inicio_vigencia = dt_inicio_vigencia_p
			and     obter_se_contido(cd_estabelecimento, elimina_aspas(ds_filtro_estab_p)) = 'S';
			end;
      	 else
       		begin
			delete
			from	brasindice_preco
			where	dt_inicio_vigencia = dt_inicio_vigencia_p
			and     obter_se_contido(cd_estabelecimento, elimina_aspas(ds_filtro_estab_p)) <> 'S';
			end;
		end if;
		end;
	elsif (cd_estabelecimento_p IS NOT NULL AND cd_estabelecimento_p::text <> '') then
	    begin
		delete
		from	brasindice_preco
		where	dt_inicio_vigencia = dt_inicio_vigencia_p
		and         cd_estabelecimento = cd_estabelecimento_p;
		end;
	else
		begin
		delete
		from	brasindice_preco
		where	dt_inicio_vigencia = dt_inicio_vigencia_p;
		end;
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE excluir_carga_brasindice (dt_inicio_vigencia_p timestamp, ds_filtro_estab_p text, ie_filtro_estab_p text, cd_estabelecimento_p text) FROM PUBLIC;

