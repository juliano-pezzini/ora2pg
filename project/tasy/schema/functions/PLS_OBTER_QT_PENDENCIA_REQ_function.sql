-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_qt_pendencia_req ( ie_tipo_item_p text, nr_seq_requisicao_item_p bigint) RETURNS varchar AS $body$
DECLARE


qt_reg_w		smallint;
qt_retorno_w		bigint := 0;



BEGIN

if (coalesce(nr_seq_requisicao_item_p::text, '') = '') then
	qt_retorno_w	:= 1;
elsif (ie_tipo_item_p = 'P') then
	select  pls_quant_itens_pendentes_exec(qt_procedimento,qt_proc_executado)
	into STRICT    qt_retorno_w
	from    pls_requisicao_proc
	where   nr_sequencia = nr_seq_requisicao_item_p;
elsif (ie_tipo_item_p = 'M') then
	select  pls_quant_itens_pendentes_exec(qt_material,qt_mat_executado)
	into STRICT    qt_retorno_w
	from    pls_requisicao_mat
	where   nr_sequencia = nr_seq_requisicao_item_p;
end if;

return	qt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_qt_pendencia_req ( ie_tipo_item_p text, nr_seq_requisicao_item_p bigint) FROM PUBLIC;
