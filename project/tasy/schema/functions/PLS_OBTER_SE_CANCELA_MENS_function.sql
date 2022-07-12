-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_cancela_mens ( nr_seq_mensalidade_p bigint, ie_verifica_titulo_p text) RETURNS varchar AS $body$
DECLARE


/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
Verificar se permite cancelar mensalidade no acompanhamento de nota fiscal
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ X] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
nr_titulo_w			bigint;
nr_lote_contabil_w		bigint;
nr_lote_contab_antecip_w	bigint;
dt_liquidacao_w			timestamp;


BEGIN
select	max(c.nr_titulo),
	max(a.nr_lote_contabil),
	max(a.nr_lote_contab_antecip)
into STRICT	nr_titulo_w,
	nr_lote_contabil_w,
	nr_lote_contab_antecip_w
from	pls_lote_mensalidade	a,
	pls_mensalidade		b,
	titulo_receber		c
where	b.nr_seq_lote		= a.nr_sequencia
and	c.nr_seq_mensalidade	= b.nr_sequencia
and	b.nr_sequencia		= nr_seq_mensalidade_p;

if (coalesce(nr_lote_contabil_w,0) = 0) and (coalesce(nr_lote_contab_antecip_w,0) = 0) then
	return 'S';
else
	return 'N';
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_cancela_mens ( nr_seq_mensalidade_p bigint, ie_verifica_titulo_p text) FROM PUBLIC;
