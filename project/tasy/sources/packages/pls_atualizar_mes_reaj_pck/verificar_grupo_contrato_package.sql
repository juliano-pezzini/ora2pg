-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_atualizar_mes_reaj_pck.verificar_grupo_contrato ( nr_seq_contrato_p pls_contrato.nr_sequencia%type, nr_seq_intercambio_p pls_intercambio.nr_sequencia%type, nr_seq_grupo_p INOUT pls_grupo_contrato.nr_sequencia%type, nr_mes_reajuste_grupo_p INOUT pls_grupo_contrato.nr_mes_reajuste%type) AS $body$
DECLARE


nr_seq_grupo_w			pls_grupo_contrato.nr_sequencia%type;
nr_mes_reajuste_grupo_w		bigint;


BEGIN

nr_mes_reajuste_grupo_w := null;

if (nr_seq_contrato_p IS NOT NULL AND nr_seq_contrato_p::text <> '') then
	select	max(a.nr_sequencia)
	into STRICT	nr_seq_grupo_w
	from	pls_grupo_contrato a,
		pls_contrato_grupo b
	where	a.nr_sequencia	= b.nr_seq_grupo
	and	b.ie_reajuste_grupo = 'S'
	and	a.ie_situacao	= 'A'
	and	(a.nr_mes_reajuste IS NOT NULL AND a.nr_mes_reajuste::text <> '')
	and	b.nr_seq_contrato = nr_seq_contrato_p;
elsif (nr_seq_intercambio_p IS NOT NULL AND nr_seq_intercambio_p::text <> '') then
	select	max(a.nr_sequencia)
	into STRICT	nr_seq_grupo_w
	from	pls_grupo_contrato a,
		pls_contrato_grupo b
	where	a.nr_sequencia	= b.nr_seq_grupo
	and	b.ie_reajuste_grupo = 'S'
	and	a.ie_situacao	= 'A'
	and	(a.nr_mes_reajuste IS NOT NULL AND a.nr_mes_reajuste::text <> '')
	and	b.nr_seq_intercambio = nr_seq_intercambio_p;
end if;

if (nr_seq_grupo_w IS NOT NULL AND nr_seq_grupo_w::text <> '') then
	select	max(nr_mes_reajuste)
	into STRICT	nr_mes_reajuste_grupo_w
	from	pls_grupo_contrato
	where	nr_sequencia = nr_seq_grupo_w;
end if;

nr_seq_grupo_p		:= nr_seq_grupo_w;
nr_mes_reajuste_grupo_p	:= nr_mes_reajuste_grupo_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atualizar_mes_reaj_pck.verificar_grupo_contrato ( nr_seq_contrato_p pls_contrato.nr_sequencia%type, nr_seq_intercambio_p pls_intercambio.nr_sequencia%type, nr_seq_grupo_p INOUT pls_grupo_contrato.nr_sequencia%type, nr_mes_reajuste_grupo_p INOUT pls_grupo_contrato.nr_mes_reajuste%type) FROM PUBLIC;