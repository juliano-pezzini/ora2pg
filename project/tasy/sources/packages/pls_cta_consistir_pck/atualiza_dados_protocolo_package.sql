-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_cta_consistir_pck.atualiza_dados_protocolo ( tb_protocolos_p dbms_sql.number_table, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE
					
nr_indexador_w			integer;
nr_indice_protocolo_w		integer;
nr_indice_resumo_w		integer;
qt_conta_consistida_w		integer;
qt_conta_liberada_w		integer;
qt_conta_W			integer;
nr_seq_fatura_w			integer;
tb_seq_prot_w			dbms_sql.number_table;
tb_status_w			dbms_sql.varchar2_table;
tb_resumo_contas_w		dbms_sql.number_table;
ie_atualizar_grupo_ans_w	varchar(1);
					

BEGIN
-- Se realmente tiver registros

nr_indice_protocolo_w	:=0;
nr_indice_resumo_w	:=0;

if (tb_protocolos_p.count > 0) then
	
	nr_indexador_w	:= tb_protocolos_p.first;
	while(nr_indexador_w IS NOT NULL AND nr_indexador_w::text <> '') loop
		
		--Retorna quantidade de contas com status entre 'P', 'L' e 'A'

		qt_conta_consistida_w	:=pls_cta_consistir_pck.obter_qtde_contas(tb_protocolos_p(nr_indexador_w), 'P');
		
		--Retorna quantidade de contas com status = 'F' ou 'C'

		qt_conta_liberada_w	:= pls_cta_consistir_pck.obter_qtde_contas(tb_protocolos_p(nr_indexador_w), 'F');
		
		--Quantidade total do protocolo

		qt_conta_W	:= pls_cta_consistir_pck.obter_qtde_contas(tb_protocolos_p(nr_indexador_w), 'T');	
		
		if (qt_conta_w = 0) then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(174118);--'Protocolo sem contas. Verifique!
		end if;
		
		--Se todas  as contas do protocolo estiverem com fechadas ou canceladas(F, C)

		if (qt_conta_liberada_w = qt_conta_W) then
						
			--Obt_m valor do campo ie_atualizar_grupo_ans

			ie_atualizar_grupo_ans_w := pls_cta_consistir_pck.obter_valor_parametro(cd_estabelecimento_p, 'G');
			
			if (ie_atualizar_grupo_ans_w = 'S') then
				--alterado na rotina para verificar o grupo ans antes de verificar o valor.

				CALL pls_atualizar_grupo_ans_conta(tb_protocolos_p(nr_indexador_w), 'N', null, null,'N',nm_usuario_p,cd_estabelecimento_p, null);
			end if;
			
			--status 5 = analisado e aguardando libera__o para pagamento

			tb_status_w(nr_indice_protocolo_w) := '5';
			tb_seq_prot_w(nr_indice_protocolo_w) := tb_protocolos_p(nr_indexador_w);
			
			--Obt_m fatura(desconsidera devolvidas (R) e canceladas(CA))

			select	max(nr_sequencia)
			into STRICT	nr_seq_fatura_w
			from	ptu_fatura
			where	nr_seq_protocolo	= tb_protocolos_p(nr_indexador_w)
			and	ie_status	not in ('CA','R');
			
			if (nr_seq_fatura_w IS NOT NULL AND nr_seq_fatura_w::text <> '') then
				CALL ptu_atualizar_status_fatura(nr_seq_fatura_w, 'AF', null, nm_usuario_p);
			end if;
		
			tb_resumo_contas_w(nr_indice_resumo_w) := tb_protocolos_p(nr_indexador_w);
			
		--Se  alguma conta no protocolo estiver  pendente de libera__o, liberada para fechamento ou em an_lse(P, L, A)

		elsif (qt_conta_consistida_w > 0) then
			
			--status 2 = Em an_lise

			tb_status_w(nr_indice_protocolo_w) := '2';
			tb_seq_prot_w(nr_indice_protocolo_w) := tb_protocolos_p(nr_indexador_w);
			
		--Caso nenhuma conta do protocolo estiver fechada ou cancelada

		elsif (qt_conta_liberada_w = 0) then
			
			--status 1 = Recebido

			tb_status_w(nr_indice_protocolo_w) := '1';
			tb_seq_prot_w(nr_indice_protocolo_w) := tb_protocolos_p(nr_indexador_w);
		end if;	
		
		if	((nr_indice_protocolo_w + nr_indice_resumo_w) >= 2000 ) then
			
			CALL CALL pls_cta_consistir_pck.atualizar_status_protocolo(tb_seq_prot_w, tb_status_w, tb_resumo_contas_w, nm_usuario_p, cd_estabelecimento_p);
			tb_seq_prot_w.delete;
			tb_status_w.delete;
			tb_resumo_contas_w.delete;
			nr_indice_protocolo_w 	:= 0;
			nr_indice_resumo_w	:= 0;
		else
			nr_indice_protocolo_w 	:= nr_indice_protocolo_w + 1;
			nr_indice_resumo_w	:= nr_indice_resumo_w + 1;
		end if;
		
		--altera_status_protocolo(tb_protocolos_p(nr_indexador_w), 'C','N',cd_estabelecimento_p, nm_usuario_p);

		nr_indexador_w := tb_protocolos_p.next(nr_indexador_w);
	end loop;
	
end if;	

--Podem sobrar registros nas variaveis tabela, ent_o manda novamente para o banco

CALL CALL pls_cta_consistir_pck.atualizar_status_protocolo( tb_seq_prot_w, tb_status_w, tb_resumo_contas_w, nm_usuario_p, cd_estabelecimento_p);

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_cta_consistir_pck.atualiza_dados_protocolo ( tb_protocolos_p dbms_sql.number_table, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;