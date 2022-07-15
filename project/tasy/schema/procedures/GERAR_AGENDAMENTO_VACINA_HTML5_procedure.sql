-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_agendamento_vacina_html5 (nr_atendimento_p bigint, cd_pessoa_fisica_p text, nr_seq_grupo_p bigint, nm_usuario_p text, nr_seq_vacina_p bigint) AS $body$
DECLARE


nr_seq_vacina_w bigint;

ie_dose_w varchar(3);

cd_procedimento_w bigint;

ie_origem_proced_w bigint;

cd_unid_medida_w varchar(30);

ie_via_aplicacao_w varchar(5);

ds_reacao_adversa_w varchar(255);

qt_dose_w double precision;

qt_prox_mes_w vacina_calendario.qt_prox_mes%type;

cd_cgc_w varchar(14);

dt_proxima_dose_w timestamp;

dt_prevista_execucao_w timestamp;

dt_nascimento_w timestamp;

cd_setor_atendimento_w integer;

qt_dias_idade_min_w bigint;

qt_dias_idade_max_w bigint;

ie_agenda_grupo_vacina_w varchar(1);

ie_permite_gerar_find_feriado varchar(1);

ie_manter_vinculo_atend_w varchar(1);

cd_medico_resp_w varchar(14);

nr_seq_lista_atend_w bigint;


C01 CURSOR FOR
SELECT a.nr_seq_vacina,
       b.ie_dose,
       b.cd_procedimento,
       b.ie_origem_proced,
       b.cd_unid_medida,
       b.ie_via_aplicacao,
       b.ds_reacao_adversa,
       b.qt_dose,
       coalesce(b.qt_prox_mes, 0),
       Obter_idade_min_max_vacina(b.nr_sequencia, 'MIN'),
       Obter_idade_min_max_vacina(b.nr_sequencia, 'MAX')
FROM vacina_grupo_vacina a,
     vacina_calendario b
WHERE b.nr_seq_vacina = a.nr_seq_vacina
  AND a.nr_seq_grupo = nr_seq_grupo_p  --and	ie_agenda_grupo_vacina_w = 'S'
  AND clock_timestamp()-dt_nascimento_w <= Obter_idade_min_max_vacina(b.nr_sequencia, 'MAX')
ORDER BY 1,
         2;


C02 CURSOR FOR
SELECT b.nr_seq_vacina,
       b.ie_dose,
       b.cd_procedimento,
       b.ie_origem_proced,
       b.cd_unid_medida,
       b.ie_via_aplicacao,
       b.ds_reacao_adversa,
       b.qt_dose,
       coalesce(b.qt_prox_mes, 0),
       Obter_idade_min_max_vacina(b.nr_sequencia, 'MIN'),
       Obter_idade_min_max_vacina(b.nr_sequencia, 'MAX')
FROM vacina_calendario b
WHERE nr_seq_vacina = nr_seq_vacina_p  --and	ie_agenda_grupo_vacina_w = 'N'
  AND clock_timestamp()-dt_nascimento_w <= Obter_idade_min_max_vacina(b.nr_sequencia, 'MAX')
ORDER BY 1,
         2;

		
C03 CURSOR FOR
SELECT nr_sequencia
FROM VACINA_LISTA_ESPERA
WHERE NR_ATENDIMENTO = nr_atendimento_p;


BEGIN

cd_setor_atendimento_w := obter_valor_param_usuario(903, 8, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento);

cd_cgc_w := obter_valor_param_usuario(903, 9, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento);

dt_nascimento_w := coalesce(obter_data_nascto_pf(cd_pessoa_fisica_p), obter_data_nascto_pf(obter_dados_atendimento(nr_atendimento_p, 'CP')));

ie_agenda_grupo_vacina_w := obter_param_usuario(903, 13, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_agenda_grupo_vacina_w);

ie_permite_gerar_find_feriado := obter_param_usuario(903, 15, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_permite_gerar_find_feriado);

ie_manter_vinculo_atend_w := obter_param_usuario(903, 26, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_manter_vinculo_atend_w);

