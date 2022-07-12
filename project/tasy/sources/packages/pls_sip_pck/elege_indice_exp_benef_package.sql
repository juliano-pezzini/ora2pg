-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_sip_pck.elege_indice_exp_benef ( nr_seq_lote_sip_p pls_lote_sip.nr_sequencia%type) AS $body$
DECLARE

_ora2pg_r RECORD;
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Elege o indice a ser utilizado no SIP por beneficiario.

	Como podem existir "varios indices" por beneficiario, devido a varias carencias,
	deve-se ser selecionado um para a a sua utilizacao no SIP
	
	Essa selecao deve respeitar o beneficiario e o item assistencial ao qual o indice
	foi criado
	
		
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[X]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------

Pontos de atencao:

Alteracoes:
-------------------------------------------------------------------------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */

-- tabelas contendo os dados a serem atualizados

tb_nr_seq_item_benef_w	dbms_sql.number_table;
tb_ie_envio_sip_w	dbms_sql.varchar2_table;
tb_nr_seq_segurado_w	dbms_sql.number_table;
tb_nr_seq_item_assist_w	dbms_sql.number_table;


-- Carrega os indices eleitos por beneficiario e item assistencial

c01 CURSOR(	nr_seq_lote_sip_pc	pls_lote_sip.nr_sequencia%type) FOR
	SELECT	max(t.nr_sequencia) nr_sequencia,
		t.nr_seq_segurado,
		t.nr_seq_item_assist,
		'S' ie_envio_sip
	from (	SELECT	x.nr_sequencia,
			x.nr_seq_segurado,
			x.qt_dias_carencia,
			x.nr_seq_item_assist,
			max(x.qt_dias_carencia) over (partition by x.nr_seq_segurado, x.nr_seq_item_assist) max_qt_dias_carencia
		from	sip_nv_benef_exp_item	x
		where	x.nr_seq_lote	= nr_seq_lote_sip_pc ) t
	where	t.qt_dias_carencia = t.max_qt_dias_carencia
	group by t.nr_seq_segurado, t.nr_seq_item_assist;

BEGIN

-- carrega os indices eleitos

open c01(nr_seq_lote_sip_p);

-- navega entre eles e envia para o banco

loop
	fetch c01 bulk collect into	tb_nr_seq_item_benef_w,
					tb_nr_seq_segurado_w,
					tb_nr_seq_item_assist_w,
					tb_ie_envio_sip_w limit current_setting('pls_sip_pck.qt_registro_transacao_w')::integer;
	exit when tb_nr_seq_item_benef_w.count = 0;
	
	-- manda para o banco

	SELECT * FROM pls_sip_pck.atualiza_envio_indice_exp(tb_nr_seq_item_benef_w, tb_ie_envio_sip_w, 'S', 'S') INTO STRICT _ora2pg_r;
 tb_nr_seq_item_benef_w := _ora2pg_r.tb_nr_seq_item_benef_p; tb_ie_envio_sip_w := _ora2pg_r.tb_ie_envio_sip_p;	
	-- Carrega esses vetores apenas para "formar" o group by

	tb_nr_seq_segurado_w.delete;
	tb_nr_seq_item_assist_w.delete;
	
end loop;

-- se o cursor esta aberto, fecha

if (c01%isopen) then

	close c01;
end if;


END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_sip_pck.elege_indice_exp_benef ( nr_seq_lote_sip_p pls_lote_sip.nr_sequencia%type) FROM PUBLIC;