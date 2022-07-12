-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE ctb_parametros_cc_rateio_pck.gerar_movto_proc_paciente ( nr_seq_proc_paciente_p procedimento_paciente.nr_sequencia%type, nr_lote_contabil_p w_movimento_contabil.nr_lote_contabil%type, ie_debito_credito_p w_movimento_contabil.ie_debito_credito%type, cd_historico_p w_movimento_contabil.cd_historico%type, dt_movimento_p w_movimento_contabil.dt_movimento%type, ds_compl_historico_p w_movimento_contabil.ds_compl_historico%type, ds_doc_agrupamento_p w_movimento_contabil.ds_doc_agrupamento%type, nr_seq_agrupamento_p w_movimento_contabil.nr_seq_agrupamento%type, nr_seq_trans_fin_p w_movimento_contabil.nr_seq_trans_fin%type, cd_cgc_p w_movimento_contabil.cd_cgc%type, cd_pessoa_fisica_p w_movimento_contabil.cd_pessoa_fisica%type, nr_documento_p w_movimento_contabil.nr_documento%type, ie_transitorio_p w_movimento_contabil.ie_transitorio%type, cd_estabelecimento_p w_movimento_contabil.cd_estabelecimento%type, ie_origem_documento_p w_movimento_contabil.ie_origem_documento%type, nr_seq_info_p w_movimento_contabil.nr_seq_info%type, nr_seq_tab_orig_p w_movimento_contabil.nr_seq_tab_orig%type, nm_tabela_p w_movimento_contabil.nm_tabela%type, nm_atributo_p w_movimento_contabil.nm_atributo%type, nr_seq_tab_compl_p w_movimento_contabil.nr_seq_tab_compl%type, nr_seq_classif_movto_p w_movimento_contabil.nr_seq_classif_movto%type, cd_centro_custo_p w_movimento_contabil.cd_centro_custo%type, nr_sequencia_movto_p INOUT w_movimento_contabil.nr_sequencia%type, ie_gerou_movto_p INOUT boolean) AS $body$
DECLARE


nr_sequencia_movto_w	w_movimento_contabil.nr_sequencia%type :=	nr_sequencia_movto_p - 1;
cd_centro_custo_w	w_movimento_contabil.cd_centro_custo%type;
ie_centro_custo_w	conta_contabil.ie_centro_custo%type;
ie_gerou_movto_w	boolean:= false;
			
--Select que busca os registros que foram rateados para o procedimento do paciente			
c_proc_paciente_rateio_cc CURSOR FOR
	SELECT	a.cd_conta_contabil,
		a.cd_centro_custo,
		a.vl_rateio
	from	proc_paciente_rateio_cc a
	where	a.nr_seq_proc_pac = nr_seq_proc_paciente_p
	and 	coalesce(a.cd_conta_contabil,'XX') <> 'XX'
	and 	coalesce(a.vl_rateio, 0) > 0;			

c_proc_paciente_rateio_cc_w	c_proc_paciente_rateio_cc%rowtype;
	

BEGIN

ie_gerou_movto_w:=	false;

open c_proc_paciente_rateio_cc;
loop
fetch c_proc_paciente_rateio_cc into	
	c_proc_paciente_rateio_cc_w;
