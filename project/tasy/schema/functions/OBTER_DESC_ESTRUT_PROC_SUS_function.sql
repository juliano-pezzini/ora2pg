-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_estrut_proc_sus ( cd_area_proced_p bigint, cd_especial_proced_p bigint, cd_grupo_proced_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_grupo_p bigint, nr_seq_subgrupo_p bigint, nr_seq_forma_org_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(254);


BEGIN
begin
if (cd_procedimento_p IS NOT NULL AND cd_procedimento_p::text <> '') then
	begin
	select ds_procedimento
	into STRICT	 ds_retorno_w
	from	 procedimento
	where	 cd_procedimento	= cd_procedimento_p
        and  ie_origem_proced 		= ie_origem_proced_p;
	end;
elsif (nr_seq_forma_org_p IS NOT NULL AND nr_seq_forma_org_p::text <> '') then
	begin
	select	ds_forma_organizacao
	into STRICT	ds_retorno_w
	from 	sus_forma_organizacao
	where	nr_sequencia	= nr_seq_forma_org_p;
	end;
elsif (nr_seq_subgrupo_p IS NOT NULL AND nr_seq_subgrupo_p::text <> '') then
	begin
	select	ds_subgrupo
	into STRICT	ds_retorno_w
	from	sus_subgrupo
	where	nr_sequencia 	= nr_seq_subgrupo_p;
	end;
elsif (nr_seq_grupo_p IS NOT NULL AND nr_seq_grupo_p::text <> '') then
	begin
	select	ds_grupo
	into STRICT	ds_retorno_w
	from	sus_grupo
	where	nr_sequencia	= nr_seq_grupo_p;
	end;
elsif (cd_grupo_proced_p IS NOT NULL AND cd_grupo_proced_p::text <> '') then
	begin
	select ds_grupo_proc
	into STRICT	 ds_retorno_w
	from	 grupo_proc
	where	 cd_grupo_proc	= cd_grupo_proced_p;
	end;
elsif (cd_especial_proced_p IS NOT NULL AND cd_especial_proced_p::text <> '') then
	begin
	select ds_especialidade
	into STRICT	 ds_retorno_w
	from	 especialidade_proc
	where	 cd_especialidade	= cd_especial_proced_p;
	end;
elsif (cd_area_proced_p IS NOT NULL AND cd_area_proced_p::text <> '') then
	begin
	select ds_area_procedimento
	into STRICT	 ds_retorno_w
	from	 area_procedimento
	where	 cd_area_procedimento	= cd_area_proced_p;
	end;
end if;
exception
	when others then
		ds_retorno_w  :=  'Erro Procedimento';
end;
RETURN ds_retorno_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_estrut_proc_sus ( cd_area_proced_p bigint, cd_especial_proced_p bigint, cd_grupo_proced_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_seq_grupo_p bigint, nr_seq_subgrupo_p bigint, nr_seq_forma_org_p bigint) FROM PUBLIC;
