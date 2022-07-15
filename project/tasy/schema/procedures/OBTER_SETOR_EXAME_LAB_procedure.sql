-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_setor_exame_lab ( nr_prescricao_p bigint, nr_seq_exame_p bigint, cd_setor_solicitacao_p bigint, cd_material_exame_p text, dt_coleta_p timestamp, ie_atualizar_dt_prescr_p text, cd_setor_atendimento_p INOUT text, cd_setor_coleta_p INOUT text, cd_setor_entrega_p INOUT text, qt_dia_entrega_p INOUT bigint, ie_emite_mapa_p INOUT text, ds_hora_fixa_p INOUT text, ie_data_resultado_p INOUT text, qt_min_entrega_p INOUT bigint, ie_atualizar_recoleta_p INOUT text, ie_urgencia_p text, ie_dia_semana_final_p INOUT bigint, ie_forma_atual_dt_result_p INOUT text, qt_min_atraso_p INOUT bigint, dt_entrada_p timestamp default null) AS $body$
DECLARE

	ie_tipo_atendimento_w 		smallint;
	dt_entrada_w 				timestamp;
	dt_entrega_w 				timestamp;
	dt_entrega_calc_w 			timestamp;
	dt_entrega_upd_w 			timestamp;
	ie_entrada_w           		varchar(1);
	nr_seq_material_w      		bigint;
	nr_seq_grupo_w         		bigint;
	cd_estabelecimento_w   		smallint;
	cd_setor_atendimento_w 		integer;
	cd_setor_coleta_w      		integer;
	cd_setor_entrega_w     		integer;
	qt_dia_entrega_w       		smallint;
	qt_dia_entrega_entrada_w	smallint;
	qt_dia_entrega_coleta_w     smallint;
	ie_domingo_w           		varchar(1);
	ie_segunda_w           		varchar(1);
	ie_terca_w             		varchar(1);
	ie_quarta_w            		varchar(1);
	ie_quinta_w            		varchar(1);
	ie_sexta_w             		varchar(1);
	ie_sabado_w            		varchar(1);
	ie_feriado_w           		varchar(1);
	dia_semana_w           		integer := 1;
	ds_hora_fixa_w         		varchar(2);
	ie_data_resultado_w    		varchar(1);
	qt_min_entrega_w       		bigint;
	nr_seq_grupo_imp_w     		bigint;
	dt_prescricao_w 			timestamp;
	ie_dia_semana_w     		smallint;
	ie_dia_semana_upd_w 		smallint;
	ie_tipo_feriado_w   		integer;
	nr_seq_prioridade_w			smallint;
	nr_seq_lab_exame_dia_w		bigint;
	nr_seq_exame_lab_regra_w	bigint;
	ie_gravar_log_lab_w		    varchar(1);
	ie_cons_dt_prev_regra_w		lab_parametro.ie_cons_dt_prev_regra%type;
    sql_w                       varchar(200);
    v_ou_f_w                    varchar(1);

	/* SEMPRE QUE FOR ALTERADO ESTE OBJETO, DEVE SER REALIZADA A ALTERACAO, NO OBJETO OBTER_SETOR_EXAME_LAB_EUP*/

	/*
	//
	// 	ATENCAO
	//
	//   	NAO INSERIR NENHUM TIPO DE COMANDO QUE ALTERE REGISTROS NO BANCO NESTA PROCEDURE
	//
	//  	A MESMA E CHAMADA DENTRO DE UMA FUNCTION E PODE GERAR PROBLEMAS AO TENTAR UTILIZAR COMANDOS DML EM UMA CONSULTA
	//
	*/
	c01 CURSOR FOR
		SELECT cd_setor_atendimento,
			cd_setor_coleta,
			cd_setor_entrega,
			coalesce(qt_dia_entrega,0),
			coalesce(ie_emite_mapa,'S'),
			ds_hora_fixa,
			ie_data_resultado,
			coalesce(qt_min_entrega,0),
			coalesce(ie_atualizar_recoleta, 'N'),
			coalesce(ie_dia_semana_final,0),
			coalesce(ie_atul_data_result, 'S'),
			coalesce(qt_min_atraso,0),
			coalesce(nr_seq_prioridade,0),
			nr_sequencia
		FROM exame_lab_regra_setor
		WHERE coalesce(cd_estabelecimento, coalesce(cd_estabelecimento_w,0))   = coalesce(cd_estabelecimento_w,0)
		AND ((ie_dia_semana                                          = ie_dia_semana_w)
		OR ((ie_dia_semana                                           = 9)
		AND (pkg_date_utils.is_business_day(dt_prescricao_w) = 1))
		OR (coalesce(ie_dia_semana::text, '') = ''))
		AND coalesce(ie_tipo_atendimento, ie_tipo_atendimento_w)          = ie_tipo_atendimento_w
		AND coalesce(cd_setor_solicitacao, coalesce(cd_setor_solicitacao_p,0)) = coalesce(cd_setor_solicitacao_p,0)
		AND coalesce(nr_seq_grupo, nr_seq_grupo_w)                        = nr_seq_grupo_w
		AND coalesce(nr_seq_grupo_imp, nr_seq_grupo_imp_w)                = nr_seq_grupo_imp_w
		AND coalesce(nr_seq_exame, nr_seq_exame_p)                        = nr_seq_exame_p
		AND coalesce(nr_seq_material, coalesce(nr_seq_material_w,0))           = coalesce(nr_seq_material_w,0)
		AND ((coalesce(ie_urgencia,ie_urgencia_p)                         = ie_urgencia_p)
		OR (coalesce(ie_urgencia,'A')                                     = 'A'))
		AND dt_prescricao_w BETWEEN TO_DATE(TO_CHAR(dt_prescricao_w,'dd/mm/yyyy')
			|| ' '
			|| coalesce(ds_hora_inicio,TO_CHAR(dt_prescricao_w,'hh24:mi'))
			|| ':00','dd/mm/yyyy hh24:mi:ss')
		AND TO_DATE(TO_CHAR(dt_prescricao_w,'dd/mm/yyyy')
			|| ' '
			|| coalesce(ds_hora_fim,TO_CHAR(dt_prescricao_w,'hh24:mi'))
			|| ':00','dd/mm/yyyy hh24:mi:ss')
		ORDER BY coalesce(nr_seq_prioridade,0),
			coalesce(nr_seq_material,0),
			coalesce(nr_seq_exame,0),
			coalesce(nr_seq_grupo,0),
			coalesce(ie_dia_semana,0),
			nr_seq_grupo_imp_w,
			cd_setor_solicitacao;
	c02 CURSOR FOR
		SELECT  ie_domingo,
			ie_segunda,
			ie_terca,
			ie_quarta,
			ie_quinta,
			ie_sexta,
			ie_sabado,
			ie_feriado,
			ie_tipo_feriado,
			nr_sequencia
		FROM 	lab_exame_dia
		WHERE 	coalesce(nr_seq_grupo, nr_seq_grupo_w)          = nr_seq_grupo_w
		AND 	coalesce(nr_seq_exame, nr_seq_exame_p)            = nr_seq_exame_p
		AND 	coalesce(cd_estabelecimento,cd_estabelecimento_w) = cd_estabelecimento_w
		AND 	coalesce(IE_TIPO_REGRA,'X')                      <> 'C'
		ORDER BY coalesce(nr_seq_exame, 0),
				coalesce(nr_seq_grupo, 0);

