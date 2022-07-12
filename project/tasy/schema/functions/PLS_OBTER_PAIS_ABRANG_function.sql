-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_pais_abrang ( cd_codigo_p text, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE

/*
	IE_OPCAO_P = PJ - Busca o país da pessoa jurídica
	IE_OPCAO_P = PF - Busca o país da pessoa física
*/
nr_seq_pais_w	pais.nr_sequencia%type;

BEGIN

if (ie_opcao_p	= 'PF')	then

	/*busca o país da pessoa física*/

	select	max(a.nr_seq_pais)
	into STRICT	nr_seq_pais_w
	from	compl_pf_tel_adic	a
	where	a.cd_pessoa_fisica = cd_codigo_p;

elsif (ie_opcao_p	= 'PJ')	then

	/*Buscar o país  pessoa jurídica*/

	select	max(a.nr_seq_pais)
	into STRICT	nr_seq_pais_w
	from	pessoa_juridica	a
	where	cd_cgc = cd_codigo_p;
end if;

return	nr_seq_pais_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_pais_abrang ( cd_codigo_p text, ie_opcao_p text) FROM PUBLIC;
