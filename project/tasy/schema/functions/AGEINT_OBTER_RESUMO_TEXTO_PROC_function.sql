-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ageint_obter_resumo_texto_proc ( nr_seq_regra_texto_proc_p bigint) RETURNS varchar AS $body$
DECLARE



ds_retorno_w			varchar(32000);
ds_texto_w				varchar(32000);
ds_item_w				varchar(255);
ds_grupo_ageint_w		varchar(255);
ds_especialidade_w		varchar(255);
ds_grupo_proc_w			varchar(255);
ds_area_w				varchar(255);
ds_separador_w			varchar(25);
cd_area_procedimento_w	ageint_regra_texto_proc.cd_area_procedimento%type;
cd_grupo_proc_w			ageint_regra_texto_proc.cd_grupo_proc%type;
cd_especialidade_w		ageint_regra_texto_proc.cd_especialidade%type;
cd_procedimento_w		ageint_regra_texto_proc.cd_procedimento%type;
nr_seq_proc_interno_w	ageint_regra_texto_proc.nr_seq_proc_interno%type;
nr_seq_grupo_ageint_w	ageint_regra_texto_proc.nr_seq_grupo_ageint%type;



BEGIN
ds_separador_w	:= '\par ';

if (nr_seq_regra_texto_proc_p IS NOT NULL AND nr_seq_regra_texto_proc_p::text <> '') then

	select	substr(coalesce(Obter_Desc_Proc_Interno(nr_seq_proc_interno), Obter_Desc_Procedimento(cd_procedimento, ie_origem_proced)),1,255),
			substr(Ageint_Obter_Desc_Grupo(nr_seq_grupo_ageint),1,255),
			substr(obter_desc_espec_proc(cd_especialidade),1,255),
			substr(obter_desc_grupo_proc(cd_grupo_proc),1,255),
			substr(obter_desc_area_procedimento(cd_area_procedimento),1,255),
			cd_area_procedimento,
			cd_grupo_proc,
			cd_especialidade,
			cd_procedimento,
			nr_seq_proc_interno,
			nr_seq_grupo_ageint
	into STRICT	ds_item_w,
			ds_grupo_ageint_w,
			ds_especialidade_w,
			ds_grupo_proc_w,
			ds_area_w,
			cd_area_procedimento_w,
			cd_grupo_proc_w,
			cd_especialidade_w,
			cd_procedimento_w,
			nr_seq_proc_interno_w,
			nr_seq_grupo_ageint_w
	from	ageint_regra_texto_proc
	where	nr_sequencia = nr_seq_regra_texto_proc_p;

	if	((nr_seq_proc_interno_w IS NOT NULL AND nr_seq_proc_interno_w::text <> '') or (cd_procedimento_w IS NOT NULL AND cd_procedimento_w::text <> '')) then
		ds_retorno_w	:= ds_separador_w || obter_desc_expressao(345211)/*Orientações referentes ao item:*/
 || ds_item_w;
	elsif (nr_seq_grupo_ageint_w IS NOT NULL AND nr_seq_grupo_ageint_w::text <> '') then
		ds_retorno_w	:= ds_separador_w || obter_desc_expressao(345212)/*Orientações referentes ao Grupo Ag. Integrada:*/
 || ds_grupo_ageint_w;
	elsif (cd_especialidade_w IS NOT NULL AND cd_especialidade_w::text <> '') then
		ds_retorno_w	:= ds_separador_w || obter_desc_expressao(345213)/*Orientações referentes a Especialidade:*/
 || ds_especialidade_w;
	elsif (cd_grupo_proc_w IS NOT NULL AND cd_grupo_proc_w::text <> '') then
		ds_retorno_w	:= ds_separador_w || obter_desc_expressao(345214)/*Orientações referentes ao Grupo Procedimento:*/
 || ds_grupo_proc_w;
	elsif (cd_area_procedimento_w IS NOT NULL AND cd_area_procedimento_w::text <> '') then
		ds_retorno_w	:= ds_separador_w || obter_desc_expressao(345215)/*Orientações referentes a Área Procedimento:*/
 || ds_area_w;

	end if;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ageint_obter_resumo_texto_proc ( nr_seq_regra_texto_proc_p bigint) FROM PUBLIC;
