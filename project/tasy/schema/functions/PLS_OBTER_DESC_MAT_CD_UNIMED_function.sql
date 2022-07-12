-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_desc_mat_cd_unimed ( cd_material_ops_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255)	:= '';
nr_seq_material_w	pls_material.nr_sequencia%type;


BEGIN

nr_seq_material_w	:= pls_obter_seq_material_unimed(cd_material_ops_p);--pls_obter_seq_codigo_material(null,cd_material_ops_p,'S');
if (nr_seq_material_w IS NOT NULL AND nr_seq_material_w::text <> '') then
	select	coalesce(max(ds_material),'')
	into STRICT	ds_retorno_w
	from	pls_material
	where	nr_sequencia	= nr_seq_material_w;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_desc_mat_cd_unimed ( cd_material_ops_p text) FROM PUBLIC;
