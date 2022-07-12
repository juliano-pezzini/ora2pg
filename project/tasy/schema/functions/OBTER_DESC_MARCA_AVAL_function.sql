-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_marca_aval ( nr_seq_marca_p bigint, cd_material_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255) := '';
ie_todas_marcas_w	varchar(1);


BEGIN
ie_todas_marcas_w := obter_param_usuario(4100, 15, obter_perfil_ativo, obter_usuario_ativo, obter_estabelecimento_ativo, ie_todas_marcas_w);

if (cd_material_p > 0) and (nr_seq_marca_p IS NOT NULL AND nr_seq_marca_p::text <> '') then
	if (ie_todas_marcas_w = 'T') then
		select	ds_marca
		into STRICT	ds_retorno_w
		from	marca
		where	nr_sequencia = nr_seq_marca_p
		group by ds_marca;
	else
		ds_retorno_w := obter_desc_material_marca(nr_seq_marca_p,cd_material_p);
	end if;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_marca_aval ( nr_seq_marca_p bigint, cd_material_p bigint) FROM PUBLIC;
