-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


-- nos fontes e utilizado o codigo da analise (pls_acao_analise->cd_acao).

-- mas nos relacionamentos e preciso existir a sequencia da tabela e e por esse motivo que essa funcao existe



CREATE OR REPLACE FUNCTION pls_util_cta_pck.pls_obter_seq_acao_analise ( cd_acao_analise_p pls_acao_analise.cd_acao%type) RETURNS bigint AS $body$
DECLARE

nr_seq_acao_analise_w	pls_acao_analise.nr_sequencia%type;

BEGIN
select	max(nr_sequencia)
into STRICT	nr_seq_acao_analise_w
from	pls_acao_analise
where	cd_acao	= cd_acao_analise_p;

return nr_seq_acao_analise_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 IMMUTABLE;
-- REVOKE ALL ON FUNCTION pls_util_cta_pck.pls_obter_seq_acao_analise ( cd_acao_analise_p pls_acao_analise.cd_acao%type) FROM PUBLIC;
