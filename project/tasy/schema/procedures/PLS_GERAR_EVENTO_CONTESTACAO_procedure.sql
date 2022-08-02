-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_evento_contestacao ( nr_seq_lote_disc_p pls_lote_discussao.nr_sequencia%type, ie_commit_p text, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


ie_tipo_relacao_aten_w		varchar(2);
ie_tipo_relacao_pgto_w		varchar(2);
nr_seq_eve_disc_w		pls_evento_discussao.nr_sequencia%type;
ie_parametro_16_w		varchar(255);
nr_seq_prestador_pgto_w		pls_prestador.nr_sequencia%type;
nr_seq_prestador_aten_w		pls_prestador.nr_sequencia%type;
ds_observacao_w			varchar(4000);
ie_desconta_prestador_w		varchar(1);
dt_pagto_orig_w			timestamp;
ds_motivo_quest_w		varchar(255);
nr_seq_prestador_w		pls_prestador.nr_sequencia%type;
vl_movimento_w			double precision := 0;
nr_seq_evento_movimento_disc_w	pls_discussao_evento_movto.nr_sequencia%type;
nr_seq_evento_movto_w		pls_evento_movimento.nr_sequencia%type;
dt_liberacao_w			pls_discussao_evento_movto.dt_liberacao%type;
ds_proc_mat_w			varchar(255);
qt_registro_w			integer := 0;
ds_obs_disc_evento_w		pls_parametros.ds_obs_disc_evento%type;
ds_obs_disc_evento2_w		pls_parametros.ds_obs_disc_evento%type;
nm_medico_executor_imp_w	pls_proc_participante.nm_medico_executor_imp%type;

C01 CURSOR(	nr_seq_lote_disc_pc	pls_lote_discussao.nr_sequencia%type) FOR
	SELECT	d.nr_sequencia,
		c.nr_seq_conta,
		substr(pls_obter_dados_contestacao(d.nr_seq_contestacao,'NN'),1,20) nr_nota,
		substr(pls_obter_dados_contestacao(d.nr_seq_contestacao,'NB'),1,255) nm_beneficiario,
		substr(pls_obter_dados_contestacao(d.nr_seq_contestacao,'CR'),1,255) cd_usuario_plano,
		substr(pls_obter_dados_conta(c.nr_seq_conta,'PE'),1,255) nm_prestador
	from	pls_contestacao_discussao d,
		pls_contestacao c
	where	c.nr_sequencia	= d.nr_seq_contestacao
	and	d.nr_seq_lote 	= nr_seq_lote_disc_pc
	and	d.vl_aceito 	> 0;

C02 CURSOR(	nr_seq_discussao_pc	pls_contestacao_discussao.nr_sequencia%type) FOR
	SELECT	nr_seq_motivo_glosa_aceita,
		nr_seq_conta_proc,
		null nr_seq_conta_mat,
		vl_prestador,
		ds_observacao ds_obs_proc_mat,
		nr_sequencia nr_seq_disc_proc,
		null nr_seq_disc_mat
	from	pls_discussao_proc
	where	nr_seq_discussao = nr_seq_discussao_pc
	and	(nr_seq_motivo_glosa_aceita IS NOT NULL AND nr_seq_motivo_glosa_aceita::text <> '')
	group by  nr_seq_conta_proc,
		nr_seq_motivo_glosa_aceita,
		vl_prestador,
		ds_observacao,
		nr_sequencia
	
union all

	SELECT	nr_seq_motivo_glosa_aceita,
		null,
		nr_seq_conta_mat,
		vl_prestador,
		ds_observacao ds_obs_proc_mat,
		null nr_seq_disc_proc,
		nr_sequencia nr_seq_disc_mat
	from	pls_discussao_mat
	where	nr_seq_discussao = nr_seq_discussao_pc
	and	(nr_seq_motivo_glosa_aceita IS NOT NULL AND nr_seq_motivo_glosa_aceita::text <> '')
	group by nr_seq_conta_mat,
		nr_seq_motivo_glosa_aceita,
		vl_prestador,
		ds_observacao,
		nr_sequencia;

C03 CURSOR(	nr_seq_motivo_glosa_aceita_pc	pls_motivo_glosa_aceita.nr_sequencia%type,
		ie_desconta_prestador_pc	pls_motivo_glosa_aceita.ie_desconta_prestador%type,
		ie_tipo_relacao_atend_pc	pls_evento_discussao.ie_tipo_relacao_atend%type,
		ie_tipo_relacao_pgto_pc		pls_evento_discussao.ie_tipo_relacao_pgto%type) FOR
	SELECT	nr_sequencia,
		nr_seq_evento,
		ie_desconto,
		ie_necessita_lib
	from	pls_evento_discussao
	where	((nr_seq_motivo_glosa = nr_seq_motivo_glosa_aceita_pc) or (coalesce(nr_seq_motivo_glosa::text, '') = ''))
	and	((ie_desconta_prestador = ie_desconta_prestador_pc) or (coalesce(ie_desconta_prestador::text, '') = '') or (ie_desconta_prestador = 'A'))
	and	((ie_tipo_relacao_pgto = ie_tipo_relacao_pgto_pc) or (coalesce(ie_tipo_relacao_pgto::text, '') = ''))
	and	((ie_tipo_relacao_atend = ie_tipo_relacao_atend_pc) or (coalesce(ie_tipo_relacao_atend::text, '') = ''));

BEGIN
-- alterado para max, vai ser mais rapido que o count
select	max(nr_sequencia)
into STRICT	nr_seq_eve_disc_w
from	pls_evento_discussao;

select	max(ds_obs_disc_evento)
into STRICT	ds_obs_disc_evento_w
from	pls_parametros
where	cd_estabelecimento	= cd_estabelecimento_p;

ds_obs_disc_evento2_w := ds_obs_disc_evento_w;

-- Verifica se tem regra de desconto contestacao discussao
if (nr_seq_eve_disc_w IS NOT NULL AND nr_seq_eve_disc_w::text <> '') then

	ie_parametro_16_w := obter_param_usuario(1334, 16, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_parametro_16_w);

	for r_C01_w in C01(nr_seq_lote_disc_p) loop
		-- Obter informacoes do prestador pagamento
		select	max(nr_seq_prestador_pgto)
		into STRICT	nr_seq_prestador_pgto_w
		from	pls_conta_medica_resumo
		where	nr_seq_conta = r_C01_w.nr_seq_conta
		and	ie_situacao = 'A';

		if (nr_seq_prestador_pgto_w IS NOT NULL AND nr_seq_prestador_pgto_w::text <> '') then
			select	max(ie_tipo_relacao)
			into STRICT	ie_tipo_relacao_pgto_w
			from	pls_prestador
			where	nr_sequencia = nr_seq_prestador_pgto_w;
		end if;

		-- Obter informacoes do prestador atendimento
		select	max(a.nr_seq_prestador)
		into STRICT	nr_seq_prestador_aten_w
		from	pls_conta b,
			pls_protocolo_conta a
		where	a.nr_sequencia = b.nr_seq_protocolo
		and	b.nr_sequencia = r_C01_w.nr_seq_conta;

		if (nr_seq_prestador_aten_w IS NOT NULL AND nr_seq_prestador_aten_w::text <> '') then
			select	max(ie_tipo_relacao)
			into STRICT	ie_tipo_relacao_aten_w
			from	pls_prestador
			where	nr_sequencia = nr_seq_prestador_aten_w;
		end if;

		-- Obter os itens da discussao
		for r_C02_w in C02(r_C01_w.nr_sequencia) loop

			select	max(ie_desconta_prestador)
			into STRICT	ie_desconta_prestador_w
			from	pls_motivo_glosa_aceita
			where	nr_sequencia = r_C02_w.nr_seq_motivo_glosa_aceita;

			select	max(dt_pagamento)
			into STRICT	dt_pagto_orig_w
			from (	SELECT	max(coalesce(t.dt_liquidacao, t.dt_vencimento_atual)) dt_pagamento
				from	pls_conta_medica_resumo x,
					pls_pag_prest_vencimento r,
					pls_pagamento_prestador w,
					titulo_pagar t
				where	w.nr_seq_lote = x.nr_seq_lote_pgto
				and	w.nr_sequencia = r.nr_seq_pag_prestador
				and	x.nr_seq_conta_proc = r_C02_w.nr_seq_conta_proc
				and	x.nr_seq_conta = r_C01_w.nr_seq_conta
				and	t.nr_titulo = r.nr_titulo
				
union all

				SELECT	max(coalesce(t.dt_liquidacao, t.dt_vencimento_atual)) dt_pagamento
				from	pls_conta_medica_resumo a,
					pls_pp_item_lote b,
					pls_pp_prestador c,
					titulo_pagar t
				where	a.nr_seq_conta = r_C01_w.nr_seq_conta
				and	a.nr_seq_conta_proc = r_C02_w.nr_seq_conta_proc
				and	b.nr_seq_lote = a.nr_seq_pp_lote
				and	b.nr_seq_conta = r_C01_w.nr_seq_conta
				and 	b.nr_seq_resumo = a.nr_sequencia
				and	c.nr_seq_lote = b.nr_seq_lote
				and	c.nr_seq_prestador = b.nr_seq_prestador
				and	t.nr_titulo = c.nr_titulo_pagar) alias5;

			if (r_C02_w.nr_seq_conta_mat IS NOT NULL AND r_C02_w.nr_seq_conta_mat::text <> '') then
				select 	substr(pls_obter_desc_contestacao(max(y.nr_seq_mot_questionamento),null),1,255)
				into STRICT	ds_motivo_quest_w
				from	ptu_questionamento x,
					ptu_questionamento_codigo y
				where 	x.nr_sequencia  = y.nr_seq_registro
				and	x.nr_seq_conta_mat = r_C02_w.nr_seq_conta_mat;

				--aldellandrea os 840673 efeetuado o tratamento abaixo para pegear o motivo do questionamento caso acima nao traga
				if (coalesce(ds_motivo_quest_w::text, '') = '') and (r_C02_w.nr_seq_disc_mat IS NOT NULL AND r_C02_w.nr_seq_disc_mat::text <> '') then
					select	max(b.ds_motivo)
					into STRICT	ds_motivo_quest_w
					from	pls_discussao_item_glosa a,
						ptu_motivo_questionamento b
					where	a.nr_seq_mot_quest = b.nr_sequencia
					and	a.nr_seq_disc_mat = r_C02_w.nr_seq_disc_mat;
				end if;
			end if;

			if (r_C02_w.nr_seq_conta_proc IS NOT NULL AND r_C02_w.nr_seq_conta_proc::text <> '') then
				select 	substr(pls_obter_desc_contestacao(max(y.nr_seq_mot_questionamento),null),1,255)
				into STRICT	ds_motivo_quest_w
				from	ptu_questionamento x,
					ptu_questionamento_codigo y
				where 	x.nr_sequencia = y.nr_seq_registro
				and	x.nr_seq_conta_proc = r_C02_w.nr_seq_conta_proc;

				--aldellandrea os 840673 efeetuado o tratamento abaixo para pegear o motivo do questionamento caso acima nao traga
				if (coalesce(ds_motivo_quest_w::text, '') = '') and (r_C02_w.nr_seq_disc_proc IS NOT NULL AND r_C02_w.nr_seq_disc_proc::text <> '') then
					select	max(b.ds_motivo)
					into STRICT	ds_motivo_quest_w
					from	pls_discussao_item_glosa a,
						ptu_motivo_questionamento b
					where	a.nr_seq_mot_quest = b.nr_sequencia
					and	a.nr_seq_disc_proc = r_C02_w.nr_seq_disc_proc;
				end if;
			end if;

			ds_proc_mat_w := null;
			if (r_C02_w.nr_seq_conta_proc IS NOT NULL AND r_C02_w.nr_seq_conta_proc::text <> '') then
				select	substr('Procedimento: ' || coalesce(cd_procedimento,cd_procedimento_imp) || ' - ' ||
											obter_descricao_procedimento(cd_procedimento, ie_origem_proced),1,255)
				into STRICT	ds_proc_mat_w
				from	pls_conta_proc
				where	nr_sequencia = r_C02_w.nr_seq_conta_proc;

			elsif (r_C02_w.nr_seq_conta_mat IS NOT NULL AND r_C02_w.nr_seq_conta_mat::text <> '') then
				select	substr('Material: ' || coalesce(coalesce(pls_obter_seq_codigo_material(nr_seq_material,null),cd_material_imp), cd_material) || ' - ' ||
											obter_descricao_padrao('PLS_MATERIAL','DS_MATERIAL',nr_seq_material),1,255)
				into STRICT	ds_proc_mat_w
				from	pls_conta_mat
				where	nr_sequencia = r_C02_w.nr_seq_conta_mat;
			end if;

			ds_observacao_w := null;
			ds_obs_disc_evento_w := ds_obs_disc_evento2_w;
			
			if (coalesce(ds_obs_disc_evento_w::text, '') = '') then
				if (r_C01_w.nr_nota IS NOT NULL AND r_C01_w.nr_nota::text <> '') then
					ds_observacao_w := substr(ds_observacao_w || chr(10) || 'Nota: ' || r_C01_w.nr_nota, 1, 4000);
				end if;
				if (r_C01_w.nr_seq_conta IS NOT NULL AND r_C01_w.nr_seq_conta::text <> '') then
					ds_observacao_w := substr(ds_observacao_w || chr(10) || 'Conta: ' || r_C01_w.nr_seq_conta, 1, 4000);
				end if;
				if (ds_proc_mat_w IS NOT NULL AND ds_proc_mat_w::text <> '') then
					ds_observacao_w := substr(ds_observacao_w || chr(10) || trim(both ds_proc_mat_w), 1, 4000);
				end if;
				if (r_C01_w.cd_usuario_plano IS NOT NULL AND r_C01_w.cd_usuario_plano::text <> '') then
					ds_observacao_w := substr(ds_observacao_w || chr(10) || 'Carteirinha: ' || r_C01_w.cd_usuario_plano, 1, 4000);
				end if;
				if (r_C01_w.nm_beneficiario IS NOT NULL AND r_C01_w.nm_beneficiario::text <> '') then
					ds_observacao_w := substr(ds_observacao_w || chr(10) || wheb_mensagem_pck.get_texto(240696) || ': ' || r_C01_w.nm_beneficiario, 1, 4000);
				end if;
				if (ds_motivo_quest_w IS NOT NULL AND ds_motivo_quest_w::text <> '') then
					ds_observacao_w := substr(ds_observacao_w || chr(10) || 'Mtvo Quest.: ' || ds_motivo_quest_w, 1, 4000);
				end if;
				if (dt_pagto_orig_w IS NOT NULL AND dt_pagto_orig_w::text <> '') then
					ds_observacao_w := substr(ds_observacao_w || chr(10) || 'Data original: ' || dt_pagto_orig_w, 1, 4000);
				end if;
				if (r_C02_w.ds_obs_proc_mat IS NOT NULL AND r_C02_w.ds_obs_proc_mat::text <> '') then
					ds_observacao_w := substr(ds_observacao_w || chr(10) || 'Obs.: ' || r_C02_w.ds_obs_proc_mat, 1, 4000);
				end if;
				if (substr(ds_observacao_w,1,1) = chr(10)) then
					ds_observacao_w := substr(ds_observacao_w, 2, 4000);
				end if;
				null;
			else
				if (r_C01_w.nr_nota IS NOT NULL AND r_C01_w.nr_nota::text <> '') then
					ds_obs_disc_evento_w := replace_macro( ds_obs_disc_evento_w, '@NR_NOTA', r_C01_w.nr_nota);
				end if;

				if (r_C01_w.nr_seq_conta IS NOT NULL AND r_C01_w.nr_seq_conta::text <> '') then
					ds_obs_disc_evento_w := replace_macro( ds_obs_disc_evento_w, '@NR_SEQ_CONTA', r_C01_w.nr_seq_conta);
				end if;

				if (ds_proc_mat_w IS NOT NULL AND ds_proc_mat_w::text <> '') then
					ds_obs_disc_evento_w := replace_macro( ds_obs_disc_evento_w, '@DS_ITEM', ds_proc_mat_w);
				end if;

				if (r_C01_w.cd_usuario_plano IS NOT NULL AND r_C01_w.cd_usuario_plano::text <> '') then
					ds_obs_disc_evento_w := replace_macro( ds_obs_disc_evento_w, '@CD_CARTEIRINHA', r_C01_w.cd_usuario_plano);
				end if;

				if (r_C01_w.nm_beneficiario IS NOT NULL AND r_C01_w.nm_beneficiario::text <> '') then
					ds_obs_disc_evento_w := replace_macro( ds_obs_disc_evento_w, '@NM_BENEFICIARIO', r_C01_w.nm_beneficiario);
				end if;

				if (ds_motivo_quest_w IS NOT NULL AND ds_motivo_quest_w::text <> '') then
					ds_obs_disc_evento_w := replace_macro( ds_obs_disc_evento_w, '@DS_MOTIVO_QUEST', ds_motivo_quest_w);
				end if;

				if (dt_pagto_orig_w IS NOT NULL AND dt_pagto_orig_w::text <> '') then
					ds_obs_disc_evento_w := replace_macro( ds_obs_disc_evento_w, '@DT_PGTO_ORIG', dt_pagto_orig_w);
				end if;

				if (r_C02_w.ds_obs_proc_mat IS NOT NULL AND r_C02_w.ds_obs_proc_mat::text <> '') then
					ds_obs_disc_evento_w := replace_macro( ds_obs_disc_evento_w, '@DS_OBS_ITEM', r_C02_w.ds_obs_proc_mat);
				end if;

				if (r_C01_w.nm_prestador IS NOT NULL AND r_C01_w.nm_prestador::text <> '') then
					ds_obs_disc_evento_w := replace_macro( ds_obs_disc_evento_w, '@DS_PARTIC', r_C01_w.nm_prestador);
				end if;

				-- Se nao trocou a macro, somente retirar da observacao
				ds_obs_disc_evento_w := replace_macro( ds_obs_disc_evento_w, '@NR_NOTA', '');
				ds_obs_disc_evento_w := replace_macro( ds_obs_disc_evento_w, '@NR_SEQ_CONTA', '');
				ds_obs_disc_evento_w := replace_macro( ds_obs_disc_evento_w, '@DS_ITEM', '');
				ds_obs_disc_evento_w := replace_macro( ds_obs_disc_evento_w, '@CD_CARTEIRINHA', '');
				ds_obs_disc_evento_w := replace_macro( ds_obs_disc_evento_w, '@NM_BENEFICIARIO', '');
				ds_obs_disc_evento_w := replace_macro( ds_obs_disc_evento_w, '@DS_MOTIVO_QUEST', '');
				ds_obs_disc_evento_w := replace_macro( ds_obs_disc_evento_w, '@DT_PGTO_ORIG', '');
				ds_obs_disc_evento_w := replace_macro( ds_obs_disc_evento_w, '@DS_OBS_ITEM', '');
				ds_obs_disc_evento_w := replace_macro( ds_obs_disc_evento_w, '@DS_PARTIC', '');

				ds_observacao_w := substr(ds_obs_disc_evento_w,1,4000);

			end if;

			for r_C03_w in C03(r_C02_w.nr_seq_motivo_glosa_aceita, ie_desconta_prestador_w, ie_tipo_relacao_aten_w, ie_tipo_relacao_pgto_w) loop
				nr_seq_prestador_w := null;
				-- 'PAG'	- Descontar do prestador de pagamento
				if (r_C03_w.ie_desconto = 'PAG') then
					nr_seq_prestador_w := nr_seq_prestador_pgto_w;
					if (r_C02_w.nr_seq_conta_proc IS NOT NULL AND r_C02_w.nr_seq_conta_proc::text <> '') then
						select	max(coalesce(vl_liberado,0))
						into STRICT	vl_movimento_w
						from	pls_conta_medica_resumo
						where	nr_seq_conta = r_C01_w.nr_seq_conta
						and	nr_seq_conta_proc = r_C02_w.nr_seq_conta_proc
						and	nr_seq_prestador_pgto = nr_seq_prestador_pgto_w;
					elsif (r_C02_w.nr_seq_conta_mat IS NOT NULL AND r_C02_w.nr_seq_conta_mat::text <> '') then
						select	max(coalesce(vl_liberado,0))
						into STRICT	vl_movimento_w
						from	pls_conta_medica_resumo
						where	nr_seq_conta = r_C01_w.nr_seq_conta
						and	nr_seq_conta_mat = r_C02_w.nr_seq_conta_mat
						and	nr_seq_prestador_pgto = nr_seq_prestador_pgto_w;
					end if;
				-- 'AT' 	- Descontar do prestador do atendimento
				elsif (r_C03_w.ie_desconto = 'AT') then
					nr_seq_prestador_w := nr_seq_prestador_aten_w;
					if (r_C02_w.nr_seq_conta_proc IS NOT NULL AND r_C02_w.nr_seq_conta_proc::text <> '') then
						select	max(coalesce(vl_liberado,0))
						into STRICT	vl_movimento_w
						from	pls_conta_medica_resumo
						where	nr_seq_conta = r_C01_w.nr_seq_conta
						and	nr_seq_conta_proc = r_C02_w.nr_seq_conta_proc
						and	nr_seq_prestador_atend = nr_seq_prestador_aten_w;
					elsif (r_C02_w.nr_seq_conta_mat IS NOT NULL AND r_C02_w.nr_seq_conta_mat::text <> '') then
						select	max(coalesce(vl_liberado,0))
						into STRICT	vl_movimento_w
						from	pls_conta_medica_resumo
						where	nr_seq_conta = r_C01_w.nr_seq_conta
						and	nr_seq_conta_mat = r_C02_w.nr_seq_conta_mat
						and	nr_seq_prestador_atend = nr_seq_prestador_aten_w;
					end if;
				end if;

				if (r_C03_w.ie_desconto not in ('N')) and (nr_seq_prestador_w IS NOT NULL AND nr_seq_prestador_w::text <> '') then
					nr_seq_evento_movimento_disc_w := null;
					if (r_C02_w.nr_seq_disc_proc IS NOT NULL AND r_C02_w.nr_seq_disc_proc::text <> '') then
						select	max(nr_sequencia)
						into STRICT	nr_seq_evento_movimento_disc_w
						from	pls_discussao_evento_movto
						where	nr_seq_lote_disc = nr_seq_lote_disc_p
						and	nr_seq_prestador = nr_seq_prestador_w
						and	nr_seq_disc_proc = r_C02_w.nr_seq_disc_proc;

					elsif (r_C02_w.nr_seq_disc_mat IS NOT NULL AND r_C02_w.nr_seq_disc_mat::text <> '') then
						select	max(nr_sequencia)
						into STRICT	nr_seq_evento_movimento_disc_w
						from	pls_discussao_evento_movto
						where	nr_seq_lote_disc = nr_seq_lote_disc_p
						and	nr_seq_prestador = nr_seq_prestador_w
						and	nr_seq_disc_mat	= r_C02_w.nr_seq_disc_mat;
					end if;

					--Verifica o parametro 16 da funcao (Permite informar valor descontado do prestador ao acatar a glosa do item da discussao)
					if (coalesce(ie_parametro_16_w, 'N') = 'S') then
						vl_movimento_w := coalesce(r_C02_w.vl_prestador,0);
					end if;

					dt_liberacao_w := null;
					if (coalesce(r_C03_w.ie_necessita_lib,'N') = 'N') then
						dt_liberacao_w := clock_timestamp();
					end if;

					if (vl_movimento_w > 0) then
						if (coalesce(nr_seq_evento_movimento_disc_w::text, '') = '') then
							insert into pls_discussao_evento_movto(
								nr_sequencia,				ds_observacao,			dt_atualizacao,
								dt_atualizacao_nrec,			dt_movimento,			nm_usuario,
								nm_usuario_nrec,			nr_seq_disc_mat,		nr_seq_disc_proc,
								nr_seq_evento_movto,			nr_seq_lote_disc,		nr_seq_prestador,
								nr_seq_regra_evento_disc,		vl_movimento,			nr_seq_evento,
								dt_liberacao)
							values (nextval('pls_discussao_evento_movto_seq'),	ds_observacao_w,		clock_timestamp(),
								clock_timestamp(),				clock_timestamp(),			nm_usuario_p,
								nm_usuario_p,				r_C02_w.nr_seq_disc_mat,	r_C02_w.nr_seq_disc_proc,
								null,					nr_seq_lote_disc_p,		nr_seq_prestador_w,
								r_C03_w.nr_sequencia,			vl_movimento_w,			r_C03_w.nr_seq_evento,
								dt_liberacao_w);
						else
							select	max(nr_seq_evento_movto)
							into STRICT	nr_seq_evento_movto_w
							from	pls_discussao_evento_movto
							where	nr_sequencia = nr_seq_evento_movimento_disc_w;

							if (coalesce(nr_seq_evento_movto_w::text, '') = '') then
								update	pls_discussao_evento_movto
								set	vl_movimento	= vl_movimento_w,
									ds_observacao	= ds_observacao_w,
									nr_seq_evento	= r_C03_w.nr_seq_evento,
									dt_atualizacao	= clock_timestamp(),
									nm_usuario	= nm_usuario_p,
									dt_liberacao	= dt_liberacao_w
								where	nr_sequencia 	= nr_seq_evento_movimento_disc_w;
							else
								select	count(1)
								into STRICT	qt_registro_w
								from	pls_discussao_evento_movto
								where	nr_sequencia = nr_seq_evento_movimento_disc_w
								and	vl_movimento != vl_movimento_w;

								if (qt_registro_w > 0) then
									-- Evento de deconto em lote de pagamento. Nao e possivel definir outro valor de desconto para o prestador.
									CALL wheb_mensagem_pck.exibir_mensagem_abort(668781, null);
								end if;
							end if;
						end if;
					end if;
				end if;
			end loop;
		end loop;
	end loop;
end if;

if (coalesce(ie_commit_p,'N') = 'S') then
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_evento_contestacao ( nr_seq_lote_disc_p pls_lote_discussao.nr_sequencia%type, ie_commit_p text, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;

