-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_mov_benef_imp_pck.obter_emissor_carteira ( nr_seq_congenere_p pls_congenere.nr_sequencia%type, ie_tipo_contrato_p pls_intercambio.ie_tipo_contrato%type, ie_repasse_p pls_intercambio.ie_tipo_repasse%type ) RETURNS bigint AS $body$
DECLARE

nr_seq_emissor_w	pls_emissor_carteira.nr_sequencia%type	:= null;
C01 CURSOR FOR
	SELECT	a.nr_seq_emissor
	from	ptu_intercambio_emissor a
	where (a.ie_repasse = ie_repasse_p or coalesce(a.ie_repasse::text, '') = '')
	and (a.ie_tipo_contrato = ie_tipo_contrato_p or coalesce(a.ie_tipo_contrato::text, '') = '')
	and (a.nr_seq_congenere = nr_seq_congenere_p or coalesce(a.nr_seq_congenere::text, '') = '')
	and	a.ie_origem_destino	in ('O','A')
	order by coalesce(a.nr_seq_congenere,0);
BEGIN
for r_c01_w in C01 loop
	begin
	nr_seq_emissor_w	:= r_c01_w.nr_seq_emissor;
	end;
end loop;
return nr_seq_emissor_w;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_mov_benef_imp_pck.obter_emissor_carteira ( nr_seq_congenere_p pls_congenere.nr_sequencia%type, ie_tipo_contrato_p pls_intercambio.ie_tipo_contrato%type, ie_repasse_p pls_intercambio.ie_tipo_repasse%type ) FROM PUBLIC;