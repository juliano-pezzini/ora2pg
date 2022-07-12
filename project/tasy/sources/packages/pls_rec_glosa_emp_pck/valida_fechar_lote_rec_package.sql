-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_rec_glosa_emp_pck.valida_fechar_lote_rec ( nr_seq_lote_p pls_grg_lote.nr_sequencia%type) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	realiza as validacoes para ver se e possivel fechar o lote

-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[X]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------

Pontos de atencao:

	
Alteracoes:
-------------------------------------------------------------------------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */

vl_saldo_w	pls_grg_guia_proc.vl_glosado%type;

BEGIN

-- Verifica se todas as guias tiveram os valores recursados ou acatados, para certificar que nao ficou nenhum item sem recursar ou acatar

select	sum(t.saldo)
into STRICT	vl_saldo_w
from (	SELECT	sum(coalesce(c.vl_glosado,0) - (coalesce(c.vl_acatado,0) + coalesce(c.vl_recursado,0))) saldo
	from	pls_grg_lote		a,
		pls_grg_protocolo	b,
		pls_grg_guia		c
	where	b.nr_seq_grg_lote	= a.nr_sequencia
	and	c.nr_seq_grg_protocolo	= b.nr_sequencia
	and	a.nr_sequencia		= nr_seq_lote_p) t;
	
	
if	((vl_saldo_w != 0) or (coalesce(vl_saldo_w::text, '') = '' )) then

	CALL wheb_mensagem_pck.exibir_mensagem_abort(854682);	
end if;
	
	
	
		
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_rec_glosa_emp_pck.valida_fechar_lote_rec ( nr_seq_lote_p pls_grg_lote.nr_sequencia%type) FROM PUBLIC;
