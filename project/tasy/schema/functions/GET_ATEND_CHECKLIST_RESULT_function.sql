-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_atend_checklist_result (nr_seq_checklist_p bigint, nr_seq_item_checklist_p bigint, ie_componente_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255);
ds_result_checklist_w	atend_pac_checklist_result.ds_valor_result%type;
nr_seq_valor_result_w	atend_pac_checklist_result.nr_seq_valor_result%type;
ds_arquivo_w		atend_pac_checklist_result.ds_arquivo%type;


BEGIN

if (nr_seq_checklist_p IS NOT NULL AND nr_seq_checklist_p::text <> '') then

	select 	coalesce(obter_descricao_padrao('CONVENIO_CHECKLIST_ITEM_VL', 'DS_VALOR', nr_seq_valor_result), ds_valor_result) ds_result_checklist,
		nr_seq_valor_result,
		ds_arquivo
	into STRICT	ds_result_checklist_w,
		nr_seq_valor_result_w,
		ds_arquivo_w
	from 	atend_pac_checklist_result
	where	nr_seq_checklist 	= nr_seq_checklist_p
	and	nr_seq_item_checklist 	= nr_seq_item_checklist_p;

	if (ie_componente_p in ('CB', 'LCB', 'RG')) then
		ds_retorno_w :=	nr_seq_valor_result_w;
	elsif (ie_componente_p in ('ED', 'ME')) then
		ds_retorno_w := ds_result_checklist_w;
	elsif (ie_componente_p = 'SERVER_FILE') then
		ds_retorno_w := ds_arquivo_w;
	end if;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_atend_checklist_result (nr_seq_checklist_p bigint, nr_seq_item_checklist_p bigint, ie_componente_p text) FROM PUBLIC;

