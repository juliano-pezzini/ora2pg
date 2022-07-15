-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consistir_regulacao_pep ( nr_seq_encaminhamento_p bigint, nm_tabela_p text) AS $body$
DECLARE


nr_seq_regulacao_w			regra_regulacao.nr_sequencia%TYPE;
nr_seq_grupo_regulacao_w	regra_regulacao.nr_seq_grupo_regulacao%TYPE;

nm_usuario_w			usuario.nm_usuario%TYPE;
ie_tipo_w				varchar(3);
dt_previsao_w			timestamp;

nr_seq_pedido_item_w	bigint;
nr_seq_exame_cad_w		bigint;
nr_seq_exame_w			bigint;
cd_material_exame_w		varchar(20);
cd_procedimento_w		bigint;
nr_seq_proc_interno_w	bigint;
ie_origem_proced_w		bigint;
ds_conteudo_w			varchar(4000);
ds_titulo_w				varchar(255);
ds_complemento_w		varchar(255);
ds_justificativa_w		varchar(255);
qt_exame_w				integer;
qt_procedimento_w		double precision;
ds_enter_w				varchar(10)	:=  '<br>';
ds_motivo_w				varchar(255);
ds_data_prevista_w		varchar(255);

nr_seq_requisicao_w		bigint;
nr_seq_equipamento_w	bigint;
nr_seq_tipo_equip_w		bigint;
qt_requisitada_w		double precision;
ds_observacao_w			varchar(255);
ds_tit_tipo_equipamento_w	varchar(255);
ds_tipo_equipamento_w	varchar(255);
ie_somente_ref_W		varchar(1);
dt_fim_w				timestamp;
cd_pessoa_fisica_w		varchar(10);
nr_atendimento_w		bigint;
nr_seq_grupo_reg_int_w		bigint;
ie_integracao_w			varchar(2);
nr_seq_grupo_reg_w		bigint;	
cd_especialidade_w		integer;	
cd_pessoa_fisica_med_dest_w	varchar(10);
ds_retorno_integracao_w	varchar(4000);
cd_estabelecimento_w	smallint;
cd_especialidade_usuario_w	integer;
cd_perfil_w	integer;
nr_seq_work_item_w	bigint;	


nr_seq_regra_regulacao_w bigint;
cd_material_w	bigint;
ie_via_aplicacao_w	varchar(5);
qt_dose_w	double precision;
cd_unidade_medida_w varchar(30);
cd_intervalo_w	varchar(7);
dt_inicio_receita_far_w timestamp;
nr_dias_receita_w	integer;
dt_validade_receita_far_w	timestamp;
ie_tipo_receita_w	varchar(15);
ds_tipo_receita_w	varchar(255);
ds_material_w		varchar(255);
ds_unidade_medida_w	varchar(255);
ds_inter_presc_w	varchar(255);
ds_via_aplic_w		varchar(255);



ie_classificacao_w		paciente_home_care.ie_classificacao%type;
dt_inicio_w				paciente_home_care.dt_inicio%type;
nr_seq_origem_w			paciente_home_care.nr_seq_origem%type;
nr_seq_entidade_w		paciente_home_care.nr_seq_entidade%type;
ds_conteudo_home_care_w		varchar(255);
		



C01 CURSOR FOR
SELECT	a.nr_sequencia,
		a.nr_seq_exame,
		a.nr_seq_exame_lab,
		a.cd_material_exame,
		a.cd_procedimento,
		coalesce(a.nr_seq_proc_int_sus,a.nr_proc_interno),
		a.ie_origem_proced,
		a.ds_justificativa,
		a.qt_exame
FROM	pedido_exame_externo_item a
WHERE	a.nr_seq_pedido = nr_seq_encaminhamento_p;

C02 CURSOR FOR
SELECT	a.nr_sequencia,
		a.nr_seq_equipamento,
		a.nr_seq_tipo_equip,
		a.ds_observacao,
		a.ds_justificativa,
		a.qt_requisitada
FROM	item_requisicao a
WHERE	a.nr_seq_requisicao = nr_seq_encaminhamento_p;


PROCEDURE gerar_processo_regulacao( 	ie_tipo_p text,
										nr_encaminhamento_p bigint,
										nm_tabela_reg_p text,
										nm_usuario_reg_p text,
										ds_conteudo_p text,
										nr_seq_regulacao_p bigint ,
										nr_seq_grupo_regulacao_p bigint,
										ie_informacao_p	text,
										nr_seq_informacao_p bigint) IS

nr_seq_parecer_w				parecer_medico_req.nr_parecer%TYPE;
cd_evolucao_w					evolucao_paciente.cd_evolucao%TYPE;
nr_seq_reg_atend_w				regulacao_atend.nr_sequencia%TYPE;
nr_seq_regulacao_reg_w			bigint;
nr_seq_grupo_regulacao_reg_w	bigint;

ds_conteudo_w	varchar(4000);


BEGIN

ds_conteudo_w := ds_conteudo_p;

