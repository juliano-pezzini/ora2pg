-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_lote_exame (nr_seq_lote_p bigint, ie_acao_p bigint, ie_status_ini_p bigint, ie_data_lote_p text, ie_gerar_sub_grupos_p text, ie_gerar_data_emissao_p text, ie_status_final_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


nr_seq_grupo_w					bigint;
nr_seq_exame_w					bigint;
nr_seq_exame_not_w				bigint;
nr_seq_grupo_imp_w				bigint;
ie_tipo_atendimento_w			smallint;
dt_inicial_w					timestamp;
dt_final_w						timestamp;
dt_geracao_w					timestamp;
cd_setor_prescr_w				integer;
cd_setor_w						integer;
nr_seq_material_w				bigint;
nr_seq_sub_grupos_w				varchar(255);
ie_lote_w						varchar(1);
cd_setor_entrega_w				integer;
cd_estab_regra_w				integer;
nr_seq_forma_laudo_w			bigint;
nr_prescricao_w					bigint;
nr_sequencia_w					bigint;
ie_gerar_lote_w					varchar(1);
ie_status_urgente_lote_w		varchar(1);
dt_impressao_w					timestamp;
qt_exame_status_w				bigint;
qt_exame_tot_w					bigint;
ie_gerar_impressos_w			varchar(1);
ie_gerar_exame_status_w			varchar(1);
qt_exames_nao_aprov_w			bigint;
ie_gerar_exames_prescr_aprov_w	varchar(1);
nr_seq_lab_lote_regra_w			bigint;
ie_gera_exame_externo_w			varchar(1);
ie_gerar_exame_regra_aprov_w	varchar(1);
nr_prescricao_exp_w				bigint;
nr_seq_prescr_exp_w				bigint;
qt_itens_lote_w					bigint := 0;
ds_consist_w					varchar(255) :=' ';
ie_status_resultado_w			bigint;
ie_inseriu_lote_w				varchar(1);

c01 CURSOR FOR
	SELECT	a.nr_prescricao,
			a.nr_sequencia
	from	material_exame_lab e,
			exame_laboratorio b,
			prescr_medica c,
			atendimento_paciente d,
			prescr_procedimento a
	where	c.nr_atendimento = d.nr_atendimento
	and		a.nr_prescricao = c.nr_prescricao
	and 	a.nr_seq_exame = b.nr_seq_exame
	and 	a.cd_material_exame = e.cd_material_exame
	and 	(((ie_lote_w = 'N') and (a.ie_status_atend between coalesce(ie_status_ini_p,0) and coalesce(ie_status_final_p,30))) or (ie_lote_w = 'I' and a.ie_status_atend = ie_status_ini_p) or
			(( or ) AND ie_gerar_exame_regra_aprov_w = 'S'))
	and		(((coalesce(a.dt_emissao_setor_atend::text, '') = '') or (ie_lote_w = 'I')) or (ie_gerar_data_emissao_p = 'N'))
	and 	CASE WHEN nr_seq_exame_w=0 THEN  a.nr_seq_exame  ELSE nr_seq_exame_w END  = a.nr_seq_exame
	and 	((nr_seq_exame_not_w <> a.nr_seq_exame) or (coalesce(nr_seq_exame_not_w::text, '') = ''))
	and (lab_obter_regra_estab(cd_estabelecimento_p,c.cd_estabelecimento) = 'S')
	and 	CASE WHEN ie_data_lote_p='P' THEN c.dt_prescricao WHEN ie_data_lote_p='A' THEN ( SELECT	max(h.dt_aprovacao)															from	exame_lab_resultado g,																	exame_lab_result_item h															where	g.nr_seq_resultado = h.nr_seq_resultado															and		a.nr_prescricao = g.nr_prescricao															and		a.nr_sequencia = h.nr_seq_prescr															and 	(h.nr_seq_material IS NOT NULL AND h.nr_seq_material::text <> ''))  ELSE a.dt_prev_execucao END  between dt_inicial_w and dt_final_w
	and		((CASE WHEN nr_seq_grupo_w=0 THEN  b.nr_seq_grupo  ELSE nr_seq_grupo_w END  = b.nr_seq_grupo) or
			((ie_gerar_sub_grupos_p = 'S') and (b.nr_seq_grupo in ( select	nr_sequencia
																	from	grupo_exame_lab
																	where	nr_seq_superior = nr_seq_grupo_w))))
	and		CASE WHEN nr_seq_grupo_imp_w=0 THEN  coalesce(nr_seq_grupo_lote,coalesce((   SELECT	MAX(nr_seq_grupo_imp)																		FROM	exame_lab_grupo_imp x																		WHERE	nr_seq_exame = b.nr_seq_exame																		AND		coalesce(cd_estabelecimento, coalesce(c.cd_estabelecimento, 0)) = coalesce(c.cd_estabelecimento, 0)																		and		coalesce(x.cd_convenio, coalesce(obter_convenio_atendimento(c.nr_atendimento), 0)) = coalesce(obter_convenio_atendimento(c.nr_atendimento), 0)                                                                 ),b.nr_seq_grupo_imp))  ELSE nr_seq_grupo_imp_w END  = coalesce(nr_seq_grupo_lote,coalesce((  SELECT	coalesce(MAX(nr_seq_grupo_imp),null)
																																			FROM	exame_lab_grupo_imp x
																																			WHERE	nr_seq_exame = b.nr_seq_exame
																																			AND		coalesce(cd_estabelecimento, coalesce(c.cd_estabelecimento, 0)) = coalesce(c.cd_estabelecimento, 0)
																																			and		coalesce(x.cd_convenio, coalesce(obter_convenio_atendimento(c.nr_atendimento), 0)) = coalesce(obter_convenio_atendimento(c.nr_atendimento), 0)),b.nr_seq_grupo_imp))
	and		CASE WHEN ie_tipo_atendimento_w=0 THEN  d.ie_tipo_atendimento  ELSE ie_tipo_atendimento_w END  = d.ie_tipo_atendimento
	and		coalesce(a.ie_suspenso,'N')	= 'N'
	and		((a.cd_motivo_baixa = 0) or (ie_lote_w = 'I'))
	and		CASE WHEN cd_setor_w=0 THEN  a.cd_setor_atendimento  ELSE cd_setor_w END  = a.cd_setor_atendimento
	and		obter_se_setor_lab_lote_regra(nr_seq_lab_lote_regra_w, a.cd_setor_atendimento) = 'N'
	and		CASE WHEN nr_seq_material_w=0 THEN  e.nr_sequencia  ELSE nr_seq_material_w END  = e.nr_sequencia
	and		CASE WHEN cd_setor_prescr_w=0 THEN  c.cd_setor_atendimento  ELSE cd_setor_prescr_w END  = c.cd_setor_atendimento
	and		CASE WHEN cd_setor_entrega_w=0 THEN  coalesce(c.cd_setor_entrega,0)  ELSE cd_setor_entrega_w END  = coalesce(c.cd_setor_entrega,0)
	and		CASE WHEN cd_estab_regra_w=0 THEN c.cd_estabelecimento  ELSE cd_estab_regra_w END  = c.cd_estabelecimento
	and		((CASE WHEN nr_seq_forma_laudo_w=0 THEN c.nr_seq_forma_laudo  ELSE nr_seq_forma_laudo_w END  = c.nr_seq_forma_laudo) or (coalesce(c.nr_seq_forma_laudo::text, '') = ''))
	and		((ie_status_urgente_lote_w = 'N' AND a.ie_urgencia = 'N') or (ie_status_urgente_lote_w = 'S' AND a.ie_urgencia = 'S') or (ie_status_urgente_lote_w = 'A'))
	and		not exists (select	1
						from	lab_lote_exame_item x
						where	x.nr_prescricao = a.nr_prescricao
						and		x.nr_seq_prescr =a.nr_sequencia)
	and		((ie_gera_exame_externo_w = 'S') or ((ie_gera_exame_externo_w = 'N') and (coalesce(a.nr_seq_lote_externo::text, '') = '')));

c02 CURSOR FOR
	SELECT	a.nr_prescricao,
			a.nr_sequencia
	from	material_exame_lab e,
			exame_laboratorio b,
			prescr_medica c,
			atendimento_paciente d,
			prescr_procedimento a
	where	c.nr_atendimento	= d.nr_atendimento
	and		a.nr_prescricao = c.nr_prescricao
	and		a.nr_seq_exame	= b.nr_seq_exame
	and		a.cd_material_exame = e.cd_material_exame
	and		(((coalesce(a.dt_emissao_setor_atend::text, '') = '') or (ie_lote_w = 'I')) or (ie_gerar_data_emissao_p = 'N'))
	and		CASE WHEN nr_seq_exame_w=0 THEN  a.nr_seq_exame  ELSE nr_seq_exame_w END  = a.nr_seq_exame
	and		((nr_seq_exame_not_w <> a.nr_seq_exame) or (coalesce(nr_seq_exame_not_w::text, '') = ''))
	and (lab_obter_regra_estab(cd_estabelecimento_p,c.cd_estabelecimento) = 'S')
	and		((CASE WHEN nr_seq_grupo_w=0 THEN  b.nr_seq_grupo  ELSE nr_seq_grupo_w END  = b.nr_seq_grupo) or
			((ie_gerar_sub_grupos_p = 'S') and (b.nr_seq_grupo in ( SELECT	nr_sequencia
																	from	grupo_exame_lab
																	where	nr_seq_superior = nr_seq_grupo_w))))
	and		CASE WHEN nr_seq_grupo_imp_w=0 THEN  coalesce(nr_seq_grupo_lote,coalesce((	SELECT	MAX(nr_seq_grupo_imp)																		FROM	exame_lab_grupo_imp x																		WHERE	nr_seq_exame = b.nr_seq_exame																		AND		coalesce(cd_estabelecimento, coalesce(c.cd_estabelecimento, 0)) = coalesce(c.cd_estabelecimento, 0)																		and 	coalesce(x.cd_convenio, coalesce(obter_convenio_atendimento(c.nr_atendimento), 0)) = coalesce(obter_convenio_atendimento(c.nr_atendimento), 0)																	),b.nr_seq_grupo_imp))  ELSE nr_seq_grupo_imp_w END  = coalesce(nr_seq_grupo_lote,coalesce((	SELECT	coalesce(MAX(nr_seq_grupo_imp),null)
																																				FROM	exame_lab_grupo_imp x
																																				WHERE	nr_seq_exame = b.nr_seq_exame
																																				AND		coalesce(cd_estabelecimento, coalesce(c.cd_estabelecimento, 0)) = coalesce(c.cd_estabelecimento, 0)
																																				and		coalesce(x.cd_convenio, coalesce(obter_convenio_atendimento(c.nr_atendimento), 0)) = coalesce(obter_convenio_atendimento(c.nr_atendimento), 0)),
																																		b.nr_seq_grupo_imp))
	and		CASE WHEN ie_tipo_atendimento_w=0 THEN  d.ie_tipo_atendimento  ELSE ie_tipo_atendimento_w END  = d.ie_tipo_atendimento
	and		CASE WHEN cd_setor_w=0 THEN  a.cd_setor_atendimento  ELSE cd_setor_w END  = a.cd_setor_atendimento
	and		obter_se_setor_lab_lote_regra(nr_seq_lab_lote_regra_w, a.cd_setor_atendimento) = 'N'
	and		CASE WHEN nr_seq_material_w=0 THEN  e.nr_sequencia  ELSE nr_seq_material_w END  = e.nr_sequencia
	and		CASE WHEN cd_setor_prescr_w=0 THEN  c.cd_setor_atendimento  ELSE cd_setor_prescr_w END  = c.cd_setor_atendimento
	and		CASE WHEN cd_setor_entrega_w=0 THEN  coalesce(c.cd_setor_entrega,0)  ELSE cd_setor_entrega_w END  = coalesce(c.cd_setor_entrega,0)
	and		CASE WHEN cd_estab_regra_w=0 THEN c.cd_estabelecimento  ELSE cd_estab_regra_w END  = c.cd_estabelecimento
	and		((CASE WHEN nr_seq_forma_laudo_w=0 THEN c.nr_seq_forma_laudo  ELSE nr_seq_forma_laudo_w END  = c.nr_seq_forma_laudo) or (coalesce(c.nr_seq_forma_laudo::text, '') = ''))
	and		((ie_status_urgente_lote_w = 'N' AND a.ie_urgencia = 'N') or (ie_status_urgente_lote_w = 'S' AND a.ie_urgencia = 'S') or (ie_status_urgente_lote_w = 'A'))
	and		not exists (select	1
						from	lab_lote_exame_item x
						where	x.nr_prescricao = a.nr_prescricao
						and		x.nr_seq_prescr =a.nr_sequencia)
	and		a.nr_sequencia	= nr_seq_prescr_exp_w
	and		a.nr_prescricao = nr_prescricao_exp_w
	and		((ie_gera_exame_externo_w = 'S') or ((ie_gera_exame_externo_w = 'N') and (coalesce(a.nr_seq_lote_externo::text, '') = '')));

C03 CURSOR FOR
	SELECT	a.nr_prescricao,
			a.nr_sequencia
	from	prescr_procedimento a
	where	(a.nr_seq_exame IS NOT NULL AND a.nr_seq_exame::text <> '')
	and		(a.cd_material_exame IS NOT NULL AND a.cd_material_exame::text <> '')
	and		((a.cd_motivo_baixa = 0) or (ie_lote_w = 'I'))
	and		coalesce(a.ie_suspenso,'N')	= 'N'
	and		(((ie_lote_w = 'N') and (a.ie_status_atend between coalesce(ie_status_ini_p,0) and coalesce(ie_status_final_p,30))) or (ie_lote_w = 'I' and a.ie_status_atend = ie_status_ini_p) or
			(( or ) AND ie_gerar_exame_regra_aprov_w = 'S'))
	and		a.dt_coleta between dt_inicial_w and dt_final_w
	and		((ie_gera_exame_externo_w = 'S') or ((ie_gera_exame_externo_w = 'N') and (coalesce(a.nr_seq_lote_externo::text, '') = '')))
	order	by a.nr_prescricao, a.nr_sequencia;

C04 CURSOR FOR
	SELECT	a.nr_prescricao,
			a.nr_sequencia
	from	prescr_procedimento a
	where	(a.nr_seq_exame IS NOT NULL AND a.nr_seq_exame::text <> '')
	and		(a.cd_material_exame IS NOT NULL AND a.cd_material_exame::text <> '')
	and		((a.cd_motivo_baixa = 0) or (ie_lote_w = 'I'))
	and		coalesce(a.ie_suspenso,'N')	= 'N'
	and		(((ie_lote_w = 'N') and (a.ie_status_atend between coalesce(ie_status_ini_p,0) and coalesce(ie_status_final_p,30))) or (ie_lote_w = 'I' and a.ie_status_atend = ie_status_ini_p))
	and (SELECT	max(f.dt_atualizacao)
			 from	prescr_proc_etapa f
			 where	f.nr_prescricao = a.nr_prescricao
			 and	f.nr_seq_prescricao = a.nr_sequencia
			 and	f.ie_etapa = 25) between dt_inicial_w and dt_final_w
	and		((ie_gera_exame_externo_w = 'S') or ((ie_gera_exame_externo_w = 'N') and (coalesce(a.nr_seq_lote_externo::text, '') = '')))
	order	by a.nr_prescricao, a.nr_sequencia;

procedure gerar_item_lote_exame(nr_prescricao_int_w bigint,
	                        	nr_seq_prescr_int_w bigint,
								ie_inseriu_lote_p	out text) is
;
BEGIN
	ie_gerar_lote_w	:= 'S';
	ie_inseriu_lote_p := 'N';
	if (ie_gerar_exames_prescr_aprov_w = 'S') then
		select	count(*)
		into STRICT	qt_exames_nao_aprov_w
		from	prescr_procedimento
		where	ie_status_atend < 35
		and		nr_prescricao = nr_prescricao_int_w;
	end if;

	if ((ie_gerar_exames_prescr_aprov_w = 'N') or not(qt_exames_nao_aprov_w > 0))  then
		if (ie_lote_w = 'I') then
			if (ie_gerar_impressos_w = 'S') then
				select	max(dt_impressao)
			    into STRICT	dt_impressao_w
			    from	exame_lab_result_item a, exame_lab_resultado b
				where	a.nr_seq_resultado = b.nr_Seq_resultado
				and		b.nr_prescricao = nr_prescricao_int_w
				and		a.nr_Seq_prescr = nr_seq_prescr_int_w;

				if (dt_impressao_w IS NOT NULL AND dt_impressao_w::text <> '') then
					ie_gerar_lote_w	:= 'N';
				end if;
			end if;

			if (ie_gerar_exame_status_w = 'S') then
				select	count(*)
			    into STRICT	qt_exame_tot_w
			    from	prescr_procedimento a
				where	a.nr_prescricao = nr_prescricao_int_w
			    and		ie_suspenso <> 'S';

				select	count(*)
			    into STRICT	qt_exame_status_w
			    from	prescr_procedimento a
			   where	a.nr_prescricao = nr_prescricao_int_w
			     and	a.ie_status_atend between coalesce(ie_status_ini_p,0) and coalesce(ie_status_final_p,30)
			     and	ie_suspenso <> 'S';

				if (qt_exame_tot_w <> qt_exame_status_w) then
					ie_gerar_lote_w	:= 'N';
				end if;
			end if;
		elsif (ie_lote_w = 'A') or (ie_lote_w = 'L') then
			select	max(elri.ie_status)
			into STRICT	ie_status_resultado_w
			from	exame_lab_resultado elr
			inner join exame_lab_result_item elri 	on elri.nr_seq_resultado = elr.nr_seq_resultado
													and elri.nr_seq_prescr = nr_seq_prescr_int_w
			where	elr.nr_prescricao = nr_prescricao_int_w;

			ds_consist_w := valida_regra_aprov_exame_lote(nr_prescricao_int_w, nr_seq_prescr_int_w, nm_usuario_p, ie_lote_w, obter_perfil_ativo, ds_consist_w);

			if ((ie_gerar_exame_regra_aprov_w <> 'S') or (coalesce(ie_status_resultado_w, -1) <> 1) or (ds_consist_w IS NOT NULL AND ds_consist_w::text <> '')) then
				ie_gerar_lote_w	:= 'N';
			end if;
		end if;

		if (ie_gerar_lote_w = 'S') then
			insert into lab_lote_exame_item(
				nr_seq_lote,
				nr_prescricao,
				nr_seq_prescr,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec)
			values (
				nr_seq_lote_p,
				nr_prescricao_int_w,
				nr_seq_prescr_int_w,
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p);
			ie_inseriu_lote_p := 'S';
		end if;
	end if;
end;

begin
	qt_itens_lote_w := 0;
	ie_inseriu_lote_w := 'N';

	select	coalesce(max(obter_valor_param_usuario(725, 19, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p)), 'A')
    into STRICT	ie_status_urgente_lote_w
;

	select	coalesce(nr_seq_grupo,0), coalesce(nr_seq_exame,0), coalesce(nr_seq_exame_not,0), coalesce(nr_seq_grupo_imp,0), coalesce(ie_tipo_atendimento,0), dt_inicial, dt_final, dt_geracao, coalesce(cd_setor_atendimento,0),
			coalesce(nr_seq_material,0), coalesce(cd_setor_prescr,0), coalesce(ie_lote,'N'), coalesce(cd_setor_entrega,0), coalesce(cd_estab_regra,0), coalesce(nr_seq_forma_laudo,0), ie_gerar_impressos, ie_gerar_exame_status,
			coalesce(ie_gerar_exames_prescr_aprov,'N'), nr_seq_lab_lote_regra, coalesce(ie_status_urgente,'A'), coalesce(IE_GERAR_EXAME_LOTE_EXT,'S'), coalesce(IE_GERAR_EXAME_REGRA_APROV, 'N')
    into STRICT	nr_seq_grupo_w, nr_seq_exame_w, nr_seq_exame_not_w, nr_seq_grupo_imp_w, ie_tipo_atendimento_w, dt_inicial_w, dt_final_w, dt_geracao_w, cd_setor_w, nr_seq_material_w, cd_setor_prescr_w,
			ie_lote_w, cd_setor_entrega_w, cd_estab_regra_w, nr_seq_forma_laudo_w, ie_gerar_impressos_w, ie_gerar_exame_status_w, ie_gerar_exames_prescr_aprov_w, nr_seq_lab_lote_regra_w,
			ie_status_urgente_lote_w, ie_gera_exame_externo_w, ie_gerar_exame_regra_aprov_w
    from	lab_lote_exame
	where	nr_sequencia = nr_seq_lote_p;

	if (coalesce(dt_geracao_w::text, '') = '') and (ie_acao_p = 0) then
		if (ie_data_lote_p <> 'C') and (ie_data_lote_p <> 'D') then
			open c01;
			loop
			fetch c01 into
				nr_prescricao_w,
				nr_sequencia_w;
			EXIT WHEN NOT FOUND; /* apply on c01 */
				gerar_item_lote_exame(nr_prescricao_w, nr_sequencia_w, ie_inseriu_lote_w);
				if (ie_inseriu_lote_w = 'S') then
					qt_itens_lote_w := qt_itens_lote_w + 1;
					ie_inseriu_lote_w := 'N';
				end if;
			end loop;
			close c01;

			if (qt_itens_lote_w > 0) then
				update	lab_lote_exame
				set		dt_geracao = clock_timestamp()
				where	nr_sequencia = nr_seq_lote_p;
			end if;
		elsif (ie_data_lote_p = 'C') then
			open c03;
			loop
			fetch c03 into
				nr_prescricao_exp_w,
				nr_seq_prescr_exp_w;
			EXIT WHEN NOT FOUND; /* apply on c03 */
			begin
				open C02;
				loop
				fetch C02 into
					nr_prescricao_w,
					nr_sequencia_w;
				EXIT WHEN NOT FOUND; /* apply on C02 */
				begin
					gerar_item_lote_exame(nr_prescricao_w, nr_sequencia_w, ie_inseriu_lote_w);
					if (ie_inseriu_lote_w = 'S') then
						qt_itens_lote_w := qt_itens_lote_w + 1;
						ie_inseriu_lote_w := 'N';
					end if;
				end;
				end loop;
				close C02;
			end;
			end loop;
			close c03;

			if (qt_itens_lote_w > 0) then
				update	lab_lote_exame
				set		dt_geracao = clock_timestamp()
				where	nr_sequencia = nr_seq_lote_p;
			end if;
		elsif (ie_data_lote_p = 'D') then
			open c04;
			loop
			fetch c04 into
				nr_prescricao_exp_w,
				nr_seq_prescr_exp_w;
			EXIT WHEN NOT FOUND; /* apply on c04 */
			begin
				open C02;
				loop
				fetch C02 into
					nr_prescricao_w,
					nr_sequencia_w;
				EXIT WHEN NOT FOUND; /* apply on C02 */
				begin
					gerar_item_lote_exame(nr_prescricao_w, nr_sequencia_w, ie_inseriu_lote_w);
					if (ie_inseriu_lote_w = 'S') then
						qt_itens_lote_w := qt_itens_lote_w + 1;
						ie_inseriu_lote_w := 'N';
					end if;
				end;
				end loop;
				close C02;
			end;
			end loop;
			close c04;

			if (qt_itens_lote_w > 0) then
				update lab_lote_exame
				set		dt_geracao = clock_timestamp()
				where	nr_sequencia = nr_seq_lote_p;
			end if;
		end if;
	elsif (ie_acao_p = 1) then
		delete	FROM lab_lote_exame_item
		where	nr_seq_lote = nr_seq_lote_p;

		update	lab_lote_exame
		set		dt_geracao  = NULL
		where	nr_sequencia = nr_seq_lote_p;
	end if;
	commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_lote_exame (nr_seq_lote_p bigint, ie_acao_p bigint, ie_status_ini_p bigint, ie_data_lote_p text, ie_gerar_sub_grupos_p text, ie_gerar_data_emissao_p text, ie_status_final_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

