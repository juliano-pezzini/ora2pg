-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_cd_anvisa_material ( nr_seq_material_p pls_material.nr_sequencia%type) RETURNS varchar AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
Obter o registro Anvisa do material
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  x]  Objetos do dicionário [ ] Tasy (Delphi/Java) [   ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ds_retorno_w		material_estab.nr_registro_anvisa%type;
cd_material_w		pls_material.cd_material%type;
cd_estabelecimento_w	pls_material.cd_estabelecimento%type;

BEGIN

begin
	select	(nr_registro_anvisa)::numeric
	into STRICT	ds_retorno_w
	from	pls_material
	where	nr_sequencia = nr_seq_material_p;
exception
when others then
	ds_retorno_w := null;
end;

if (coalesce(ds_retorno_w::text, '') = '') then
	begin
		select	(max(a.cd_anvisa))::numeric
		into STRICT	ds_retorno_w
		from	pls_mat_unimed_fed_sc a,
			pls_material b
		where	a.nr_sequencia = b.nr_seq_mat_uni_fed_sc
		and	b.nr_sequencia = nr_seq_material_p;
	exception
	when others then
		ds_retorno_w	:= null;
	end;
end if;

if (coalesce(ds_retorno_w::text, '') = '') then
	begin
		select	cd_material,
			cd_estabelecimento
		into STRICT	cd_material_w,
			cd_estabelecimento_w
		from	pls_material
		where	nr_sequencia = nr_seq_material_p;
	exception
	when others then
		cd_material_w	:= null;
	end;

	if (cd_material_w IS NOT NULL AND cd_material_w::text <> '') then
		begin
			select	(nr_registro_anvisa)::numeric
			into STRICT	ds_retorno_w
			from 	material_estab
			where 	cd_material		= cd_material_w
			and	cd_estabelecimento = cd_estabelecimento_w;
		exception
		when others then
			ds_retorno_w	:= null;
		end;
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_cd_anvisa_material ( nr_seq_material_p pls_material.nr_sequencia%type) FROM PUBLIC;

