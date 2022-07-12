-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION qua_obter_dados_crit_problema ( nr_seq_crit_probl_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

/*ie_opcao_p
'D' - Descrição do valor do critério (Shift+F11)
'Q' - Qt valor
*/
nr_seq_crit_valor_w		bigint;
qt_valor_w		integer;
ds_retorno_w		varchar(255);


BEGIN

select	nr_seq_crit_valor,
	qt_valor
into STRICT	nr_seq_crit_valor_w,
	qt_valor_w
from	qua_analise_problema_crit
where	nr_sequencia = nr_seq_crit_probl_p;

if (ie_opcao_p = 'D') then
	select	substr(max(obter_desc_expressao(CD_EXP_DESCRICAO,DS_DESCRICAO)),1,80) ds_descricao
	into STRICT	ds_retorno_w
	from	qua_crit_probl_valor
	where	nr_seq_criterio	= nr_seq_crit_valor_w
	and	vl_valor		= qt_valor_w;
elsif (ie_opcao_p = 'Q') then
	ds_retorno_w := qt_valor_w;
end if;
return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION qua_obter_dados_crit_problema ( nr_seq_crit_probl_p bigint, ie_opcao_p text) FROM PUBLIC;

