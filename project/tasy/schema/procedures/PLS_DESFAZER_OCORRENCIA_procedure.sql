-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_desfazer_ocorrencia ( nr_seq_guia_p bigint, nr_seq_requisicao_p bigint, nr_seq_conta_p bigint) AS $body$
DECLARE


nr_seq_analise_w		bigint;


BEGIN
if (coalesce(nr_seq_guia_p,0) > 0) then
	delete	FROM pls_ocorrencia_benef
	where	nr_seq_guia_plano	= nr_seq_guia_p;
elsif (coalesce(nr_seq_requisicao_p,0) > 0) then
	delete	FROM pls_ocorrencia_benef
	where	nr_seq_requisicao	= nr_seq_requisicao_p;
elsif (coalesce(nr_seq_conta_p,0) > 0) then
	select	max(a.nr_seq_analise)
	into STRICT	nr_seq_analise_w
	from	pls_conta	a
	where	a.nr_sequencia	= nr_seq_conta_p;

	delete	from pls_analise_glo_ocor_grupo	a
	where	a.nr_seq_ocor_benef in (SELECT	x.nr_sequencia
					from	pls_ocorrencia_benef	x
					where	x.nr_seq_conta	= nr_seq_conta_p);

	delete	FROM pls_ocorrencia_benef
	where	nr_seq_conta	= nr_seq_conta_p;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_desfazer_ocorrencia ( nr_seq_guia_p bigint, nr_seq_requisicao_p bigint, nr_seq_conta_p bigint) FROM PUBLIC;
