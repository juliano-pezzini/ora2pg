-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_recal_regra_preco ( nr_seq_lote_p bigint, nm_usuario_p text, cd_estabelecimento_p text) AS $body$
DECLARE


ie_tipo_despesa_w		varchar(10);
vl_recalculo_w			double precision;
nr_seq_regra_w			bigint;
ie_recalcular_pos_w		varchar(10);
ie_recalcular_copartic_w	varchar(10);

nr_seq_segurado_w		bigint;
ie_tipo_segurado_w		varchar(2);

nr_seq_plano_w			bigint	:= null;
nr_seq_contrato_w		bigint	:= null;
nr_seq_intercambio_w		bigint	:= null;
dt_contratacao_w		timestamp		:= null;
qt_idade_w			bigint	:= null;
ie_titularidade_w		varchar(2)	:= null;
nr_seq_recalc_w			bigint;
ie_recalculo_item_w		varchar(1)	:= 'N';
nr_seq_analise_w		bigint;
ie_origem_analise_w		bigint;
cd_estabelecimento_w		smallint;
ie_status_w			varchar(1);
qt_item_w			integer;
nr_lote_contabil_prov_w		pls_conta_pos_estab_contab.nr_lote_contabil_prov%type;
nr_lote_contabil_w		pls_conta_pos_estab_contab.nr_lote_contabil%type;
nr_lote_contabil_cancel_w	pls_conta_pos_estab_contab.nr_lote_contabil_cancel%type;

C01 CURSOR FOR
	SELECT	nr_seq_conta,
		nr_sequencia
	from	pls_conta_recalculo	
	where	nr_seq_lote	= nr_seq_lote_p;
	
C02 CURSOR(nr_seq_recalc_pc	pls_item_recalculo.nr_seq_conta%type)FOR
	SELECT	nr_sequencia,
		ie_tipo_item,
		nr_seq_procedimento,
		nr_seq_material
	from	pls_item_recalculo	a
	where	nr_seq_conta	= nr_seq_recalc_pc;
	
C03 CURSOR(	nr_seq_conta_proc_pc	pls_conta_proc.nr_sequencia%type,
			nr_seq_conta_mat_pc		pls_conta_mat.nr_sequencia%type) FOR
	SELECT	nr_sequencia
	from	pls_conta_coparticipacao
	where	nr_seq_conta_proc = nr_seq_conta_proc_pc
	
union all

	SELECT	nr_sequencia
	from	pls_conta_coparticipacao
	where	nr_seq_conta_mat = nr_seq_conta_mat_pc;

BEGIN

select	ie_recalcular_pos,
	ie_recalcular_copartic,
	cd_estabelecimento,
	ie_recalcular_item
into STRICT	ie_recalcular_pos_w,
	ie_recalcular_copartic_w,
	cd_estabelecimento_w,
	ie_recalculo_item_w
from	pls_lote_recalculo
where	nr_sequencia = nr_seq_lote_p;

