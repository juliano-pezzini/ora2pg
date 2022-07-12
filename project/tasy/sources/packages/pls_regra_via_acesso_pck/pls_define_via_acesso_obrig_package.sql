-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/

CREATE OR REPLACE PROCEDURE pls_regra_via_acesso_pck.pls_define_via_acesso_obrig ( nr_seq_lote_p pls_lote_protocolo_conta.nr_sequencia%type, nr_seq_protocolo_p pls_protocolo_conta.nr_sequencia%type, nr_seq_lote_processo_p pls_cta_lote_processo.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc.nr_sequencia%type, nr_seq_analise_p pls_conta.nr_seq_analise%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type ) AS $body$
DECLARE
	
_ora2pg_r RECORD;
/* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: 	Rotina responsavel por armazenar todos os procedimentos que deverao ter o campo IE_VIA_OBRIGATORIA = 'S'.
	(Obs: o campo IE_VIA_OBRIGATORIA indica se a via de acesso e obrigatoria para o procedimento)
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 	

i				integer;
qt_registro_transacao_w		integer;
			
qt_regra_via_acesso_obr_w	integer;

nr_seq_conta_proc_table_w   	dbms_sql.number_table;
nr_seq_regra_via_table_w   	dbms_sql.number_table;
BEGIN

i := 0;

-- Obtem o controle padrao da quantidade de registros que sera enviada a cada vez para o banco de dados
qt_registro_transacao_w := pls_util_cta_pck.qt_registro_transacao_w;

-- Verifica se existe alguma regra de via de acesso obrigatoria ativa
select	count(1)
into STRICT	qt_regra_via_acesso_obr_w
from	pls_regra_via_acesso
where	ie_situacao = 'A';

if (qt_regra_via_acesso_obr_w > 0) then
	-- Cursor de procedimentos que retorna somente a guia de referencia e a sequencia do segurado
	for r_C01_w in current_setting('pls_regra_via_acesso_pck.c_dados_proc_param')::CURSOR((nr_seq_lote_p, nr_seq_protocolo_p, nr_seq_lote_processo_p, nr_seq_conta_p, nr_seq_conta_proc_p, nr_seq_analise_p) loop		
		-- Cursor de procedimentos restringido somente pela guia de referencia e sequencia do segurado
		for r_C02_w in current_setting('pls_regra_via_acesso_pck.c_dados_proc')::CURSOR((r_C01_w.cd_guia_referencia, r_C01_w.nr_seq_segurado) loop	
			begin	
			-- Obtem os procedimentos que terao a via de acesso obrigatoria 
			SELECT * FROM pls_regra_via_acesso_pck.pls_obtem_proc_obrig_via(r_C02_w, nm_usuario_p, cd_estabelecimento_p, i, nr_seq_conta_proc_table_w, nr_seq_regra_via_table_w) INTO STRICT _ora2pg_r;
 i := _ora2pg_r.i_p; nr_seq_conta_proc_table_w := _ora2pg_r.nr_seq_conta_proc_table_p; nr_seq_regra_via_table_w := _ora2pg_r.nr_seq_regra_via_table_p;

			if (i >= qt_registro_transacao_w) then	
				-- Altera o campo IE_VIA_OBRIGATORIA de cada procedimento para 'S'
							
				CALL pls_regra_via_acesso_pck.pls_atualiza_obrig_via_acesso(nr_seq_conta_proc_table_w, nr_seq_regra_via_table_w);
				
				-- Limpa a variavel table
				nr_seq_conta_proc_table_w.delete;
				
				i := 0;
			end if;
			end;
		end loop;
	end loop;
end if;	

-- Caso sobre algum procedimento dentro das tables, estes tambem devem ser atualizados
CALL pls_regra_via_acesso_pck.pls_atualiza_obrig_via_acesso(nr_seq_conta_proc_table_w, nr_seq_regra_via_table_w);

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_regra_via_acesso_pck.pls_define_via_acesso_obrig ( nr_seq_lote_p pls_lote_protocolo_conta.nr_sequencia%type, nr_seq_protocolo_p pls_protocolo_conta.nr_sequencia%type, nr_seq_lote_processo_p pls_cta_lote_processo.nr_sequencia%type, nr_seq_conta_p pls_conta.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc.nr_sequencia%type, nr_seq_analise_p pls_conta.nr_seq_analise%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type ) FROM PUBLIC;
