-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_marcar_itens_exec_lote ( nr_seq_item_p bigint, nr_seq_execucao_lote_p text, ie_limpa_execucao_p text, nm_usuario_p text) AS $body$
DECLARE


/*++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:   Marcar itens utilizados na execução da requisição
----------------------------------------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [  ] Tasy (Delphi/Java) [ x ] Portal [  ] Relatórios [ ] Outros:
 ----------------------------------------------------------------------------------------------------------------------------------------------------
Pontos de atenção:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/qt_pendente_w		double precision;


BEGIN

select 	max(coalesce(qt_pendente,0))
into STRICT	qt_pendente_w
from (	SELECT	pls_quant_itens_pendentes_exec(b.qt_procedimento,b.qt_proc_executado) qt_pendente
		from	pls_requisicao_proc	b,
			pls_itens_lote_execucao	a
		where	a.nr_seq_req_proc	= b.nr_sequencia
		and	a.nr_sequencia		= nr_seq_item_p
		
union

		SELECT	pls_quant_itens_pendentes_exec(b.qt_material,b.qt_mat_executado) qt_pendente
		from	pls_requisicao_mat	b,
			pls_itens_lote_execucao	a
		where	a.nr_seq_req_mat	= b.nr_sequencia
		and	a.nr_sequencia		= nr_seq_item_p) alias4;

if (ie_limpa_execucao_p = 'S' ) then
	update	pls_itens_lote_execucao
	set	ie_executar 	= 'N',
		qt_item_exec 	= 0,
		nm_usuario	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp()
	where	nr_seq_lote_exec = nr_seq_execucao_lote_p;
end if;

update	pls_itens_lote_execucao
set	ie_executar 	= 'S',
	qt_item_exec 	= qt_pendente_w,
	nm_usuario	= nm_usuario_p,
	dt_atualizacao	= clock_timestamp(),
	ds_observacao 	 = ds_observacao || ' - PLS_MARCAR_ITENS_EXEC_LOTE: '||clock_timestamp()||' Qt: '||qt_pendente_w
where	nr_sequencia	 = nr_seq_item_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_marcar_itens_exec_lote ( nr_seq_item_p bigint, nr_seq_execucao_lote_p text, ie_limpa_execucao_p text, nm_usuario_p text) FROM PUBLIC;

