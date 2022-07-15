-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_protocolo_dieta (cd_protocolo_dest_p bigint , nr_seq_destino_p bigint , nr_seq_dieta_p text) AS $body$
DECLARE

ie_tipo_dieta_w          varchar(3);
ds_justificativa_w       varchar(4000);
ie_administracao_w       varchar(3);
dt_liberacao_w           timestamp;
ie_duracao_w             varchar(3);
dt_fim_w                 timestamp;
dt_inicio_w              timestamp;
ie_via_aplicacao_w       varchar(50);
ds_observacao_w          varchar(255);
ie_urgencia_w            varchar(4);
qt_dose_w                bigint;
hr_prim_horario_w        varchar(5);
nr_atendimento_w         bigint;
cd_intervalo_w           varchar(7);
nm_usuario_nrec_w        varchar(15);
dt_atualizacao_nrec_w    timestamp;
dt_atualizacao_w         timestamp;
ds_horarios_w            varchar(2000);
cd_dieta_w               bigint;
nr_sequencia_w           bigint;
cd_funcao_origem_w       bigint;
ie_retrogrado_w          varchar(1);
cd_pessoa_fisica_w       varchar(10);
cd_perfil_ativo_w        integer;
cd_setor_atendimento_w   integer;
nr_seq_objetivo_w        bigint;
ds_evento_w              varchar(255);
dt_evento_w              timestamp;
qt_hora_depois_w         integer;
qt_min_depois_w          integer;
qt_hora_ant_w            integer;
qt_min_ant_w             integer;
ie_inicio_w              varchar(15);
nr_seq_tipo_w            bigint;
cd_material_w            integer;
ie_acm_w                 varchar(1);
ie_se_necessario_w       varchar(1);
qt_vel_infusao_w         double precision;
qt_tempo_aplic_w         varchar(6);
ie_bomba_infusao_w       varchar(1);
nr_seq_disp_succao_w     bigint;
nr_seq_leite_prot_w      bigint;
nr_seq_prod_prot_w       bigint;
nr_seq_dil_prot_w        bigint;
nr_seq_prod_w            bigint;
cd_unidade_medida_dose_w varchar(30);
-- diluente ('S') e material adicional ('L')
cd_mat_prod1_w           integer;
cd_unid_med_prod1_w      varchar(30);
qt_dose_prod1_w          bigint;
ie_via_leite1_w          varchar(15);
nm_usuario_w             varchar(255);
nr_seq_prod_adic_w       bigint;
ie_via_aplic_w	       	varchar(5);
qt_volume_oral_w		bigint;
qt_volume_sonda_w		bigint;
ie_continuo_w 			cpoe_dieta.ie_continuo%type;

  c02 CURSOR FOR
    SELECT ie_tipo_dieta
           , ds_justificativa
           , ie_administracao
           , dt_liberacao
           , ie_duracao
           , dt_fim
           , dt_inicio
           , ie_via_aplicacao
           , ds_observacao
           , ie_urgencia
           , qt_dose
           , hr_prim_horario
           , nr_atendimento
           , cd_intervalo
           , nm_usuario_nrec
           , dt_atualizacao_nrec
           , nm_usuario
           , dt_atualizacao
           , ds_horarios
           , cd_dieta
           , nr_sequencia
           , cd_funcao_origem
           , ie_retrogrado
           , cd_pessoa_fisica
           , cd_perfil_ativo
           , cd_setor_atendimento
           , nr_seq_tipo
           , nr_seq_objetivo
           , coalesce(ie_inicio, 'F')
           , dt_evento
           , qt_min_ant
           , qt_min_depois
           , qt_hora_ant
           , qt_hora_depois
           , ds_evento
           , cd_material
           , ie_acm
           , ie_se_necessario
           , qt_vel_infusao
           , qt_tempo_aplic
           , ie_bomba_infusao
           , hr_prim_horario
           , nr_seq_disp_succao
           , cd_mat_prod1
           , cd_unidade_medida_dose
           , qt_dose_prod1
           , ie_via_leite1
		   , ie_continuo
    FROM   cpoe_dieta
    WHERE  nr_sequencia = nr_seq_dieta_p
       AND ie_tipo_dieta = ie_tipo_dieta_w;

