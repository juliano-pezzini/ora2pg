-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_rec_glosa_emp_pck.validar_geracao_rec_glosa ( nr_seq_grg_lote_p pls_grg_lote.nr_sequencia%type) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Realiza a validacao incial dos dados para gerar o recurso de glosa

-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[]  Objetos do dicionario [X] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------

Pontos de atencao:
Alteracoes:
-------------------------------------------------------------------------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */

ie_status_w		pls_grg_lote.ie_status%type;
vl_recursado_w		pls_grg_guia_proc.vl_recursado%type;

qt_erg_recurso_w	integer;


BEGIN

select	max(a.ie_status)
into STRICT	ie_status_w
from	pls_grg_lote	a
where	a.nr_sequencia	= nr_seq_grg_lote_p;

-- se nao for status "Fechado", nao gera os dados

if (coalesce(ie_status_w, 'A') != 'F') then

	CALL wheb_mensagem_pck.exibir_mensagem_abort(854683);
end if;


-- Valida se tem algum valor a ser recursado, conforme o tipo de recurso

select	sum(vl_recursado)
into STRICT	vl_recursado_w
from (	SELECT	sum(x.vl_recursado) vl_recursado
	from	pls_grg_guia_proc	x,
		pls_grg_guia		y,
		pls_grg_protocolo	z
	where	x.nr_seq_grg_guia	= y.nr_sequencia
	and	y.nr_seq_grg_protocolo	= z.nr_sequencia
	and	z.nr_seq_grg_lote	= nr_seq_grg_lote_p
	
union

	SELECT	sum(x.vl_recursado) vl_recursado
	from	pls_grg_guia_mat	x,
		pls_grg_guia		y,
		pls_grg_protocolo	z
	where	x.nr_seq_grg_guia	= y.nr_sequencia
	and	y.nr_seq_grg_protocolo	= z.nr_sequencia
	and	z.nr_seq_grg_lote	= nr_seq_grg_lote_p
	
union

	select	sum(y.vl_recursado) vl_recursado
	from	pls_grg_guia		y,
		pls_grg_protocolo	z
	where	y.nr_seq_grg_protocolo	= z.nr_sequencia
	and	z.nr_seq_grg_lote	= nr_seq_grg_lote_p) alias4;

if (coalesce(vl_recursado_w,0) = 0) then

	CALL wheb_mensagem_pck.exibir_mensagem_abort(854684);
end if;

select	count(1)
into STRICT	qt_erg_recurso_w
from	pls_erg_recurso
where	nr_seq_grg_lote	= nr_seq_grg_lote_p;

-- Nao permite gerar os dados, caso ja existam

if (coalesce(qt_erg_recurso_w, 0) > 0) then

	-- Nao e permitido gerar dados XML com dados ja gerados.

	CALL wheb_mensagem_pck.exibir_mensagem_abort(857222);
end if;



END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_rec_glosa_emp_pck.validar_geracao_rec_glosa ( nr_seq_grg_lote_p pls_grg_lote.nr_sequencia%type) FROM PUBLIC;