IF (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') THEN
	SELECT cd_medico_resp
	INTO STRICT cd_medico_resp_w
	FROM atendimento_paciente
	WHERE nr_atendimento = nr_atendimento_p;
END IF;

IF (nr_seq_grupo_p IS NOT NULL AND nr_seq_grupo_p::text <> '') THEN OPEN C01;

LOOP FETCH C01 INTO nr_seq_vacina_w,
                    ie_dose_w,
                    cd_procedimento_w,
                    ie_origem_proced_w,
                    cd_unid_medida_w,
                    ie_via_aplicacao_w,
                    ds_reacao_adversa_w,
                    qt_dose_w,
                    qt_prox_mes_w,
                    qt_dias_idade_min_w,
                    qt_dias_idade_max_w;

EXIT WHEN NOT FOUND; /* apply on C01 */

BEGIN dt_proxima_dose_w := NULL;

dt_prevista_execucao_w := NULL;


SELECT max(dt_proxima_dose) INTO STRICT dt_prevista_execucao_w
FROM paciente_vacina
WHERE nr_seq_vacina = nr_seq_vacina_w
  AND (cd_pessoa_fisica = cd_pessoa_fisica_p
       OR obter_dados_atendimento(nr_atendimento, 'CP') = obter_dados_atendimento(nr_atendimento_p, 'CP'))
  AND CASE WHEN ie_dose='1D' THEN  1 WHEN ie_dose='1R' THEN  2 WHEN ie_dose='2D' THEN  3 WHEN ie_dose='2R' THEN  4 WHEN ie_dose='3D' THEN  5 END  < CASE WHEN ie_dose_w='1D' THEN  1 WHEN ie_dose_w='1R' THEN  2 WHEN ie_dose_w='2D' THEN  3 WHEN ie_dose_w='2R' THEN  4 WHEN ie_dose_w='3D' THEN  5 END;

IF (coalesce(dt_prevista_execucao_w::text, '') = '') THEN IF (clock_timestamp()-dt_nascimento_w BETWEEN qt_dias_idade_min_w AND qt_dias_idade_max_w) THEN dt_prevista_execucao_w := clock_timestamp();

ELSE dt_prevista_execucao_w := dt_nascimento_w + qt_dias_idade_min_w;

END IF;

END IF;

IF (qt_prox_mes_w > 0)
AND (dt_prevista_execucao_w IS NOT NULL AND dt_prevista_execucao_w::text <> '') THEN dt_proxima_dose_w := dt_prevista_execucao_w + qt_prox_mes_w * 30;

END IF;


INSERT INTO paciente_vacina( nr_sequencia,
							  nr_atendimento,
							  ie_dose,
							  nr_seq_vacina,
							  dt_atualizacao,
							  nm_usuario,
							  ie_via_aplicacao,
							  qt_dose,
							  cd_unid_medida,
							  cd_procedimento,
							  ie_origem_proced,
							  ds_reacao_adversa,
							  dt_proxima_dose,
							  cd_pessoa_fisica,
							  cd_setor_atendimento,
							  ie_executado,
							  cd_cgc,
							  dt_prevista_execucao,
							  ie_localidade_inf,
							  cd_profissional,
							  dt_registro,
							  ie_situacao,
							  cd_medico_resp)
VALUES (nextval('paciente_vacina_seq'),
       CASE WHEN ie_manter_vinculo_atend_w='S' THEN  nr_atendimento_p  ELSE NULL END ,
       ie_dose_w,
       nr_seq_vacina_w,
       clock_timestamp(),
       nm_usuario_p,
       ie_via_aplicacao_w,
       qt_dose_w,
       cd_unid_medida_w,
       cd_procedimento_w,
       ie_origem_proced_w,
       ds_reacao_adversa_w,
       CASE WHEN ie_permite_gerar_find_feriado='N' THEN  obter_proximo_dia_util(wheb_usuario_pck.get_cd_estabelecimento, dt_proxima_dose_w)  ELSE dt_proxima_dose_w END ,
       cd_pessoa_fisica_p,
       cd_setor_atendimento_w,
       'N',
       cd_cgc_w,
       dt_prevista_execucao_w,
       'N',
       NULL,--Obter_Pf_Usuario(nm_usuario_p,'C'), - Elton em 12/01/2012, nao necessariamente o profissional que gerou os agendamentos sera o profissional que ira aplicar a vacina no agendamento;
	   clock_timestamp(),
	   'A',
	   cd_medico_resp_w);

END;

END LOOP;

CLOSE C01;

END IF;

IF (nr_seq_vacina_p IS NOT NULL AND nr_seq_vacina_p::text <> '') THEN

	OPEN C02;

	LOOP FETCH C02 INTO nr_seq_vacina_w,
                    ie_dose_w,
                    cd_procedimento_w,
                    ie_origem_proced_w,
                    cd_unid_medida_w,
                    ie_via_aplicacao_w,
                    ds_reacao_adversa_w,
                    qt_dose_w,
                    qt_prox_mes_w,
                    qt_dias_idade_min_w,
                    qt_dias_idade_max_w;

	EXIT WHEN NOT FOUND; /* apply on C02 */

	BEGIN
		if (cd_procedimento_w IS NOT NULL AND cd_procedimento_w::text <> '') THEN
			dt_proxima_dose_w := NULL;
			dt_prevista_execucao_w := NULL;

			SELECT max(dt_proxima_dose) INTO STRICT dt_prevista_execucao_w
			FROM paciente_vacina
			WHERE nr_seq_vacina = nr_seq_vacina_w
			  AND (cd_pessoa_fisica = cd_pessoa_fisica_p
				   OR obter_dados_atendimento(nr_atendimento, 'CP') = obter_dados_atendimento(nr_atendimento_p, 'CP'))
			  AND CASE WHEN ie_dose='1D' THEN  1 WHEN ie_dose='1R' THEN  2 WHEN ie_dose='2D' THEN  3 WHEN ie_dose='2R' THEN  4 WHEN ie_dose='3D' THEN  5 END  < CASE WHEN ie_dose_w='1D' THEN  1 WHEN ie_dose_w='1R' THEN  2 WHEN ie_dose_w='2D' THEN  3 WHEN ie_dose_w='2R' THEN  4 WHEN ie_dose_w='3D' THEN  5 END;

			IF (coalesce(dt_prevista_execucao_w::text, '') = '') THEN IF (clock_timestamp()-dt_nascimento_w BETWEEN qt_dias_idade_min_w AND qt_dias_idade_max_w) THEN dt_prevista_execucao_w := clock_timestamp();

			ELSE dt_prevista_execucao_w := dt_nascimento_w + qt_dias_idade_min_w;

			END IF;

			END IF;

			IF (qt_prox_mes_w > 0)
			AND (dt_prevista_execucao_w IS NOT NULL AND dt_prevista_execucao_w::text <> '') THEN dt_proxima_dose_w := dt_prevista_execucao_w + qt_prox_mes_w * 30;

			END IF;


			INSERT INTO paciente_vacina( nr_sequencia,
										  nr_atendimento,
										  ie_dose,
										  nr_seq_vacina,
										  dt_atualizacao,
										  nm_usuario,
										  ie_via_aplicacao,
										  qt_dose,
										  cd_unid_medida,
										  cd_procedimento,
										  ie_origem_proced,
										  ds_reacao_adversa,
										  dt_proxima_dose,
										  cd_pessoa_fisica,
										  cd_setor_atendimento,
										  ie_executado,
										  cd_cgc,
										  dt_prevista_execucao,
										  ie_localidade_inf,
										  cd_profissional,
										  dt_registro,
										  ie_situacao,
										  cd_medico_resp)
			VALUES (nextval('paciente_vacina_seq'),
				   CASE WHEN ie_manter_vinculo_atend_w='S' THEN  nr_atendimento_p  ELSE NULL END ,
				   ie_dose_w,
				   nr_seq_vacina_w,
				   clock_timestamp(),
				   nm_usuario_p,
				   ie_via_aplicacao_w,
				   qt_dose_w,
				   cd_unid_medida_w,
				   cd_procedimento_w,
				   ie_origem_proced_w,
				   ds_reacao_adversa_w,
				   CASE WHEN ie_permite_gerar_find_feriado='N' THEN  obter_proximo_dia_util(wheb_usuario_pck.get_cd_estabelecimento, dt_proxima_dose_w)  ELSE dt_proxima_dose_w END ,
				   cd_pessoa_fisica_p,
				   cd_setor_atendimento_w,
				   'N',
				   cd_cgc_w,
				   dt_prevista_execucao_w,
				   'N',
				   NULL,--Obter_Pf_Usuario(nm_usuario_p,'C'), - Elton em 12/01/2012, nao necessariamente o profissional que gerou os agendamentos sera o profissional que ira aplicar a vacina no agendamento;
				   clock_timestamp(),
				   'A',
				   cd_medico_resp_w
			 );
			
			OPEN C03;
			LOOP FETCH C03 INTO nr_seq_lista_atend_w;
			EXIT WHEN NOT FOUND; /* apply on C03 */
			BEGIN

			IF (nr_seq_lista_atend_w IS NOT NULL AND nr_seq_lista_atend_w::text <> '') THEN
				CALL ATENDER_VACINA_LISTA_ESPERA(nr_seq_lista_atend_w, nm_usuario_p);
			END IF;

			END;

			END LOOP;

			CLOSE C03;
		END IF;
		
	END;

	END LOOP;

	CLOSE C02;

END IF;


COMMIT;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_agendamento_vacina_html5 (nr_atendimento_p bigint, cd_pessoa_fisica_p text, nr_seq_grupo_p bigint, nm_usuario_p text, nr_seq_vacina_p bigint) FROM PUBLIC;

