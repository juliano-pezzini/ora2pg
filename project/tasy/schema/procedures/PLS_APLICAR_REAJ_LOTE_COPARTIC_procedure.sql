-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_aplicar_reaj_lote_copartic ( nr_seq_lote_reaj_copart_p bigint, dt_aplicacao_p timestamp, ie_opcao_p text, ie_commit_p text, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_reajuste_w		pls_reajuste.nr_sequencia%type;
ie_tipo_reajuste_w		pls_reajuste.ie_tipo_reajuste%type;
ie_tipo_lote_w			pls_reajuste.ie_tipo_lote%type;
tx_deflator_w			pls_reajuste.tx_deflator%type;
nr_seq_co_partip_w		pls_regra_coparticipacao.nr_sequencia%type;
vl_maximo_w			pls_regra_coparticipacao.vl_maximo%type;
vl_coparticipacao_w		pls_regra_coparticipacao.vl_coparticipacao%type;
nr_seq_reaj_copartic_w		pls_reajuste_copartic.nr_sequencia%type;
ie_origem_coparticipacao_w	pls_reajuste_copartic.ie_origem_coparticipacao%type;
tx_reajuste_copartic_w		pls_reajuste_copartic.tx_reajuste%type;
tx_reajuste_copartic_max_w	pls_reajuste_copartic.tx_valor_maximo%type;
vl_copart_max_w			pls_regra_coparticipacao.vl_maximo%type;
nr_seq_regra_atual_ant_w	pls_regra_coparticipacao.nr_sequencia%type;
nr_seq_regra_coparticipacao_w	pls_regra_coparticipacao.nr_sequencia%type;
nr_seq_copartic_ant_w		pls_regra_copartic.nr_sequencia%type;
nr_seq_regra_copartic_w		pls_regra_copartic.nr_sequencia%type;
vl_maximo_copartic_w		pls_regra_copartic.vl_maximo_copartic%type;
nr_seq_regra_aprop_w		pls_regra_copartic_aprop.nr_sequencia%type;
vl_apropriacao_w		pls_regra_copartic_aprop.vl_apropriacao%type;
vl_apropriacao_reajustado_w	pls_regra_copartic_aprop.vl_apropriacao%type;
nr_seq_contrato_w		pls_contrato.nr_sequencia%type;
qt_dias_retorno_w		pls_regra_copartic_retorno.qt_dias_retorno%type;
dt_fim_vigencia_w		timestamp;
vl_fixo_reajustado_w		double precision;
vl_base_w			double precision;
ie_desfazer_reajuste_w		varchar(1)	:= 'N';
tx_deflator_copart_w		pls_reajuste.tx_deflator_copartic%type;
tx_deflator_copart_max_w	pls_reajuste.tx_deflator_copartic_max%type;
qt_regra_copart_exc_w		bigint;
dt_inicio_vigencia_w		pls_regra_copartic_exce.dt_inicio_vigencia%type;
dt_fim_vigencia_ww		pls_regra_copartic_exce.dt_fim_vigencia%type;
nr_seq_grupo_servico_w		pls_regra_copartic_exce.nr_seq_grupo_servico%type;
nr_seq_grupo_prestador_w	pls_regra_copartic_exce.nr_seq_grupo_prestador%type;
ie_tipo_guia_w			pls_regra_copartic_exce.ie_tipo_guia%type;
nr_seq_saida_int_w		pls_regra_copartic_exce.nr_seq_saida_int%type;
nr_seq_saida_int_princ_w	pls_regra_copartic_exce.nr_seq_saida_int_princ%type;
ie_tipo_protocolo_w		pls_regra_copartic_exce.ie_tipo_protocolo%type;
nr_seq_intercambio_w		pls_intercambio.nr_sequencia%type;
nr_seq_tipo_atendimento_w	pls_regra_copartic_exce.nr_seq_tipo_atendimento%type;
ie_tipo_atend_tiss_w 		pls_regra_copartic_exce.ie_tipo_atend_tiss%type;

C01 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.nr_seq_regra_atual,
		a.nr_seq_copartic_ant,
		a.ie_origem_coparticipacao,
		a.tx_reajuste,
		a.tx_valor_maximo
	from	pls_reajuste_copartic		a,
		pls_lote_reaj_copartic		b
	where	a.nr_seq_lote		= b.nr_sequencia
	and	b.nr_sequencia		= nr_seq_lote_reaj_copart_p;

C02 CURSOR FOR
	SELECT	nr_sequencia,
		vl_apropriacao
	from	pls_regra_copartic_aprop
	where	nr_seq_regra	= nr_seq_regra_copartic_w
	and	vl_apropriacao	> 0;
	
C03 CURSOR FOR
	SELECT	dt_inicio_vigencia,
		dt_fim_vigencia,
		nr_seq_grupo_servico,
		nr_seq_grupo_prestador,
		ie_tipo_guia,
		nr_seq_saida_int,
		nr_seq_saida_int_princ,
		ie_tipo_protocolo,
		nr_seq_tipo_atendimento,
		ie_tipo_atend_tiss		
	from	pls_regra_copartic_exce
	where	nr_seq_regra_copartic = nr_seq_co_partip_w;


BEGIN
if (ie_opcao_p = 'L') then /* Liberar reajuste */
	update	pls_lote_reaj_copartic
	set	dt_liberacao	= clock_timestamp()
	where	nr_sequencia	= nr_seq_lote_reaj_copart_p;
elsif (ie_opcao_p = 'A') then /* Aplicar reajuste */
	dt_fim_vigencia_w	:= fim_dia(dt_aplicacao_p - 1);
	
	select	nr_seq_contrato,
		nr_seq_reajuste,
		nr_seq_intercambio
	into STRICT	nr_seq_contrato_w,
		nr_seq_reajuste_w,
		nr_seq_intercambio_w
	from	pls_lote_reaj_copartic
	where	nr_sequencia	= nr_seq_lote_reaj_copart_p;
	
	select	ie_tipo_reajuste,
		coalesce(ie_tipo_lote,'A'),
		coalesce(tx_deflator,0),
		coalesce(tx_deflator_copartic,0),
		coalesce(tx_deflator_copartic_max,0)
	into STRICT	ie_tipo_reajuste_w,
		ie_tipo_lote_w,
		tx_deflator_w,
		tx_deflator_copart_w,
		tx_deflator_copart_max_w
	from	pls_reajuste
	where	nr_sequencia	= nr_seq_reajuste_w;
	
	if	((ie_tipo_reajuste_w = 'I' AND ie_tipo_lote_w	= 'D') or
		((ie_tipo_reajuste_w = 'C') and
		((coalesce(tx_deflator_w,0) <> 0) or (coalesce(tx_deflator_copart_w,0) <> 0) or (coalesce(tx_deflator_copart_max_w,0) <> 0)))) then
		ie_desfazer_reajuste_w	:= 'S';
	end if;

	open C01;
	loop
	fetch C01 into	
		nr_seq_reaj_copartic_w,
		nr_seq_co_partip_w,
		nr_seq_copartic_ant_w,
		ie_origem_coparticipacao_w,
		tx_reajuste_copartic_w,
		tx_reajuste_copartic_max_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		vl_base_w		:= 0;
		vl_fixo_reajustado_w	:= 0;
		vl_copart_max_w		:= 0;
		
		if (nr_seq_co_partip_w IS NOT NULL AND nr_seq_co_partip_w::text <> '') then
			select	vl_maximo,
				vl_coparticipacao
			into STRICT	vl_maximo_w,
				vl_coparticipacao_w
			from	pls_regra_coparticipacao
			where	nr_sequencia	= nr_seq_co_partip_w;
			
			if (ie_desfazer_reajuste_w = 'S') then
				if	((ie_tipo_reajuste_w = 'I') or (coalesce(tx_deflator_copart_w,0) = 0 and coalesce(tx_deflator_copart_max_w,0) = 0)) then
					select	max(b.nr_seq_regra_atual)
					into STRICT	nr_seq_regra_atual_ant_w
					from	pls_reajuste_copartic	b,
						pls_lote_reaj_copartic	a
					where	b.nr_seq_lote		= a.nr_sequencia
					and	a.nr_seq_contrato	= nr_seq_contrato_w
					and	nr_seq_regra_gerada	= nr_seq_co_partip_w;
					
					if (nr_seq_regra_atual_ant_w IS NOT NULL AND nr_seq_regra_atual_ant_w::text <> '') then
						select	vl_maximo,
							vl_coparticipacao
						into STRICT	vl_copart_max_w,
							vl_fixo_reajustado_w
						from	pls_regra_coparticipacao
						where	nr_sequencia	= nr_seq_regra_atual_ant_w;
					end if;
				else				
					vl_base_w		:= dividir_sem_round((vl_coparticipacao_w * tx_deflator_copart_w)::numeric,100);
					vl_fixo_reajustado_w	:= vl_coparticipacao_w + vl_base_w;
					vl_copart_max_w		:= vl_maximo_w + dividir_sem_round((vl_maximo_w * tx_deflator_copart_max_w)::numeric,100);	
				end if;		
			else
				vl_base_w		:= dividir_sem_round((vl_coparticipacao_w * tx_reajuste_copartic_w)::numeric,100);
				vl_fixo_reajustado_w	:= vl_coparticipacao_w + vl_base_w;
				vl_copart_max_w		:= vl_maximo_w + dividir_sem_round((vl_maximo_w * tx_reajuste_copartic_max_w)::numeric,100);
			end if;

			select	nextval('pls_regra_coparticipacao_seq')
			into STRICT	nr_seq_regra_coparticipacao_w
			;
			
			insert into pls_regra_coparticipacao(nr_sequencia, dt_atualizacao, nm_usuario,
				dt_atualizacao_nrec, nm_usuario_nrec, dt_inicio_vigencia,
				ie_tipo_atendimento, dt_contrato_de, dt_contrato_ate,
				qt_eventos_minimo, ie_situacao, nr_seq_tipo_coparticipacao,
				tx_coparticipacao, vl_maximo, vl_coparticipacao,
				nr_seq_contrato, nr_seq_lote_reajuste, qt_ocorrencias,
				ie_tipo_ocorrencia, ie_tipo_data_consistencia, ie_reajuste,
				qt_meses_intervalo, nr_seq_plano, nr_seq_prestador,
				nr_seq_tipo_prestador, qt_idade_min, qt_idade_max,
				ie_titularidade, ie_tipo_parentesco, qt_diaria_inicial,
				qt_diaria_final, qt_ocorrencia_grupo_serv, qt_periodo_ocor,
				ie_tipo_periodo_ocor, nr_seq_grupo_serv, ie_incidencia_valor_maximo,
				ie_periodo_valor_maximo, ie_forma_cobr_internacao, ie_ano_calendario_outras_ocor,
				ie_considera_outra_ocor_regra, ie_incidencia_valor_fixo, ie_tipo_incidencia,
				ie_incidencia_proc_mat, dt_fim_vigencia, cd_procedimento,
				cd_sistema_anterior, ie_incide_vl_fixo_cta, ie_origem_proced,
				ie_prestador_cooperado, nr_seq_intercambio, vl_base_min,
				vl_base_max, ie_incidencia_psiquiatria)
			(SELECT	nr_seq_regra_coparticipacao_w, clock_timestamp(), nm_usuario_p,
				clock_timestamp(), nm_usuario_p, dt_aplicacao_p,
				ie_tipo_atendimento, dt_contrato_de, dt_contrato_ate,
				qt_eventos_minimo, ie_situacao, nr_seq_tipo_coparticipacao,
				tx_coparticipacao, vl_copart_max_w, vl_fixo_reajustado_w,
				nr_seq_contrato_w, nr_seq_lote_reaj_copart_p, qt_ocorrencias,
				ie_tipo_ocorrencia, ie_tipo_data_consistencia, ie_reajuste,
				qt_meses_intervalo, nr_seq_plano, nr_seq_prestador,
				nr_seq_tipo_prestador, qt_idade_min, qt_idade_max,
				ie_titularidade, ie_tipo_parentesco, qt_diaria_inicial,
				qt_diaria_final, qt_ocorrencia_grupo_serv, qt_periodo_ocor,
				ie_tipo_periodo_ocor, nr_seq_grupo_serv, ie_incidencia_valor_maximo,
				ie_periodo_valor_maximo, ie_forma_cobr_internacao, ie_ano_calendario_outras_ocor,
				ie_considera_outra_ocor_regra, ie_incidencia_valor_fixo, coalesce(ie_tipo_incidencia,'B'),
				ie_incidencia_proc_mat, dt_fim_vigencia, cd_procedimento,
				cd_sistema_anterior, ie_incide_vl_fixo_cta, ie_origem_proced,
				ie_prestador_cooperado, nr_seq_intercambio_w, vl_base_min,
				vl_base_max, ie_incidencia_psiquiatria
			from	pls_regra_coparticipacao
			where	nr_sequencia	= nr_seq_co_partip_w);

			select	count(1)
			into STRICT	qt_regra_copart_exc_w
			from	pls_regra_copartic_exce
			where	nr_seq_regra_copartic = nr_seq_co_partip_w;
			
			if (qt_regra_copart_exc_w > 0) then
				open C03;
				loop
				fetch C03 into	
					dt_inicio_vigencia_w,
					dt_fim_vigencia_ww,
					nr_seq_grupo_servico_w,
					nr_seq_grupo_prestador_w,
					ie_tipo_guia_w,
					nr_seq_saida_int_w,
					nr_seq_saida_int_princ_w,
					ie_tipo_protocolo_w,
					nr_seq_tipo_atendimento_w,
					ie_tipo_atend_tiss_w;
				EXIT WHEN NOT FOUND; /* apply on C03 */
					begin
					
					insert into pls_regra_copartic_exce(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
							nr_seq_regra_copartic,dt_inicio_vigencia,dt_fim_vigencia,nr_seq_grupo_servico,nr_seq_grupo_prestador,
							ie_tipo_guia,nr_seq_saida_int,nr_seq_saida_int_princ,ie_tipo_protocolo,nr_seq_tipo_atendimento,ie_tipo_atend_tiss)
					values (	nextval('pls_regra_copartic_exce_seq'),clock_timestamp(),nm_usuario_p,clock_timestamp(),nm_usuario_p,
							nr_seq_regra_coparticipacao_w,dt_inicio_vigencia_w,dt_fim_vigencia_ww,nr_seq_grupo_servico_w,nr_seq_grupo_prestador_w,
							ie_tipo_guia_w,nr_seq_saida_int_w,nr_seq_saida_int_princ_w,ie_tipo_protocolo_w,nr_seq_tipo_atendimento_w,ie_tipo_atend_tiss_w);

					end;
				end loop;
				close C03;
			end if;
			
			if (ie_origem_coparticipacao_w = 'C') then /* Se for regra do produto, nao pode inativar a regra */
				update	pls_regra_coparticipacao
				set	dt_fim_vigencia	= dt_fim_vigencia_w
				where	nr_sequencia	= nr_seq_co_partip_w;
			end if;
			
			qt_dias_retorno_w	:= null;
			
			select	max(qt_dias_retorno)
			into STRICT	qt_dias_retorno_w
			from	pls_regra_copartic_retorno
			where	nr_seq_regra_copartic	= nr_seq_co_partip_w;
			
			if (qt_dias_retorno_w IS NOT NULL AND qt_dias_retorno_w::text <> '') then
				insert into pls_regra_copartic_retorno(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec,
						nr_seq_regra_copartic,qt_dias_retorno)
				values (	nextval('pls_regra_copartic_retorno_seq'),clock_timestamp(),nm_usuario_p,clock_timestamp(),nm_usuario_p,
						nr_seq_regra_coparticipacao_w,qt_dias_retorno_w);
			end if;
			
			update	pls_reajuste_copartic
			set	nr_seq_regra_gerada	= nr_seq_regra_coparticipacao_w
			where	nr_sequencia		= nr_seq_reaj_copartic_w;
		elsif (nr_seq_copartic_ant_w IS NOT NULL AND nr_seq_copartic_ant_w::text <> '') then
			select	vl_maximo_copartic
			into STRICT	vl_maximo_copartic_w
			from	pls_regra_copartic
			where	nr_sequencia	= nr_seq_copartic_ant_w;
			
			if (ie_desfazer_reajuste_w = 'S') then
				vl_copart_max_w		:= vl_maximo_copartic_w + dividir_sem_round((vl_maximo_copartic_w * tx_deflator_copart_max_w)::numeric,100);
			else
				vl_copart_max_w		:= vl_maximo_copartic_w + dividir_sem_round((vl_maximo_copartic_w * tx_reajuste_copartic_max_w)::numeric,100);
			end if;
			
			select	nextval('pls_regra_copartic_seq')
			into STRICT	nr_seq_regra_copartic_w
			;
			
			insert	into	pls_regra_copartic(	nr_sequencia,
					nr_seq_tipo_coparticipacao,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					nr_seq_contrato,
					dt_inicio_vigencia,
					ie_tipo_atendimento,
					vl_maximo_copartic,
					ie_beneficiario,
					ie_prestador,
					ie_conta_medica,
					ie_utilizacao,
					ie_guia,
					ie_internacao,
					nr_seq_lote_reaj_copartic,
					dt_liberacao,
					nm_usuario_liberacao,
					ie_forma_cobr_internacao,
					nr_ordem_prioridade,
					dt_fim_vigencia)
				(SELECT	nr_seq_regra_copartic_w,
					nr_seq_tipo_coparticipacao,
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					nr_seq_contrato_w,
					dt_aplicacao_p,
					ie_tipo_atendimento,
					vl_copart_max_w,
					ie_beneficiario,
					ie_prestador,
					ie_conta_medica,
					ie_utilizacao,
					ie_guia,
					ie_internacao,
					nr_seq_lote_reaj_copart_p,
					clock_timestamp(),
					nm_usuario_p,
					coalesce(ie_forma_cobr_internacao,'I'),
					nr_ordem_prioridade,
					dt_fim_vigencia
				from	pls_regra_copartic
				where	nr_sequencia	= nr_seq_copartic_ant_w);
			
			CALL pls_copiar_itens_regra_copart(nr_seq_copartic_ant_w, nr_seq_regra_copartic_w, nm_usuario_p, 'N');
			
			open C02;
			loop
			fetch C02 into	
				nr_seq_regra_aprop_w,
				vl_apropriacao_w;
			EXIT WHEN NOT FOUND; /* apply on C02 */
				begin
					
				if (ie_desfazer_reajuste_w = 'S') then
					vl_apropriacao_reajustado_w	:= vl_apropriacao_w + dividir_sem_round((vl_apropriacao_w * tx_deflator_copart_max_w)::numeric,100);
				else
					vl_apropriacao_reajustado_w	:= vl_apropriacao_w + dividir_sem_round((vl_apropriacao_w * tx_reajuste_copartic_w)::numeric,100);
				end if;
				
				update	pls_regra_copartic_aprop
				set	vl_apropriacao	= vl_apropriacao_reajustado_w
				where	nr_sequencia	= nr_seq_regra_aprop_w;
				end;
			end loop;
			close C02;
			
			if (ie_origem_coparticipacao_w = 'C') then /* Se for regra do produto, nao pode inativar a regra */
				update	pls_regra_copartic
				set	dt_fim_vigencia	= dt_fim_vigencia_w,
					nr_seq_regra_reajustada	= nr_seq_regra_copartic_w
				where	nr_sequencia	= nr_seq_copartic_ant_w;
			end if;
			
			update	pls_reajuste_copartic
			set	nr_seq_copartic_reajustada	= nr_seq_regra_copartic_w
			where	nr_sequencia			= nr_seq_reaj_copartic_w;
		end if;
		end;
	end loop;
	close C01;
	
	update	pls_lote_reaj_copartic
	set	dt_aplicacao	= dt_aplicacao_p
	where	nr_sequencia	= nr_seq_lote_reaj_copart_p;
end if;

if (ie_commit_p = 'S') then
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_aplicar_reaj_lote_copartic ( nr_seq_lote_reaj_copart_p bigint, dt_aplicacao_p timestamp, ie_opcao_p text, ie_commit_p text, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
