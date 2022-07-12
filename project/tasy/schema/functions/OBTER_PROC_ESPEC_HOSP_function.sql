-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_proc_espec_hosp ( cd_procedimento_p bigint, ie_origem_proced_p bigint, ie_tipo_p text) RETURNS varchar AS $body$
DECLARE



ie_espec_proc_w			smallint;
nr_seq_grupo_w			bigint;
nr_seq_subgrupo_w		bigint;
nr_seq_forma_org_w		bigint;
ds_retorno_w			varchar(80)	:= '';



BEGIN

begin
select	nr_seq_grupo,
	nr_seq_subgrupo,
	nr_seq_forma_org
into STRICT	nr_seq_grupo_w,
	nr_seq_subgrupo_w,
	nr_seq_forma_org_w
from	sus_estrutura_procedimento_v
where	cd_procedimento		= cd_procedimento_p
and	ie_origem_proced		= ie_origem_proced_p;
exception
	when others then
	nr_seq_grupo_w		:= 0;
	nr_seq_subgrupo_w	:= 0;
	nr_seq_forma_org_w	:= 0;
end;

begin
select	max(ie_especialidade_proc)
into STRICT	ie_espec_proc_w
from	sus_proc_espec_hosp
where	coalesce(cd_procedimento, cd_procedimento_p)		= cd_procedimento_p
and	coalesce(ie_origem_proced, ie_origem_proced_p)		= ie_origem_proced_p
and	coalesce(nr_seq_grupo, coalesce(nr_seq_grupo_w,0))		= coalesce(nr_seq_grupo_w,0)
and	coalesce(nr_seq_subgrupo, coalesce(nr_seq_subgrupo_w,0))		= coalesce(nr_seq_subgrupo_w,0)
and	coalesce(nr_seq_forma_org, coalesce(nr_seq_forma_org_w,0))		= coalesce(nr_seq_forma_org_w,0);
exception
	when others then
	ie_espec_proc_w	:= null;
end;

if (ie_tipo_p	= 'C') then
	ds_retorno_w	:= ie_espec_proc_w;
elsif (ie_tipo_p	= 'D') then
	ds_retorno_w	:= coalesce(substr(obter_valor_dominio(1900, ie_espec_proc_w),1,80),'');
end if;

return	ds_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_proc_espec_hosp ( cd_procedimento_p bigint, ie_origem_proced_p bigint, ie_tipo_p text) FROM PUBLIC;