BEGIN
	/* SEMPRE QUE FOR ALTERADO ESTE OBJETO, DEVE SER REALIZADA A ALTERACAO, NO OBJETO OBTER_SETOR_EXAME_LAB_EUP*/

select 	max(coalesce(c.ie_cons_dt_prev_regra, 'N'))
into STRICT	ie_cons_dt_prev_regra_w
FROM lab_parametro c, prescr_medica a
LEFT OUTER JOIN atendimento_paciente b ON (a.nr_atendimento = b.nr_atendimento)
WHERE a.nr_prescricao	= nr_prescricao_p and c.cd_estabelecimento = coalesce(b.cd_estabelecimento,a.cd_estabelecimento);

	SELECT 	MAX(coalesce(coalesce(b.cd_estabelecimento,a.cd_estabelecimento),0)),
			MAX(b.ie_tipo_atendimento),
			MAX(CASE WHEN coalesce(ie_cons_dt_prev_regra_w, 'N')='S' THEN  coalesce(dt_entrada_p, coalesce(a.dt_entrada_unidade,a.dt_prescricao))  ELSE coalesce(a.dt_entrada_unidade,a.dt_prescricao) END ),
			MAX(coalesce(a.dt_entrega, coalesce(a.dt_entrada_unidade,a.dt_prescricao))),
			MAX(pkg_date_utils.get_weekday(coalesce(a.dt_entrada_unidade,a.dt_prescricao)) + 1),
			MAX(TRUNC(a.dt_prescricao,'mi'))
	INTO STRICT 	cd_estabelecimento_w,
			ie_tipo_atendimento_w,
			dt_entrada_w,
			dt_entrega_w,
			ie_entrada_w,
			dt_prescricao_w
	FROM prescr_medica a