BEGIN
    nm_usuario_w := wheb_usuario_pck.get_nm_usuario;

    IF (nr_seq_dieta_p IS NOT NULL AND nr_seq_dieta_p::text <> '') THEN
      SELECT ie_tipo_dieta
      INTO STRICT   ie_tipo_dieta_w
      FROM   cpoe_dieta
      WHERE  nr_sequencia = nr_seq_dieta_p;

      OPEN c02;

      LOOP
          FETCH c02 INTO
            ie_tipo_dieta_w
            , ds_justificativa_w
            , ie_administracao_w
            , dt_liberacao_w
            , ie_duracao_w
            , dt_fim_w
			, dt_inicio_w
            , ie_via_aplicacao_w
            , ds_observacao_w
            , ie_urgencia_w
            , qt_dose_w
            , hr_prim_horario_w
            , nr_atendimento_w
            , cd_intervalo_w
            , nm_usuario_nrec_w
            , dt_atualizacao_nrec_w
            , nm_usuario_w
            , dt_atualizacao_w
            , ds_horarios_w
            , cd_dieta_w
            , nr_sequencia_w
            , cd_funcao_origem_w
            , ie_retrogrado_w
            , cd_pessoa_fisica_w
            , cd_perfil_ativo_w
            , cd_setor_atendimento_w
            , nr_seq_tipo_w
            , nr_seq_objetivo_w
            , ie_inicio_w
            , dt_evento_w
            , qt_min_ant_w
            , qt_min_depois_w
            , qt_hora_ant_w
            , qt_hora_depois_w
            , ds_evento_w
            , cd_material_w
            , ie_acm_w
            , ie_se_necessario_w
            , qt_vel_infusao_w
            , qt_tempo_aplic_w
            , ie_bomba_infusao_w
            , hr_prim_horario_w
            , nr_seq_disp_succao_w
            , cd_mat_prod1_w
            , cd_unidade_medida_dose_w
            , qt_dose_prod1_w
            , ie_via_leite1_w
			, ie_continuo_w;

          EXIT WHEN NOT FOUND; /* apply on c02 */

          IF ( ie_tipo_dieta_w = 'J' ) THEN -- Caso for Jejum 'J'
            INSERT INTO protocolo_medic_jejum(cd_protocolo
                         , nr_sequencia
                         , nr_seq_jejum
                         , dt_atualizacao
                         , nm_usuario
                         , dt_atualizacao_nrec
                         , nm_usuario_nrec
                         , nr_seq_tipo
                         , nr_seq_objetivo
                         , ie_inicio
                         , dt_inicio
                         , dt_fim
                         , dt_evento
                         , qt_min_ant
                         , qt_min_depois
                         , qt_hora_ant
                         , qt_hora_depois
                         , ds_evento
                         , ds_observacao
                         , ie_repete_copia)
            VALUES ( cd_protocolo_dest_p
                         , nr_seq_destino_p
                         , nr_seq_dieta_p
                         , clock_timestamp()
                         , nm_usuario_w
                         , clock_timestamp()
                         , nm_usuario_w
                         , nr_seq_tipo_w
                         , nr_seq_objetivo_w
                         , ie_inicio_w
                         , dt_inicio_w
                         , dt_fim_w
                         , dt_evento_w
                         , qt_min_ant_w
                         , qt_min_depois_w
                         , qt_hora_ant_w
                         , qt_hora_depois_w
                         , ds_evento_w
                         , Substr(ds_observacao_w, 1, 255)
                         , 'N' );
          END IF;

          IF ( ie_tipo_dieta_w IN ( 'O' ) ) THEN -- Oral
            INSERT INTO protocolo_medic_dieta(cd_protocolo
                         , nr_sequencia
                         , nr_seq_dieta
                         , cd_dieta
                         , dt_atualizacao
                         , nm_usuario
                         , ds_observacao
                         , cd_intervalo)
            VALUES ( cd_protocolo_dest_p
                         , nr_seq_destino_p
                         , nr_sequencia_w
                         , cd_dieta_w
                         , clock_timestamp()
                         , nm_usuario_w
                         , Substr(ds_observacao_w, 1, 255)
                         , cd_intervalo_w );
          END IF;

          IF ( ie_tipo_dieta_w = 'E' AND (cd_material_w IS NOT NULL AND cd_material_w::text <> '') ) THEN -- Enteral
            INSERT INTO protocolo_medic_material( cd_protocolo
	                 , nr_sequencia
	                 , nr_seq_material
	                 , cd_material
	                 , qt_dose
	                 , ie_via_aplicacao
	                 , cd_unidade_medida
	                 , cd_intervalo
	                 , nr_agrupamento
	                 , ie_agrupador
	                 , ie_aplic_bolus
	                 , ie_aplic_lenta
	                 , dt_atualizacao
	                 , ie_urgencia
	                 , ie_intervalo_fixo
	                 , ie_multiplicar_dose
	                 , ie_bomba_infusao
	                 , nm_usuario
	                 , ie_continuo
	                 , qt_vel_infusao)
            VALUES ( cd_protocolo_dest_p
            	, nr_seq_destino_p
            	, Obter_seq_mat_prot_medic_mat(cd_protocolo_dest_p, nr_seq_destino_p)
            	, cd_material_w
            	, qt_dose_w
            	, ie_via_aplicacao_w
            	, cd_unidade_medida_dose_w
            	, cd_intervalo_w
            	, Obter_agrup_prot_medic_mat(cd_protocolo_dest_p, nr_seq_destino_p, 0)
            	, 8
            	, 'N'
            	, 'N'
            	, clock_timestamp()
            	, 'N'
            	, 'N'
            	, 'N'
            	, 'N'
            	, nm_usuario_w
            	, ie_continuo_w
            	, qt_vel_infusao_w);
          END IF;

          IF ( ie_tipo_dieta_w = 'S' ) THEN -- Suplemento
            CALL Incluir_prot_derivado_material(
              cd_protocolo_dest_p
              , nr_seq_destino_p
              , cd_material_w
              , NULL
              , 12
              , qt_dose_w
              , NULL
              , ie_via_aplicacao_w
              , cd_unidade_medida_dose_w
              , ds_horarios_w
              , NULL
              , cd_intervalo_w
              , NULL
              , 'N'
              , 'N'
              , clock_timestamp()
              , 'N'
              , 'N'
              , 'N'
              , 'N'
              , NULL
              , NULL
              , NULL
              , (Substr(qt_tempo_aplic_w, 1, position(':' in qt_tempo_aplic_w) - 1))::numeric
              , (Substr(qt_tempo_aplic_w, position(':' in qt_tempo_aplic_w)+1))::numeric 
            )
