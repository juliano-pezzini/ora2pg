-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_rec_glosa_emp_pck.gerar_erg_lote ( nr_seq_grg_lote_p pls_grg_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Gera o lote de envio de recurso de glosa
	
	Existem 3 formas de se gerar o lote de recurso, conforme Schema TISS
	
	1 - A nivel de protocolo, onde apenas as informacoes e glosas do protocolo e glosa serao gerados
	2 - A nivel de guia, onde as informacoes e glosas da guia serao geradas
	3 - A nivel de Item, onde as informacoes e glosas dos itens serao gerados
	
	Como cada forma seria "unica" no arquivo, entao e possivel gerar varios lotes de dados,
	conforme os niveis necessarios.
	
	Para definir os niveis:
		A nivel de protocolo, serao buscado os protocolos que suas guias e itens
		nao possuem nenhuma acao a nivel de Guia ou Item
		
		A nivel de guia, serao buscados as guias que em seus itens nao possuem
		nenhuma acao a nivel de item
		
		A nivel de Item, sera gerado para todos os itens que possuirem acao a nivel
		de item.
		
	A existencia ou nao da glosa para seu respectivo nivel devera ser controlada no
	momento em que e acatado ou recursado, anterior a geracao dos dados do lote.	
	
	Para manter essa rotina mais limpa e visivel, cada nivel ganhou sua respectiva procedure,
	e esta rotina apenas chama elas
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[]  Objetos do dicionario [X] Tasy (Delphi/Java) [  ] Portal [  ]  Relatorios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------

Pontos de atencao:
Alteracoes:
-------------------------------------------------------------------------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */


nr_sequencia_w		pls_erg_recurso.nr_sequencia%type;



BEGIN

-- Tenta recursar em nivel de protocolo

CALL pls_rec_glosa_emp_pck.gera_erg_lote_lvl_prot(		nr_seq_grg_lote_p, nm_usuario_p);

-- Tenta recursar em nivel de guia.

CALL pls_rec_glosa_emp_pck.gera_erg_lote_lvl_guia_item(	nr_seq_grg_lote_p, 'G', nm_usuario_p);

-- Tenta recursar em nivel de item

CALL pls_rec_glosa_emp_pck.gera_erg_lote_lvl_guia_item(	nr_seq_grg_lote_p, 'I', nm_usuario_p);



END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_rec_glosa_emp_pck.gerar_erg_lote ( nr_seq_grg_lote_p pls_grg_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
