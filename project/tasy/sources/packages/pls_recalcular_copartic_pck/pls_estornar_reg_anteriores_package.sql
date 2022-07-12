-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


/*	Para cada procedimento e/ou material, identifica os registros de coparticipa??o que n?o est?o estornados e estorna-os, 
	exceto o registro com maior sequencial(que corresponde a gera??o do rec?clulo atual)*/
CREATE OR REPLACE PROCEDURE pls_recalcular_copartic_pck.pls_estornar_reg_anteriores ( nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_lote_recalc_p pls_recalc_copartic_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

										
C00 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_conta_coparticipacao
	where	nr_seq_conta = nr_seq_conta_p
	and 	ie_estorno_custo = 'S'
	and 	coalesce(dt_estorno::text, '') = '';										

BEGIN

	for r_c00_w in C00 loop
	
		update 	pls_conta_coparticipacao
		set 	ds_observacao = 'Estorno realizado atrav?s de rec?lculo processado via lote de rec?lculo '||nr_seq_lote_recalc_p||
								'na fun??o OPS - Controle de Coparticipa??es e P?s Estabelecido'
		where 	nr_sequencia = r_c00_w.nr_sequencia;
	
		CALL pls_estornar_custo_copartic( r_c00_w.nr_sequencia, 'Aplica??o do rec?lculo de coparticipa??o', 'R', nm_usuario_p, 'C');
	
	end loop;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_recalcular_copartic_pck.pls_estornar_reg_anteriores ( nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_lote_recalc_p pls_recalc_copartic_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
