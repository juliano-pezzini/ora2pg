-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_filtro_regra_preco_cta_pck.grava_regra_combinada_item ( ie_destino_regra_p text, nr_seq_filtro_p pls_cp_cta_combinada.nr_sequencia%type, ie_tipo_regra_p pls_cp_cta_combinada.ie_tipo_regra%type, nr_id_transacao_p pls_cp_cta_selecao.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


tb_seq_item_w		pls_util_cta_pck.t_number_table;
					
c_proc_serv CURSOR(	nr_id_transacao_pc	pls_cp_cta_selecao.nr_id_transacao%type) FOR
	SELECT	distinct a.nr_seq_conta_proc
	from	pls_cp_cta_selecao a
	where	a.nr_id_transacao = nr_id_transacao_pc
	and	a.ie_valido = 'S';
	
c_mat CURSOR(	nr_id_transacao_pc	pls_cp_cta_selecao.nr_id_transacao%type) FOR
	SELECT	distinct a.nr_seq_conta_mat
	from	pls_cp_cta_selecao a
	where	a.nr_id_transacao = nr_id_transacao_pc
	and	a.ie_valido = 'S';
	
c_partic CURSOR(	nr_id_transacao_pc	pls_cp_cta_selecao.nr_id_transacao%type) FOR
	SELECT	distinct a.nr_seq_proc_partic
	from	pls_cp_cta_selecao a
	where	a.nr_id_transacao = nr_id_transacao_pc
	and	a.ie_valido = 'S';	


BEGIN

-- regra de material

if (ie_tipo_regra_p = 'M') then
	
	open c_mat(nr_id_transacao_p);
	loop
		fetch c_mat bulk collect into tb_seq_item_w
		limit pls_util_pck.qt_registro_transacao_w;
		exit when tb_seq_item_w.count = 0;
		
		-- coparticipacao

		if (ie_destino_regra_p = 'C') then
		
			forall i in tb_seq_item_w.first..tb_seq_item_w.last
				update	pls_conta_mat_regra
				set	nr_seq_cp_comb_filtro_cop = nr_seq_filtro_p,
					dt_atualizacao = clock_timestamp(),
					nm_usuario = nm_usuario_p
				where	nr_sequencia = tb_seq_item_w(i);
		else
			forall i in tb_seq_item_w.first..tb_seq_item_w.last
				update	pls_conta_mat_regra
				set	nr_seq_cp_comb_filtro = nr_seq_filtro_p,
					dt_atualizacao = clock_timestamp(),
					nm_usuario = nm_usuario_p
				where	nr_sequencia = tb_seq_item_w(i);
		end if;
		
		commit;
	end loop;
	close c_mat;

-- participante do procedimento

elsif (ie_tipo_regra_p = 'PP') then

	open c_partic(nr_id_transacao_p);
	loop
		fetch c_partic bulk collect into tb_seq_item_w
		limit pls_util_pck.qt_registro_transacao_w;
		exit when tb_seq_item_w.count = 0;
		
		-- coparticipacao

		if (ie_destino_regra_p = 'C') then
		
			forall i in tb_seq_item_w.first..tb_seq_item_w.last
				update	pls_proc_participante
				set	nr_seq_cp_comb_filtro_cop = nr_seq_filtro_p,
					dt_atualizacao = clock_timestamp(),
					nm_usuario = nm_usuario_p
				where	nr_sequencia = tb_seq_item_w(i);
		else
			forall i in tb_seq_item_w.first..tb_seq_item_w.last
				update	pls_proc_participante
				set	nr_seq_cp_comb_filtro = nr_seq_filtro_p,
					dt_atualizacao = clock_timestamp(),
					nm_usuario = nm_usuario_p
				where	nr_sequencia = tb_seq_item_w(i);
		end if;
		
		commit;
	end loop;
	close c_partic;
	
-- procedimento ou servico

elsif (ie_tipo_regra_p in ('P','S')) then

	open c_proc_serv(nr_id_transacao_p);
	loop
		fetch c_proc_serv bulk collect into tb_seq_item_w
		limit pls_util_pck.qt_registro_transacao_w;
		exit when tb_seq_item_w.count = 0;
		
		-- coparticipacao

		if (ie_destino_regra_p = 'C') then
		
			forall i in tb_seq_item_w.first..tb_seq_item_w.last
				update	pls_conta_proc_regra
				set	nr_seq_cp_comb_filtro_cop = nr_seq_filtro_p,
					dt_atualizacao = clock_timestamp(),
					nm_usuario = nm_usuario_p
				where	nr_sequencia = tb_seq_item_w(i);
		else
			forall i in tb_seq_item_w.first..tb_seq_item_w.last
				update	pls_conta_proc_regra
				set	nr_seq_cp_comb_filtro = nr_seq_filtro_p,
					dt_atualizacao = clock_timestamp(),
					nm_usuario = nm_usuario_p
				where	nr_sequencia = tb_seq_item_w(i);
		end if;
		
		commit;
	end loop;
	close c_proc_serv;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_filtro_regra_preco_cta_pck.grava_regra_combinada_item ( ie_destino_regra_p text, nr_seq_filtro_p pls_cp_cta_combinada.nr_sequencia%type, ie_tipo_regra_p pls_cp_cta_combinada.ie_tipo_regra%type, nr_id_transacao_p pls_cp_cta_selecao.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
