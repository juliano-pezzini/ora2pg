-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION spa_obter_dados_item_conta ( nr_seq_item_p bigint, ie_tipo_item_p text, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255);
cd_item_w		bigint;
ds_item_w		varchar(255);
dt_conta_item_w		timestamp;
qt_item_w		double precision;
vl_item_w		double precision;
vl_unit_item_w		double precision;

/*
IE_TIPO_ITEM_P:
P - Procedimentos
M - Materiais
*/
/*
IE_OPCAO_P:
C - Código
D - Descrição
DC - Data conta
Q - Quantidade
VU - Valor unitário
V - Valor
QM - Quantidade sem máscara
VM - Valor sem máscara
*/
BEGIN

if (ie_tipo_item_p = 'P') then
	select	cd_procedimento,
		substr(obter_desc_procedimento(cd_procedimento, ie_origem_proced),1,255),
		dt_conta,
		qt_procedimento,
		dividir(vl_procedimento, qt_procedimento),
		vl_procedimento
	into STRICT	cd_item_w,
		ds_item_w,
		dt_conta_item_w,
		qt_item_w,
		vl_unit_item_w,
		vl_item_w
	from	procedimento_paciente
	where	nr_sequencia = nr_seq_item_p;
else
	select	cd_material,
		substr(obter_desc_material(cd_material),1,255),
		dt_conta,
		qt_material,
		vl_unitario,
		vl_material
	into STRICT	cd_item_w,
		ds_item_w,
		dt_conta_item_w,
		qt_item_w,
		vl_unit_item_w,
		vl_item_w
	from	material_atend_paciente
	where	nr_sequencia = nr_seq_item_p;
end if;

if (ie_opcao_p = 'C') then
	ds_retorno_w	:= cd_item_w;
elsif (ie_opcao_p = 'D') then
	ds_retorno_w	:= ds_item_w;
elsif (ie_opcao_p = 'DC') then
	ds_retorno_w	:= to_char(dt_conta_item_w, 'dd/mm/yyyy hh24:mi:ss');
elsif (ie_opcao_p = 'Q') then
	ds_retorno_w	:= campo_mascara_virgula(qt_item_w);
elsif (ie_opcao_p = 'VU') then
	ds_retorno_w	:= campo_mascara_virgula(vl_unit_item_w);
elsif (ie_opcao_p = 'V') then
	ds_retorno_w	:= campo_mascara_virgula(vl_item_w);
elsif (ie_opcao_p = 'VM') then
	ds_retorno_w	:= vl_item_w;
elsif (ie_opcao_p = 'QM') then
	ds_retorno_w	:= qt_item_w;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION spa_obter_dados_item_conta ( nr_seq_item_p bigint, ie_tipo_item_p text, ie_opcao_p text) FROM PUBLIC;
