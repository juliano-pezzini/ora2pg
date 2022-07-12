-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_verifica_mens_gerada_js ( ds_lista_mensalidades_p text, nm_usuario_p text) RETURNS varchar AS $body$
DECLARE


ds_lista_mensalidades_w	varchar(2000);
nr_pos_virgula_w		bigint;
nr_sequencia_w		bigint;
ie_retorno_w		varchar(1) := 'N';


BEGIN

if (ds_lista_mensalidades_p IS NOT NULL AND ds_lista_mensalidades_p::text <> '') then

	begin

		ds_lista_mensalidades_w		:= ds_lista_mensalidades_p;

	while(ds_lista_mensalidades_w IS NOT NULL AND ds_lista_mensalidades_w::text <> '') loop
		begin

		nr_pos_virgula_w	:= position(',' in ds_lista_mensalidades_w);

		if (nr_pos_virgula_w > 0) then
			begin
			nr_sequencia_w			:= (substr(ds_lista_mensalidades_w,0,nr_pos_virgula_w-1))::numeric;
			ds_lista_mensalidades_w		:= substr(ds_lista_mensalidades_w,nr_pos_virgula_w+1,length(ds_lista_mensalidades_w));
			end;
		else
			begin
			nr_sequencia_w			:= (ds_lista_mensalidades_w)::numeric;
			ds_lista_mensalidades_w		:= null;
			end;
		end if;

		if (nr_sequencia_w > 0) then
			ie_retorno_w := 'S';
		end if;
		end;
	end loop;
	end;
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_verifica_mens_gerada_js ( ds_lista_mensalidades_p text, nm_usuario_p text) FROM PUBLIC;

