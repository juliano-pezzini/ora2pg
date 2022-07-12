-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_sip_pck.sip_atualiza_qt_evento_pct ( nr_seq_lote_p pls_lote_sip.nr_sequencia%type) AS $body$
DECLARE

_ora2pg_r RECORD;
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Atualiza a contagem de eventos para pacotes

	Quando e considerado os pacotes, e necessario verificar se ele nao foi aberto
	na conta, se estiver "fechado", entao e considerado os procedimentos que compoem ele
	na contagem de eventos.
	
	Se o pacote ja foi considerado "aberto", os itens ja foram inclusos na conta, e nao
	precisam ser considerados novamente, portanto o pacote e zerado na quantidade.
	
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[X]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------

Pontos de atencao:

Alteracoes:
-------------------------------------------------------------------------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */


tb_nr_seq_w		pls_util_cta_pck.t_number_table;
tb_qt_proc_mat_w	pls_util_cta_pck.t_number_table;
i			integer := 0;

-- Busca os pacotes a serem atualizados

c01 CURSOR(	nr_seq_lote_sip_pc	pls_lote_sip.nr_sequencia%type) FOR
	SELECT	a.nr_sequencia,
		-- se o pacote nao tem itens abertos, entao e apurada a quantidade da composicao, senao e zero (pacote ja aberto)

		CASE WHEN a.qt_itens_aberto=0 THEN 	coalesce((	SELECT	sum(y.qt_procedimento)


	from	sip_nv_dados_pct_v	a
	where	a.nr_seq_lote_sip	= nr_seq_lote_sip_pc;
	

BEGIN


-- Carrega os pacotes a serem atualizados

open c01(nr_seq_lote_p);
loop
fetch c01 bulk collect into	tb_nr_seq_w,
				tb_qt_proc_mat_w limit current_setting('pls_sip_pck.qt_registro_transacao_w')::integer;
exit when tb_nr_seq_w.count = 0;

	SELECT * FROM pls_sip_pck.sip_grava_qt_evento_pct(tb_nr_seq_w, tb_qt_proc_mat_w, 'S', 'S') INTO STRICT _ora2pg_r;
 tb_nr_seq_w := _ora2pg_r.tb_nr_seq_p; tb_qt_proc_mat_w := _ora2pg_r.tb_qt_proc_mat_p;
	
end loop;

-- se o curso estiver aberto, fecha

if (c01%isopen) then

	close c01;
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_sip_pck.sip_atualiza_qt_evento_pct ( nr_seq_lote_p pls_lote_sip.nr_sequencia%type) FROM PUBLIC;