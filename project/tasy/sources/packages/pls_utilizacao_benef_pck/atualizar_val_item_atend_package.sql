-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_utilizacao_benef_pck.atualizar_val_item_atend ( regra_util_p INOUT regra_utilizacao_benef) AS $body$
DECLARE

_ora2pg_r RECORD;
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Atualiza o valor do atendimento
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta: 
[X]  Objetos do dicionario [ ] Tasy (Delphi/Java) [ ] Portal [  ]  Relatorios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------
Pontos de atencao:

	Sera atualizado o valor do atendimento, nao e utilizado o campo vl_utilizacao do atendimento
	para filtro, para evitar problemas de se atualizar uma coluna, e utilizar ela ao mesmo tempo
	em um cursor
Alteracoes:
-------------------------------------------------------------------------------------------------------------------
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
-- Tabelas virtuais
nr_sequencia_w	pls_util_cta_pck.t_number_table;
vl_item_w	pls_util_cta_pck.t_number_table;


-- Traz os atendimentos
c01 CURSOR(	nr_id_transacao_pc	w_pls_utilizacao_benef.nr_id_transacao%type) FOR
	SELECT	a.nr_sequencia,
		sum(b.vl_item) vl_item		
	from	w_pls_utilizacao_benef	a,
		w_pls_util_benef_item	b
	where	b.nr_seq_util_benef	= a.nr_sequencia
	and	a.nr_id_transacao	= nr_id_transacao_pc
	group	by a.nr_sequencia;


BEGIN

begin
	open c01(regra_util_p.nr_id_transacao);
	loop
	fetch c01 bulk collect into	nr_sequencia_w,
					vl_item_w limit pls_util_pck.qt_registro_transacao_w;
	exit when nr_sequencia_w.count = 0;
	
		SELECT * FROM pls_utilizacao_benef_pck.gravar_val_item_atend(	nr_sequencia_w, vl_item_w, 'S', 'S') INTO STRICT _ora2pg_r;
 	nr_sequencia_w := _ora2pg_r.nr_sequencia_p; vl_item_w := _ora2pg_r.vl_item_p;
	end loop;			
	close c01;
exception

	when others then
		
		-- se o cursor ainda estiver aberto, tenta fechar ele
		if (c01%isopen) then
		
			close c01;
		end if;
		
		CALL CALL pls_utilizacao_benef_pck.exibe_msg_erro_padrao();
end;


END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_utilizacao_benef_pck.atualizar_val_item_atend ( regra_util_p INOUT regra_utilizacao_benef) FROM PUBLIC;