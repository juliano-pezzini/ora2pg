-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


-- cancela o procedimento e suas respectivas glosas e ocorrencias se a regra permitir



CREATE OR REPLACE PROCEDURE pls_cta_gera_hono_indiv_pck.cancela_proc_abert_conta ( nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc.nr_sequencia%type, dt_procedimento_p pls_conta_proc.dt_procedimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


qt_registro_w		integer;
C01 CURSOR(dt_procedimento_pc		pls_conta_proc.dt_procedimento%type) is
	with query_tmp as (
			SELECT	a.nr_sequencia,
				coalesce(a.ie_cancelamento, 'N') ie_cancelamento
			from	pls_regra_canc_item_orig	a
			where	dt_procedimento_pc between a.dt_inicio_vigencia and coalesce(a.dt_fim_vigencia, dt_procedimento_pc)
			order by a.ie_cancelamento desc
			)
	SELECT	nr_sequencia,
		ie_cancelamento
	from	query_tmp LIMIT 1;
BEGIN

select	count(1)
into STRICT	qt_registro_w
from	pls_conta_proc	proc
where	proc.nr_sequencia	= nr_seq_conta_proc_p
and	exists (SELECT	1
		from	pls_proc_participante	partic
		where	partic.nr_seq_conta_proc	= proc.nr_sequencia
		and	partic.ie_status		!= 'C');
		
if (qt_registro_w	= 0) then
	--busca a regra que define se o procedimento sera cancelado

	for r_C01_w in C01(dt_procedimento_p) loop
		
		-- se na regra esta marcado para cancelar

		if (r_C01_w.ie_cancelamento = 'S') then
			update	pls_conta_proc
			set	ie_status			= 'D',
				nr_seq_regra_canc_item_orig	= r_C01_w.nr_sequencia
			where	nr_sequencia			= nr_seq_conta_proc_p;
			
			-- cancela todas as glosas e ocorrencias vinculadas ao procedimento que foi cancelado

			CALL pls_gerencia_dados_ocor_pck.pls_gerencia_situ_glo_ocor( nr_seq_conta_p,
										nr_seq_conta_proc_p,
										null,
										null,
										'I',
										nm_usuario_p);
		end if;

	end loop;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_cta_gera_hono_indiv_pck.cancela_proc_abert_conta ( nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc.nr_sequencia%type, dt_procedimento_p pls_conta_proc.dt_procedimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