LEFT OUTER JOIN atendimento_paciente b ON (a.nr_atendimento = b.nr_atendimento)
WHERE a.nr_prescricao    = nr_prescricao_p;

	SELECT obter_cod_dia_semana(dt_prescricao_w) INTO STRICT ie_dia_semana_w;
	qt_dia_entrega_p := 0;

	SELECT	MAX(nr_seq_grupo),
			MAX(coalesce(nr_seq_grupo_imp,0))
	INTO STRICT 	nr_seq_grupo_w,
			nr_seq_grupo_imp_w
	FROM 	exame_laboratorio
	WHERE 	nr_seq_exame = nr_seq_exame_p;

	SELECT	MAX(nr_sequencia)
	INTO STRICT 	nr_seq_material_w
	FROM 	material_exame_lab
	WHERE 	cd_material_exame = cd_material_exame_p;

	select max(coalesce(ie_gera_log_interf, 'N'))
	into STRICT ie_gravar_log_lab_w
	from lab_parametro
	where cd_estabelecimento = cd_estabelecimento_w;

	OPEN c01;
	LOOP
		FETCH c01
		INTO cd_setor_atendimento_w,
			cd_setor_coleta_w,
			cd_setor_entrega_w,
			qt_dia_entrega_w,
			ie_emite_mapa_p,
			ds_hora_fixa_p,
			ie_data_resultado_p,
			qt_min_entrega_p,
			ie_atualizar_recoleta_p,
			ie_dia_semana_final_p,
			ie_forma_atual_dt_result_p,
			qt_min_atraso_p,
			nr_seq_prioridade_w,
			nr_seq_exame_lab_regra_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
		IF (cd_setor_atendimento_w IS NOT NULL AND cd_setor_atendimento_w::text <> '') THEN
			cd_setor_atendimento_p    := cd_setor_atendimento_p || cd_setor_atendimento_w || ',';
		END IF;
		IF (cd_setor_coleta_w IS NOT NULL AND cd_setor_coleta_w::text <> '') THEN
			cd_setor_coleta_p    := cd_setor_coleta_p || cd_setor_coleta_w || ',';
		END IF;
		IF (cd_setor_entrega_w IS NOT NULL AND cd_setor_entrega_w::text <> '') THEN
			cd_setor_entrega_p    := cd_setor_entrega_p || cd_setor_entrega_w || ',';
		END IF;
		qt_dia_entrega_p   := coalesce(qt_dia_entrega_w, 0);
	END LOOP;
	CLOSE c01;
	OPEN c02;
	LOOP
		FETCH c02
		INTO ie_domingo_w,
			ie_segunda_w,
			ie_terca_w,
			ie_quarta_w,
			ie_quinta_w,
			ie_sexta_w,
			ie_sabado_w,
			ie_feriado_w,
			ie_tipo_feriado_w,
			nr_seq_lab_exame_dia_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
		ie_domingo_w := ie_domingo_w;
	END LOOP;
	CLOSE c02;
/* InIcio MD1 */

