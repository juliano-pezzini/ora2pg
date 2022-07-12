-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_sip_pck.desfaz_indice_exp_benef ( nr_seq_lote_sip_p pls_lote_sip.nr_sequencia%type) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Desfaz todos os indices de exposicao do beneficiaro

		
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[X]  Objetos do dicionario [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------

Pontos de atencao:	
		Existe um ponto de atencao quanto a performance, como no geral
		a geracao do indice de exposicao e uma tabela com muitos registros,
		a forma de apagar eles foi feita por agrupamento de lote e beneficiario.
		
		Isto foi feito agrupado, segundo constatacao feita em bases de desenvolvimento
		de clientes, onde foi estimado que a media de carencias por beneficiario 
		justificaria a exclusao por "agrupamento" de beneficiario e lote, ao inves
		de utilizar a PK, pois o volume de dados carregado pelo cursor seria muito maior
		utilizando a PK do que o "agrupamento". 
	
Alteracoes:
-------------------------------------------------------------------------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
	
-- tabela virtual

tb_nr_seq_segurado_w	dbms_sql.number_table;

--Carrega os beneficiarios que devem ter o indice de exposicao apagados

c01 CURSOR(	nr_seq_lote_sip_pc	pls_lote_sip.nr_sequencia%type) FOR
	SELECT	a.nr_seq_segurado
	from	sip_nv_benef_exp_item	a
	where	a.nr_seq_lote	= nr_seq_lote_sip_pc
	group by a.nr_seq_segurado;

BEGIN

-- carrega os beneficiarios

open c01(nr_seq_lote_sip_p);

-- navega pelos registros

loop
	fetch c01 bulk collect into tb_nr_seq_segurado_w limit current_setting('pls_sip_pck.qt_registro_transacao_w')::integer;
	exit when tb_nr_seq_segurado_w.count = 0;
	
	-- joga para o banco

	forall i in tb_nr_seq_segurado_w.first..tb_nr_seq_segurado_w.last
		delete	
		from	sip_nv_benef_exp_item
		where	nr_seq_lote	= nr_seq_lote_sip_p
		and	nr_seq_segurado	= tb_nr_seq_segurado_w(i);
	
	commit;
	tb_nr_seq_segurado_w.delete;
	
end loop;

-- se o cursor ficou aberto, fecha ele

if (c01%isopen) then

	close c01;
end if;


END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_sip_pck.desfaz_indice_exp_benef ( nr_seq_lote_sip_p pls_lote_sip.nr_sequencia%type) FROM PUBLIC;