IF ( coalesce(nr_seq_regulacao_p,0) > 0) THEN


	IF ( ie_tipo_p = 'EN') THEN

		nr_seq_parecer_w := gerar_parecer_encaminhamento(nr_encaminhamento_p, nr_seq_parecer_w);

	ELSIF ( ie_tipo_p = 'EV') THEN

		nr_seq_parecer_w := gerar_parecer_evolucao(nr_encaminhamento_p, ds_conteudo_w, nr_seq_regulacao_p, nr_seq_parecer_w);
		cd_evolucao_w := nr_encaminhamento_p;

	ELSIF ( ie_tipo_p = 'SE') THEN

		nr_seq_parecer_w := gerar_parecer_solic_exame(nr_encaminhamento_p, ds_conteudo_w, nr_seq_regulacao_p, nr_seq_parecer_w);

	ELSIF (ie_tipo_p = 'TC') THEN

		nr_seq_parecer_w := gerar_parecer_transf_cuidado(nr_encaminhamento_p, ds_conteudo_w, nr_seq_regulacao_p, nr_seq_parecer_w);

	ELSIF (ie_tipo_p = 'EQ') THEN

		nr_seq_parecer_w := gerar_parecer_equipamentos(nr_encaminhamento_p, ds_conteudo_w, nr_seq_regulacao_p, nr_seq_parecer_w, ie_informacao_p);

	ELSIF (ie_tipo_p = 'CPOE') THEN

		nr_seq_parecer_w := gerar_parecer_solic_proc_cpoe(nr_encaminhamento_p, ds_conteudo_w, nr_seq_regulacao_p, nr_seq_parecer_w);
		
	ELSIF (ie_tipo_p = 'ME') THEN

		nr_seq_parecer_w := gerar_parecer_solic_mat_cpoe(nr_encaminhamento_p, ds_conteudo_w, nr_seq_regulacao_p, nr_seq_parecer_w);

	ELSIF (ie_tipo_p = 'SV') THEN

		nr_seq_parecer_w := gerar_parecer_solic_vagas(nr_encaminhamento_p, ds_conteudo_w, nr_seq_regulacao_p, nr_seq_parecer_w);

	ELSIF (ie_tipo_p = 'FA') THEN	
		nr_seq_parecer_w := gerar_parecer_farmacia_ambu(nr_encaminhamento_p, ds_conteudo_w, nr_seq_regulacao_p, nr_seq_parecer_w);
		
	ELSIF (ie_tipo_p = 'SH') THEN	
		nr_seq_parecer_w := gerar_parecer_home_care(nr_encaminhamento_p, ds_conteudo_w, nr_seq_regulacao_p, nr_seq_parecer_w);
	END IF;

	if (ie_tipo_p <> 'EV' and coalesce(nr_seq_parecer_w,0) > 0) then
		cd_evolucao_w := gerar_nota_clinica_req_parecer(nr_seq_parecer_w, cd_evolucao_w);
	end if;



		
	SELECT	MAX(ie_integracao)
	INTO STRICT	ie_integracao_w
	FROM 	grupo_regulacao
	WHERE 	nr_sequencia = nr_seq_grupo_regulacao_p
	AND		ie_situacao = 'A';
  	
		
	nr_seq_reg_atend_w := gerar_regulacao_atend(nr_encaminhamento_p, ie_tipo_p, ie_informacao_p, nr_seq_informacao_p, cd_evolucao_w, nr_seq_parecer_w, NULL, nr_seq_grupo_regulacao_p, nr_seq_reg_atend_w);

	IF((coalesce(ie_integracao_w, 'N') = 'S') OR (coalesce(ie_integracao_w,'N') = 'T'))THEN


		SELECT BIFROST.SEND_INTEGRATION(
		'regulation.worklist',
		'com.philips.tasy.integration.atepac.regulation.regulationWorkList.RegulationWorkList',
		'{"regulationSequence" : '|| nr_seq_reg_atend_w || '}',
		nm_usuario_w)
		INTO STRICT ds_retorno_integracao_w
		;

	ELSE
		CALL gerar_worklist_regulacao(nr_seq_reg_atend_w, ie_tipo_p);
	END IF;

elsif ( ie_tipo_p = 'EN') THEN


		nr_seq_parecer_w := gerar_parecer_encaminhamento(nr_encaminhamento_p, nr_seq_parecer_w);
		
		
		cd_evolucao_w := gerar_nota_clinica_req_parecer(nr_seq_parecer_w, cd_evolucao_w);

		
		SELECT	obter_regulacao_med_esp(cd_especialidade, cd_medico_dest, 'RC','N','S'),
				obter_regulacao_med_esp(cd_especialidade, cd_medico_dest ,'RC','S','S'),
				cd_especialidade,
				cd_medico_dest
		INTO STRICT	nr_seq_regulacao_reg_w,
				nr_seq_grupo_regulacao_reg_w,
				cd_especialidade_w,
				cd_pessoa_fisica_med_dest_w
		FROM	atend_encaminhamento
		WHERE	nr_sequencia = nr_encaminhamento_p;
		

		if (nr_seq_grupo_regulacao_reg_w IS NOT NULL AND nr_seq_grupo_regulacao_reg_w::text <> '') then
   
			CALL insere_ref_contrarreferencia(nr_seq_parecer_w,nm_usuario_reg_p);

			SELECT	MAX(ie_integracao)
			INTO STRICT	ie_integracao_w
			FROM 	grupo_regulacao
			WHERE 	nr_sequencia = nr_seq_grupo_regulacao_reg_w
			AND		ie_situacao = 'A';
			

			if (cd_evolucao_w IS NOT NULL AND cd_evolucao_w::text <> '') then

				select 	max(nr_atendimento),
						max(cd_pessoa_fisica)
				into STRICT	nr_atendimento_w,
						cd_pessoa_fisica_w
				from 	evolucao_paciente
				where	cd_evolucao = cd_evolucao_w;

				Select (clock_timestamp() + interval '30 days')
				into STRICT	dt_fim_w
				;

				IF((coalesce(ie_integracao_w, 'N') = 'S') OR (coalesce(ie_integracao_w,'N') = 'T'))THEN

					SELECT BIFROST.SEND_INTEGRATION(
					'clinicalnotes.opinioncounterreferral',
					'com.philips.tasy.integration.atepac.clinicalNotes.opinionCounterReferral.OpinionCounterReferral',
					'{"opinionSequence" : '|| nr_seq_parecer_w || '}',
					nm_usuario_w)
					INTO STRICT ds_retorno_integracao_w
					;

				else
				
			
					select	max(nr_seq_grupo_regulacao)
					into STRICT 	nr_seq_grupo_reg_w
					from 	regra_regulacao
					where	ie_tipo = 'RC'
					and		coalesce(ie_tipo_parecer,'R') = 'C'
					and		coalesce(cd_especialidade,coalesce(cd_especialidade_w,0)) = coalesce(cd_especialidade_w,0)
					and		coalesce(cd_medico_dest,coalesce(cd_pessoa_fisica_med_dest_w,0)) = coalesce(cd_pessoa_fisica_med_dest_w,0);
					


					if (nr_seq_grupo_reg_w IS NOT NULL AND nr_seq_grupo_reg_w::text <> '') then
					
						Select 	max(wheb_usuario_pck.get_cd_estabelecimento),
								max(obter_perfil_ativo),
								max(obter_especialidade_pf(Obter_dados_usuario_opcao(nm_usuario_w,'C')))
						into STRICT	cd_estabelecimento_w,
								cd_perfil_w,
								cd_especialidade_usuario_w
						;
						
						select  max(nr_seq_work_item )
						into STRICT	nr_seq_work_item_w
						from	grupo_regulacao_lib
						where 	nr_seq_grupo_regulacao = nr_seq_grupo_reg_w
						and		coalesce(cd_estabelecimento,coalesce(cd_estabelecimento_w,0)) = coalesce(cd_estabelecimento_w,0)
						and		coalesce(cd_perfil,coalesce(cd_perfil_w,0)) = coalesce(cd_perfil_w,0)
						and		coalesce(cd_especialidade,coalesce(cd_especialidade_usuario_w,0)) = coalesce(cd_especialidade_usuario_w,0)	
						and		coalesce(nm_usuario_exclusivo,coalesce(nm_usuario_w,0)) = coalesce(nm_usuario_w,0)
						and 	coalesce(ie_situacao,'A') = 'A';
						
						if (nr_seq_work_item_w IS NOT NULL AND nr_seq_work_item_w::text <> '') then

							CALL gerar_registro_worklist(nr_atendimento_w,clock_timestamp(),nm_usuario_w,clock_timestamp(),dt_fim_w,cd_pessoa_fisica_w,nr_seq_work_item_w);
							
						end if;
						
					end if;

				end if;

			end if;

		end if;