--PARA TODOS OS MEDICAL DEVICES DESSE OBEJETO VERIFICAR SE E POSSIVEL UTILIZAR OS MESMOS DO/PARA OBTER_SETOR_EXAME_LAB_EUP
    BEGIN
        sql_w := 'begin OBTER_DIA_ENTREGA_MD(:1, :2, :3, :4, :5, :6, :7, :8, :9, :10, :11, :12, :13, :14, :15, :16, :17, :18); end;';
        EXECUTE sql_w
            USING IN qt_dia_entrega_p, IN dt_entrada_w, IN cd_estabelecimento_w, IN ie_tipo_feriado_w, IN dt_coleta_p,
                  IN ie_data_resultado_p, IN ie_domingo_w, IN ie_segunda_w, IN ie_terca_w, IN ie_quarta_w,
                  IN ie_quinta_w, IN ie_sexta_w, IN ie_sabado_w, IN ie_feriado_w, 
                 OUT qt_dia_entrega_w, OUT qt_dia_entrega_entrada_w, OUT dt_entrega_calc_w, OUT qt_dia_entrega_coleta_w;

    EXCEPTION
        WHEN OTHERS THEN
            qt_dia_entrega_w := NULL;
            qt_dia_entrega_entrada_w := NULL;
            dt_entrega_calc_w := NULL;
            qt_dia_entrega_coleta_w := NULL;
    END;

    /* Fim MD1 */

    /* InIcio MD2 */

    --VERIFICAR SE E POSSIVEL UTILIZAR O MESMO OBJETO CRIADO NO MD2 DO OBTER_SETOR_EXAME_LAB_EUP
     BEGIN
        sql_w := 'CALL OBTER_DT_ENTREGA_MD(:1, :2, :3, :4, :5) INTO :qt_dia_entrega_p';
        EXECUTE sql_w
            USING IN ie_data_resultado_p, IN ie_atualizar_dt_prescr_p, IN qt_dia_entrega_entrada_w, IN dt_coleta_p,
                  IN qt_dia_entrega_coleta_w, OUT qt_dia_entrega_p;

    EXCEPTION
        WHEN OTHERS THEN
            qt_dia_entrega_p := NULL;
    END;

    /* Fim MD2 */

    /* InIcio MD3*/

  --CRIAR UM OBJETO PARA VERIFICAR SE O IF ABAIXO E VERDADEIRO, SE FOR, RETORNAR TRUE E CONTINUA, SENAO, RETONAR FALSE
    BEGIN
        sql_w := 'CALL VERIFICAR_VERDADEIRO_FALSO_MD(:1, :2, :3, :4, :5, :6, :7, :8, :9, :10) INTO :v_ou_f_w';
        EXECUTE sql_w
            USING IN dt_entrega_w, IN dt_entrada_w, IN qt_dia_entrega_entrada_w, IN qt_min_entrega_p,
                  IN ds_hora_fixa_p, IN ie_data_resultado_p, IN ie_atualizar_dt_prescr_p,
                  IN dt_coleta_p, IN qt_dia_entrega_coleta_w, IN 1, OUT v_ou_f_w;

    EXCEPTION
        WHEN OTHERS THEN
            v_ou_f_w := 'N';
    END;


	IF (  v_ou_f_w = 'S' ) THEN
		--FIM MD 3
        IF (ds_hora_fixa_p IS NOT NULL AND ds_hora_fixa_p::text <> '') THEN
			--INICIO obter_dia_semana_upd_mdMD 4            
    BEGIN
        sql_w := 'CALL obter_dia_semana_upd_md(:1, :2, :3, :4, :5, :6, :7, :8, :9) INTO :dt_entrega_upd_w';
        EXECUTE sql_w
            USING IN dt_entrada_w, IN ds_hora_fixa_p, IN qt_dia_entrega_entrada_w, IN qt_min_entrega_p,
                  IN ie_dia_semana_final_p, IN dt_prescricao_w, IN qt_dia_entrega_coleta_w,
                  IN dt_coleta_p, IN 1, OUT dt_entrega_upd_w;

    EXCEPTION
        WHEN OTHERS THEN
            dt_entrega_upd_w := NULL;
    END;
            /* Fim MD4 */

			UPDATE prescr_medica
			SET dt_entrega      = dt_entrega_upd_w
			WHERE nr_prescricao = nr_prescricao_p;

			if ie_gravar_log_lab_w = 'S' then			
				CALL gravar_log_lab(41, '01 - nr_seq_lab_exame_dia_w: ' || nr_seq_lab_exame_dia_w ||
						      '; nr_seq_exame_lab_regra_w: ' || nr_seq_exame_lab_regra_w ||
						      '; dt_entrada_w: ' || PKG_DATE_FORMATERS_TZ.TO_VARCHAR(dt_entrada_w, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone)||
						      '; qt_dia_entrega_entrada_w: ' || qt_dia_entrega_entrada_w ||
						      '; qt_min_entrega_p: ' || qt_min_entrega_p ||
						      '; ie_dia_semana_final_p: ' || ie_dia_semana_final_p ||
						      '; dt_entrega_upd_w: ' || PKG_DATE_FORMATERS_TZ.TO_VARCHAR(dt_entrega_upd_w, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone),
						      'tasy',
						      nr_prescricao_p);
			end if;

		ELSE
            /* InIcio MD5 */

    BEGIN
        sql_w := 'CALL obter_dia_semana_upd_md(:1, :2, :3, :4, :5, :6, :7, :8, :9) INTO :dt_entrega_upd_w';
        EXECUTE sql_w
            USING IN dt_entrada_w, IN ds_hora_fixa_p, IN qt_dia_entrega_entrada_w, IN qt_min_entrega_p,
                  IN ie_dia_semana_final_p, IN dt_prescricao_w, IN qt_dia_entrega_coleta_w,
                  IN dt_coleta_p, IN 2, OUT dt_entrega_upd_w;

    EXCEPTION
        WHEN OTHERS THEN
            dt_entrega_upd_w := NULL;
    END;
            /* Fim MD5 */
			UPDATE prescr_medica
			SET dt_entrega      = dt_entrega_upd_w
			WHERE nr_prescricao = nr_prescricao_p;

			if ie_gravar_log_lab_w = 'S' then
				CALL gravar_log_lab(41, '02 - nr_seq_lab_exame_dia_w: ' || nr_seq_lab_exame_dia_w ||
						      '; nr_seq_exame_lab_regra_w: ' || nr_seq_exame_lab_regra_w ||
						      '; dt_entrada_w: ' || PKG_DATE_FORMATERS_TZ.TO_VARCHAR(dt_entrada_w, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone)||
						      '; qt_dia_entrega_entrada_w: ' || qt_dia_entrega_entrada_w ||
						      '; qt_min_entrega_p: ' || qt_min_entrega_p ||
						      '; ie_dia_semana_final_p: ' || ie_dia_semana_final_p ||
						      '; dt_entrega_upd_w: ' || PKG_DATE_FORMATERS_TZ.TO_VARCHAR(dt_entrega_upd_w, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone),
						      'tasy',
						      nr_prescricao_p);
			end if;

		END IF;
	END IF;
    --INICIOF MD 6
     --CRIAR UM OBJETO PARA VERIFICAR SE O IF ABAIXO E VERDADEIRO, SE FOR, RETORNAR TRUE E CONTINUA, SENAO, RETONAR FALSE
    BEGIN
        sql_w := 'CALL VERIFICAR_VERDADEIRO_FALSO_MD(:1, :2, :3, :4, :5, :6, :7, :8, :9, :10) INTO :v_ou_f_w';
        EXECUTE sql_w
            USING IN dt_entrega_w, IN dt_entrada_w, IN qt_dia_entrega_entrada_w, IN qt_min_entrega_p,
                  IN ds_hora_fixa_p, IN ie_data_resultado_p, IN ie_atualizar_dt_prescr_p,
                  IN dt_coleta_p, IN qt_dia_entrega_coleta_w, IN 2, OUT v_ou_f_w;

    EXCEPTION
        WHEN OTHERS THEN
            v_ou_f_w := 'N';
    END;


	IF (  v_ou_f_w = 'S' ) THEN
		--FIM MD 6
        IF (ds_hora_fixa_p IS NOT NULL AND ds_hora_fixa_p::text <> '') THEN
            /* InIcio MD7 */

    BEGIN
        sql_w := 'CALL obter_dia_semana_upd_md(:1, :2, :3, :4, :5, :6, :7, :8, :9) INTO :dt_entrega_upd_w';
        EXECUTE sql_w
            USING IN dt_entrada_w, IN ds_hora_fixa_p, IN qt_dia_entrega_entrada_w, IN qt_min_entrega_p,
                  IN ie_dia_semana_final_p, IN dt_prescricao_w, IN qt_dia_entrega_coleta_w,
                  IN dt_coleta_p, IN 3, OUT dt_entrega_upd_w;

    EXCEPTION
        WHEN OTHERS THEN
            dt_entrega_upd_w := NULL;
    END;
            /* Fim MD7 */

			UPDATE prescr_medica
			SET dt_entrega      = dt_entrega_upd_w
			WHERE nr_prescricao = nr_prescricao_p;

			if ie_gravar_log_lab_w = 'S' then
				CALL gravar_log_lab(41, '03 - nr_seq_lab_exame_dia_w: ' || nr_seq_lab_exame_dia_w ||
						      '; nr_seq_exame_lab_regra_w: ' || nr_seq_exame_lab_regra_w ||
						      '; dt_coleta_p: ' || PKG_DATE_FORMATERS_TZ.TO_VARCHAR(dt_coleta_p, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone)||
						      '; qt_dia_entrega_coleta_w: ' || qt_dia_entrega_coleta_w ||
						      '; qt_min_entrega_p: ' || qt_min_entrega_p ||
						      '; ie_dia_semana_final_p: ' || ie_dia_semana_final_p ||
						      '; dt_entrega_upd_w: ' || PKG_DATE_FORMATERS_TZ.TO_VARCHAR(dt_entrega_upd_w, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone),
						      'tasy',
						      nr_prescricao_p);
			end if;

		ELSE
            /* InIcio MD8 */

    BEGIN
        sql_w := 'CALL obter_dia_semana_upd_md(:1, :2, :3, :4, :5, :6, :7, :8, :9) INTO :dt_entrega_upd_w';
        EXECUTE sql_w
            USING IN dt_entrada_w, IN ds_hora_fixa_p, IN qt_dia_entrega_entrada_w, IN qt_min_entrega_p,
                  IN ie_dia_semana_final_p, IN dt_prescricao_w, IN qt_dia_entrega_coleta_w,
                  IN dt_coleta_p, IN 4, OUT dt_entrega_upd_w;

    EXCEPTION
        WHEN OTHERS THEN
            dt_entrega_upd_w := NULL;
    END;
            /* Fim MD8 */

			UPDATE prescr_medica
			SET dt_entrega      = dt_entrega_upd_w
			WHERE nr_prescricao = nr_prescricao_p;

			if ie_gravar_log_lab_w = 'S' then
				CALL gravar_log_lab(41, '04 - nr_seq_lab_exame_dia_w: ' || nr_seq_lab_exame_dia_w ||
						      '; nr_seq_exame_lab_regra_w: ' || nr_seq_exame_lab_regra_w ||
						      '; dt_coleta_p: ' ||  PKG_DATE_FORMATERS_TZ.TO_VARCHAR(dt_coleta_p, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone)||
						      '; qt_dia_entrega_coleta_w: ' || qt_dia_entrega_coleta_w ||
						      '; qt_min_entrega_p: ' || qt_min_entrega_p ||
						      '; ie_dia_semana_final_p: ' || ie_dia_semana_final_p ||
						      '; dt_entrega_upd_w: ' ||  PKG_DATE_FORMATERS_TZ.TO_VARCHAR(dt_entrega_upd_w, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone),
						      'tasy',
						      nr_prescricao_p);
			end if;

		END IF;
	END IF;
    --INICIO MD 9
         --CRIAR UM OBJETO PARA VERIFICAR SE O IF ABAIXO E VERDADEIRO, SE FOR, RETORNAR TRUE E CONTINUA, SENAO, RETONAR FALSE
    BEGIN
        sql_w := 'CALL VERIFICAR_VERDADEIRO_FALSO_MD(:1, :2, :3, :4, :5, :6, :7, :8, :9, :10) INTO :v_ou_f_w';
        EXECUTE sql_w
            USING IN dt_entrega_w, IN dt_entrada_w, IN qt_dia_entrega_entrada_w, IN qt_min_entrega_p,
                  IN ds_hora_fixa_p, IN ie_data_resultado_p, IN ie_atualizar_dt_prescr_p,
                  IN dt_coleta_p, IN qt_dia_entrega_coleta_w, IN 3, OUT v_ou_f_w;

    EXCEPTION
        WHEN OTHERS THEN
            v_ou_f_w := 'N';
    END;


	IF (  v_ou_f_w = 'S' ) THEN        --FIM MD 9
		IF (coalesce(ie_atualizar_dt_prescr_p,'S') = 'S') THEN
            --INICIO MD 10
			IF (ds_hora_fixa_p IS NOT NULL AND ds_hora_fixa_p::text <> '') THEN

    BEGIN
        sql_w := 'CALL obter_dia_semana_upd_md(:1, :2, :3, :4, :5, :6, :7, :8, :9) INTO :dt_entrega_upd_w';
        EXECUTE sql_w
            USING IN dt_entrada_w, IN ds_hora_fixa_p, IN qt_dia_entrega_entrada_w, IN qt_min_entrega_p,
                  IN ie_dia_semana_final_p, IN dt_prescricao_w, IN qt_dia_entrega_coleta_w,
                  IN dt_coleta_p, IN 5, OUT dt_entrega_upd_w;

    EXCEPTION
        WHEN OTHERS THEN
            dt_entrega_upd_w := NULL;
    END;
                --FIM MD 10
				UPDATE prescr_medica
				SET dt_entrega      = dt_entrega_upd_w
				WHERE nr_prescricao = nr_prescricao_p;

				if ie_gravar_log_lab_w = 'S' then
					CALL gravar_log_lab(41, '05 - nr_seq_lab_exame_dia_w: ' || nr_seq_lab_exame_dia_w ||
							      '; nr_seq_exame_lab_regra_w: ' || nr_seq_exame_lab_regra_w ||
							      '; dt_entrada_w: ' ||  PKG_DATE_FORMATERS_TZ.TO_VARCHAR(dt_entrega_w, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone)||
							      '; qt_dia_entrega_entrada_w: ' || qt_dia_entrega_entrada_w ||
							      '; qt_min_entrega_p: ' || qt_min_entrega_p ||
							      '; ie_dia_semana_final_p: ' || ie_dia_semana_final_p ||
							      '; dt_entrega_upd_w: ' ||  PKG_DATE_FORMATERS_TZ.TO_VARCHAR(dt_entrega_upd_w, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone),
							      'tasy',
							      nr_prescricao_p);
				end if;

			ELSE
                /* InIcio MD11 */

    BEGIN
        sql_w := 'CALL obter_dia_semana_upd_md(:1, :2, :3, :4, :5, :6, :7, :8, :9) INTO :dt_entrega_upd_w';
        EXECUTE sql_w
            USING IN dt_entrada_w, IN ds_hora_fixa_p, IN qt_dia_entrega_entrada_w, IN qt_min_entrega_p,
                  IN ie_dia_semana_final_p, IN dt_prescricao_w, IN qt_dia_entrega_coleta_w,
                  IN dt_coleta_p, IN 6, OUT dt_entrega_upd_w;

    EXCEPTION
        WHEN OTHERS THEN
            dt_entrega_upd_w := NULL;
    END;
                /* Fim MD11 */

				UPDATE prescr_medica
				SET dt_entrega      = dt_entrega_upd_w
				WHERE nr_prescricao = nr_prescricao_p;

				if ie_gravar_log_lab_w = 'S' then
					CALL gravar_log_lab(41, '06 - nr_seq_lab_exame_dia_w: ' || nr_seq_lab_exame_dia_w ||
							      '; nr_seq_exame_lab_regra_w: ' || nr_seq_exame_lab_regra_w ||
							      '; dt_entrada_w: ' ||  PKG_DATE_FORMATERS_TZ.TO_VARCHAR(dt_entrada_w, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone)||
							      '; qt_dia_entrega_entrada_w: ' || qt_dia_entrega_entrada_w ||
							      '; qt_min_entrega_p: ' || qt_min_entrega_p ||
							      '; ie_dia_semana_final_p: ' || ie_dia_semana_final_p ||
							      '; dt_entrega_upd_w: ' ||  PKG_DATE_FORMATERS_TZ.TO_VARCHAR(dt_entrega_upd_w, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone),
							      'tasy',
							      nr_prescricao_p);
				end if;

			END IF;
		ELSIF (dt_coleta_p IS NOT NULL AND dt_coleta_p::text <> '') THEN
			IF (ds_hora_fixa_p IS NOT NULL AND ds_hora_fixa_p::text <> '') THEN
                /* InIcio MD12 */

    BEGIN
        sql_w := 'CALL obter_dia_semana_upd_md(:1, :2, :3, :4, :5, :6, :7, :8, :9) INTO :dt_entrega_upd_w';
        EXECUTE sql_w
            USING IN dt_entrada_w, IN ds_hora_fixa_p, IN qt_dia_entrega_entrada_w, IN qt_min_entrega_p,
                  IN ie_dia_semana_final_p, IN dt_prescricao_w, IN qt_dia_entrega_coleta_w,
                  IN dt_coleta_p, IN 7, OUT dt_entrega_upd_w;

    EXCEPTION
        WHEN OTHERS THEN
            dt_entrega_upd_w := NULL;
    END;
               /* Fim MD12 */

				UPDATE prescr_medica
				SET dt_entrega      = dt_entrega_upd_w
				WHERE nr_prescricao = nr_prescricao_p;

				if ie_gravar_log_lab_w = 'S' then
					CALL gravar_log_lab(41, '07 - nr_seq_lab_exame_dia_w: ' || nr_seq_lab_exame_dia_w ||
							      '; nr_seq_exame_lab_regra_w: ' || nr_seq_exame_lab_regra_w ||
							      '; dt_coleta_p: ' || PKG_DATE_FORMATERS_TZ.TO_VARCHAR(dt_coleta_p, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone)||
							      '; qt_dia_entrega_coleta_w: ' || qt_dia_entrega_coleta_w ||
							      '; qt_min_entrega_p: ' || qt_min_entrega_p ||
							      '; ie_dia_semana_final_p: ' || ie_dia_semana_final_p ||
							      '; dt_entrega_upd_w: ' ||  PKG_DATE_FORMATERS_TZ.TO_VARCHAR(dt_entrega_upd_w, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone),
							      'tasy',
							      nr_prescricao_p);
				end if;

			ELSE
                /* InIcio MD13 */

    BEGIN
        sql_w := 'CALL obter_dia_semana_upd_md(:1, :2, :3, :4, :5, :6, :7, :8, :9) INTO :dt_entrega_upd_w';
        EXECUTE sql_w
            USING IN dt_entrada_w, IN ds_hora_fixa_p, IN qt_dia_entrega_entrada_w, IN qt_min_entrega_p,
                  IN ie_dia_semana_final_p, IN dt_prescricao_w, IN qt_dia_entrega_coleta_w,
                  IN dt_coleta_p, IN 8, OUT dt_entrega_upd_w;

    EXCEPTION
        WHEN OTHERS THEN
            dt_entrega_upd_w := NULL;
    END;
                    /* Fim MD13 */

				UPDATE prescr_medica
				SET dt_entrega      = dt_entrega_upd_w
				WHERE nr_prescricao = nr_prescricao_p;

				if ie_gravar_log_lab_w = 'S' then
					CALL gravar_log_lab(41, '08 - nr_seq_lab_exame_dia_w: ' || nr_seq_lab_exame_dia_w ||
							      '; nr_seq_exame_lab_regra_w: ' || nr_seq_exame_lab_regra_w ||
							      '; dt_coleta_p: ' || PKG_DATE_FORMATERS_TZ.TO_VARCHAR(dt_coleta_p, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone)||
							      '; qt_dia_entrega_coleta_w: ' || qt_dia_entrega_coleta_w ||
							      '; qt_min_entrega_p: ' || qt_min_entrega_p ||
							      '; ie_dia_semana_final_p: ' || ie_dia_semana_final_p ||
							      '; dt_entrega_upd_w: ' ||  PKG_DATE_FORMATERS_TZ.TO_VARCHAR(dt_entrega_upd_w, 'timestamp', ESTABLISHMENT_TIMEZONE_UTILS.getTimeZone),
							      'tasy',
							      nr_prescricao_p);
				end if;

			END IF;
		END IF;
	END IF;
	cd_setor_atendimento_p     := SUBSTR(cd_setor_atendimento_p, 1, LENGTH(cd_setor_atendimento_p) - 1);
	cd_setor_coleta_p          := SUBSTR(cd_setor_coleta_p, 1, LENGTH(cd_setor_coleta_p)           - 1);
	cd_setor_entrega_p         := SUBSTR(cd_setor_entrega_p, 1, LENGTH(cd_setor_entrega_p)         - 1);
	IF (coalesce(cd_setor_atendimento_p::text, '') = '') THEN
		cd_setor_atendimento_p    := cd_setor_atendimento_p || cd_setor_solicitacao_p;
	END IF;
	cd_setor_atendimento_p := '(' || cd_setor_atendimento_p || ')';
	IF (coalesce(cd_setor_coleta_p::text, '') = '') THEN
		cd_setor_coleta_p     := cd_setor_coleta_p || cd_setor_solicitacao_p;
	END IF;
	cd_setor_coleta_p      := '(' || cd_setor_coleta_p || ')';
	IF (coalesce(cd_setor_entrega_p::text, '') = '') THEN
		cd_setor_entrega_p    := cd_setor_entrega_p || cd_setor_solicitacao_p;
	END IF;
	cd_setor_entrega_p := '(' || cd_setor_entrega_p || ')';
	ie_emite_mapa_p    := coalesce(ie_emite_mapa_p,'S');

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_setor_exame_lab ( nr_prescricao_p bigint, nr_seq_exame_p bigint, cd_setor_solicitacao_p bigint, cd_material_exame_p text, dt_coleta_p timestamp, ie_atualizar_dt_prescr_p text, cd_setor_atendimento_p INOUT text, cd_setor_coleta_p INOUT text, cd_setor_entrega_p INOUT text, qt_dia_entrega_p INOUT bigint, ie_emite_mapa_p INOUT text, ds_hora_fixa_p INOUT text, ie_data_resultado_p INOUT text, qt_min_entrega_p INOUT bigint, ie_atualizar_recoleta_p INOUT text, ie_urgencia_p text, ie_dia_semana_final_p INOUT bigint, ie_forma_atual_dt_result_p INOUT text, qt_min_atraso_p INOUT bigint, dt_entrada_p timestamp default null) FROM PUBLIC;

