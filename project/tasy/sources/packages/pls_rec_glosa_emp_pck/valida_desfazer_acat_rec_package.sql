-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_rec_glosa_emp_pck.valida_desfazer_acat_rec ( nr_seq_grg_guia_p pls_grg_guia.nr_sequencia%type) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Valida se e possivel desfazer as acoes e acatar ou recursar a guia de forma generica

-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[X]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------

Pontos de atencao:

	
Alteracoes:
-------------------------------------------------------------------------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */


qt_lote_fechado_w	integer;
qt_itens_glosados_w	integer;


BEGIN
select	count(1)
into STRICT	qt_lote_fechado_w
from 	pls_grg_guia		a,
	pls_grg_protocolo	b,
	pls_grg_lote		c
where	b.nr_sequencia		= a.nr_seq_grg_protocolo
and	c.nr_sequencia		= b.nr_seq_grg_lote
and	c.ie_status		= 'F' -- Nao permite para fechados

and	a.nr_sequencia		= nr_seq_grg_guia_p;

	
if (coalesce(qt_lote_fechado_w, 0) > 0) then

	CALL wheb_mensagem_pck.exibir_mensagem_abort(857157);
end if;


END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_rec_glosa_emp_pck.valida_desfazer_acat_rec ( nr_seq_grg_guia_p pls_grg_guia.nr_sequencia%type) FROM PUBLIC;
