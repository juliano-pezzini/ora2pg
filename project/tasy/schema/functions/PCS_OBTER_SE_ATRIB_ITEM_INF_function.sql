-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pcs_obter_se_atrib_item_inf (nr_seq_registro_p bigint, cd_material_p bigint, ds_coluna_p text) RETURNS varchar AS $body$
DECLARE

--Verifica se o atributo possui informação
ie_retorno_w	varchar(1) := 'N';
vl_informacao_w	varchar(255);


BEGIN

begin
select	vl_informacao
into STRICT	vl_informacao_w
from	pcs_reg_analise_itens
where	nr_seq_registro = nr_seq_registro_p
and		cd_material		= cd_material_p
and		nm_informacao	= ds_coluna_p;
exception
when others then
	vl_informacao_w:= 'null';
end;

if (vl_informacao_w <> 'null') then
	ie_retorno_w := 'S';
end if;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pcs_obter_se_atrib_item_inf (nr_seq_registro_p bigint, cd_material_p bigint, ds_coluna_p text) FROM PUBLIC;