EXIT WHEN NOT FOUND; /* apply on c_proc_paciente_rateio_cc */
	begin
	
	cd_centro_custo_w:=	null;
	
	--Verificacao de exigencia de centro de custo ou nao
	if (coalesce(c_proc_paciente_rateio_cc_w.cd_conta_contabil,'0') <> '0') then
		begin
		select	coalesce(ie_centro_custo, 'N')
		into STRICT	ie_centro_custo_w
		from	conta_contabil
		where	cd_conta_contabil =	c_proc_paciente_rateio_cc_w.cd_conta_contabil;
		
		if (ie_centro_custo_w = 'S') then
			
			select	coalesce(c_proc_paciente_rateio_cc_w.cd_centro_custo, cd_centro_custo_p)
			into STRICT	cd_centro_custo_w
			;

		end if;
	
		end;
	end if;
	
	nr_sequencia_movto_w:= nr_sequencia_movto_w + 1;
	
	--Insercao dos movimentos ja rateados
	insert into w_movimento_contabil(	nr_lote_contabil,
						nr_sequencia,
						cd_conta_contabil,
						ie_debito_credito,
						cd_historico,
						dt_movimento,
						vl_movimento,
						cd_centro_custo,
						ds_compl_historico,
						ds_doc_agrupamento,
						nr_seq_agrupamento,
						nr_seq_trans_fin,
						cd_cgc,
						cd_pessoa_fisica,
						nr_documento,
						ie_transitorio,
						cd_estabelecimento,
						ie_origem_documento,
						nr_seq_info,
						nr_seq_tab_orig,
						nm_tabela,
						nm_atributo,
						nr_seq_tab_compl,
						nr_seq_classif_movto)
				values (	nr_lote_contabil_p,
						nr_sequencia_movto_w,
						c_proc_paciente_rateio_cc_w.cd_conta_contabil,
				                ie_debito_credito_p,
				                cd_historico_p,
				                dt_movimento_p,
						c_proc_paciente_rateio_cc_w.vl_rateio,
						cd_centro_custo_w,
				                ds_compl_historico_p,
				                ds_doc_agrupamento_p,
				                nr_seq_agrupamento_p,
				                nr_seq_trans_fin_p,
				                cd_cgc_p,
				                cd_pessoa_fisica_p,
				                nr_documento_p,
				                ie_transitorio_p,
				                cd_estabelecimento_p,
				                ie_origem_documento_p,
				                nr_seq_info_p,
				                nr_seq_tab_orig_p,
				                nm_tabela_p,
				                nm_atributo_p,
				                nr_seq_tab_compl_p,
				                nr_seq_classif_movto_p);
	
	ie_gerou_movto_w := true;
	
	end;
end loop;
close c_proc_paciente_rateio_cc;

--Retorno da sequencia da movimentacao para continuacao da geracao dos movimentos contabeis
nr_sequencia_movto_p 	:= nr_sequencia_movto_w;

--Retorno para verificacao de geracao da movimentacao
ie_gerou_movto_p	:= ie_gerou_movto_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_parametros_cc_rateio_pck.gerar_movto_proc_paciente ( nr_seq_proc_paciente_p procedimento_paciente.nr_sequencia%type, nr_lote_contabil_p w_movimento_contabil.nr_lote_contabil%type, ie_debito_credito_p w_movimento_contabil.ie_debito_credito%type, cd_historico_p w_movimento_contabil.cd_historico%type, dt_movimento_p w_movimento_contabil.dt_movimento%type, ds_compl_historico_p w_movimento_contabil.ds_compl_historico%type, ds_doc_agrupamento_p w_movimento_contabil.ds_doc_agrupamento%type, nr_seq_agrupamento_p w_movimento_contabil.nr_seq_agrupamento%type, nr_seq_trans_fin_p w_movimento_contabil.nr_seq_trans_fin%type, cd_cgc_p w_movimento_contabil.cd_cgc%type, cd_pessoa_fisica_p w_movimento_contabil.cd_pessoa_fisica%type, nr_documento_p w_movimento_contabil.nr_documento%type, ie_transitorio_p w_movimento_contabil.ie_transitorio%type, cd_estabelecimento_p w_movimento_contabil.cd_estabelecimento%type, ie_origem_documento_p w_movimento_contabil.ie_origem_documento%type, nr_seq_info_p w_movimento_contabil.nr_seq_info%type, nr_seq_tab_orig_p w_movimento_contabil.nr_seq_tab_orig%type, nm_tabela_p w_movimento_contabil.nm_tabela%type, nm_atributo_p w_movimento_contabil.nm_atributo%type, nr_seq_tab_compl_p w_movimento_contabil.nr_seq_tab_compl%type, nr_seq_classif_movto_p w_movimento_contabil.nr_seq_classif_movto%type, cd_centro_custo_p w_movimento_contabil.cd_centro_custo%type, nr_sequencia_movto_p INOUT w_movimento_contabil.nr_sequencia%type, ie_gerou_movto_p INOUT boolean) FROM PUBLIC;
