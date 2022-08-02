-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_aplicar_recalculo ( nr_seq_lote_p bigint, ie_apenas_fins_contabeis_p text, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


vl_item_w				double precision  := 0;
vl_dif_partic_w          		double precision;
vl_tot_partic_w          		double precision;
aux_w              			bigint;
qt_conta_w          			bigint;
ie_atualizou_data_lote_w    		boolean := false;
vl_lib_anterior_w        		pls_conta_proc.vl_liberado%type  := 0;
dt_mes_competencia_w      		pls_lote_recalculo.dt_mes_competencia%type;
nr_seq_regra_w          		pls_lote_recalculo.nr_seq_regra%type;
ie_tipo_regra_w          		pls_regra_lote_recalculo.ie_tipo_regra%type;
ie_recalcular_pos_w        		pls_lote_recalculo.ie_recalcular_pos%type;
ie_recalcular_copartic_w    		pls_lote_recalculo.ie_recalcular_copartic%type;
ie_recalculo_item_w       		pls_lote_recalculo.ie_recalcular_item%type;
nr_seq_prestador_pgto_w      		pls_criterio_recalculo.nr_seq_prestador_pag%type;
vl_calculado_w          		pls_conta_proc.vl_procedimento%type;
vl_liberado_w          			pls_conta_medica_resumo.vl_lib_original%type;
vl_calc_hi_util_w        		pls_conta_proc.vl_calc_hi_util%type;
vl_calc_co_util_w        		pls_conta_proc.vl_calc_co_util%type;
vl_calc_mat_util_w        		pls_conta_proc.vl_calc_mat_util%type;
vl_liberado_hi_w        		pls_conta_proc.vl_liberado_hi%type;
vl_liberado_co_w        		pls_conta_proc.vl_liberado_co%type;
vl_liberado_material_w      		pls_conta_proc.vl_liberado_material%type;
qt_apresentado_w        		pls_conta_proc.qt_procedimento_imp%type;
vl_pagamento_w          		pls_conta_medica_resumo.vl_lib_original%type;
vl_total_protocolo_w      		pls_conta.vl_total%type;
nr_seq_protocolo_anterior_w    	pls_protocolo_conta.nr_sequencia%type := -1; --Apenas para fazer um controle de loop
ie_tipo_protocolo_w    		pls_protocolo_conta.ie_tipo_protocolo%type;
tot_registros_w			integer;
vl_liberado_ant_res_w		pls_conta_medica_resumo.vl_liberado_ant%type;
vl_liberado_ant_dif_w		pls_conta_medica_resumo.vl_liberado_ant%type;
qt_contas_abertas_w		integer;
nr_iteracao_cursor_w		integer := 0;
qt_participante_w		integer;
nr_seq_resumo_pagto_w		pls_conta_medica_resumo.nr_sequencia%type;

C01 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.nr_seq_conta,
		a.cd_pessoa_fisica,
		a.nr_seq_prestador,
		a.nr_seq_protocolo,
		count(1) over () total_registros
	from    pls_conta_recalculo  a
	where    a.nr_seq_lote  = nr_seq_lote_p
	order by   nr_seq_protocolo;

C02 CURSOR(nr_seq_conta_recalculo_pc  pls_item_recalculo.nr_seq_conta%type) FOR
	SELECT 	a.nr_seq_procedimento,
		a.nr_seq_material,
		a.vl_item,
		a.nr_seq_regra_preco,
		a.nr_regra_recalculo,
		a.nr_seq_conta_resumo,
		a.nr_sequencia
	from   	pls_item_recalculo  a
	where  	a.nr_seq_conta    = nr_seq_conta_recalculo_pc;

C03 CURSOR(nr_seq_protocolo_pc pls_protocolo_conta.nr_sequencia%type) FOR
	SELECT 	nr_sequencia
	from   	pls_conta
	where  	nr_seq_protocolo = nr_seq_protocolo_pc;
BEGIN

select  dt_mes_competencia,
	nr_seq_regra,
	coalesce(ie_recalcular_pos,'N'),
	coalesce(ie_recalcular_copartic,'N'),
	coalesce(ie_recalcular_item,'N')
into STRICT    dt_mes_competencia_w,
	nr_seq_regra_w,
	ie_recalcular_pos_w,
	ie_recalcular_copartic_w,
	ie_recalculo_item_w
from    pls_lote_recalculo
where   nr_sequencia = nr_seq_lote_p;

select  max(ie_tipo_regra)
into STRICT  	ie_tipo_regra_w
from  	pls_regra_lote_recalculo
where  	nr_sequencia  = nr_seq_regra_w;

--Aplicação do Recurso prórpio será tratada na rotina pls_aplicar_rec_recurso_prop
if (ie_tipo_regra_w <> 1) then
	if (ie_tipo_regra_w  = 4) then
	  /* 4 - 	Recalculo das regras existentes
		Para esse tipo de regra, apenas é gerada as contas no Calculo do lote, e na aplicação do mesmo é gerada a nova valorização
		Isso porque a rotina que calcula os preços, já atualiza diretamente os valores na conta */
		CALL pls_gerar_recal_regra_preco(nr_seq_lote_p, nm_usuario_p, cd_estabelecimento_p);
	end if;

	for r_c01_w in C01() loop
		begin --*1
		qt_conta_w  := 0;
		nr_iteracao_cursor_w := nr_iteracao_cursor_w + 1;
		select	count(1)
		into STRICT  	aux_w
		from  	sip_nv_dados a
		where 	a.ie_conta_enviada_ans = 'S'
		and  	a.nr_seq_conta = r_c01_w.nr_seq_conta
		and  	exists (	SELECT  1
				from  	pls_lote_sip b
				where  	b.nr_sequencia = a.nr_seq_lote_sip
				and  	(b.dt_envio IS NOT NULL AND b.dt_envio::text <> ''));

		if (aux_w > 0) then
			update	pls_lote_recalculo
			set  	dt_aplicacao  	 = NULL,
				nm_usuario  	= nm_usuario_p,
				dt_atualizacao  = clock_timestamp()
			where   nr_sequencia  	= nr_seq_lote_p;

			CALL wheb_mensagem_pck.exibir_mensagem_abort(338028);
		end if;

		if (not ie_atualizou_data_lote_w) then
			update  pls_lote_recalculo
			set  	dt_aplicacao   	= clock_timestamp(),
				nm_usuario	= nm_usuario_p,
				dt_atualizacao  = clock_timestamp(),
				ie_somente_contabil = coalesce(ie_apenas_fins_contabeis_p,'N')
			where   nr_sequencia   	= nr_seq_lote_p;
			ie_atualizou_data_lote_w := true;
		end if;

		--Aplicar ajuste de recurso próprio apenas para fins contábeis(Aplicar ajuste de recurso próprio apenas para fins contábeis - OS 928106)
		if (ie_apenas_fins_contabeis_p = 'N') or (ie_tipo_regra_w = 4) then
			for r_c02_w in C02(r_c01_w.nr_sequencia) loop
				begin
				vl_lib_anterior_w := null;
				if (coalesce(r_c02_w.vl_item,0) > 0) then
					if (coalesce(r_c02_w.nr_seq_procedimento,0) > 0) then
						select  vl_liberado,
							vl_procedimento,
							qt_procedimento_imp
						into STRICT  	vl_lib_anterior_w,
							vl_calculado_w,
							qt_apresentado_w
						from  	pls_conta_proc
						where  	nr_sequencia  = r_c02_w.nr_seq_procedimento;

						if (ie_tipo_regra_w = 3)  then -- Tratamento para regra de preço fixo
							nr_seq_prestador_pgto_w := null;

							select  max(nr_seq_prestador_pag)
							into STRICT  	nr_seq_prestador_pgto_w
							from  	pls_criterio_recalculo
							where  	nr_sequencia  = r_c02_w.nr_regra_recalculo;

							if (nr_seq_prestador_pgto_w IS NOT NULL AND nr_seq_prestador_pgto_w::text <> '') then
								select  sum(vl_lib_original)
								into STRICT  	vl_liberado_w
								from  	pls_conta_medica_resumo
								where  	nr_seq_conta_proc  	= r_c02_w.nr_seq_procedimento
								and  	nr_seq_conta    	= r_c01_w.nr_seq_conta
								and  	nr_seq_prestador_pgto   != nr_seq_prestador_pgto_w
								and  	ie_tipo_item     	!= 'I'
								and  	vl_lib_original   	> 0
								and  	ie_situacao    		= 'A';

								if (coalesce(vl_liberado_w,0) = 0) then
								
									/*
										Para não ficar um decode muito dificil de ler, dividi o update em dois e setei o valor para o vl_pag_medico_conta
										apenas para tipo despesa =1, estava antes errôneamente setando valor para taxas e etc, impactando na definição de 
										prestador de pagamento ao aplicar recálculo.
									*/
									update  pls_conta_proc
									set vl_liberado      	= r_c02_w.vl_item,
										vl_prestador      	= r_c02_w.vl_item,
										vl_unitario      = dividir(r_c02_w.vl_item,qt_procedimento),
										vl_glosa = case when vl_procedimento_imp > r_c02_w.vl_item
												 then vl_procedimento_imp - r_c02_w.vl_item else 0 end
									where  nr_sequencia     = r_c02_w.nr_seq_procedimento;									
									
									update 	pls_conta_proc
									set		vl_pag_medico_conta    	= CASE WHEN coalesce(vl_pag_medico_conta,0)=0 THEN  0  ELSE r_c02_w.vl_item END
									where  	nr_sequencia     		= r_c02_w.nr_seq_procedimento
									and 	ie_tipo_despesa 		in ('1', '4');
								else
									vl_item_w := r_c02_w.vl_item + coalesce(vl_liberado_w,0);

									update	pls_conta_proc
									set  	vl_liberado	= vl_item_w,
											vl_prestador    = vl_item_w,
											vl_unitario     = dividir(vl_item_w,qt_procedimento),
											vl_glosa = case when vl_procedimento_imp > vl_item_w
												 then vl_procedimento_imp - vl_item_w else 0 end
									where  nr_sequencia     = r_c02_w.nr_seq_procedimento;

								end if;

							else
								update  pls_conta_proc
								set  	vl_liberado      	= r_c02_w.vl_item,
									vl_pag_medico_conta    	= 0,
									vl_total_partic      	= 0,
									vl_prestador     = r_c02_w.vl_item,
									vl_unitario      = dividir(r_c02_w.vl_item,qt_procedimento),
									vl_glosa = case when vl_procedimento_imp > r_c02_w.vl_item
												 then vl_procedimento_imp - r_c02_w.vl_item else 0 end
								where  nr_sequencia      = r_c02_w.nr_seq_procedimento;

								vl_item_w  := r_c02_w.vl_item;
							end if;

							if (nr_seq_prestador_pgto_w IS NOT NULL AND nr_seq_prestador_pgto_w::text <> '') then
								select	count(1),
									min(nr_seq_conta_proc_partic)
								into STRICT	qt_participante_w,
									nr_seq_resumo_pagto_w
								from 	pls_conta_medica_resumo
								where	(nr_seq_conta_proc_partic IS NOT NULL AND nr_seq_conta_proc_partic::text <> '')
								and	nr_seq_conta_proc 		= r_c02_w.nr_seq_procedimento
								and	nr_seq_conta			= r_c01_w.nr_seq_conta
								and  	nr_seq_prestador_pgto  		= nr_seq_prestador_pgto_w
								and	ie_situacao			= 'A';

								update  pls_proc_participante
								set  	vl_participante   = r_c02_w.vl_item
								where  	nr_seq_conta_proc = r_c02_w.nr_seq_procedimento
								and  	nr_seq_prestador_pgto  = nr_seq_prestador_pgto_w
								and (coalesce(ie_gerada_cta_honorario::text, '') = '' or ie_gerada_cta_honorario = 'N')
								and (coalesce(ie_status::text, '') = '' or ie_status <> 'C')
								and	nr_sequencia = nr_seq_resumo_pagto_w;
								
								update  pls_proc_participante
								set  	vl_participante   = 0
								where  	nr_seq_conta_proc = r_c02_w.nr_seq_procedimento
								and  	nr_seq_prestador_pgto  = nr_seq_prestador_pgto_w
								and (coalesce(ie_gerada_cta_honorario::text, '') = '' or ie_gerada_cta_honorario = 'N')
								and (coalesce(ie_status::text, '') = '' or ie_status <> 'C')
								and	nr_sequencia != nr_seq_resumo_pagto_w;
								
							else
								update  pls_proc_participante
								set  	vl_participante    = 0
								where  	nr_seq_conta_proc  = r_c02_w.nr_seq_procedimento
								and (	coalesce(ie_gerada_cta_honorario::text, '') = '' or ie_gerada_cta_honorario = 'N')
								and (	coalesce(ie_status::text, '') = '' or ie_status <> 'C');
							end if;

							insert into pls_conta_proc_hist( nr_sequencia, nr_seq_proc, nr_seq_lote,
								dt_atualizacao, nm_usuario, dt_atualizacao_nrec,
								nm_usuario_nrec, vl_liberado, vl_lib_anterior)
							values ( nextval('pls_conta_proc_hist_seq'), r_c02_w.nr_seq_procedimento, nr_seq_lote_p,
								clock_timestamp(), nm_usuario_p, clock_timestamp(),
								nm_usuario_p, vl_item_w, vl_lib_anterior_w);

							 CALL pls_atualiza_conta_resumo_item(r_c02_w.nr_seq_procedimento, 'P', nm_usuario_p,'N');

							select	count(1) tot_registros
							into STRICT	tot_registros_w
							from	pls_conta_medica_resumo	a
							where	a.nr_seq_conta		= r_c01_w.nr_seq_conta
							and	a.nr_seq_conta_proc	= r_c02_w.nr_seq_procedimento
							and	a.ie_tipo_item		!= 'I'
							and	a.ie_situacao 		= 'A';

							--Divide proporcionalmente o valor apresentado entre os registros  na pls_conta_medica_resumo de cada item da conta
							if (tot_registros_w > 1) then
								update	pls_conta_medica_resumo
								set	vl_liberado_ant	 	= vl_lib_anterior_w * (dividir_sem_round(vl_lib_original, vl_item_w))
								where	nr_seq_conta		= r_c01_w.nr_seq_conta
								and	nr_seq_conta_proc	= r_c02_w.nr_seq_procedimento
								and	ie_tipo_item		!= 'I'
								and	ie_situacao 		= 'A';

								select	sum(vl_liberado_ant)
								into STRICT	vl_liberado_ant_res_w
								from	pls_conta_medica_resumo
								where	nr_seq_conta		= r_c01_w.nr_seq_conta
								and	nr_seq_conta_proc	= r_c02_w.nr_seq_procedimento
								and	ie_tipo_item		!= 'I'
								and	ie_situacao 		= 'A';

								--Diferença entre a soma dos valores apresentados dos registros na pls_conta_medica_resumo do procedimento em questão, em relação ao valor apresentado para o procedimento.
								vl_liberado_ant_dif_w := vl_liberado_ant_res_w - vl_lib_anterior_w;

								--Na divisão do valor apresentado, pode ocorrer uma divergência de valor entre a soma dos registros e o total apresentado do item,

								--então aqui é feito um ajuste e o ajuste apenas ocorre em um único item cujo valor apresentado já seja maior que o valor de ajuste(evita ficar negativo, no caso de ajuste com valor negativo)
								if (vl_liberado_ant_dif_w <> 0) then
									update	pls_conta_medica_resumo
									set	vl_liberado_ant = vl_liberado_ant + vl_liberado_ant_dif_w
									where	nr_sequencia   =  (	SELECT	max(nr_sequencia)
													from 	pls_conta_medica_resumo
													where	nr_seq_conta		= r_c01_w.nr_seq_conta
													and	nr_seq_conta_proc	= r_c02_w.nr_seq_procedimento
													and	vl_liberado_ant		> vl_liberado_ant_dif_w
													and	ie_tipo_item		!= 'I'
													and	ie_situacao 		= 'A')
									and	nr_seq_conta	= r_c01_w.nr_seq_conta;
								end if;
							else
								update	pls_conta_medica_resumo
								set	vl_liberado_ant	 	= vl_lib_anterior_w
								where	nr_seq_conta		= r_c01_w.nr_seq_conta
								and	nr_seq_conta_proc	= r_c02_w.nr_seq_procedimento
								and	ie_tipo_item		!= 'I'
								and	ie_situacao 		= 'A';
							end if;
						else
							if (ie_tipo_regra_w <> 4) then

								vl_liberado_hi_w    := r_c02_w.vl_item * dividir_sem_round(vl_calc_hi_util_w,vl_calculado_w);
								vl_liberado_co_w    := r_c02_w.vl_item * dividir_sem_round(vl_calc_co_util_w,vl_calculado_w);
								vl_liberado_material_w    := r_c02_w.vl_item * dividir_sem_round(vl_calc_mat_util_w,vl_calculado_w);

								update  pls_conta_proc
								set  	vl_liberado		= r_c02_w.vl_item,
									vl_unitario     	= dividir(r_c02_w.vl_item,qt_procedimento),
									vl_pag_medico_conta    	= 0,
									vl_total_partic = 0,
									vl_prestador    = r_c02_w.vl_item,
									vl_liberado_hi  = vl_liberado_hi_w,
									vl_liberado_co  = vl_liberado_co_w,
									vl_liberado_material	= vl_liberado_material_w
								where  	nr_sequencia 	= r_c02_w.nr_seq_procedimento;

								update  pls_proc_participante
								set  	vl_participante = dividir((r_c02_w.vl_item * vl_calculado),vl_calculado_w),
									qt_liberada     = qt_apresentado_w,
									vl_glosa      	= 0,
									ie_status_pagamento    	= 'L',
									ie_status      		= 'L'
								where  nr_seq_conta_proc    	= r_c02_w.nr_seq_procedimento
								and  ((coalesce(ie_status::text, '') = '')     or (ie_status != 'C'))
								and  ((coalesce(ie_gerada_cta_honorario::text, '') = '') or (ie_gerada_cta_honorario <> 'S'));

								select   coalesce(sum(vl_participante),0)
								into STRICT  vl_tot_partic_w
								from  pls_proc_participante
								where  nr_seq_conta_proc    = r_c02_w.nr_seq_procedimento
								and  ((coalesce(ie_status::text, '') = '')    or (ie_status != 'C'))
								and  ((coalesce(ie_gerada_cta_honorario::text, '') = '') or (ie_gerada_cta_honorario <> 'S'));

								if (	vl_tot_partic_w > r_c02_w.vl_item ) then
									vl_dif_partic_w  := vl_tot_partic_w - r_c02_w.vl_item;

									update  pls_proc_participante  a
									set  	a.vl_participante  	= a.vl_participante - vl_dif_partic_w
									where  	a.nr_sequencia  	= (  SELECT  max(x.nr_sequencia)
									from  	pls_proc_participante  x
									where 	x.nr_seq_conta_proc    = r_c02_w.nr_seq_procedimento
									and  	((coalesce(x.ie_status::text, '') = '') or (x.ie_status != 'C'))
									and  	((coalesce(x.ie_gerada_cta_honorario::text, '') = '') or (x.ie_gerada_cta_honorario <> 'S'))
									and  	x.vl_participante >= vl_dif_partic_w);

								end if;

							end if;

							insert into pls_conta_proc_hist(nr_sequencia, nr_seq_proc, nr_seq_lote,
											dt_atualizacao, nm_usuario, dt_atualizacao_nrec,
											nm_usuario_nrec, vl_liberado, vl_lib_anterior)
										values ( nextval('pls_conta_proc_hist_seq'), r_c02_w.nr_seq_procedimento, nr_seq_lote_p,
											clock_timestamp(), nm_usuario_p, clock_timestamp(),
											nm_usuario_p, r_c02_w.vl_item, vl_lib_anterior_w);

							if ( 	ie_tipo_regra_w <> 4) or (ie_recalculo_item_w = 'S') then
								CALL pls_atualiza_conta_resumo_item(r_c02_w.nr_seq_procedimento, 'P', nm_usuario_p,'N');

								select	count(1) tot_registros
								into STRICT	tot_registros_w
								from	pls_conta_medica_resumo	a
								where	a.nr_seq_conta		= r_c01_w.nr_seq_conta
								and	a.nr_seq_conta_proc	= r_c02_w.nr_seq_procedimento
								and	a.ie_tipo_item		!= 'I'
								and	a.ie_situacao 		= 'A';

								--Divide proporcionalmente o valor apresentado entre os registros  na pls_conta_medica_resumo de cada item da conta
								if (tot_registros_w > 1) then
									update	pls_conta_medica_resumo
									set	vl_liberado_ant	 	= vl_lib_anterior_w * (dividir_sem_round(vl_lib_original, vl_item_w))
									where	nr_seq_conta		= r_c01_w.nr_seq_conta
									and	nr_seq_conta_proc	= r_c02_w.nr_seq_procedimento
									and	ie_tipo_item		!= 'I'
									and	ie_situacao 		= 'A';

									select	sum(vl_liberado_ant)
									into STRICT	vl_liberado_ant_res_w
									from	pls_conta_medica_resumo
									where	nr_seq_conta		= r_c01_w.nr_seq_conta
									and	nr_seq_conta_proc	= r_c02_w.nr_seq_procedimento
									and	ie_tipo_item		!= 'I'
									and	ie_situacao 		= 'A';

									--Diferença entre a soma dos valores apresentados dos registros na pls_conta_medica_resumo do procedimento em questão, em relação ao valor apresentado para o procedimento.
									vl_liberado_ant_dif_w := vl_liberado_ant_res_w - vl_lib_anterior_w;

									--Na divisão do valor apresentado, pode ocorrer uma divergência de valor entre a soma dos registros e o total apresentado do item,

									--então aqui é feito um ajuste e o ajuste apenas ocorre em um único item cujo valor apresentado já seja maior que o valor de ajuste(evita ficar negativo, no caso de ajuste com valor negativo)
									if (vl_liberado_ant_dif_w <> 0) then
										update	pls_conta_medica_resumo
										set	vl_liberado_ant = vl_liberado_ant + vl_liberado_ant_dif_w
										where	nr_sequencia   =  (	SELECT	max(nr_sequencia)
														from 	pls_conta_medica_resumo
														where	nr_seq_conta		= r_c01_w.nr_seq_conta
														and	nr_seq_conta_proc	= r_c02_w.nr_seq_procedimento
														and	vl_liberado_ant		> vl_liberado_ant_dif_w
														and	ie_tipo_item		!= 'I'
														and	ie_situacao 		= 'A')
										and	nr_seq_conta  	= r_c01_w.nr_seq_conta;
									end if;
								else
									update	pls_conta_medica_resumo
									set	vl_liberado_ant	 	= vl_lib_anterior_w
									where	nr_seq_conta		= r_c01_w.nr_seq_conta
									and	nr_seq_conta_proc	= r_c02_w.nr_seq_procedimento
									and	ie_tipo_item		!= 'I'
									and	ie_situacao 		= 'A';
								end if;

							end if;
						end if;
						elsif (coalesce(r_c02_w.nr_seq_material,0) > 0) then

							select 	vl_liberado
							into STRICT	vl_lib_anterior_w
							from	pls_conta_mat
							where 	nr_sequencia = r_c02_w.nr_seq_material;
																			
							if (ie_tipo_regra_w <> 4) then

								nr_seq_prestador_pgto_w := null;
								vl_item_w := r_c02_w.vl_item;
								if (ie_tipo_regra_w = 3) then
									begin
										select  nr_seq_prestador_pag
										into STRICT  nr_seq_prestador_pgto_w
										from  pls_criterio_recalculo
										where  nr_sequencia  = r_c02_w.nr_regra_recalculo;
									exception
									when others then
										nr_seq_prestador_pgto_w := null;
									end;

									if (nr_seq_prestador_pgto_w IS NOT NULL AND nr_seq_prestador_pgto_w::text <> '') then
										select  sum(vl_lib_original)
										into STRICT  vl_liberado_w
										from  pls_conta_medica_resumo
										where  nr_seq_conta_mat  	= r_c02_w.nr_seq_material
										and  nr_seq_conta    		= r_c01_w.nr_seq_conta
										and  nr_seq_prestador_pgto   	!= nr_seq_prestador_pgto_w
										and  ie_tipo_item     	!= 'I'
										and  vl_lib_original  	> 0
										and  ((ie_situacao    	!= 'I') or (coalesce(ie_situacao::text, '') = ''));
										vl_item_w := r_c02_w.vl_item + coalesce(vl_liberado_w,0);
									end if;

								end if;

								update	pls_conta_mat
								set  	vl_liberado      = vl_item_w,
									nr_seq_regra_recalculo      = NULL,
									nr_seq_regra_preco_recalc   = NULL,
									vl_unitario     = dividir(vl_item_w,qt_material)
								where  	nr_sequencia    = r_c02_w.nr_seq_material;

							end if;

							insert into pls_conta_mat_hist( nr_sequencia, nr_seq_material, nr_seq_lote,
								dt_atualizacao, nm_usuario, dt_atualizacao_nrec,
								nm_usuario_nrec, vl_liberado, vl_lib_anterior)
							values ( nextval('pls_conta_mat_hist_seq'), r_c02_w.nr_seq_material, nr_seq_lote_p,
								clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p, vl_item_w, vl_lib_anterior_w);

							if (ie_tipo_regra_w <> 4) or (ie_recalculo_item_w = 'S') then
								CALL pls_atualiza_conta_resumo_item(r_c02_w.nr_seq_material, 'M', nm_usuario_p,'N');

								update	pls_conta_medica_resumo
								set	vl_liberado_ant	 	= vl_lib_anterior_w
								where	nr_seq_conta		= r_c01_w.nr_seq_conta
								and	nr_seq_conta_mat	= r_c02_w.nr_seq_material
								and	ie_tipo_item		!= 'I'
								and	ie_situacao 		= 'A';

							end if;
						end if;

					
						
					end if;

					--Inicio OS 1126582
					if (r_c02_w.nr_seq_conta_resumo <> 0) then
						select 	count(1)
						into STRICT	aux_w
						from	pls_conta_medica_resumo
						where	nr_sequencia = r_c02_w.nr_seq_conta_resumo
						and	nr_seq_conta = r_c01_w.nr_seq_conta;

						if (aux_w = 0) then

							select 	max(nr_sequencia)
							into STRICT 	aux_w
							from (	SELECT 	nr_sequencia
								from 	pls_conta_medica_resumo
								where 	nr_seq_conta = r_c01_w.nr_seq_conta
								and 	nr_seq_conta_proc = r_c02_w.nr_seq_procedimento
								and 	ie_situacao = 'A'
								and 	ie_tipo_item != 'I'
								
union all

								SELECT 	nr_sequencia
								from 	pls_conta_medica_resumo
								where 	nr_seq_conta = r_c01_w.nr_seq_conta
								and 	nr_seq_conta_mat = r_c02_w.nr_seq_material
								and 	ie_situacao = 'A'
								and 	ie_tipo_item != 'I'
							) alias2;

							update 	pls_item_recalculo
							set 	nr_seq_conta_resumo = aux_w
							where 	nr_sequencia = r_c02_w.nr_sequencia;
						end if;
					end if;
					--Fim OS 1126582
				end;
			end loop;  -- fim loop pelo cursor C02
		end if;

		--Aplicar ajuste de recurso próprio apenas para fins contábeis(Aplicar ajuste de recurso próprio apenas para fins contábeis - OS 928106)
		if (ie_apenas_fins_contabeis_p = 'N') or (ie_tipo_regra_w = 4) then
			--Como o cursor 1 esta ordenado por protocolos, quando o protocolo atual for diferente do anterior, então pode atualizar os valores das contas e também

			--gerar os valores de protocolo e gerar resumo. Na primeira iteração do loop certamente o protocolo anterior será diferente do atual, por esse motivo

			--verifica ainda se o protocolo anterior é diferente do valor de inicialização. Verificado também se está na última iteração, pois nesse caso, mesmo o 

			--protocolo atual sendo igual ao anterior, é necessário processar a atualização do valor das contas para que as contas do último protocolo da ordenação 

			--não fiquem sem a atualização de valores.
			
			if  	(( r_c01_w.total_registros = nr_iteracao_cursor_w) or (nr_seq_protocolo_anterior_w <> r_c01_w.nr_seq_protocolo or nr_seq_protocolo_anterior_w <> -1)) then
				
					nr_seq_protocolo_anterior_w := r_c01_w.nr_seq_protocolo;
				
				for r_c03_w in C03(nr_seq_protocolo_anterior_w) loop
					begin
					CALL pls_cta_consistir_pck.gerar_resumo_conta(null, null, null, r_c03_w.nr_sequencia, nm_usuario_p, cd_estabelecimento_p);
					CALL pls_atualiza_valor_conta(r_c03_w.nr_sequencia, nm_usuario_p);
					
					--Atualiza evento de pagamento(Pagamento novo).					
					CALL pls_filtro_regra_event_cta_pck.gerencia_regra_filtro(	null, r_c03_w.nr_sequencia, cd_estabelecimento_p,
								nm_usuario_p);
								
					end;
				end loop;

				CALL pls_gerar_valores_protocolo(nr_seq_protocolo_anterior_w, nm_usuario_p);
				--Realiza a verificação se todas as contas do protocolo estão fechadas
				select  count(1)
				into STRICT  qt_conta_w
				from  pls_conta
				where  nr_seq_protocolo = nr_seq_protocolo_anterior_w
				and  ie_status  != 'F';

				if (qt_conta_w     = 0) and ((ie_tipo_regra_w   != 4) or (ie_recalculo_item_w   = 'S')) then
				      /*Tartamento para refazer o lote pagamento com os novos valores. Diego OPS - OS 236018*/

				      CALL pls_desfazer_resumo_conta_prot(nr_seq_protocolo_anterior_w, nm_usuario_p);
				      CALL pls_gerar_resumo_conta_prot(nr_seq_protocolo_anterior_w, nm_usuario_p, cd_estabelecimento_p);
				end if;

				select	count(1)
				into STRICT	qt_contas_abertas_w
				from	pls_conta
				where	nr_seq_protocolo = nr_seq_protocolo_anterior_w
				and	ie_status <> 'F';

				--Somente fará a consistência de valores caso todas as contas do protocolo estiverem fechadas, pois pode ter alguma conta

				--em análise com pendências(talvez nem esteja no lote de recálculo, mas esteja em um protocolo que tenha alguma conta no lote) e nesse caso,

				--Emitiria a mensagem desnecessariamente
				if (qt_contas_abertas_w = 0) then
					--Consiste valores liberados nas contas do protocolo com os valores da conta resumo
					select  sum(vl_total)
					into STRICT  	vl_total_protocolo_w
					from  	pls_conta
					where  	nr_seq_protocolo  = nr_seq_protocolo_anterior_w
					and  	(vl_total IS NOT NULL AND vl_total::text <> '');

					select	coalesce(sum(a.vl_lib_original),0)
					into STRICT   	vl_pagamento_w
					from   	pls_conta_medica_resumo  a
					where  	a.ie_tipo_item <> 'I' --retira itens de intercâmbio da contagem
					and	a.ie_situacao <> 'I'  --retira itens inativos da contagem
					and	a.nr_seq_conta in ( 	SELECT   b.nr_sequencia
									from  	pls_conta b
									where 	b.nr_seq_protocolo = nr_seq_protocolo_anterior_w);

					select	max(ie_tipo_protocolo)
					into STRICT	ie_tipo_protocolo_w
					from	pls_protocolo_conta
					where	nr_sequencia	= nr_seq_protocolo_anterior_w;

					--Verificar a questão do commit no cursor 1... se abortar o processo aqui, não poderá ter o commit, mas o cursor possivelmente retornará uma quantidade

					--muito grande de dados e não fazer o commit é complicado
					if (coalesce(vl_total_protocolo_w,0) <> coalesce(vl_pagamento_w,0)) and (ie_tipo_protocolo_w   = 'C') then
						CALL wheb_mensagem_pck.exibir_mensagem_abort(225847);--Não é possível liberar o protocolo para pagamento, pois existe divergência de valores
					end if;
				end if;

			end if;
			nr_seq_protocolo_anterior_w := r_c01_w.nr_seq_protocolo;
		end if;

		commit;
		end; -- *1
	end loop; --fim loop pelo cursor C01

	--Efetiva conclusão da aplicação do recálculo
	update  pls_lote_recalculo
	set  	dt_fim_recalculo   	= clock_timestamp(),
			nm_usuario	= nm_usuario_p,
			dt_atualizacao  = clock_timestamp()
	where   nr_sequencia   	= nr_seq_lote_p;
	commit;
	
else
	CALL pls_aplicar_rec_recurso_prop(nr_seq_lote_p, ie_apenas_fins_contabeis_p, nm_usuario_p, cd_estabelecimento_p);

end if;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_aplicar_recalculo ( nr_seq_lote_p bigint, ie_apenas_fins_contabeis_p text, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

