-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_origem_extrato ( nr_seq_prog_reaj_colet_p pls_prog_reaj_coletivo.nr_sequencia%type, nr_seq_prog_reaj_lote_p pls_prog_reaj_colet_lote.nr_sequencia%type, nr_seq_contrato_p pls_contrato.nr_sequencia%type, dt_mes_reajuste_p pls_prog_reaj_colet_lote.dt_mes_reajuste%type) RETURNS varchar AS $body$
DECLARE


ie_origem_extrato_w		varchar(255);
qt_extrato_prog_colet_w		bigint;
qt_extrato_grupo_contrato_w	bigint;
qt_extrato_prog_reaj_lote_w	bigint;


BEGIN

select	count(1)
into STRICT	qt_extrato_prog_colet_w
from	pls_prog_reaj_documentacao
where	nr_seq_prog_reaj = nr_seq_prog_reaj_colet_p;

if (qt_extrato_prog_colet_w > 0) then
	ie_origem_extrato_w	:= 'Programação';
else
	select	count(1)
	into STRICT	qt_extrato_grupo_contrato_w
	from	pls_prog_reaj_documentacao a,
		pls_grupo_contrato b,
		pls_contrato_grupo c
	where	b.nr_sequencia = a.nr_seq_grupo_contrato
	and	b.nr_sequencia = c.nr_seq_grupo
	and	c.nr_seq_contrato = nr_seq_contrato_p
	and	a.dt_reajuste = dt_mes_reajuste_p
	and	b.ie_situacao = 'A'
	and	dt_mes_reajuste_p between coalesce(b.dt_inicio_vigencia, dt_mes_reajuste_p) and coalesce(b.dt_fim_vigencia, dt_mes_reajuste_p);

	if (qt_extrato_grupo_contrato_w > 0) then
		ie_origem_extrato_w	:= 'Grupo de contratos';
	else
		select	count(1)
		into STRICT	qt_extrato_prog_reaj_lote_w
		from	pls_prog_reaj_documentacao
		where	nr_seq_lote = nr_seq_prog_reaj_lote_p;

		if (qt_extrato_prog_reaj_lote_w > 0) then
			ie_origem_extrato_w	:= 'Lote de programação';
		else
			ie_origem_extrato_w	:= 'Sem Extrato';
		end if;
	end if;
end if;

return	ie_origem_extrato_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_origem_extrato ( nr_seq_prog_reaj_colet_p pls_prog_reaj_coletivo.nr_sequencia%type, nr_seq_prog_reaj_lote_p pls_prog_reaj_colet_lote.nr_sequencia%type, nr_seq_contrato_p pls_contrato.nr_sequencia%type, dt_mes_reajuste_p pls_prog_reaj_colet_lote.dt_mes_reajuste%type) FROM PUBLIC;

