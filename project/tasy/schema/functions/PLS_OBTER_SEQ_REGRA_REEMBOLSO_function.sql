-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_seq_regra_reembolso ( nr_seq_regra_acao_p bigint) RETURNS bigint AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Locais de chamada direta:
[  X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
nr_seq_regra_w	bigint;


BEGIN
select	coalesce(max(a.nr_sequencia),0)
into STRICT	nr_seq_regra_w
from	pls_regra_reembolso	a,
	pls_regra_reemb_acao	b
where	a.nr_sequencia = b.nr_seq_regra
and	b.nr_sequencia = nr_seq_regra_acao_p;

return	nr_seq_regra_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_seq_regra_reembolso ( nr_seq_regra_acao_p bigint) FROM PUBLIC;
