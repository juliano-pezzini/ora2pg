-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_sip_pck.sip_nv_alimenta_segmentacao ( nr_seq_lote_p pls_lote_sip.nr_sequencia%type, nm_usuario_p text) AS $body$
DECLARE


tb_rowid_w		pls_util_cta_pck.t_rowid;
tb_segmentacao_w	dbms_sql.varchar2_table;

c01 CURSOR FOR
	SELECT	nr_sequencia nr_seq_item_assist,
		ie_hospitalar,
		ie_hospitalar_obs, 
		ie_ambulatorial,
		ie_odontologico
	from	sip_item_assistencial;
		
c02 CURSOR(	nr_seq_lote_pc 		pls_lote_sip.nr_sequencia%type,
		nr_seq_item_assist_pc	sip_item_assistencial.nr_sequencia%type,
		ie_hospitalar_pc	sip_item_assistencial.ie_hospitalar%type,
		ie_hospitalar_obs_pc	sip_item_assistencial.ie_hospitalar_obs%type,
		ie_ambulatorial_pc	sip_item_assistencial.ie_ambulatorial%type,
		ie_odontologico_pc	sip_item_assistencial.ie_odontologico%type) FOR
	SELECT	a.oid,
		pls_sip_pck.obter_segmentacao_sip(	ie_hospitalar_pc, ie_hospitalar_obs_pc,
							ie_ambulatorial_pc, ie_odontologico_pc, 
							a.ie_segmentacao) ie_segmentacao
	from	sip_nv_dados		a,
		sip_nv_regra_vinc_it	b
	where	a.nr_seq_lote_sip	= nr_seq_lote_pc
	and	b.nr_seq_item_assist	= nr_seq_item_assist_pc
	and	b.nr_seq_sip_nv_dados	= a.nr_sequencia;

BEGIN

for r_c01_w in c01 loop

	-- Busca os dados gerados e a segmentacao dele 

	open c02(	nr_seq_lote_p, r_c01_w.nr_seq_item_assist, r_c01_w.ie_hospitalar,
			r_c01_w.ie_hospitalar_obs, r_c01_w.ie_ambulatorial, r_c01_w.ie_odontologico);
	loop
		-- Limpa os registros ja gravados

		tb_rowid_w.delete;
		tb_segmentacao_w.delete;
		
		-- Preenche X linhas nas tabelas

		fetch c02
		bulk collect into tb_rowid_w, tb_segmentacao_w
		limit current_setting('pls_sip_pck.qt_registro_transacao_w')::integer;
		-- Sai do loop quando acabar tudo.

		exit when tb_rowid_w.count = 0;
		
		forall i in tb_rowid_w.first .. tb_rowid_w.last
			update	sip_nv_dados
			set	ie_segmentacao_sip = tb_segmentacao_w(i),
				dt_atualizacao = clock_timestamp(),
				nm_usuario = nm_usuario_p
			where	rowid = tb_rowid_w(i);
		commit;
	end loop;
	close c02;
end loop;
	
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_sip_pck.sip_nv_alimenta_segmentacao ( nr_seq_lote_p pls_lote_sip.nr_sequencia%type, nm_usuario_p text) FROM PUBLIC;