ELSE
	CALL gerar_lista_espera_pep( nr_encaminhamento_p, nm_tabela_reg_p, nm_usuario_reg_p);
END IF;

END;

BEGIN

IF (nr_seq_encaminhamento_p IS NOT NULL AND nr_seq_encaminhamento_p::text <> '') THEN

	nm_usuario_w := wheb_usuario_pck.get_nm_usuario;

	IF (UPPER(nm_tabela_p) = 'ATEND_ENCAMINHAMENTO') THEN

		ie_tipo_w := 'EN';

		SELECT	obter_regulacao_med_esp(cd_especialidade, cd_medico_dest, ie_tipo_w),
				obter_regulacao_med_esp(cd_especialidade, cd_medico_dest ,ie_tipo_w,'S')
		INTO STRICT	nr_seq_regulacao_w,
				nr_seq_grupo_regulacao_w
		FROM	atend_encaminhamento
		WHERE	nr_sequencia = nr_seq_encaminhamento_p;

		gerar_processo_regulacao(ie_tipo_w, nr_seq_encaminhamento_p,nm_tabela_p,nm_usuario_w, ds_conteudo_w, nr_seq_regulacao_w, nr_seq_grupo_regulacao_w,NULL,NULL);

	ELSIF (UPPER(nm_tabela_p) = 'EVOLUCAO_PACIENTE') THEN

	ie_tipo_w := 'EV';

	SELECT	obter_regulacao_med_esp(cd_especialidade, cd_medico_parecer, 'EN'),
				obter_regulacao_med_esp(cd_especialidade, cd_medico_parecer, 'EN','S')
	INTO STRICT	nr_seq_regulacao_w,
			nr_seq_grupo_regulacao_w
	FROM	evolucao_paciente
	WHERE	cd_evolucao = nr_seq_encaminhamento_p;

	gerar_processo_regulacao( ie_tipo_w, nr_seq_encaminhamento_p,nm_tabela_p,nm_usuario_w, ds_conteudo_w, nr_seq_regulacao_w,nr_seq_grupo_regulacao_w,NULL,NULL);

	ELSIF (UPPER(nm_tabela_p) = 'PEDIDO_EXAME_EXTERNO') THEN

		ie_tipo_w := 'SE';

		SELECT 	Obter_desc_expressao(297049) -- Quantidade
		INTO STRICT	ds_complemento_w
		;

		OPEN C01;
		LOOP
		FETCH C01 INTO
			nr_seq_pedido_item_w,
			nr_seq_exame_cad_w,
			nr_seq_exame_w,
			cd_material_exame_w,
			cd_procedimento_w,
			nr_seq_proc_interno_w,
			ie_origem_proced_w,
			ds_justificativa_w,
			qt_exame_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			BEGIN

			IF (nr_seq_exame_cad_w IS NOT NULL AND nr_seq_exame_cad_w::text <> '') THEN

				SELECT	obter_regulacao_exame(nr_seq_exame_cad_w,NULL,NULL,NULL,NULL,NULL,ie_tipo_w,'N'),
						obter_regulacao_exame(nr_seq_exame_cad_w,NULL,NULL,NULL,NULL,NULL,ie_tipo_w,'S')
				INTO STRICT	nr_seq_regulacao_w,
						nr_seq_grupo_regulacao_w
				;

				SELECT 	ds_exame
				INTO STRICT	ds_conteudo_w
				FROM 	med_exame_padrao
				WHERE 	nr_sequencia = nr_seq_exame_cad_w;

				IF (qt_exame_w IS NOT NULL AND qt_exame_w::text <> '') THEN

					IF (ds_conteudo_w IS NOT NULL AND ds_conteudo_w::text <> '') THEN
						ds_conteudo_w := ds_conteudo_w || ds_enter_w;
					END IF;

					ds_conteudo_w := ds_conteudo_w || '<b>' || ds_complemento_w|| ' : ' || '</b>'  || qt_exame_w;

				END IF;

				IF (ds_justificativa_w IS NOT NULL AND ds_justificativa_w::text <> '') THEN

					IF (ds_conteudo_w IS NOT NULL AND ds_conteudo_w::text <> '') THEN
						ds_conteudo_w := ds_conteudo_w || ds_enter_w;
					END IF;

					ds_conteudo_w := ds_conteudo_w || '<b>' || wheb_mensagem_pck.get_texto(1011867,NULL) || ' : ' || '</b>' || REPLACE(ds_justificativa_w,  CHR(10), '<br>') ||' <br>';

				END IF;


				gerar_processo_regulacao(ie_tipo_w,nr_seq_encaminhamento_p,nm_tabela_p, nm_usuario_w, ds_conteudo_w, nr_seq_regulacao_w,nr_seq_grupo_regulacao_w,'SEC',nr_seq_pedido_item_w);

			ELSIF (nr_seq_exame_w IS NOT NULL AND nr_seq_exame_w::text <> '') THEN

				SELECT	obter_regulacao_exame(NULL,nr_seq_exame_w,NULL,NULL,NULL,cd_material_exame_w, ie_tipo_w,'N'),
						obter_regulacao_exame(NULL,nr_seq_exame_w,NULL,NULL,NULL,cd_material_exame_w, ie_tipo_w,'S')
				INTO STRICT	nr_seq_regulacao_w,
						nr_seq_grupo_regulacao_w
				;


				SELECT 	obter_desc_exame(nr_seq_exame_w)
				INTO STRICT	ds_conteudo_w
				;

				IF (qt_exame_w IS NOT NULL AND qt_exame_w::text <> '') THEN

					IF (ds_conteudo_w IS NOT NULL AND ds_conteudo_w::text <> '') THEN
						ds_conteudo_w := ds_conteudo_w || ds_enter_w;
					END IF;

					ds_conteudo_w := ds_conteudo_w || '<b>' || ds_complemento_w|| ' : ' || '</b>' || ' ' || qt_exame_w;

				END IF;

				IF (ds_justificativa_w IS NOT NULL AND ds_justificativa_w::text <> '') THEN

					IF (ds_conteudo_w IS NOT NULL AND ds_conteudo_w::text <> '') THEN
						ds_conteudo_w := ds_conteudo_w || ds_enter_w;
					END IF;

					ds_conteudo_w := ds_conteudo_w || '<b>' || wheb_mensagem_pck.get_texto(1011867,NULL) || ' : ' || '</b>' || REPLACE(ds_justificativa_w,  CHR(10), '<br>') ||' <br>';

				END IF;

				gerar_processo_regulacao(ie_tipo_w,nr_seq_encaminhamento_p,nm_tabela_p,nm_usuario_w, ds_conteudo_w, nr_seq_regulacao_w,nr_seq_grupo_regulacao_w,'SE',nr_seq_pedido_item_w);

			ELSIF ( (cd_procedimento_w IS NOT NULL AND cd_procedimento_w::text <> '') AND coalesce(nr_seq_proc_interno_w::text, '') = '') THEN
				SELECT	obter_regulacao_exame(NULL,NULL,NULL,cd_procedimento_w,ie_origem_proced_w,NULL, ie_tipo_w,'N'),
						obter_regulacao_exame(NULL,NULL,NULL,cd_procedimento_w,ie_origem_proced_w,NULL, ie_tipo_w,'S')
				INTO STRICT	nr_seq_regulacao_w,
						nr_seq_grupo_regulacao_w
				;

				SELECT 	obter_descricao_procedimento(cd_procedimento_w,ie_origem_proced_w)
				INTO STRICT	ds_conteudo_w
				;

				IF (qt_exame_w IS NOT NULL AND qt_exame_w::text <> '') THEN

					IF (ds_conteudo_w IS NOT NULL AND ds_conteudo_w::text <> '') THEN
						ds_conteudo_w := ds_conteudo_w || ds_enter_w;
					END IF;

					ds_conteudo_w := ds_conteudo_w || '<b>' || ds_complemento_w|| ' : ' || '</b>' || qt_exame_w;

				END IF;

				IF (ds_justificativa_w IS NOT NULL AND ds_justificativa_w::text <> '') THEN

					IF (ds_conteudo_w IS NOT NULL AND ds_conteudo_w::text <> '') THEN
						ds_conteudo_w := ds_conteudo_w || ds_enter_w;
					END IF;

					ds_conteudo_w := ds_conteudo_w || '<b>' || wheb_mensagem_pck.get_texto(1011867,NULL) || ' : ' || '</b>' || REPLACE(ds_justificativa_w,  CHR(10), '<br>') ||' <br>';

				END IF;


				gerar_processo_regulacao(ie_tipo_w,nr_seq_encaminhamento_p,nm_tabela_p,nm_usuario_w, ds_conteudo_w, nr_seq_regulacao_w,nr_seq_grupo_regulacao_w,'SP',nr_seq_pedido_item_w);

			ELSIF (nr_seq_proc_interno_w IS NOT NULL AND nr_seq_proc_interno_w::text <> '') THEN

				SELECT	obter_regulacao_exame(NULL,NULL,nr_seq_proc_interno_w,cd_procedimento_w,ie_origem_proced_w,NULL,ie_tipo_w,'N'),
						obter_regulacao_exame(NULL,NULL,nr_seq_proc_interno_w,cd_procedimento_w,ie_origem_proced_w,NULL,ie_tipo_w,'S')
				INTO STRICT	nr_seq_regulacao_w,
						nr_seq_grupo_regulacao_w
				;

				SELECT 	obter_desc_proc_interno(nr_seq_proc_interno_w)
				INTO STRICT	ds_conteudo_w
				;

				IF (qt_exame_w IS NOT NULL AND qt_exame_w::text <> '') THEN

					IF (ds_conteudo_w IS NOT NULL AND ds_conteudo_w::text <> '') THEN
						ds_conteudo_w := ds_conteudo_w || ds_enter_w;
					END IF;

					ds_conteudo_w := ds_conteudo_w || '<b>' || ds_complemento_w|| ' : ' || '</b>'  || qt_exame_w;

				END IF;

				IF (ds_justificativa_w IS NOT NULL AND ds_justificativa_w::text <> '') THEN

					IF (ds_conteudo_w IS NOT NULL AND ds_conteudo_w::text <> '') THEN
						ds_conteudo_w := ds_conteudo_w || ds_enter_w;
					END IF;

					ds_conteudo_w := ds_conteudo_w || '<b>' || wheb_mensagem_pck.get_texto(1011867,NULL) || ' : ' || '</b>' || REPLACE(ds_justificativa_w,  CHR(10), '<br>') ||' <br>';

				END IF;

				gerar_processo_regulacao(ie_tipo_w,nr_seq_encaminhamento_p,nm_tabela_p,nm_usuario_w, ds_conteudo_w, nr_seq_regulacao_w,nr_seq_grupo_regulacao_w,'SPI',nr_seq_pedido_item_w);

			END IF;


			END;
		END LOOP;
		CLOSE C01;

	ELSIF (UPPER(nm_tabela_p) = 'SOLIC_TRANSF_EXTERNA') THEN

		ie_tipo_w := 'TC';

		SELECT	obter_regulacao_cuidado(nr_seq_motivo_solic_externa, ie_tipo_w,'N'),
				obter_regulacao_cuidado(nr_seq_motivo_solic_externa, ie_tipo_w,'S'),
				SUBSTR(obter_motivo_solic_ext(nr_seq_motivo_solic_externa),1,90),
				ds_observacao,
				dt_geracao_vaga
		INTO STRICT	nr_seq_regulacao_w,
				nr_seq_grupo_regulacao_w,
				ds_motivo_w,
				ds_justificativa_w,
				dt_previsao_w
		FROM	solic_transf_externa
		WHERE	nr_sequencia = nr_seq_encaminhamento_p;


		SELECT 	Obter_desc_expressao(293478), -- Motivo
				Obter_desc_expressao(287126)  -- Data prevista
		INTO STRICT	ds_complemento_w,
				ds_data_prevista_w
		;

		IF (ds_motivo_w IS NOT NULL AND ds_motivo_w::text <> '') THEN
			ds_conteudo_w := ds_conteudo_w || ds_enter_w ||'<b>' || ds_complemento_w || ' : ' || '</b>' ||  REPLACE(ds_motivo_w,  CHR(10), '<br>');
		END IF;


		IF (dt_previsao_w IS NOT NULL AND dt_previsao_w::text <> '') THEN
			ds_conteudo_w := ds_conteudo_w || ds_enter_w ||'<b>' || ds_data_prevista_w || ' : ' || '</b>' || PKG_DATE_FORMATERS_TZ.TO_VARCHAR(dt_previsao_w,'shortDate', ESTABLISHMENT_TIMEZONE_UTILS.getTimezone);
		END IF;


		IF (ds_justificativa_w IS NOT NULL AND ds_justificativa_w::text <> '') THEN

			IF (ds_conteudo_w IS NOT NULL AND ds_conteudo_w::text <> '') THEN
				ds_conteudo_w := ds_conteudo_w || ds_enter_w;
			END IF;

			ds_conteudo_w := ds_conteudo_w || '<b>' || wheb_mensagem_pck.get_texto(1011867,NULL) || ' : ' || '</b>' || REPLACE(ds_justificativa_w,  CHR(10), '<br>');

		END IF;



		gerar_processo_regulacao(ie_tipo_w, nr_seq_encaminhamento_p,nm_tabela_p,nm_usuario_w, ds_conteudo_w, nr_seq_regulacao_w,nr_seq_grupo_regulacao_w,NULL,NULL);


	ELSIF (UPPER(nm_tabela_p) = 'REQUISICAO_ITEM') THEN

		ie_tipo_w := 'EQ';


		SELECT 	Obter_desc_expressao(297049), -- Quantidade
				Obter_desc_expressao(299616) -- Tipo de equipamento
		INTO STRICT	ds_complemento_w,
				ds_tit_tipo_equipamento_w
		;

		OPEN C02;
		LOOP
		FETCH C02 INTO
			nr_seq_requisicao_w,
			nr_seq_equipamento_w,
			nr_seq_tipo_equip_w,
			ds_observacao_w,
			ds_justificativa_w,
			qt_requisitada_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			BEGIN

			IF (nr_seq_equipamento_w IS NOT NULL AND nr_seq_equipamento_w::text <> '') THEN

				SELECT	obter_regulacao_equipamentos(nr_seq_equipamento_w,nr_seq_tipo_equip_w,ie_tipo_w,'N'),
						obter_regulacao_equipamentos(nr_seq_equipamento_w,nr_seq_tipo_equip_w,ie_tipo_w,'S')
				INTO STRICT	nr_seq_regulacao_w,
						nr_seq_grupo_regulacao_w
				;

				SELECT 	SUBSTR(man_obter_desc_equipamento(nr_seq_equipamento_w),1,255),
						SUBSTR(man_obter_desc_tipo_equip(nr_seq_tipo_equip_w),1,255)
				INTO STRICT	ds_conteudo_w,
						ds_tit_tipo_equipamento_w
				;

				IF (nr_seq_tipo_equip_w IS NOT NULL AND nr_seq_tipo_equip_w::text <> '') THEN

					ds_conteudo_w := ds_conteudo_w || '<b>' || ds_tit_tipo_equipamento_w|| ' : ' || '</b>' || ds_tipo_equipamento_w;

				END IF;

				IF (qt_requisitada_w IS NOT NULL AND qt_requisitada_w::text <> '') THEN

					IF (ds_conteudo_w IS NOT NULL AND ds_conteudo_w::text <> '') THEN
						ds_conteudo_w := ds_conteudo_w || ds_enter_w;
					END IF;

					ds_conteudo_w := ds_conteudo_w || '<b>' || ds_complemento_w|| ' : ' || '</b>' ||qt_requisitada_w;

				END IF;

				IF (ds_observacao_w IS NOT NULL AND ds_observacao_w::text <> '') THEN

					IF (ds_conteudo_w IS NOT NULL AND ds_conteudo_w::text <> '') THEN
						ds_conteudo_w := ds_conteudo_w || ds_enter_w;
					END IF;

					ds_conteudo_w := ds_conteudo_w || '<b>' || wheb_mensagem_pck.get_texto(49042,NULL) || '</b>' ||REPLACE(ds_observacao_w,  CHR(10), '<br>');

				END IF;

				IF (ds_justificativa_w IS NOT NULL AND ds_justificativa_w::text <> '') THEN

					IF (ds_conteudo_w IS NOT NULL AND ds_conteudo_w::text <> '') THEN
						ds_conteudo_w := ds_conteudo_w || ds_enter_w;
					END IF;

					ds_conteudo_w := ds_conteudo_w || '<b>' || wheb_mensagem_pck.get_texto(1011867,NULL) || ' : ' || '</b>' || REPLACE(ds_justificativa_w,  CHR(10), '<br>');

				END IF;

				gerar_processo_regulacao(ie_tipo_w,nr_seq_encaminhamento_p,nm_tabela_p, nm_usuario_w, ds_conteudo_w, nr_seq_regulacao_w,nr_seq_grupo_regulacao_w,NULL,nr_seq_requisicao_w);

			END IF;

			END;
		END LOOP;
		CLOSE C02;

	ELSIF (UPPER(nm_tabela_p) = 'HC_PAC_EQUIPAMENTO') THEN

		ie_tipo_w := 'EQ';


		SELECT 	Obter_desc_expressao(297049), -- Quantidade
				Obter_desc_expressao(299616) -- Tipo de equipamento
		INTO STRICT	ds_complemento_w,
				ds_tit_tipo_equipamento_w
		;

		SELECT NR_SEQUENCIA,
			NR_SEQ_EQUIP_CONTROL,
			HC_SEQ_TIPO_EQUIP(NR_SEQ_EQUIP_CONTROL),
			'',
			'',
			1
		INTO STRICT nr_seq_requisicao_w,
			nr_seq_equipamento_w,
			nr_seq_tipo_equip_w,
			ds_observacao_w,
			ds_justificativa_w,
			qt_requisitada_w
		FROM HC_PAC_EQUIPAMENTO
		WHERE NR_SEQUENCIA = nr_seq_encaminhamento_p;

		IF (nr_seq_equipamento_w IS NOT NULL AND nr_seq_equipamento_w::text <> '') THEN

			SELECT	obter_regulacao_equipamentos(nr_seq_equipamento_w,nr_seq_tipo_equip_w,ie_tipo_w,'N'),
					obter_regulacao_equipamentos(nr_seq_equipamento_w,nr_seq_tipo_equip_w,ie_tipo_w,'S')
			INTO STRICT	nr_seq_regulacao_w,
					nr_seq_grupo_regulacao_w
			;

			SELECT 	SUBSTR(man_obter_desc_equipamento(nr_seq_equipamento_w),1,255),
					SUBSTR(man_obter_desc_tipo_equip(nr_seq_tipo_equip_w),1,255)
			INTO STRICT	ds_conteudo_w,
					ds_tit_tipo_equipamento_w
			;

			IF (nr_seq_tipo_equip_w IS NOT NULL AND nr_seq_tipo_equip_w::text <> '') THEN

				ds_conteudo_w := ds_conteudo_w || '<b>' || ds_tit_tipo_equipamento_w|| ' : ' || '</b>' || ds_tipo_equipamento_w;

			END IF;

			IF (qt_requisitada_w IS NOT NULL AND qt_requisitada_w::text <> '') THEN

				IF (ds_conteudo_w IS NOT NULL AND ds_conteudo_w::text <> '') THEN
					ds_conteudo_w := ds_conteudo_w || ds_enter_w;
				END IF;

				ds_conteudo_w := ds_conteudo_w || '<b>' || ds_complemento_w|| ' : ' || '</b>' ||qt_requisitada_w;

			END IF;

			IF (ds_observacao_w IS NOT NULL AND ds_observacao_w::text <> '') THEN

				IF (ds_conteudo_w IS NOT NULL AND ds_conteudo_w::text <> '') THEN
					ds_conteudo_w := ds_conteudo_w || ds_enter_w;
				END IF;

				ds_conteudo_w := ds_conteudo_w || '<b>' || wheb_mensagem_pck.get_texto(49042,NULL) || '</b>' ||REPLACE(ds_observacao_w,  CHR(10), '<br>');

			END IF;

			IF (ds_justificativa_w IS NOT NULL AND ds_justificativa_w::text <> '') THEN

				IF (ds_conteudo_w IS NOT NULL AND ds_conteudo_w::text <> '') THEN
					ds_conteudo_w := ds_conteudo_w || ds_enter_w;
				END IF;

				ds_conteudo_w := ds_conteudo_w || '<b>' || wheb_mensagem_pck.get_texto(1011867,NULL) || ' : ' || '</b>' || REPLACE(ds_justificativa_w,  CHR(10), '<br>');

			END IF;

			gerar_processo_regulacao(ie_tipo_w,nr_seq_encaminhamento_p,nm_tabela_p, nm_usuario_w, ds_conteudo_w, nr_seq_regulacao_w,nr_seq_grupo_regulacao_w,'HC',nr_seq_requisicao_w);

		END IF;

	ELSIF (UPPER(nm_tabela_p) = 'CPOE_MATERIAL') THEN

		ie_tipo_w := 'ME';

		SELECT	obter_regulacao_medic(c.cd_material, ie_tipo_w,'N'),
				obter_regulacao_medic(c.cd_material, ie_tipo_w,'S'),
				cpoe_obter_desc_info_material(  c.cd_material,
											c.cd_mat_comp1,
											c.qt_dose_comp1,
											c.cd_unid_med_dose_comp1,
											c.cd_mat_comp2,
											c.qt_dose_comp2,
											c.cd_unid_med_dose_comp2,
											c.cd_mat_comp3,
											c.qt_dose_comp3,
											c.cd_unid_med_dose_comp3,
											c.cd_mat_dil,
											c.qt_dose_dil,
											c.cd_unid_med_dose_dil,
											c.cd_mat_red,
											c.qt_dose_red,
											c.cd_unid_med_dose_red,
											c.dt_liberacao,
											c.qt_dose,
											c.cd_unidade_medida,
											c.ie_via_aplicacao,
											c.cd_intervalo,
											c.dt_lib_suspensao,
											c.dt_suspensao,
											c.ie_administracao,
											c.nr_seq_ataque,
											c.nr_seq_procedimento,
											c.nr_seq_adicional,
											c.nr_seq_hemoterapia,
											c.ds_dose_diferenciada,
											c.ds_dose_diferenciada_dil,
											c.ds_dose_diferenciada_red,
											c.ds_dose_diferenciada_comp1,
											c.ds_dose_diferenciada_comp2,
											c.ds_dose_diferenciada_comp3,
											c.cd_mat_comp4,
											c.qt_dose_comp4,
											c.cd_unid_med_dose_comp4,
											c.ds_dose_diferenciada_comp4,
											c.cd_mat_comp5,
											c.qt_dose_comp5,
											c.cd_unid_med_dose_comp5,
											c.ds_dose_diferenciada_comp5,
											c.cd_mat_comp6,
											c.qt_dose_comp6,
											c.cd_unid_med_dose_comp6,
											c.ds_dose_diferenciada_comp6),
				c.ds_justificativa,
				c.ds_observacao
		INTO STRICT	nr_seq_regulacao_w,
				nr_seq_grupo_regulacao_w,
				ds_conteudo_w,
				ds_justificativa_w,
				ds_observacao_w
		FROM	cpoe_material c
		WHERE	c.nr_sequencia = nr_seq_encaminhamento_p;
		
	
		IF (ds_observacao_w IS NOT NULL AND ds_observacao_w::text <> '') THEN

			IF (ds_conteudo_w IS NOT NULL AND ds_conteudo_w::text <> '') THEN
				ds_conteudo_w := ds_conteudo_w || ds_enter_w;
			END IF;

			ds_conteudo_w := ds_conteudo_w || '<b>' || wheb_mensagem_pck.get_texto(49042,NULL) || '</b>' || REPLACE(ds_observacao_w,  CHR(10), '<br>');

		END IF;


		IF (ds_justificativa_w IS NOT NULL AND ds_justificativa_w::text <> '') THEN

			IF (ds_conteudo_w IS NOT NULL AND ds_conteudo_w::text <> '') THEN
				ds_conteudo_w := ds_conteudo_w || ds_enter_w;
			END IF;

			ds_conteudo_w := ds_conteudo_w || '<b>' || wheb_mensagem_pck.get_texto(1011867,NULL) || ' : ' || '</b>' || REPLACE(ds_justificativa_w,  CHR(10), '<br>');

		END IF;



		gerar_processo_regulacao(ie_tipo_w, nr_seq_encaminhamento_p,nm_tabela_p,nm_usuario_w, ds_conteudo_w, nr_seq_regulacao_w,nr_seq_grupo_regulacao_w,NULL,NULL);


	ELSIF (UPPER(nm_tabela_p) = 'CPOE_PROCEDIMENTO') THEN

		ie_tipo_w := 'CPOE';

		SELECT 	Obter_desc_expressao(297049) -- Quantidade
		INTO STRICT	ds_complemento_w
		;

		SELECT	obter_regulacao_exame(NULL,NULL,nr_seq_proc_interno,NULL,NULL,NULL,ie_tipo_w,'N'),
				obter_regulacao_exame(NULL,NULL,nr_seq_proc_interno,NULL,NULL,NULL,ie_tipo_w,'S'),
				cpoe_obter_desc_proc_interno(nr_seq_proc_interno),
				qt_procedimento,
				ds_justificativa,
				ds_observacao
		INTO STRICT	nr_seq_regulacao_w,
				nr_seq_grupo_regulacao_w,
				ds_conteudo_w,
				qt_procedimento_w,
				ds_justificativa_w,
				ds_observacao_w
		FROM 	cpoe_procedimento
		WHERE	nr_sequencia =  nr_seq_encaminhamento_p;

		SELECT 	obter_desc_proc_interno(nr_seq_proc_interno_w)
		INTO STRICT	ds_conteudo_w
		;

		IF (qt_procedimento_w IS NOT NULL AND qt_procedimento_w::text <> '') THEN

			IF (ds_conteudo_w IS NOT NULL AND ds_conteudo_w::text <> '') THEN
				ds_conteudo_w := ds_conteudo_w;
			END IF;

			ds_conteudo_w := ds_conteudo_w || '<b>'  || ds_complemento_w|| ' : ' ||  '</b>' || qt_exame_w ||' <br>';

		END IF;

		IF (ds_observacao_w IS NOT NULL AND ds_observacao_w::text <> '') THEN

					IF (ds_conteudo_w IS NOT NULL AND ds_conteudo_w::text <> '') THEN
						ds_conteudo_w := ds_conteudo_w || ds_enter_w;
					END IF;

			ds_conteudo_w := ds_conteudo_w || '<b>'  || wheb_mensagem_pck.get_texto(49042,NULL) || '</b>'  || REPLACE(ds_observacao_w,  CHR(10), '<br>');

				END IF;

		IF (ds_justificativa_w IS NOT NULL AND ds_justificativa_w::text <> '') THEN

			IF (ds_conteudo_w IS NOT NULL AND ds_conteudo_w::text <> '') THEN
				ds_conteudo_w := ds_conteudo_w || ds_enter_w;
			END IF;

			ds_conteudo_w := ds_conteudo_w || '<b>'  || wheb_mensagem_pck.get_texto(1011867,NULL) || ' : ' || '</b>' || '<br>' || REPLACE(ds_justificativa_w,  CHR(10), '<br>');

		END IF;

		gerar_processo_regulacao(ie_tipo_w,nr_seq_encaminhamento_p,nm_tabela_p,nm_usuario_w, ds_conteudo_w, nr_seq_regulacao_w,nr_seq_grupo_regulacao_w,NULL,NULL);

	ELSIF (UPPER(nm_tabela_p) = 'GESTAO_VAGA') THEN

		ie_tipo_w := 'SV';

		SELECT obter_regulacao_gestao_vagas(ie_solicitacao, ie_tipo_vaga),
				ds_observacao
		INTO STRICT nr_seq_regulacao_w,
			ds_conteudo_w
		FROM gestao_vaga
		WHERE nr_sequencia =  nr_seq_encaminhamento_p;

		gerar_processo_regulacao(ie_tipo_w, nr_seq_encaminhamento_p, nm_tabela_p, nm_usuario_w, ds_conteudo_w, nr_seq_regulacao_w, NULL, NULL, NULL);
		
	ELSIF (UPPER(nm_tabela_p) = 'FA_LIBERAR_RECEITA') THEN
		ie_tipo_w := 'FA';

		select  obter_regulacao_medic(a.cd_material, 'ME','N') nr_seq_regra_regulacao,
				obter_regulacao_medic(a.cd_material, 'ME','S') nr_seq_grupo_regulacao,
				a.cd_material cd_material,
				a.ie_via_aplicacao ie_via_aplicacao,
				a.qt_dose qt_dose,
				a.cd_unidade_medida cd_unidade_medida,
				a.cd_intervalo cd_intervalo,
				a.ds_justificativa ds_justificativa,
				b.dt_inicio_receita dt_inicio_receita_far,
				b.nr_dias_receita nr_dias_receita,
				b.dt_validade_receita dt_validade_receita_far,
				b.ie_tipo_receita ie_tipo_receita,
				b.ds_observacao ds_observacao
		into STRICT    nr_seq_regra_regulacao_w,
				nr_seq_grupo_regulacao_w,
				cd_material_w,
				ie_via_aplicacao_w,
				qt_dose_w,
				cd_unidade_medida_w,
				cd_intervalo_w,
				ds_justificativa_w,
				dt_inicio_receita_far_w,
				nr_dias_receita_w,
				dt_validade_receita_far_w,
				ie_tipo_receita_w,
				ds_observacao_w
		from	fa_receita_farmacia_item a,
				fa_receita_farmacia b
		where 	a.nr_seq_receita = b.nr_sequencia
		and     a.nr_sequencia = nr_seq_encaminhamento_p;
	
		IF (ds_conteudo_w IS NOT NULL AND ds_conteudo_w::text <> '') THEN
			ds_conteudo_w := ds_conteudo_w || ds_enter_w;
		END IF;

		ds_conteudo_w := ds_conteudo_w || '<b>' || wheb_mensagem_pck.get_texto(1074496,NULL) /*Receita*/ || ': ' || '</b>' || ds_enter_w;
			
		if (ie_tipo_receita_w IS NOT NULL AND ie_tipo_receita_w::text <> '') then
			
			select	max(obter_valor_dominio(5302, ie_tipo_receita_w))
			into STRICT 	ds_tipo_receita_w
			;
		
			ds_conteudo_w := ds_conteudo_w ||  wheb_mensagem_pck.get_texto(1074556,NULL) /*Tipo de receita*/
  || ': ' || ds_tipo_receita_w || ds_enter_w;
		
		end if;		
		
		if (dt_inicio_receita_far_w IS NOT NULL AND dt_inicio_receita_far_w::text <> '') then
		
			ds_conteudo_w := ds_conteudo_w || wheb_mensagem_pck.get_texto(1074557,NULL) /*Data de inicio*/
 || dt_inicio_receita_far_w || ds_enter_w;
			
		end if;
		
		
		if (nr_dias_receita_w IS NOT NULL AND nr_dias_receita_w::text <> '') then
				
			ds_conteudo_w := ds_conteudo_w || wheb_mensagem_pck.get_texto(1074558,NULL) /*Dias receita*/
 || ': ' || nr_dias_receita_w || ds_enter_w;
			
		end if;
		
		if (dt_validade_receita_far_w IS NOT NULL AND dt_validade_receita_far_w::text <> '') then
		
			ds_conteudo_w := ds_conteudo_w || wheb_mensagem_pck.get_texto(1074559,NULL) /*Validade*/
 || dt_validade_receita_far_w || ds_enter_w;
		
		end if;
		
		if (ds_observacao_w IS NOT NULL AND ds_observacao_w::text <> '') then
		
			ds_conteudo_w := ds_conteudo_w || wheb_mensagem_pck.get_texto(1074560,NULL)/*Observacao*/
  || ds_observacao_w || ds_enter_w;
		
		end if;
		
		
		ds_conteudo_w := ds_conteudo_w || '<b>' || wheb_mensagem_pck.get_texto(1074497,NULL)/*Medicamento*/ || '</b>' || ds_enter_w;
		
		if (cd_material_w IS NOT NULL AND cd_material_w::text <> '') then
		
			select  max(ds_material)
			into STRICT 	ds_material_w
			from	material
			where 	cd_material = cd_material_w;
			
			ds_conteudo_w := ds_conteudo_w || wheb_mensagem_pck.get_texto(1074561,NULL)/*Material*/
 || ': ' || ds_material_w || ds_enter_w;
		
		end if;
		
		if (qt_dose_w IS NOT NULL AND qt_dose_w::text <> '') then
		
			ds_conteudo_w := ds_conteudo_w || wheb_mensagem_pck.get_texto(1074572,NULL) /*Dose*/
 || ' ' || qt_dose_w || ds_enter_w;
		
		end if;
		
		if (cd_unidade_medida_w IS NOT NULL AND cd_unidade_medida_w::text <> '') then
			
			select  max(ds_unidade_medida)
			into STRICT 	ds_unidade_medida_w
			from    unidade_medida_dose_v
			where   upper(cd_unidade_medida) = upper(cd_unidade_medida_w);
			
			ds_conteudo_w := ds_conteudo_w || wheb_mensagem_pck.get_texto(1074573,NULL) /*Unidade de Medida*/
 || ': ' || ds_unidade_medida_w || ds_enter_w;
		
		end if;
		
		
		if (cd_intervalo_w IS NOT NULL AND cd_intervalo_w::text <> '') then
		
			select  max(coalesce(ds_prescricao,ds_intervalo))
			into STRICT 	ds_inter_presc_w
			from    intervalo_prescricao
			where   cd_intervalo = cd_intervalo_w;
		
			ds_conteudo_w := ds_conteudo_w || wheb_mensagem_pck.get_texto(1074574,NULL) /*Intervalo*/
 || ': ' || ds_inter_presc_w || ds_enter_w;
		
		end if;
		
		
		if (ie_via_aplicacao_w IS NOT NULL AND ie_via_aplicacao_w::text <> '') then
		
			select	max(ds_via_aplicacao)
			into STRICT 	ds_via_aplic_w
			from    via_aplicacao
			where	ie_via_aplicacao = ie_via_aplicacao_w;
			
			ds_conteudo_w := ds_conteudo_w || wheb_mensagem_pck.get_texto(1074575,NULL) /*Via de aplicacao*/
 || ': '  || ds_via_aplic_w || ds_enter_w;
		
		end if;

		if (ds_justificativa_w IS NOT NULL AND ds_justificativa_w::text <> '') then
			ds_conteudo_w := ds_conteudo_w || wheb_mensagem_pck.get_texto(1074577,NULL) /*Justificativa*/
 || ' ' || ds_justificativa_w || ds_enter_w;
		end if;
		
		gerar_processo_regulacao(ie_tipo_w, nr_seq_encaminhamento_p,nm_tabela_p,nm_usuario_w, ds_conteudo_w, nr_seq_regra_regulacao_w,nr_seq_grupo_regulacao_w,NULL,NULL);

	ElSIF (UPPER(nm_tabela_p) = 'PACIENTE_HOME_CARE') THEN

		ie_tipo_w := 'SH';

		SELECT	obter_regulacao_homecare( IE_CLASSIFICACAO, ie_tipo_w),
				obter_regulacao_homecare( IE_CLASSIFICACAO, ie_tipo_w,'S'),
				ie_classificacao,
				dt_inicio,
				nr_seq_origem,
				nr_seq_entidade,
				ds_observacao
		INTO STRICT	nr_seq_regulacao_w,
				nr_seq_grupo_regulacao_w,
				ie_classificacao_w,
				dt_inicio_w,
				nr_seq_origem_w,
				nr_seq_entidade_w,
				ds_observacao_w
		FROM	PACIENTE_HOME_CARE
		WHERE	nr_sequencia = nr_seq_encaminhamento_p;
		
		ds_conteudo_w := ds_conteudo_w || '<b>' || wheb_mensagem_pck.get_texto(945471,NULL) /*Solicitacao de home care*/ || ': ' || '</b>' || ds_enter_w;
			
		if (ie_classificacao_w IS NOT NULL AND ie_classificacao_w::text <> '') then
			
			select	max(obter_valor_dominio(1729, ie_classificacao_w))
			into STRICT 	ds_conteudo_home_care_w
			;
		
			ds_conteudo_w := ds_conteudo_w ||  wheb_mensagem_pck.get_texto(285105,NULL) /*Classificacao do servico*/
  || ': ' || ds_conteudo_home_care_w || ds_enter_w;
		
		end if;

		if (dt_inicio_w IS NOT NULL AND dt_inicio_w::text <> '') then
		
			Select  max(PKG_DATE_FORMATERS_TZ.TO_VARCHAR(dt_inicio_w,'shortDate', ESTABLISHMENT_TIMEZONE_UTILS.getTimezone))
			into STRICT	ds_conteudo_home_care_w
			;
		
			ds_conteudo_w := ds_conteudo_w ||  wheb_mensagem_pck.get_texto(286737,NULL) /*Data de inicio*/
  || ': ' || ds_conteudo_home_care_w || ds_enter_w;
		
		end if;	
		
		
		if (nr_seq_origem_w IS NOT NULL AND nr_seq_origem_w::text <> '') then
			
			select	max(obter_desc_hc_origem(nr_seq_origem_w))
			into STRICT 	ds_conteudo_home_care_w
			;
		
			ds_conteudo_w := ds_conteudo_w ||  wheb_mensagem_pck.get_texto(294924,NULL) /*Origem*/
  || ': ' || ds_conteudo_home_care_w || ds_enter_w;
		
		end if;	
		
		
		if (nr_seq_entidade_w IS NOT NULL AND nr_seq_entidade_w::text <> '') then
			
			select	max(obter_desc_hc_entidade(nr_seq_entidade_w))
			into STRICT 	ds_conteudo_home_care_w
			;
		
			ds_conteudo_w := ds_conteudo_w ||  wheb_mensagem_pck.get_texto(289262,NULL) /*Entidade*/
  || ': ' || ds_conteudo_home_care_w || ds_enter_w;
		
		end if;
		
		if (ds_observacao_w IS NOT NULL AND ds_observacao_w::text <> '') then
			
			select	max(substr(ds_observacao_w,1,255))
			into STRICT 	ds_conteudo_home_care_w
			;
		
			ds_conteudo_w := ds_conteudo_w ||  wheb_mensagem_pck.get_texto(294639,NULL) /*Observacao*/
  || ': ' || ds_conteudo_home_care_w || ds_enter_w;
		
		end if;	
		
		
		
		gerar_processo_regulacao(ie_tipo_w, nr_seq_encaminhamento_p,nm_tabela_p,nm_usuario_w, ds_conteudo_w, nr_seq_regulacao_w, nr_seq_grupo_regulacao_w,NULL,NULL);

		
	END IF;

END IF;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consistir_regulacao_pep ( nr_seq_encaminhamento_p bigint, nm_tabela_p text) FROM PUBLIC;

