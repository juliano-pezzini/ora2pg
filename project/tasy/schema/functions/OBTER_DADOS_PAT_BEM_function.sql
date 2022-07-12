-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_pat_bem ( cd_bem_p text, ie_opcao_p text, nr_seq_bem_p bigint default 0) RETURNS varchar AS $body$
DECLARE

/*	CD - Código do bem
	DS - Descriçao do bem
	LO - Código da localizacao
	TI - Código do tipo
	DT - Descrição do tipo
	TB - Descricao do tipo com descricao do bem
	CE - Centro custo
	DC - Descrição centro custo
	DL - Descrição da localizacao
	SUI - Sequencia último inventário
	PR  - Propriedade
	TV - Tipo valor
*/
cd_bem_w		varchar(20);
cd_centro_custo_w		integer;
ds_bem_w		varchar(255);
nr_seq_local_w		bigint;
nr_seq_tipo_w		bigint;
ds_tipo_w		varchar(80);
ds_tipo_bem_w		varchar(350);
ds_retorno_w		varchar(350);
nr_seq_bem_w		bigint;
ie_propriedade_w		varchar(15);
ie_tipo_valor_w		pat_bem.ie_tipo_valor%type;


BEGIN
if (coalesce(nr_seq_bem_p,0) > 0) then
	nr_seq_bem_w := nr_seq_bem_p;
else
	select	max(nr_sequencia)
	into STRICT	nr_seq_bem_w
	from	pat_bem
	where	cd_bem = cd_bem_p;
end if;

select	a.cd_bem,
	a.ds_bem,
	a.nr_seq_local,
	a.nr_seq_tipo,
	substr(pat_obter_desc_tipo_bem(a.nr_seq_tipo),1,80) ds_tipo,
	substr(pat_obter_desc_tipo_bem(a.nr_seq_tipo) || ' ' || a.ds_bem,1,350) ds_tipo_bem,
	a.cd_centro_custo,
	a.ie_propriedade,
	a.ie_tipo_valor
into STRICT	cd_bem_w,
	ds_bem_w,
	nr_seq_local_w,
	nr_seq_tipo_w,
	ds_tipo_w,
	ds_tipo_bem_w,
	cd_centro_custo_w,
	ie_propriedade_w,
	ie_tipo_valor_w
from	pat_bem a
where	a.nr_sequencia = nr_seq_bem_w;

if (ie_opcao_p = 'CD') then
	ds_retorno_w := cd_bem_w;
elsif (ie_opcao_p = 'DS') then
	ds_retorno_w := ds_bem_w;
elsif (ie_opcao_p = 'LO') then
	ds_retorno_w := nr_seq_local_w;
elsif (ie_opcao_p = 'TI') then
	ds_retorno_w := nr_seq_tipo_w;
elsif (ie_opcao_p = 'DT') then
	ds_retorno_w := ds_tipo_w;
elsif (ie_opcao_p = 'TB') then
	ds_retorno_w := ds_tipo_bem_w;
elsif (ie_opcao_p = 'CE') then
	ds_retorno_w := cd_centro_custo_w;
elsif (ie_opcao_p = 'DC') then
	ds_retorno_w := substr(obter_desc_centro_custo(cd_centro_custo_w),1,255);
elsif (ie_opcao_p = 'DL') then
	select	max(ds_local)
	into STRICT	ds_retorno_w
	from	pat_local
	where	nr_sequencia	= nr_seq_local_w;
elsif (ie_opcao_p = 'NR') then
	ds_retorno_w	:= nr_seq_bem_w;
elsif (ie_opcao_p = 'SUI') then
	select	max(x.nr_sequencia)
	into STRICT	ds_retorno_w
	from	pat_inventario x,
		pat_inventario_bem y
	where	x.nr_sequencia = y.nr_seq_inventario
	and	y.cd_bem = cd_bem_p;
elsif (ie_opcao_p = 'PR') then
	ds_retorno_w	:= ie_propriedade_w;
elsif (ie_opcao_p = 'TV') then
	ds_retorno_w	:= substr(ie_tipo_valor_w,1,1);	 --Copiado da function pat_obter_dados_bem;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_pat_bem ( cd_bem_p text, ie_opcao_p text, nr_seq_bem_p bigint default 0) FROM PUBLIC;

