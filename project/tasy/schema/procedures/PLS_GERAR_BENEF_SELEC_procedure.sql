-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_benef_selec ( nr_seq_inclusao_benef_p pls_inclusao_beneficiario.nr_sequencia%type, nr_seq_lote_p pls_lote_inclusao_benef.nr_sequencia%type) AS $body$
BEGIN

--Tratamento realizado para desfazer a seleção de todos os beneficiários.
if (nr_seq_lote_p IS NOT NULL AND nr_seq_lote_p::text <> '') then
	update	pls_inclusao_beneficiario
	set	ie_selecionado		= 'N'
	where	nr_seq_lote_inclusao	= nr_seq_lote_p;
end if;

if (nr_seq_inclusao_benef_p IS NOT NULL AND nr_seq_inclusao_benef_p::text <> '') then
	update	pls_inclusao_beneficiario
	set	ie_selecionado	= 'S'
	where	nr_sequencia	= nr_seq_inclusao_benef_p;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_benef_selec ( nr_seq_inclusao_benef_p pls_inclusao_beneficiario.nr_sequencia%type, nr_seq_lote_p pls_lote_inclusao_benef.nr_sequencia%type) FROM PUBLIC;

