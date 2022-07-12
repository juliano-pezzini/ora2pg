-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_conv_xml_cta_pck.pls_atualizar_info_finais_proc ( nr_seq_protocolo_p pls_protocolo_conta_imp.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE


_ora2pg_r RECORD;
ie_gerar_grupo_ans_w	pls_parametro_contabil.ie_consitencia_grupo_ans%type;	
nr_seq_conselho_w	pls_conta_imp.nr_cons_prof_exec_conv%type;
cd_medico_partic_w	pls_conta_item_equipe_imp.cd_profissional_conv%type;
nr_seq_grupo_ans_w	pls_conta_proc.nr_seq_grupo_ans%type;
tb_nr_seq_item_w	pls_util_cta_pck.t_number_table;
tb_seq_grupo_ans_w	pls_util_cta_pck.t_number_table;
nr_index_w		integer := 0;

C01 CURSOR FOR
	SELECT	c.cd_procedimento_conv,
		c.ie_origem_proced_conv,
		c.nr_sequencia nr_seq_conta_proc,
		b.nr_seq_tipo_atend_conv,
		b.ie_regime_internacao,
		b.nr_cons_prof_exec_conv,
		a.ie_tipo_guia,
		c.nr_sequencia
	from	pls_protocolo_conta_imp a,
		pls_conta_imp b,
		pls_conta_proc_imp c
	where	a.nr_sequencia = b.nr_seq_protocolo
	and	b.nr_sequencia = c.nr_seq_conta
	and	a.nr_sequencia = nr_seq_protocolo_p;
	
BEGIN

select	coalesce(max(ie_consitencia_grupo_ans), 'S')
into STRICT	ie_gerar_grupo_ans_w
from	pls_parametro_contabil
where	cd_estabelecimento	= cd_estabelecimento_p;

-- Par_metro que verifica se o deve gerar o grupo ANS. Basicamente n~_o precisa olhar mais nada, pois aqui certamente n_o

--ter_  ainda informacao de grupo ANS por estarmos na importacao de XML.

if (ie_gerar_grupo_ans_w = 'S')  then

	for r_c01_w in C01 loop

		if (coalesce(r_c01_w.nr_cons_prof_exec_conv::text, '') = '') then
		
			select 	max(cd_profissional_conv)
			into STRICT	cd_medico_partic_w
			from	pls_conta_item_equipe_imp
			where	nr_seq_conta_proc	= r_c01_w.nr_seq_conta_proc;
			
			select	max(nr_seq_conselho)
			into STRICT	nr_seq_conselho_w
			from	pessoa_fisica
			where	cd_pessoa_fisica	= cd_medico_partic_w;
		else
			nr_seq_conselho_w := r_c01_w.nr_cons_prof_exec_conv;
		
		end if;
	
		nr_seq_grupo_ans_w	:= pls_obter_grupo_ans(	r_c01_w.cd_procedimento_conv, r_c01_w.ie_origem_proced_conv, nr_seq_conselho_w,
								r_c01_w.nr_seq_tipo_atend_conv, r_c01_w.ie_tipo_guia, r_c01_w.ie_regime_internacao,
								'O', 'G',cd_estabelecimento_p, null);
					
		tb_nr_seq_item_w(nr_index_w)   	:= r_c01_w.nr_sequencia;
		tb_seq_grupo_ans_w(nr_index_w)	:= nr_seq_grupo_ans_w;			
		
		-- se atingiu a quantidade manda pro banco

		if (nr_index_w >= pls_util_pck.qt_registro_transacao_w) then
			
			SELECT * FROM pls_conv_xml_cta_pck.atualiza_dados_finais_proc(tb_nr_seq_item_w, tb_seq_grupo_ans_w) INTO STRICT _ora2pg_r;
 tb_nr_seq_item_w := _ora2pg_r.tb_nr_seq_item_p; tb_seq_grupo_ans_w := _ora2pg_r.tb_seq_grupo_ans_p;
			nr_index_w := 0;
		else
			nr_index_w := nr_index_w + 1;
		end if;	
	end loop;
	
	--Se sobrarem registros em mem_ria, precisa persistir os mesmo no banco.

	SELECT * FROM pls_conv_xml_cta_pck.atualiza_dados_finais_proc(tb_nr_seq_item_w, tb_seq_grupo_ans_w) INTO STRICT _ora2pg_r;
 tb_nr_seq_item_w := _ora2pg_r.tb_nr_seq_item_p; tb_seq_grupo_ans_w := _ora2pg_r.tb_seq_grupo_ans_p;
	
end if;



END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_conv_xml_cta_pck.pls_atualizar_info_finais_proc ( nr_seq_protocolo_p pls_protocolo_conta_imp.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;