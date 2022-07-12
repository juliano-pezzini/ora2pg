-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qt_unitarizacao_ativ (nr_seq_unitarizacao_p bigint, nr_seq_atividade_p bigint, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE


/*ie_opcao_p:
F - Quantidade fracionada
P - Quantidade perda
*/
qt_retorno_w		double precision;


BEGIN

if (ie_opcao_p = 'F') then
	select	sum(a.qt_material)
	into STRICT	qt_retorno_w
	from	item_unitarizacao a
	where	a.nr_seq_unitarizacao = nr_seq_unitarizacao_p
	and	a.nr_seq_atividade = nr_seq_atividade_p
	and	coalesce(a.nr_seq_motivo_perda::text, '') = '';
else
	select	sum(a.qt_material)
	into STRICT	qt_retorno_w
	from	item_unitarizacao a
	where	a.nr_seq_unitarizacao = nr_seq_unitarizacao_p
	and	a.nr_seq_atividade = nr_seq_atividade_p
	and	(a.nr_seq_motivo_perda IS NOT NULL AND a.nr_seq_motivo_perda::text <> '');
end if;

return	qt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qt_unitarizacao_ativ (nr_seq_unitarizacao_p bigint, nr_seq_atividade_p bigint, ie_opcao_p text) FROM PUBLIC;

