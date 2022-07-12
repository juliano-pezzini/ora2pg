-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_util_pck.obter_numero_tag ( ds_arquivo_xml_p w_pls_monitor_ans_qualid.ds_xml%type, ds_tag_p text ) RETURNS bigint AS $body$
DECLARE


nr_retorno_w		bigint := 0;
nr_instr_w		bigint := 1;
ds_tag_w		varchar(255) := pls_util_pck.montar_tag('I',ds_tag_p);


BEGIN
--nr_retorno_w := regexp_count(ds_arquivo_xml_p,ds_tag_w); ** SÓ PODE SER USADO EM ORCLE 11G OU SUPERIOR
while(nr_instr_w > 0) loop
	select	instr(ds_arquivo_xml_p,ds_tag_w,nr_instr_w)
	into STRICT	nr_instr_w
	;

	if (nr_instr_w > 0) then
		nr_retorno_w := nr_retorno_w + 1;
		nr_instr_w := nr_instr_w + length(ds_tag_w);
	end if;
end loop;

return nr_retorno_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_util_pck.obter_numero_tag ( ds_arquivo_xml_p w_pls_monitor_ans_qualid.ds_xml%type, ds_tag_p text ) FROM PUBLIC;
