-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_dados_prot_rec_emp ( nr_seq_grg_prot_p pls_grg_protocolo.nr_sequencia%type, ie_opcao_p text ) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(4000);


BEGIN
if (ie_opcao_p = 'VCF') then
	select	coalesce(sum(vl_cobrado_fat),0)
	into STRICT	ds_retorno_w
	from (SELECT	sum(y.vl_cobrado_fat) vl_cobrado_fat
		from	pls_grg_guia	y
		where	y.nr_seq_grg_protocolo	= nr_seq_grg_prot_p
		
union

		SELECT	sum(y.vl_cobrado_fat) vl_cobrado_fat
		from	pls_grg_guia	y
		where	y.nr_seq_grg_protocolo	= nr_seq_grg_prot_p) alias5;

elsif (ie_opcao_p = 'VG') then
	select	coalesce(sum(vl_glosado),0)
	into STRICT	ds_retorno_w
	from (SELECT	sum(y.vl_glosado) vl_glosado
		from	pls_grg_guia	y
		where	y.nr_seq_grg_protocolo	= nr_seq_grg_prot_p
		
union

		SELECT	sum(y.vl_glosado) vl_glosado
		from	pls_grg_guia	y
		where	y.nr_seq_grg_protocolo	= nr_seq_grg_prot_p) alias5;

elsif (ie_opcao_p = 'VR') then
	select	coalesce(sum(vl_recursado),0)
	into STRICT	ds_retorno_w
	from (SELECT	sum(y.vl_recursado) vl_recursado
		from	pls_grg_guia	y
		where	y.nr_seq_grg_protocolo	= nr_seq_grg_prot_p
		
union

		SELECT	sum(y.vl_recursado) vl_recursado
		from	pls_grg_guia	y
		where	y.nr_seq_grg_protocolo	= nr_seq_grg_prot_p) alias5;

elsif (ie_opcao_p = 'VA') then
	select	coalesce(sum(vl_acatado),0)
	into STRICT	ds_retorno_w
	from (SELECT	sum(y.vl_acatado) vl_acatado
		from	pls_grg_guia	y
		where	y.nr_seq_grg_protocolo	= nr_seq_grg_prot_p
		
union

		SELECT	sum(y.vl_acatado) vl_acatado
		from	pls_grg_guia	y
		where	y.nr_seq_grg_protocolo	= nr_seq_grg_prot_p) alias5;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_dados_prot_rec_emp ( nr_seq_grg_prot_p pls_grg_protocolo.nr_sequencia%type, ie_opcao_p text ) FROM PUBLIC;

