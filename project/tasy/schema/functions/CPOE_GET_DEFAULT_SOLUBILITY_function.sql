-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cpoe_get_default_solubility ( cd_material_p material.cd_material%type) RETURNS bigint AS $body$
DECLARE


nr_seq_solubilidade_w		nutricao_leite_deriv_solub.nr_sequencia%type;

c01 CURSOR FOR
	SELECT	a.nr_sequencia
	from	nutricao_leite_deriv_solub a,
			nutricao_leite_deriv b
	where	b.nr_sequencia = a.nr_seq_produto
	and		coalesce(a.ie_situacao,'A') = 'A'
	and		b.cd_material = cd_material_p
	and		coalesce(ie_padrao,'N') = 'S'
	and 	coalesce(b.ie_situacao,'A') = 'A'
	order by a.nr_sequencia;


BEGIN

if (cd_material_p IS NOT NULL AND cd_material_p::text <> '') then
	open c01;
	loop
	fetch c01 into nr_seq_solubilidade_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
	end loop;
	close c01;
end if;

return nr_seq_solubilidade_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cpoe_get_default_solubility ( cd_material_p material.cd_material%type) FROM PUBLIC;