for r_c01_w in C01() loop
	begin
	select	nr_seq_segurado,
		nr_seq_analise,
		cd_estabelecimento,
		ie_status,
		ie_tipo_segurado
	into STRICT	nr_seq_segurado_w,
		nr_seq_analise_w,
		cd_estabelecimento_w,
		ie_status_w,
		ie_tipo_segurado_w
	from	pls_conta
	where 	nr_sequencia = r_c01_w.nr_seq_conta;

	if (coalesce(ie_recalculo_item_w,'S') = 'S') then
	
		for r_c02_w in C02(r_c01_w.nr_sequencia) loop
			begin
			if (r_c02_w.ie_tipo_item	= 'P') then
				update	pls_conta_proc
				set	tx_medico			 = NULL,
					tx_custo_operacional		 = NULL,
					tx_material			 = NULL,
					ie_regra_qtde_execucao		= 'N',
					nr_seq_regra_tx_proc		 = NULL,
					nr_seq_rp_combinada		 = NULL,
					tx_item				= CASE WHEN ie_tx_manual='S' THEN tx_item  ELSE CASE WHEN ie_via_acesso='M' THEN 50 WHEN ie_via_acesso='D' THEN 70  ELSE 100 END  END ,
					vl_unitario_imp			= CASE WHEN ie_vl_apresentado_sistema='S' THEN  0  ELSE vl_unitario_imp END ,
					vl_procedimento_imp		= CASE WHEN ie_vl_apresentado_sistema='S' THEN  0  ELSE vl_procedimento_imp END ,
					ie_vl_apresentado_sistema	= 'N',
					ie_status					= 'S'
				where	nr_sequencia			= r_c02_w.nr_seq_procedimento;
			end if;
			
			if (r_c02_w.ie_tipo_item	= 'M') then
			
				update	pls_conta_mat
				set 	ie_status = 'S'
				where 	nr_sequencia = r_c02_w.nr_seq_material;
			
			end if;
			
			end;
		end loop;
	end if;
	
	for r_c02_w in C02(r_c01_w.nr_sequencia) loop
		begin
		if (r_c02_w.ie_tipo_item	= 'P') and (coalesce(r_c02_w.nr_seq_procedimento,0) > 0)then
			
			if (coalesce(ie_recalculo_item_w,'S') = 'S') then
				select	max(ie_tipo_despesa)
				into STRICT	ie_tipo_despesa_w
				from	pls_conta_proc
				where	nr_sequencia	= r_c02_w.nr_seq_procedimento;
				
				if (ie_tipo_despesa_w = '1') then /* Atualizar o valor do procedimento */
					CALL pls_atualiza_valor_proc(r_c02_w.nr_seq_procedimento, 'N', nm_usuario_p,'S','G',null);
				elsif (ie_tipo_despesa_w in ('2','3')) then /* Atualizar os valores das taxas e diarias */
					CALL pls_atualiza_valor_servico(r_c02_w.nr_seq_procedimento, 'N', nm_usuario_p,'S');
				elsif (ie_tipo_despesa_w = '4') then /* Atualizar os valores dos pacotes */
					CALL pls_atualiza_valor_pacote(r_c02_w.nr_seq_procedimento, 'C', nm_usuario_p, 'S', 'N');
				end if;
			
				select	coalesce(vl_procedimento,0),
					nr_seq_regra
				into STRICT	vl_recalculo_w,
					nr_seq_regra_w
				from	pls_conta_proc
				where	nr_sequencia	= r_c02_w.nr_seq_procedimento;
				
				CALL pls_atualiza_valor_apresentado( null, null, null, r_c01_w.nr_seq_conta, r_c02_w.nr_seq_procedimento, cd_estabelecimento_w, nm_usuario_p);
				
				CALL pls_obter_regra_valor_conta(r_c01_w.nr_seq_conta, r_c02_w.nr_seq_procedimento, null,null,nm_usuario_p);
				CALL pls_liberar_item_automatic(null,r_c02_w.nr_seq_procedimento,null,nm_usuario_p);
				select count(1)
				into STRICT	qt_item_w
				from	pls_conta_proc
				where	nr_seq_conta = r_c01_w.nr_seq_conta
				and	ie_status not in ('S','D');
				
				if (qt_item_w > 0) then
					CALL pls_atualiza_lib_conta(r_c01_w.nr_seq_conta,'A',nm_usuario_p);
				end if;
			else
				select	coalesce(vl_liberado,0),
					nr_seq_regra
				into STRICT	vl_recalculo_w,
					nr_seq_regra_w
				from	pls_conta_proc
				where	nr_sequencia	= r_c02_w.nr_seq_procedimento;
			end if;

			if (ie_tipo_segurado_w in ('B','A','I','C','T','R','H')) and (coalesce( ie_recalcular_copartic_w,'S') = 'S') then
				
				delete	FROM pls_conta_copartic_aprop
				where	NR_SEQ_CONTA_COPARTICIPACAO in (SELECT	nr_sequencia
									from	pls_conta_coparticipacao
									where	nr_seq_conta_proc = r_c02_w.nr_seq_procedimento);
									
				delete	FROM pls_conta_proc_aprop
				where	nr_seq_conta_proc = r_c02_w.nr_seq_procedimento;
				
				for r_c03_w in c03(r_c02_w.nr_seq_procedimento, r_c02_w.nr_seq_material) loop
				
					CALL pls_deletar_coparticipacao(r_c01_w.nr_seq_conta, r_c03_w.nr_sequencia,'S', 'N', null, null, nm_usuario_p,cd_estabelecimento_p);
				
				end loop;						
											
				CALL pls_gerar_coparticipacao_proc(r_c02_w.nr_seq_procedimento,'N',nm_usuario_p);
				
				CALL pls_gerar_coparticipacao(r_c02_w.nr_seq_procedimento, nr_seq_segurado_w, r_c01_w.nr_seq_conta,
							cd_estabelecimento_w, nm_usuario_p, 0,
							nr_seq_plano_w, nr_seq_contrato_w, nr_seq_intercambio_w,
							dt_contratacao_w,qt_idade_w,ie_titularidade_w,
							null,null,null,
							null);	

			end if;

			update	pls_item_recalculo
			set	vl_item				= vl_recalculo_w,
				nr_seq_regra_preco		= nr_seq_regra_w
			where	nr_sequencia			= r_c02_w.nr_sequencia;
			
			if (ie_recalcular_pos_w = 'S' )	and (ie_status_w = 'F') then
				CALL pls_gerar_valor_pos_estab(r_c01_w.nr_seq_conta, nm_usuario_p, 'R',r_c02_w.nr_seq_procedimento,null,'A');
			end if;
				
		elsif (r_c02_w.ie_tipo_item	= 'M') and (coalesce(r_c02_w.nr_seq_material,0) > 0)then

			if (coalesce(ie_recalculo_item_w,'N') = 'S') then
				CALL pls_atualiza_valor_mat(r_c02_w.nr_seq_material, 'N', nm_usuario_p,null,null);
				
				select	coalesce(vl_material,0),
					nr_seq_regra
				into STRICT	vl_recalculo_w,
					nr_seq_regra_w
				from	pls_conta_mat
				where	nr_sequencia	= r_c02_w.nr_seq_material;
				
				CALL pls_obter_regra_valor_conta(r_c01_w.nr_seq_conta, null, r_c02_w.nr_seq_material,null,nm_usuario_p);
				CALL pls_liberar_item_automatic(null,null,r_c02_w.nr_seq_material,nm_usuario_p);	
				
				select count(1)
				into STRICT	qt_item_w
				from	pls_conta_mat
				where	nr_seq_conta = r_c01_w.nr_seq_conta
				and	ie_status not in ('S','D');
				
				if (qt_item_w > 0) then
					CALL pls_atualiza_lib_conta(r_c01_w.nr_seq_conta,'A',nm_usuario_p);
				end if;
			else
				select	coalesce(vl_liberado,0),
					nr_seq_regra
				into STRICT	vl_recalculo_w,
					nr_seq_regra_w
				from	pls_conta_mat
				where	nr_sequencia	= r_c02_w.nr_seq_material;
			end if;
			if (ie_tipo_segurado_w in ('B','A','I','C','T','R','H')) and (coalesce(ie_recalcular_copartic_w,'N') = 'S') then
				
				delete	FROM pls_conta_copartic_aprop
				where	NR_SEQ_CONTA_COPARTICIPACAO in (SELECT	nr_sequencia
									from	pls_conta_coparticipacao
									where	nr_seq_conta_mat = r_c02_w.nr_seq_material);
									
				delete	FROM pls_conta_mat_aprop
				where	nr_seq_conta_mat = r_c02_w.nr_seq_material;

				for r_c03_w in c03(r_c02_w.nr_seq_procedimento, r_c02_w.nr_seq_material) loop
				
					CALL pls_deletar_coparticipacao(r_c01_w.nr_seq_conta, r_c03_w.nr_sequencia,'S', 'N', null, null, nm_usuario_p,cd_estabelecimento_p);
				
				end loop;
				
				CALL pls_gerar_coparticipacao_mat(r_c02_w.nr_seq_material, nm_usuario_p, cd_estabelecimento_w);
				
				CALL pls_gerar_coparticipacao(null, nr_seq_segurado_w, r_c01_w.nr_seq_conta,
							cd_estabelecimento_w, nm_usuario_p, r_c02_w.nr_seq_material,
							nr_seq_plano_w, nr_seq_contrato_w, nr_seq_intercambio_w,
							dt_contratacao_w, qt_idade_w, ie_titularidade_w, 
							null,null,null,
							null);
			end if;
		
			update	pls_item_recalculo
			set	vl_item				= vl_recalculo_w,
				nr_seq_regra_preco		= nr_seq_regra_w
			where	nr_sequencia			= r_c02_w.nr_sequencia;
			
			if (ie_recalcular_pos_w = 'S' )	and (ie_status_w = 'F') then
				CALL pls_gerar_valor_pos_estab(r_c01_w.nr_seq_conta, nm_usuario_p, 'R',null,r_c02_w.nr_seq_material,'A');
			end if;
		end if;
		
		
		end;
	end loop;

	select	coalesce(max(a.nr_lote_contabil_prov),0),
		coalesce(max(a.nr_lote_contabil),0),
		coalesce(max(a.nr_lote_contabil_cancel),0)
	into STRICT	nr_lote_contabil_prov_w,
		nr_lote_contabil_w,
		nr_lote_contabil_cancel_w
	from	pls_conta_pos_estab_contab	a
	where	a.nr_seq_conta			= r_c01_w.nr_seq_conta;

	if (nr_lote_contabil_prov_w = 0) and (nr_lote_contabil_w = 0) and (nr_lote_contabil_cancel_w = 0) then

		begin
			-- nao pode gerar nenhuma exception aqui, para nao parar o processo
			delete from pls_conta_pos_estab_contab where nr_seq_conta = r_c01_w.nr_seq_conta;
		exception
			when others then null;
		end;
	end if;

	CALL pls_gerar_contab_val_adic(	r_c01_w.nr_seq_conta,	null, null,null,
				null,null,null, 'P','N', nm_usuario_p);
	CALL pls_gerar_contab_val_adic(	r_c01_w.nr_seq_conta,	null, null,null,
				null,null,null, 'C','N', nm_usuario_p);
	if (ie_status_w = 'F') then
		CALL pls_atualiza_status_copartic(r_c01_w.nr_seq_conta, 'FC', null, nm_usuario_p, cd_estabelecimento_w);
	end if;
	
	end;
end loop;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_recal_regra_preco ( nr_seq_lote_p bigint, nm_usuario_p text, cd_estabelecimento_p text) FROM PUBLIC;

