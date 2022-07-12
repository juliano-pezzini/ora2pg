-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_filtro_regra_event_cta_pck.limpa_vinculo_regra_filtro ( nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_analise_p pls_analise_conta.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type, ie_tipo_limpeza_p text) AS $body$
DECLARE

					
tb_seq_conta_medi_resu_w	pls_util_cta_pck.t_number_table;
tb_seq_conta_w			pls_util_cta_pck.t_number_table;

C01 CURSOR(	nr_seq_conta_pc		pls_conta.nr_sequencia%type,
		nr_seq_analise_pc	pls_analise_conta.nr_sequencia%type) FOR
	SELECT	b.nr_sequencia,
		b.nr_seq_conta
	from	pls_conta_medica_resumo b
	where 	b.nr_seq_conta = nr_seq_conta_pc
	and 	b.ie_tipo_item in ('C', 'M', 'P', 'R')
	and 	b.ie_situacao = 'A'
	and	coalesce(b.nr_seq_pp_lote::text, '') = ''
	and 	(nr_seq_conta_pc IS NOT NULL AND nr_seq_conta_pc::text <> '')
	
union all

	SELECT 	b.nr_sequencia,
		b.nr_seq_conta
	from 	pls_conta a,
		pls_conta_medica_resumo b
	where 	a.nr_seq_analise = nr_seq_analise_pc
	and 	b.nr_seq_conta = a.nr_sequencia
	and 	b.ie_tipo_item in ('C', 'M', 'P', 'R')
	and	coalesce(b.nr_seq_pp_lote::text, '') = ''
	and 	b.ie_situacao = 'A'
	and 	(nr_seq_analise_pc IS NOT NULL AND nr_seq_analise_pc::text <> '');
	

BEGIN

begin
	open C01(nr_seq_conta_p, nr_seq_analise_p);
	loop
		fetch C01 bulk collect into tb_seq_conta_medi_resu_w, tb_seq_conta_w
		limit pls_util_pck.qt_registro_transacao_w;
		exit when tb_seq_conta_medi_resu_w.count = 0;
		
		-- grava nas contas medicas resumo o valor '-1' no campo nr_seq_pp_evento para posteriormente fazer comparacoes

		-- utilizando o comando 'nr_seq_pp_evento = '-1' e nao 'nr_seq_pp_evento is null' nos registros que serao processados

		if (ie_tipo_limpeza_p = '-1') then
		
			forall	i in tb_seq_conta_medi_resu_w.first..tb_seq_conta_medi_resu_w.last
				update	pls_conta_medica_resumo
				set	nr_seq_pp_evento = -1
				where 	nr_seq_conta = tb_seq_conta_w(i)
				and	nr_sequencia = tb_seq_conta_medi_resu_w(i);
				
		-- limpa o vinculo da regra que existe nos registros que foram processados, os registros que anteriormente 

		-- tiveram o nr_seq_pp_evento setado para '-1' e nao se encaixaram em nenhuma regra terao seu valor setado para null

		else	
			forall	i in tb_seq_conta_medi_resu_w.first..tb_seq_conta_medi_resu_w.last
				update	pls_conta_medica_resumo
				set	nr_seq_pp_evento  = NULL
				where 	nr_seq_conta = tb_seq_conta_w(i)
				and	nr_sequencia = tb_seq_conta_medi_resu_w(i)
				and	nr_seq_pp_evento = -1;
		end if;
		commit;
	end loop;
	close C01;
exception
	when others then
	-- se deu algo e o cursor esta aberto fecha ele

	if (C01%isopen) then
		close C01;
	end if;
end;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_filtro_regra_event_cta_pck.limpa_vinculo_regra_filtro ( nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_analise_p pls_analise_conta.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type, ie_tipo_limpeza_p text) FROM PUBLIC;
