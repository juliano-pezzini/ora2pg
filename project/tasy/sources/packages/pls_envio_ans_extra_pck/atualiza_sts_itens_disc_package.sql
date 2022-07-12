-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_envio_ans_extra_pck.atualiza_sts_itens_disc ( nr_seq_lote_p pls_monitor_tiss_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE


tb_seq_w    	pls_util_cta_pck.t_number_table;
tb_seq_conta_w   pls_util_cta_pck.t_number_table;	
					
--casos onde tenha mais de uma discussao para uma mesma conta origem, dentro de uma mesma competencia	
C01 is CURSOR
	with query_temp as (
		SELECT  a.nr_seq_conta
		from  pls_monitor_tiss_cta_val a
		where  a.nr_seq_lote_monitor = nr_seq_lote_p
		and   a.ie_tipo_evento = 'PD'
	)SELECT max(x.nr_sequencia) nr_sequencia,
		x.nr_seq_conta
	from  	pls_monitor_tiss_alt x,
		query_temp query_temp
	where   x.nr_seq_conta =  query_temp.nr_seq_conta
	and   	x.dt_evento between dt_mes_comp_w and dt_fim_mes_comp_w
	and   	x.ie_tipo_evento = 'PD'
	and   	x.ie_status in ('P','N')
	group by x.nr_seq_conta;	


BEGIN

	
	open c01;
	loop
		tb_seq_w.delete;
		tb_seq_conta_w.delete;
		
		fetch C01 bulk collect into tb_seq_w, tb_seq_conta_w
		limit current_setting('pls_envio_ans_extra_pck.qt_registro_transacao_w')::integer;
		
		exit when tb_seq_w.count = 0;
		
		CALL pls_envio_ans_extra_pck.atualiza_tabela_controle(tb_seq_w , tb_seq_conta_w, 'AG');
	end loop;
	close C01;
	commit;
	

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_envio_ans_extra_pck.atualiza_sts_itens_disc ( nr_seq_lote_p pls_monitor_tiss_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;