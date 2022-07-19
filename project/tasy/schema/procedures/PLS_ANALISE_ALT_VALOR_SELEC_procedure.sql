-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_analise_alt_valor_selec ( nr_seq_analise_p pls_analise_conta.nr_sequencia%type, nr_seq_ocorrencia_p pls_ocorrencia.nr_sequencia%type, nr_seq_motivo_glosa_p tiss_motivo_glosa.nr_sequencia%type, ds_observacao_p text, qt_liberada_p text, vl_liberado_p text, vl_liberado_hi_p text, vl_liberado_mat_p text, vl_liberado_co_p text, vl_lib_taxa_hi_p text, vl_lib_taxa_mat_p text, vl_lib_taxa_co_p text, cd_estabelecimento_p bigint, nm_usuario_p text, nr_seq_grupo_atual_p pls_grupo_auditor.nr_sequencia%type) AS $body$
DECLARE

 
nr_seq_conta_w			pls_conta.nr_sequencia%type;
nr_seq_conta_proc_w		pls_conta_proc.nr_sequencia%type;
nr_seq_conta_mat_w		pls_conta_mat.nr_sequencia%type;
nr_seq_proc_partic_w		pls_proc_participante.nr_sequencia%type;
tx_intercambio_imp_w  		pls_conta_proc.tx_intercambio_imp%type;
vl_liberado_w			pls_conta_proc.vl_liberado%type;
vl_lib_taxa_mat_p_w		pls_conta_proc.vl_liberado_material%type;
vl_liberado_hi_w		pls_conta_proc.vl_liberado_hi%type;
vl_liberado_material_w		pls_conta_proc.vl_liberado_material%type;
vl_liberado_co_w		pls_conta_proc.vl_liberado_co%type;
qt_procedimento_w		pls_conta_proc.qt_procedimento%type;
				
C01 CURSOR FOR 
	SELECT	distinct(a.nr_seq_w_item) 
	from	w_pls_analise_selecao_item a 
	where	a.nr_seq_analise	= nr_seq_analise_p 
	and	a.nm_usuario		= nm_usuario_p;
									
BEGIN 
 
for r_C01 in C01 loop 
 
	begin 
	select	a.nr_seq_conta, 
		a.nr_seq_conta_proc, 
		a.nr_seq_conta_mat, 
		a.nr_seq_proc_partic, 
		a.tx_intercambio_imp, 
		a.vl_liberado_hi, 
		a.vl_material_ptu_imp, 
		a.vl_liberado_co, 
		a.qt_liberado 
	into STRICT	nr_seq_conta_w, 
		nr_seq_conta_proc_w, 
		nr_seq_conta_mat_w, 
		nr_seq_proc_partic_w, 
		tx_intercambio_imp_w, 
		vl_liberado_hi_w, 
		vl_liberado_material_w, 
		vl_liberado_co_w, 
		qt_procedimento_w 
	from	w_pls_analise_item a 
	where	a.nr_sequencia	= r_C01.nr_seq_w_item;
	exception 
	when others then 
		nr_seq_conta_w		:= null;
		nr_seq_conta_proc_w	:= null;
		nr_seq_conta_mat_w	:= null;
		nr_seq_proc_partic_w	:= null;
	end;
	 
	/*calcular os valores igual é feito no delphi para enviar na rotina de atualização - Drquadros 582821*/
 
	if (nr_seq_conta_proc_w IS NOT NULL AND nr_seq_conta_proc_w::text <> '')	then 
		vl_liberado_w 	:= vl_liberado_hi_w + vl_liberado_material_w + vl_liberado_co_w + vl_lib_taxa_hi_p + vl_lib_taxa_mat_p + vl_lib_taxa_co_p;
	elsif (tx_intercambio_imp_w > 0) and (vl_lib_taxa_mat_p > 0)	then 
		vl_liberado_w	:= ((vl_lib_taxa_mat_p / tx_intercambio_imp_w)* 100);
	end if;
 
	if (nr_seq_conta_proc_w IS NOT NULL AND nr_seq_conta_proc_w::text <> '')	then 
	    vl_lib_taxa_mat_p_w   := ((vl_liberado_w * tx_intercambio_imp_w) / 100);
	end if;
	 
	/*tratamento se for nulo recebe o parâmetro*/
 
	vl_liberado_w		:= coalesce(vl_liberado_w,vl_liberado_p);
	qt_procedimento_w	:= coalesce(qt_procedimento_w, qt_liberada_p);
	vl_lib_taxa_mat_p_w	:= coalesce(vl_lib_taxa_mat_p_w,vl_lib_taxa_mat_p);
	 
	/*Tratamento realizado para não duplicar a glosa para o item - Drquadros 04/06/2013*/
 
	if (coalesce(nr_seq_proc_partic_w::text, '') = '')	then 
		CALL pls_analise_altera_valor_item(	nr_seq_analise_p, nr_seq_conta_proc_w, nr_seq_conta_mat_w, 
					nr_seq_proc_partic_w ,nr_seq_ocorrencia_p, nr_seq_motivo_glosa_p, 
					ds_observacao_p, qt_procedimento_w, vl_liberado_w, 
					vl_liberado_hi_w, vl_liberado_material_w, vl_liberado_co_w, 
					vl_lib_taxa_hi_p ,vl_lib_taxa_mat_p_w , vl_lib_taxa_co_p, 
					cd_estabelecimento_p , nm_usuario_p, nr_seq_grupo_atual_p);
	end if;
 
end loop;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_analise_alt_valor_selec ( nr_seq_analise_p pls_analise_conta.nr_sequencia%type, nr_seq_ocorrencia_p pls_ocorrencia.nr_sequencia%type, nr_seq_motivo_glosa_p tiss_motivo_glosa.nr_sequencia%type, ds_observacao_p text, qt_liberada_p text, vl_liberado_p text, vl_liberado_hi_p text, vl_liberado_mat_p text, vl_liberado_co_p text, vl_lib_taxa_hi_p text, vl_lib_taxa_mat_p text, vl_lib_taxa_co_p text, cd_estabelecimento_p bigint, nm_usuario_p text, nr_seq_grupo_atual_p pls_grupo_auditor.nr_sequencia%type) FROM PUBLIC;

