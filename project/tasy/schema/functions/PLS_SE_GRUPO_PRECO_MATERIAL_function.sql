-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_se_grupo_preco_material ( nr_seq_grupo_material_p pls_preco_grupo_material.nr_sequencia%type, nr_seq_material_p pls_material.nr_sequencia%type) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(1)	:= 'N';
qt_regra_w		integer;


BEGIN

if (nr_seq_grupo_material_p IS NOT NULL AND nr_seq_grupo_material_p::text <> '') and (nr_seq_material_p IS NOT NULL AND nr_seq_material_p::text <> '') then

	-- verifica se o material passado de parâmetro pertence ao grupo passado, caso um dos dois seja nulo
	-- então o retorno é N ou caso não pertença
	select	count(1)
	into STRICT	qt_regra_w
	from	pls_grupo_material_tm	a
	where	a.nr_seq_grupo		= nr_seq_grupo_material_p
	and	a.nr_seq_material	= nr_seq_material_p  LIMIT 1;

	if (qt_regra_w > 0) then
		ds_retorno_w	:= 'S';
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_se_grupo_preco_material ( nr_seq_grupo_material_p pls_preco_grupo_material.nr_sequencia%type, nr_seq_material_p pls_material.nr_sequencia%type) FROM PUBLIC;
