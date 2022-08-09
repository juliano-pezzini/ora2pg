-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_obter_processo_reaj ( nr_seq_contrato_p pls_contrato.nr_sequencia%type, nr_seq_segurado_p pls_segurado.nr_sequencia%type, nr_seq_titular_p pls_segurado.nr_seq_titular%type, cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type, dt_reajuste_p pls_reajuste.dt_reajuste%type, nr_seq_processo_p INOUT processo_judicial_liminar.nr_sequencia%type, tx_reajuste_liminar_p INOUT pls_reajuste.tx_reajuste%type) AS $body$
DECLARE


tx_reajuste_liminar_w		pls_processo_judicial_reaj.tx_reajuste%type;
nr_seq_processo_w		processo_judicial_liminar.nr_sequencia%type;
nr_seq_processo_reaj_w		pls_processo_judicial_reaj.nr_sequencia%type;


BEGIN
nr_seq_processo_reaj_w	:= null;

--1 Procura processo cadastrado para o beneficiario
if (nr_seq_segurado_p IS NOT NULL AND nr_seq_segurado_p::text <> '') then
	select	max(b.nr_sequencia)
	into STRICT	nr_seq_processo_reaj_w
	from	processo_judicial_liminar a,
		pls_processo_judicial_reaj b
	where	a.nr_sequencia		= b.nr_seq_processo
	and	a.nr_seq_segurado	= nr_seq_segurado_p
	and	dt_reajuste_p between coalesce(b.dt_inicio_vigencia,dt_reajuste_p) and coalesce(b.dt_fim_vigencia,dt_reajuste_p)
	and	dt_reajuste_p between coalesce(a.dt_inicio_validade,dt_reajuste_p) and coalesce(a.dt_fim_validade,dt_reajuste_p)
	and	a.ie_estagio = 2;
end if;

--2 Procura processo cadastro para a PF do beneficiario
if ((cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') and coalesce(nr_seq_processo_reaj_w::text, '') = '') then
	select	max(b.nr_sequencia)
	into STRICT	nr_seq_processo_reaj_w
	from	processo_judicial_liminar a,
		pls_processo_judicial_reaj b
	where	a.nr_sequencia		= b.nr_seq_processo
	and	a.nr_seq_segurado in (	SELECT	x.nr_sequencia
					from	pls_segurado x
					where	x.cd_pessoa_fisica = cd_pessoa_fisica_p)
	and	a.ie_considera_codigo_pf = 'S'
	and	dt_reajuste_p between coalesce(b.dt_inicio_vigencia,dt_reajuste_p) and coalesce(b.dt_fim_vigencia,dt_reajuste_p)
	and	dt_reajuste_p between coalesce(a.dt_inicio_validade,dt_reajuste_p) and coalesce(a.dt_fim_validade,dt_reajuste_p)
	and	a.ie_estagio = 2;
end if;

--3 Procura processo cadastrado para o titular do beneficiario
if ((nr_seq_titular_p IS NOT NULL AND nr_seq_titular_p::text <> '') and coalesce(nr_seq_processo_reaj_w::text, '') = '') then
	select	max(b.nr_sequencia)
	into STRICT	nr_seq_processo_reaj_w
	from	processo_judicial_liminar a,
		pls_processo_judicial_reaj b
	where	a.nr_sequencia		= b.nr_seq_processo
	and	(a.nr_seq_segurado in (	SELECT	x.nr_sequencia
					from	pls_segurado x
					where	((x.nr_seq_titular = nr_seq_titular_p) or (x.nr_sequencia = nr_seq_titular_p))))
	and	b.ie_considerar_dependente = 'S'
	and	dt_reajuste_p between coalesce(b.dt_inicio_vigencia,dt_reajuste_p) and coalesce(b.dt_fim_vigencia,dt_reajuste_p)
	and	dt_reajuste_p between coalesce(a.dt_inicio_validade,dt_reajuste_p) and coalesce(a.dt_fim_validade,dt_reajuste_p)
	and	a.ie_estagio = 2;
end if;

--4 Procura processo cadastrado para o contrato do beneficiario
if ((nr_seq_contrato_p IS NOT NULL AND nr_seq_contrato_p::text <> '') and coalesce(nr_seq_processo_reaj_w::text, '') = '' ) then
	select	max(b.nr_sequencia)
	into STRICT	nr_seq_processo_reaj_w
	from	processo_judicial_liminar a,
		pls_processo_judicial_reaj b
	where	a.nr_sequencia		= b.nr_seq_processo
	and	a.nr_seq_contrato	= nr_seq_contrato_p
	and	dt_reajuste_p between coalesce(b.dt_inicio_vigencia,dt_reajuste_p) and coalesce(b.dt_fim_vigencia,dt_reajuste_p)
	and	dt_reajuste_p between coalesce(a.dt_inicio_validade,dt_reajuste_p) and coalesce(a.dt_fim_validade,dt_reajuste_p)
	and	a.ie_estagio = 2;
end if;

if (nr_seq_processo_reaj_w IS NOT NULL AND nr_seq_processo_reaj_w::text <> '') then
	select	a.nr_sequencia,
		b.tx_reajuste
	into STRICT	nr_seq_processo_w,
		tx_reajuste_liminar_w
	from	processo_judicial_liminar a,
		pls_processo_judicial_reaj b
	where	a.nr_sequencia	= b.nr_seq_processo
	and	b.nr_sequencia	= nr_seq_processo_reaj_w;
end if;

if (nr_seq_processo_w IS NOT NULL AND nr_seq_processo_w::text <> '') then
	nr_seq_processo_p	:= nr_seq_processo_w;
	tx_reajuste_liminar_p	:= tx_reajuste_liminar_w;
else
	nr_seq_processo_p	:= nr_seq_processo_w;
	tx_reajuste_liminar_p	:= null;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_obter_processo_reaj ( nr_seq_contrato_p pls_contrato.nr_sequencia%type, nr_seq_segurado_p pls_segurado.nr_sequencia%type, nr_seq_titular_p pls_segurado.nr_seq_titular%type, cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type, dt_reajuste_p pls_reajuste.dt_reajuste%type, nr_seq_processo_p INOUT processo_judicial_liminar.nr_sequencia%type, tx_reajuste_liminar_p INOUT pls_reajuste.tx_reajuste%type) FROM PUBLIC;