;
          END IF;

          IF ( ie_tipo_dieta_w = 'L' ) THEN -- Leite e derivados
			SELECT nextval('protocolo_medic_leite_seq')
            INTO STRICT   nr_seq_leite_prot_w
;

			if (obter_se_via_sonda(ie_via_leite1_w) = 'N') THEN
				qt_volume_oral_w := qt_dose_prod1_w;
			else
				qt_volume_sonda_w := qt_dose_prod1_w;
			end if;

            INSERT INTO protocolo_medic_leite(nr_sequencia
                         , dt_atualizacao
                         , nm_usuario
                         , dt_atualizacao_nrec
                         , nm_usuario_nrec
                         , cd_protocolo
                         , nr_seq_protocolo
                         , cd_intervalo
                         , ie_se_necessario
                         , hr_prim_horario
                         , ie_via_aplicacao
                         , qt_volume_oral
                         , qt_volume_sonda
                         , nr_seq_disp_succao
						 , qt_tempo_aplic)
            VALUES ( nr_seq_leite_prot_w
                         , clock_timestamp()
                         , nm_usuario_w
                         , clock_timestamp()
                         , nm_usuario_w
                         , cd_protocolo_dest_p
                         , nr_seq_destino_p
                         , cd_intervalo_w
                         , ie_se_necessario_w
                         , hr_prim_horario_w
                         , ie_via_leite1_w
                         , qt_volume_oral_w
                         , qt_volume_sonda_w
                         , nr_seq_disp_succao_w
						 , qt_tempo_aplic_w);

            IF (cd_mat_prod1_w IS NOT NULL AND cd_mat_prod1_w::text <> '') THEN
              SELECT nextval('protocolo_medic_produto_seq')
              INTO STRICT   nr_seq_prod_prot_w
;

              INSERT INTO protocolo_medic_produto(cd_material
                           , dt_atualizacao
                           , dt_atualizacao_nrec
                           , nm_usuario
                           , nm_usuario_nrec
                           , nr_seq_prot_leite
                           , nr_sequencia)
              SELECT cd_mat_prod
                     , clock_timestamp()
                     , clock_timestamp()
                     , nm_usuario_w
                     , nm_usuario_w
                     , nr_seq_leite_prot_w
                     , nr_seq_prod_prot_w
              FROM   cpoe_dieta_item_v
              WHERE  ie_tipo_dieta = 'L'
                 AND nr_sequencia = nr_seq_dieta_p;

              INSERT INTO protocolo_medic_prod_adic(nr_sequencia
                           , dt_atualizacao
                           , nm_usuario
                           , dt_atualizacao_nrec
                           , nm_usuario_nrec
                           , nr_seq_produto
                           , cd_material
                           , qt_dose
                           , qt_porcentagem
                           , cd_unidade_medida_dose)
              SELECT nextval('protocolo_medic_prod_adic_seq')
                     , clock_timestamp()
                     , nm_usuario_w
                     , clock_timestamp()
                     , nm_usuario_w
                     , nr_seq_prod_prot_w
                     , cd_mat_prod_adic
                     , qt_dose_prod_adic
                     , qt_porcentagem_adic
                     , cd_unid_med_prod_adic
              FROM   cpoe_dieta_item_adicional_v
              WHERE  ie_tipo_dieta = 'L'
                 AND nr_sequencia = nr_seq_dieta_p;
            END IF;
          END IF;
      END LOOP;

      CLOSE c02;
    END IF;

    COMMIT;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_protocolo_dieta (cd_protocolo_dest_p bigint , nr_seq_destino_p bigint , nr_seq_dieta_p text) FROM PUBLIC;

