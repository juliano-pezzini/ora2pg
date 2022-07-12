-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION tiss_obter_dados_proc_mat ( nr_seq_procedimento_p bigint, nr_seq_material_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255);
cd_material_w		varchar(255);
ds_material_w		varchar(255);
cd_procedimento_w	varchar(255);
ds_procedimento_w		varchar(255);
vl_unitario_w		double precision;

/*
ie_opcao_p

'CM'	- código do material
'CP'	- código do procedimento
'DM'	- descrição do material
'DP'	- descrição do procedimento
'DPM'	- descrição do procedimento ou descrição do material
'CPM'	- código do procedimento ou código do material
'UP'	- valor unitário do procedimento
*/
BEGIN

if (nr_seq_procedimento_p IS NOT NULL AND nr_seq_procedimento_p::text <> '') then

	select	cd_procedimento,
		substr(obter_descricao_procedimento(cd_procedimento, ie_origem_proced),1,255)
	into STRICT	cd_procedimento_w,
		ds_procedimento_w
	from	procedimento_paciente
	where	nr_sequencia		= nr_seq_procedimento_p;

	select	coalesce(a.vl_procedimento,0)
	into STRICT	vl_unitario_w
	from	proc_paciente_valor a,
		procedimento_paciente b
	where	a.nr_seq_procedimento	= b.nr_sequencia
	and	a.ie_tipo_valor		= 99
	and	b.nr_sequencia 		= nr_seq_procedimento_p;

elsif (nr_seq_material_p IS NOT NULL AND nr_seq_material_p::text <> '') then
	select	cd_material,
		substr(obter_desc_material(cd_material),1,255)
	into STRICT	cd_material_w,
		ds_material_w
	from	material_atend_paciente
	where	nr_sequencia		= nr_seq_material_p;
end if;

if (ie_opcao_p	= 'CM') then
	ds_retorno_w	:= cd_material_w;
elsif (ie_opcao_p	= 'CP') then
	ds_retorno_w	:= cd_procedimento_w;
elsif (ie_opcao_p	= 'DP') then
	ds_retorno_w	:= ds_procedimento_w;
elsif (ie_opcao_p	= 'DM') then
	ds_retorno_w	:= ds_material_w;
elsif (ie_opcao_p	= 'DPM') then
	ds_retorno_w	:= coalesce(ds_procedimento_w, ds_material_w);
elsif (ie_opcao_p	= 'CPM') then
	ds_retorno_w	:= coalesce(cd_procedimento_w, cd_material_w);
elsif (ie_opcao_p	= 'UP') then
	ds_retorno_w	:= vl_unitario_w;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION tiss_obter_dados_proc_mat ( nr_seq_procedimento_p bigint, nr_seq_material_p bigint, ie_opcao_p text) FROM PUBLIC;
