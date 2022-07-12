-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



--Faz insert dos registros correspondetes _s regras de tx_pos_estab



CREATE OR REPLACE PROCEDURE pls_pos_estabelecido_pck.processa_taxa_adm_pos (nr_seq_conta_p pls_conta.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE


_ora2pg_r RECORD;
nr_seq_lote_disc_w		pls_conta_pos_proc.nr_seq_lote_disc%type;
ie_tipo_taxa_w			varchar(1);
vl_taxa_pos_w			pls_conta_pos_proc_v.vl_beneficiario%type;
qt_grupo_proc_mat_w		integer := 0;
index_proc_w			integer := 0;
index_mat_w			integer := 0;
ind_contas_w			integer := 0;
ie_conta_valida_w		varchar(1);
tb_nr_seq_conta_pos_estab_w	pls_util_cta_pck.t_number_table;
tb_proc_nr_seq_pos_estab_w	pls_util_cta_pck.t_number_table;
tb_proc_nr_seq_regra_w		pls_util_cta_pck.t_number_table;
tb_proc_vl_taxa_pos_w		pls_util_cta_pck.t_number_table;
tb_proc_ie_tipo_taxa_w		pls_util_cta_pck.t_varchar2_table_1;
tb_mat_nr_seq_pos_estab_w	pls_util_cta_pck.t_number_table;
tb_mat_nr_seq_regra_w		pls_util_cta_pck.t_number_table;
tb_mat_vl_taxa_pos_w		pls_util_cta_pck.t_number_table;
tb_mat_ie_tipo_taxa_w		pls_util_cta_pck.t_varchar2_table_1;
		
-- utilizo union pois se retornar um registro para uma conta nos procedimentos e um nos materiais, apenas preciso passar uma vez no loop		

C01 CURSOR FOR
	SELECT	max(a.nr_seq_conta) nr_seq_conta,
		a.dt_atendimento,
		a.nr_seq_plano,
		c.nr_seq_contrato,	
		a.nr_seq_intercambio,
		a.nr_seq_congenere_seg
	from	w_pls_conta_pos_proc a,
		pls_conta_pos_proc_v b,
		pls_segurado	c
	where	a.nr_seq_conta_proc = b.nr_seq_conta_proc
	and	a.nr_seq_segurado = c.nr_sequencia
	group by a.dt_atendimento,
	         a.nr_seq_plano,
	         c.nr_seq_contrato,	
	         a.nr_seq_intercambio,
	         a.nr_seq_congenere_seg
	
union

	SELECT	max(a.nr_seq_conta) nr_seq_conta,
		a.dt_atendimento,
		a.nr_seq_plano,
		c.nr_seq_contrato,	
		a.nr_seq_intercambio,
		a.nr_seq_congenere_seg
	from	w_pls_conta_pos_mat a,
		pls_conta_pos_mat_v b,
		pls_segurado	c
	where	a.nr_seq_conta_mat = b.nr_seq_conta_mat
	and	a.nr_seq_segurado = c.nr_sequencia
	group by a.dt_atendimento,
	         a.nr_seq_plano,
	         c.nr_seq_contrato,	
	         a.nr_seq_intercambio,
	         a.nr_seq_congenere_seg;
	
--Cursor de regras	

C02 CURSOR(	nr_seq_contrato_pc		pls_contrato.nr_sequencia%type,
		nr_seq_intercambio_pc		pls_intercambio.nr_sequencia%type,
		dt_mesano_referencia_pc		timestamp,
		nr_seq_plano_pc			pls_plano.nr_sequencia%type,
		nr_seq_conta_pc			pls_conta.nr_sequencia%type,
		nr_seq_congenere_pc		pls_congenere.nr_sequencia%type) FOR	
	SELECT	a.tx_administracao,
		a.vl_informado,
		a.nr_seq_grupo_servico,
		a.nr_seq_grupo_material,
		a.nr_sequencia nr_seq_regra,
		null nr_seq_sca,
		coalesce(a.ie_repassa_medico, 'E') ie_repassa_medico,
		coalesce(dt_vigencia_inicio, dt_mesano_referencia_pc) dt_vigencia_inicio,
		coalesce(dt_vigencia_fim, dt_mesano_referencia_pc + 1) dt_vigencia_fim,
		ie_cobranca
	from	pls_regra_pos_estabelecido	a
	where	a.nr_seq_contrato	= nr_seq_contrato_pc
	
union all

	SELECT	a.tx_administracao,
		a.vl_informado,
		a.nr_seq_grupo_servico,
		a.nr_seq_grupo_material,
		a.nr_sequencia,
		null nr_seq_sca,
		coalesce(a.ie_repassa_medico, 'E') ie_repassa_medico,
		coalesce(dt_vigencia_inicio, dt_mesano_referencia_pc) dt_vigencia_inicio,
		coalesce(dt_vigencia_fim, dt_mesano_referencia_pc + 1) 	dt_vigencia_fim,
		ie_cobranca
	from	pls_regra_pos_estabelecido	a
	where	a.nr_seq_intercambio	= nr_seq_intercambio_pc
	
union all

	select	a.tx_administracao,
		a.vl_informado,
		a.nr_seq_grupo_servico,
		a.nr_seq_grupo_material,
		a.nr_sequencia,
		null nr_seq_sca,
		coalesce(a.ie_repassa_medico, 'E') ie_repassa_medico,
		coalesce(dt_vigencia_inicio, dt_mesano_referencia_pc) dt_vigencia_inicio,
		coalesce(dt_vigencia_fim, dt_mesano_referencia_pc + 1) dt_vigencia_fim,
		ie_cobranca
	from	pls_regra_pos_estabelecido	a
	where	a.nr_seq_plano	= nr_seq_plano_pc
	and	not exists (	select	1
				from	pls_regra_pos_estabelecido x
				where	x.nr_seq_contrato	= nr_seq_contrato_pc
				
union all

				select	1
				from	pls_regra_pos_estabelecido y
				where 	y.nr_seq_intercambio = nr_seq_intercambio_pc
			)
	
union all

	select	a.tx_administracao,
		a.vl_informado,
		a.nr_seq_grupo_servico,
		a.nr_seq_grupo_material,
		a.nr_sequencia,
		a.nr_seq_plano nr_seq_sca,
		coalesce(a.ie_repassa_medico, 'E') ie_repassa_medico,
		coalesce(dt_vigencia_inicio, dt_mesano_referencia_pc) dt_vigencia_inicio,
		coalesce(dt_vigencia_fim, dt_mesano_referencia_pc + 1) dt_vigencia_fim,
		ie_cobranca
	from	pls_regra_pos_estabelecido	a
	where	not exists (	select	1
			from	pls_regra_pos_estabelecido x
			where	x.nr_seq_contrato	= nr_seq_contrato_pc 
			
union all

			select	1
			from	pls_regra_pos_estabelecido y
			where 	y.nr_seq_intercambio = nr_seq_intercambio_pc
		)	
	and	exists (select	1
			from	pls_conta_pos_estabelecido	x
			where	x.nr_seq_conta 	= nr_seq_conta_pc
			and	x.nr_seq_sca 	= a.nr_seq_plano)
	
union all

	select	a.tx_administracao,
		a.vl_informado,
		a.nr_seq_grupo_servico,
		a.nr_seq_grupo_material,
		a.nr_sequencia,
		null nr_seq_sca,
		coalesce(a.ie_repassa_medico, 'E') ie_repassa_medico,
		coalesce(dt_vigencia_inicio, dt_mesano_referencia_pc) dt_vigencia_inicio,
		fim_dia(coalesce(dt_vigencia_fim, dt_mesano_referencia_pc + 1)) dt_vigencia_fim,
		ie_cobranca
	from	pls_regra_pos_estabelecido	a
	where	a.nr_seq_congenere	= nr_seq_congenere_pc
	and	not exists (	select	1
			from	pls_regra_pos_estabelecido x
			where	x.nr_seq_contrato	= nr_seq_contrato_pc 
			
union all

			select	1
			from	pls_regra_pos_estabelecido y
			where 	y.nr_seq_intercambio = nr_seq_intercambio_pc
			
union all

			select	1
			from	pls_regra_pos_estabelecido z
			where 	z.nr_seq_plano	 = nr_seq_plano_pc	
		);

C03 CURSOR(	nr_seq_conta_pc		pls_conta.nr_sequencia%type,
		nr_seq_sca_pc		pls_plano.nr_sequencia%type,
		ie_repassa_medico_pc	pls_regra_pos_estabelecido.ie_repassa_medico%type,
		nr_seq_lote_disc_pc	pls_lote_discussao.nr_sequencia%type) FOR
	SELECT	a.vl_beneficiario,
		a.nr_sequencia nr_seq_conta_pos_estab,
		a.cd_procedimento,
		a.ie_origem_proced
	from	pls_conta_pos_proc_v	a
	where	a.nr_seq_conta = nr_seq_conta_pc
	and (a.nr_seq_sca = nr_seq_sca_pc or coalesce(nr_seq_sca_pc::text, '') = '')
	and (a.nr_seq_lote_disc	= nr_seq_lote_disc_pc or coalesce(nr_seq_lote_disc_pc::text, '') = '')
	and	a.vl_beneficiario	> 0
	and (exists (SELECT	1
			from	pls_conta_proc x
			where	x.nr_sequencia = a.nr_seq_conta_proc
			and	x.ie_repassa_medico = ie_repassa_medico_pc) or ie_repassa_medico_pc = 'E')
	and	not exists (	select	1
				from	pls_conta_pos_proc_tx	z
				where	z.nr_seq_regra_pos_estab	= a.nr_sequencia);
				
C04 CURSOR(	nr_seq_conta_pc		pls_conta.nr_sequencia%type,
		nr_seq_sca_pc		pls_plano.nr_sequencia%type,
		ie_repassa_medico_pc	pls_regra_pos_estabelecido.ie_repassa_medico%type,
		nr_seq_lote_disc_pc	pls_lote_discussao.nr_sequencia%type) FOR
	SELECT	a.vl_beneficiario,
		a.nr_sequencia nr_seq_conta_pos_estab,
		a.nr_seq_material
	from	pls_conta_pos_mat_v	a
	where	a.nr_seq_conta = nr_seq_conta_pc
	and (a.nr_seq_sca = nr_seq_sca_pc or coalesce(nr_seq_sca_pc::text, '') = '')
	and (a.nr_seq_lote_disc	= nr_seq_lote_disc_pc or coalesce(nr_seq_lote_disc_pc::text, '') = '')
	and	ie_repassa_medico_pc = 'E'
	and	a.vl_beneficiario	> 0
	and	not exists (	SELECT	1
				from	pls_conta_pos_mat_tx	z
				where	z.nr_seq_regra_pos_estab	= a.nr_sequencia);
	
	
	
		
BEGIN
	--Se tiver passado par_metro de conta, significa que a chamada para processar regra de taxa adm de p_s 

	--ocorreu em momento que n_o a geracao do p_s, ent_o precisa alimentar as tabelas tempor_rias

	if (nr_seq_conta_p IS NOT NULL AND nr_seq_conta_p::text <> '') then
	
		--Nessa rotina ser_o gravados nas tabelas tempor_rias, os procedimentos selecionados para aplicabilidade da

		--geracao de p_s-estabelecido.

		CALL pls_pos_estabelecido_pck.carrega_procedimentos_geracao(null, null, null,
					      null,	nr_seq_conta_p,	null,
					      nm_usuario_p, cd_estabelecimento_p);
		
		--Nessa rotina ser_o gravados nas tabelas tempor_rias, os procedimentos selecionados para aplicabilidade da

		--geracao de p_s-estabelecido.

		CALL pls_pos_estabelecido_pck.carrega_materiais_geracao(	null, null, null,
						null, nr_seq_conta_p, null,
						nm_usuario_p, cd_estabelecimento_p);
	
	end if;

	for r_c01_w in C01 loop
		
		delete 	FROM pls_conta_pos_mat_tx a
		where 	a.nr_seq_conta_mat_pos in (	SELECT	b.nr_sequencia
							from	pls_conta_pos_mat b
							where	b.nr_seq_conta = r_c01_w.nr_seq_conta)
		and	not exists (select	1
					from	w_pls_lote_fat_mat	x
					where	x.nr_seq_pos_mat	= a.nr_seq_conta_mat_pos)			
		and	not exists (select	1
					from	pls_fatura_mat x
					where	x.nr_seq_pos_mat	= a.nr_seq_conta_mat_pos);
					
		delete 	FROM pls_conta_pos_proc_tx a
		where 	a.nr_seq_conta_pos_proc in (	SELECT	b.nr_sequencia
							from	pls_conta_pos_proc b
							where	b.nr_seq_conta = r_c01_w.nr_seq_conta)
		and	not exists (select	1
					from	w_pls_lote_fat_proc	x
					where	x.nr_seq_pos_proc	= a.nr_seq_conta_pos_proc)			
		and	not exists (select	1
					from	pls_fatura_proc x
					where	x.nr_seq_pos_proc	= a.nr_seq_conta_pos_proc);
		
	end loop;
	
	for r_c01_w in C01 loop
	
		ie_conta_valida_w := 'N';
		
		select	max(nr_seq_lote_disc)
		into STRICT	nr_seq_lote_disc_w
		from (
			SELECT 	nr_seq_lote_disc
			from	pls_conta_pos_proc
			where	nr_seq_conta = nr_seq_conta_p
			
union all

			SELECT 	nr_seq_lote_disc
			from	pls_conta_pos_mat
			where	nr_seq_conta = nr_seq_conta_p
		) alias1;
				
		for r_c02_w in C02(	r_c01_w.nr_seq_contrato, r_c01_w.nr_seq_intercambio, r_c01_w.dt_atendimento,
					r_c01_w.nr_seq_plano, r_c01_w.nr_seq_conta, r_c01_w.nr_seq_congenere_seg) loop
							
			if ( coalesce(r_c02_w.ie_cobranca::text, '') = '' or r_c02_w.ie_cobranca = 'A') then
			
				if	(r_c02_w.dt_vigencia_inicio < (r_c01_w.dt_atendimento + 1)) and (r_c02_w.dt_vigencia_fim > r_c01_w.dt_atendimento)then
				
				
					for r_c03_w in C03(	r_c01_w.nr_seq_conta, r_c02_w.nr_seq_sca,
								r_c02_w.ie_repassa_medico, nr_seq_lote_disc_w) loop
								
						vl_taxa_pos_w 		:= 0;
						qt_grupo_proc_mat_w 	:= 0;		
						
						if (r_c02_w.nr_seq_grupo_servico IS NOT NULL AND r_c02_w.nr_seq_grupo_servico::text <> '') or (r_c02_w.nr_seq_grupo_material IS NOT NULL AND r_c02_w.nr_seq_grupo_material::text <> '') then
							
							if (r_c03_w.cd_procedimento IS NOT NULL AND r_c03_w.cd_procedimento::text <> '') and (r_c02_w.nr_seq_grupo_servico IS NOT NULL AND r_c02_w.nr_seq_grupo_servico::text <> '') then
								select	count(1)
								into STRICT	qt_grupo_proc_mat_w
								from	pls_proc_grup_serv_v a
								where	a.nr_seq_grupo 		= r_c02_w.nr_seq_grupo_servico
								and	a.ie_origem_proced 	= r_c03_w.ie_origem_proced
								and	a.cd_procedimento 	= r_c03_w.cd_procedimento;
								
							else  							
								--Como estamos percorrendo registros de p_s relacionados a procedimentos, ent_o cestamente  n_o estar_ no grupo

								qt_grupo_proc_mat_w :=0;
							end if;	
							
							if ( qt_grupo_proc_mat_w > 0) then
								if (r_c02_w.vl_informado > 0) then
									vl_taxa_pos_w	:= r_c02_w.vl_informado;
									ie_tipo_taxa_w	:= '1';
								end if;

								if (r_c02_w.tx_administracao > 0) then
									vl_taxa_pos_w	:= (r_c03_w.vl_beneficiario * r_c02_w.tx_administracao) / 100;
									ie_tipo_taxa_w	:= '2';
								end if;
							end if;	
						else
							if (r_c02_w.vl_informado > 0) then
								vl_taxa_pos_w	:= r_c02_w.vl_informado;
								ie_tipo_taxa_w	:= '1';
							end if;

							if (r_c02_w.tx_administracao > 0) then
								vl_taxa_pos_w	:= (r_c03_w.vl_beneficiario * r_c02_w.tx_administracao) / 100;
								ie_tipo_taxa_w	:= '2';
							end if;
						end if;
						
						if (vl_taxa_pos_w > 0) then
						
							
							tb_proc_nr_seq_pos_estab_w(index_proc_w):= r_c03_w.nr_seq_conta_pos_estab;
							tb_proc_nr_seq_regra_w(index_proc_w)	:= r_c02_w.nr_seq_regra;
							tb_proc_vl_taxa_pos_w(index_proc_w) 	:= vl_taxa_pos_w;
							tb_proc_ie_tipo_taxa_w(index_proc_w)	:= ie_tipo_taxa_w;
							
							if (index_proc_w > pls_util_cta_pck.qt_registro_transacao_w) then
							
								SELECT * FROM pls_pos_estabelecido_pck.ins_registros_pos_taxa(tb_proc_nr_seq_pos_estab_w, tb_proc_nr_seq_regra_w, tb_proc_vl_taxa_pos_w, tb_proc_ie_tipo_taxa_w, 'P', nm_usuario_p) INTO STRICT _ora2pg_r;
 tb_proc_nr_seq_pos_estab_w := _ora2pg_r.tb_proc_nr_seq_pos_estab_p; tb_proc_nr_seq_regra_w := _ora2pg_r.tb_proc_nr_seq_regra_p; tb_proc_vl_taxa_pos_w := _ora2pg_r.tb_proc_vl_taxa_pos_p; tb_proc_ie_tipo_taxa_w := _ora2pg_r.tb_proc_ie_tipo_taxa_p;
								index_proc_w := 0;
							
							else
							
								index_proc_w := index_proc_w + 1;
							
							end if;
							
							ie_conta_valida_w := 'S';
						
						end if;
						
					end loop;
						
					--materiais

					for r_c04_w in C04(	r_c01_w.nr_seq_conta, r_c02_w.nr_seq_sca,
								r_c02_w.ie_repassa_medico, nr_seq_lote_disc_w) loop
								
						vl_taxa_pos_w 		:= 0;
						qt_grupo_proc_mat_w 	:= 0;		
						
						if (r_c02_w.nr_seq_grupo_servico IS NOT NULL AND r_c02_w.nr_seq_grupo_servico::text <> '') or (r_c02_w.nr_seq_grupo_material IS NOT NULL AND r_c02_w.nr_seq_grupo_material::text <> '') then
															
							if (r_c04_w.nr_seq_material IS NOT NULL AND r_c04_w.nr_seq_material::text <> '') and (r_c02_w.nr_seq_grupo_material IS NOT NULL AND r_c02_w.nr_seq_grupo_material::text <> '') then
								select	count(1)
								into STRICT	qt_grupo_proc_mat_w
								from	pls_preco_grupo_mat_v a
								where	a.nr_seq_grupo 		= r_c02_w.nr_seq_grupo_material
								and	a.nr_seq_material 	= r_c04_w.nr_seq_material;	
							
							else  							
								--Como estamos percorrendo registros de p_s relacionados a procedimentos, ent_o cestamente  n_o estar_ no grupo

								qt_grupo_proc_mat_w :=0;
							end if;	
							
							if ( qt_grupo_proc_mat_w > 0) then
								if (r_c02_w.vl_informado > 0) then
									vl_taxa_pos_w	:= r_c02_w.vl_informado;
									ie_tipo_taxa_w	:= '1';
								end if;

								if (r_c02_w.tx_administracao > 0) then
									vl_taxa_pos_w	:= ( r_c04_w.vl_beneficiario * r_c02_w.tx_administracao) / 100;
									ie_tipo_taxa_w	:= '2';
								end if;
							end if;	
						else
							if (r_c02_w.vl_informado > 0) then
								vl_taxa_pos_w	:= r_c02_w.vl_informado;
								ie_tipo_taxa_w	:= '1';
							end if;

							if (r_c02_w.tx_administracao > 0) then
								vl_taxa_pos_w	:= ( r_c04_w.vl_beneficiario * r_c02_w.tx_administracao) / 100;
								ie_tipo_taxa_w	:= '2';
							end if;
						end if;
						
						--Se vl_taxa for diferente de zero, ent_o localizou regra.

						if (vl_taxa_pos_w > 0) then
													
							tb_mat_nr_seq_pos_estab_w(index_mat_w)	:= r_c04_w.nr_seq_conta_pos_estab;
							tb_mat_nr_seq_regra_w(index_mat_w)	:= r_c02_w.nr_seq_regra;
							tb_mat_vl_taxa_pos_w(index_mat_w) 	:= vl_taxa_pos_w;
							tb_mat_ie_tipo_taxa_w(index_mat_w)	:= ie_tipo_taxa_w;
							
							if (index_mat_w > pls_util_cta_pck.qt_registro_transacao_w) then
							
								SELECT * FROM pls_pos_estabelecido_pck.ins_registros_pos_taxa(tb_mat_nr_seq_pos_estab_w, tb_mat_nr_seq_regra_w, tb_mat_vl_taxa_pos_w, tb_mat_ie_tipo_taxa_w, 'M', nm_usuario_p) INTO STRICT _ora2pg_r;
 tb_mat_nr_seq_pos_estab_w := _ora2pg_r.tb_proc_nr_seq_pos_estab_p; tb_mat_nr_seq_regra_w := _ora2pg_r.tb_proc_nr_seq_regra_p; tb_mat_vl_taxa_pos_w := _ora2pg_r.tb_proc_vl_taxa_pos_p; tb_mat_ie_tipo_taxa_w := _ora2pg_r.tb_proc_ie_tipo_taxa_p;
								index_mat_w := 0;
							
							else
							
								index_mat_w := index_mat_w + 1;
							
							end if;
							
							ie_conta_valida_w := 'S';
						
						end if;
						
					end loop;
					
				
				end if;
			
			end if;
			
		end loop;
	
		if ( ie_conta_valida_w = 'S') then
			
			tb_nr_seq_conta_pos_estab_w(ind_contas_w) := r_c01_w.nr_seq_conta;
			
		end if;
		
		ind_contas_w := ind_contas_w + 1;
	
	end loop;

	--Se sobrarem registros nas estruturas em mem_ria, persiste no banco

	SELECT * FROM pls_pos_estabelecido_pck.ins_registros_pos_taxa( tb_proc_nr_seq_pos_estab_w, tb_proc_nr_seq_regra_w, tb_proc_vl_taxa_pos_w, tb_proc_ie_tipo_taxa_w, 'P', nm_usuario_p) INTO STRICT _ora2pg_r;
  tb_proc_nr_seq_pos_estab_w := _ora2pg_r.tb_proc_nr_seq_pos_estab_p; tb_proc_nr_seq_regra_w := _ora2pg_r.tb_proc_nr_seq_regra_p; tb_proc_vl_taxa_pos_w := _ora2pg_r.tb_proc_vl_taxa_pos_p; tb_proc_ie_tipo_taxa_w := _ora2pg_r.tb_proc_ie_tipo_taxa_p;

	SELECT * FROM pls_pos_estabelecido_pck.ins_registros_pos_taxa(	tb_mat_nr_seq_pos_estab_w, tb_mat_nr_seq_regra_w, tb_mat_vl_taxa_pos_w, tb_mat_ie_tipo_taxa_w, 'M', nm_usuario_p) INTO STRICT _ora2pg_r;
 	tb_mat_nr_seq_pos_estab_w := _ora2pg_r.tb_proc_nr_seq_pos_estab_p; tb_mat_nr_seq_regra_w := _ora2pg_r.tb_proc_nr_seq_regra_p; tb_mat_vl_taxa_pos_w := _ora2pg_r.tb_proc_vl_taxa_pos_p; tb_mat_ie_tipo_taxa_w := _ora2pg_r.tb_proc_ie_tipo_taxa_p;

				
	--Gerar os dados de contabilidade da taxa administrativa de p_s-estabelecido

	if (tb_nr_seq_conta_pos_estab_w.count > 0) then
		
		--Geracao de valores cont_beis da taxa administrativa do p_s-estabelecido.

		CALL pls_pos_estabelecido_pck.gerar_contab_taxa_adm_pos( tb_nr_seq_conta_pos_estab_w, nm_usuario_p);
		
		--Geracao dos valores de faturamento da taxa administrativa do p_s-estabelecido.

		CALL pls_pos_estabelecido_pck.gerar_taxa_faturamento_adm_pos(tb_nr_seq_conta_pos_estab_w, nm_usuario_p);
		
	end if;

	CALL pls_pos_estabelecido_pck.limpa_reg_taxas_sem_tx_ctb( tb_nr_seq_conta_pos_estab_w, nm_usuario_p);
				
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_pos_estabelecido_pck.processa_taxa_adm_pos (nr_seq_conta_p pls_conta.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;