-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_regra_doacao_san (nr_seq_doacao_p bigint, nm_usuario_p text, ie_tipo_coleta_p bigint, cd_pessoa_fisica_p text, ds_mensagem_p INOUT text, nr_seq_derivado_p bigint default null, dt_doacao_p timestamp DEFAULT NULL) AS $body$
DECLARE

                               

ds_mensagem_w			varchar(300);				
ie_sexo_w			varchar(1);
nr_sequencia_w			bigint;
qt_dias_ult_dia_w		bigint;
qt_doacao_ano_w			bigint;
dt_doacao_w			timestamp;
qt_doa_ano_w			bigint;
ie_tipo_doacao_ant_reg_w 	smallint;
ie_tipo_doacao_reg_w		smallint;
nr_seq_doacao_anterior_w	bigint;
ie_tipo_coleta_ant_w		smallint;
ie_considera_tipo_bolsa_w	varchar(1);
qt_bolsa_simples_w		bigint;
qt_bolsa_dupla_w		bigint;
ds_tipo_coleta_w		varchar(255);
dt_anterior_w			timestamp;
nr_seq_derivado_ant_w           san_doacao.nr_seq_derivado%type;
nr_seq_doacao_periodo_w         bigint;
qt_hora_w                       bigint;
qt_hora_perm_w                  bigint;
qt_dia_w                        bigint;
qt_dia_perm_w                   bigint;
qt_mes_w                        bigint;
qt_mes_perm_w                   bigint;
qt_registros_doacao_w           bigint;
data_ultima_doacao_w            timestamp;
qt_prox_doacao_mes_w            bigint;
ds_texto_w                      varchar(10);
					

BEGIN
ds_mensagem_w := NULL;
dt_anterior_w := clock_timestamp() - interval '365 days';

IF (nr_seq_doacao_p IS NOT NULL AND nr_seq_doacao_p::text <> '') THEN

	SELECT	MAX(ie_sexo)
	INTO STRICT	ie_sexo_w
	FROM 	pessoa_fisica
	WHERE	cd_pessoa_fisica = cd_pessoa_fisica_p;
	
	--verificar a ultima sequencia/doacao concluida do doador	
	SELECT 	MAX(nr_sequencia)
	INTO STRICT	nr_seq_doacao_anterior_w
	FROM   	san_doacao
	WHERE 	cd_pessoa_fisica = cd_pessoa_fisica_p
	AND 	(dt_coleta IS NOT NULL AND dt_coleta::text <> '')
	and 	ie_tipo_coleta = ie_tipo_coleta_p
	AND     nr_sequencia <> nr_seq_doacao_p;	
	
	--localizar o tipo de coleta e o hemocomponente da ultima doacao
	SELECT  max(ie_tipo_coleta),
                MAX(nr_seq_derivado)
	INTO STRICT	ie_tipo_coleta_ant_w,
                nr_seq_derivado_ant_w
	FROM    san_doacao
	WHERE 	nr_sequencia = nr_seq_doacao_anterior_w;	
			
	--Verificar se eh doacao mista e se tem regra cadastrada
	IF (ie_tipo_coleta_ant_w IS NOT NULL AND ie_tipo_coleta_ant_w::text <> '') THEN

                --Nova regra, Regra de Periodos (Regra por Sexo/Tipo de Coleta Atual e Anterior/Hemocomponente Atual e Anterior) e Se Hemocomponentes 5, 6 ou 7
                IF ((ie_tipo_coleta_ant_w IS NOT NULL AND ie_tipo_coleta_ant_w::text <> '') AND (ie_tipo_coleta_p IN (5,6,7))) THEN
                
                        SELECT	MAX(nr_sequencia),
                                MAX(qt_dias_ult_dia),
                                MAX(qt_prox_doacao_mes),
                                MAX(qt_doacao_ano),
                                MAX(nr_tipo_doacao),
                                MAX(nr_tipo_doacao_anterior),
                                MAX(ie_considerar_tipo_bolsa)
                        INTO STRICT    nr_sequencia_w,
                                qt_dias_ult_dia_w,
                                qt_prox_doacao_mes_w,
                                qt_doacao_ano_w,
                                ie_tipo_doacao_reg_w,
                                ie_tipo_doacao_ant_reg_w,
                                ie_considera_tipo_bolsa_w
                        FROM    san_regra_doacao
                        WHERE   ie_tipo_coleta_p IN (5,6,7)
                        AND     ie_sexo = ie_sexo_w
                        AND     coalesce(nr_tipo_doacao,99) = coalesce(ie_tipo_coleta_p,99)
                        AND (nr_seq_derivado = nr_seq_derivado_p or coalesce(nr_seq_derivado::text, '') = '')
                        AND (nr_seq_derivado_ant = nr_seq_derivado_ant_w or coalesce(nr_seq_derivado_ant::text, '') = '');

                ELSE 
                
                        SELECT	MAX(nr_sequencia),
                                MAX(qt_dias_ult_dia),
                                MAX(qt_doacao_ano),
                                MAX(nr_tipo_doacao),
                                MAX(nr_tipo_doacao_anterior),
                                MAX(ie_considerar_tipo_bolsa)
                        INTO STRICT	nr_sequencia_w,
                                qt_dias_ult_dia_w,
                                qt_doacao_ano_w,
                                ie_tipo_doacao_reg_w,
                                ie_tipo_doacao_ant_reg_w,
                                ie_considera_tipo_bolsa_w
                        FROM	san_regra_doacao
                        WHERE	ie_sexo = ie_sexo_w
                        AND  	coalesce(nr_tipo_doacao,99) 		= coalesce(ie_tipo_coleta_p,99)
                        AND	coalesce(nr_tipo_doacao_anterior,99) = coalesce(ie_tipo_coleta_ant_w,99)
                        AND (nr_seq_derivado = nr_seq_derivado_p or coalesce(nr_seq_derivado::text, '') = '')
                        AND (nr_seq_derivado_ant = nr_seq_derivado_ant_w or coalesce(nr_seq_derivado_ant::text, '') = '');
                END IF;
	END IF;

        --Verifica se regra por tipo (aferese/Sangue total)
	IF (coalesce(nr_sequencia_w::text, '') = '') THEN
                SELECT	MAX(nr_sequencia),
			MAX(qt_dias_ult_dia),
			MAX(qt_doacao_ano),
			MAX(nr_tipo_doacao),
			MAX(nr_tipo_doacao_anterior),
			MAX(ie_considerar_tipo_bolsa)
		INTO STRICT	nr_sequencia_w,
			qt_dias_ult_dia_w,
			qt_doacao_ano_w,
			ie_tipo_doacao_reg_w,
			ie_tipo_doacao_ant_reg_w,
			ie_considera_tipo_bolsa_w
		FROM	san_regra_doacao
		WHERE	ie_sexo = ie_sexo_w
		AND 	coalesce(nr_tipo_doacao,99) = coalesce(ie_tipo_coleta_p,99)
		AND	coalesce(nr_tipo_doacao_anterior::text, '') = ''
		AND (nr_seq_derivado = nr_seq_derivado_p or coalesce(nr_seq_derivado::text, '') = '')
		AND (nr_seq_derivado_ant = nr_seq_derivado_ant_w or coalesce(nr_seq_derivado_ant::text, '') = '');
	END IF;	

        --Se nao tiver regra por tipo (aferese/Sangue total) e nem por doacao mista, pegar a regra normal
	IF (coalesce(nr_sequencia_w::text, '') = '') THEN
		SELECT	MAX(nr_sequencia),
			MAX(qt_dias_ult_dia),
			MAX(qt_doacao_ano)		
		INTO STRICT	nr_sequencia_w,
			qt_dias_ult_dia_w,
			qt_doacao_ano_w	
		FROM	san_regra_doacao
		WHERE	ie_sexo = ie_sexo_w
		AND	coalesce(ie_tipo_bolsa::text, '') = ''
		AND	coalesce(nr_tipo_doacao::text, '') = ''
		AND	coalesce(nr_tipo_doacao_anterior::text, '') = ''
		AND (nr_seq_derivado = nr_seq_derivado_p or coalesce(nr_seq_derivado::text, '') = '')
		AND (nr_seq_derivado_ant = nr_seq_derivado_ant_w or coalesce(nr_seq_derivado_ant::text, '') = '');
	END IF;
	
	
	IF (nr_sequencia_w > 0) THEN

                --localizar a ultima data de doacao
                SELECT  MAX(dt_coleta)
                INTO STRICT    data_ultima_doacao_w
                FROM    SAN_DOACAO
                WHERE   cd_pessoa_fisica = cd_pessoa_fisica_p
                AND     (dt_coleta IS NOT NULL AND dt_coleta::text <> '');

                --busca informacoes dos periodos cadastrados, vinculados a regra localizada.
                SELECT	MAX(nr_sequencia),
                        MAX(qt_hora),
                        MAX(qt_hora_perm),
                        MAX(qt_dia),
                        MAX(qt_dia_perm),
                        MAX(qt_mes),
                        MAX(qt_mes_perm)
		INTO STRICT	nr_seq_doacao_periodo_w,
                        qt_hora_w,
                        qt_hora_perm_w,	
                        qt_dia_w,
                        qt_dia_perm_w,
                        qt_mes_w,
                        qt_mes_perm_w
		FROM	SAN_DOACAO_PERIODO
                WHERE   nr_seq_regra_doacao = nr_sequencia_w;

                IF (qt_doacao_ano_w > 0) AND (coalesce(ie_considera_tipo_bolsa_w,'N') = 'N') THEN
                        SELECT	COUNT(*)
                        INTO STRICT	qt_doa_ano_w
                        FROM	san_doacao
                        WHERE (dt_doacao > dt_anterior_w)
                        AND	cd_pessoa_fisica = cd_pessoa_fisica_p
                        AND     (dt_coleta IS NOT NULL AND dt_coleta::text <> '')
                        AND	nr_sequencia <> nr_seq_doacao_p;

                        IF (qt_doa_ano_w >= qt_doacao_ano_w ) THEN
                                ds_mensagem_w := ds_mensagem_w || wheb_mensagem_pck.get_texto(307646, 'QT_DOA_ANO_W=' || qt_doa_ano_w); -- O doador possui #@QT_DOA_ANO_W#@ doacoes no periodo de um ano.
                        END IF;

                ELSIF (qt_doacao_ano_w > 0) AND (coalesce(ie_considera_tipo_bolsa_w,'N') = 'S') THEN
                        SELECT (COUNT(*) * 2)
                        INTO STRICT	qt_bolsa_simples_w
                        FROM	san_doacao
                        WHERE (dt_doacao > dt_anterior_w) 
                        AND	cd_pessoa_fisica = cd_pessoa_fisica_p
                        AND     (dt_coleta IS NOT NULL AND dt_coleta::text <> '')			
                        AND	nr_sequencia  	<> nr_seq_doacao_p
                        AND	ie_tipo_coleta = ie_tipo_coleta_p
                        AND	ie_tipo_bolsa 	= '1';

                        
                        SELECT	COUNT(*)
                        INTO STRICT	qt_bolsa_dupla_w
                        FROM	san_doacao
                        WHERE (dt_doacao > dt_anterior_w) 
                        AND	cd_pessoa_fisica = cd_pessoa_fisica_p
                        AND     (dt_coleta IS NOT NULL AND dt_coleta::text <> '')			
                        AND	nr_sequencia  	<> nr_seq_doacao_p
                        AND	ie_tipo_coleta  = ie_tipo_coleta_p
                        AND	ie_tipo_bolsa 	= '2';

                        qt_doa_ano_w := qt_bolsa_simples_w + qt_bolsa_dupla_w;

                        SELECT	obter_valor_dominio(1353,ie_tipo_coleta_p)
                        INTO STRICT	ds_tipo_coleta_w
;

                
                        IF (qt_doa_ano_w >= qt_doacao_ano_w ) THEN
                                ds_mensagem_w := ds_mensagem_w || wheb_mensagem_pck.get_texto(307647, 'DS_TIPO_COLETA_W=' || ds_tipo_coleta_w); -- O doador ja atingiu o limite de doacoes de #@DS_TIPO_COLETA_W#@ no periodo de um ano.
                        END IF;

                END IF;

                --Possui regra de periodo
                IF (nr_seq_doacao_periodo_w > 0) THEN
                        IF (qt_mes_w > 0) THEN
                        --validar meses
                        qt_registros_doacao_w := HEMOT_GET_DONATIONS_BY_PERIOD(cd_pessoa_fisica_p, data_ultima_doacao_w, dt_doacao_p, qt_mes_w, 'MES');

                                IF (qt_registros_doacao_w >= qt_mes_perm_w) THEN
                                        ds_mensagem_w := wheb_mensagem_pck.get_texto(1213251);

                                        IF (qt_prox_doacao_mes_w > 0) THEN
                                                ds_texto_w := 'mes';
                                                IF (qt_prox_doacao_mes_w > 1) THEN
                                                        ds_texto_w := 'meses';
                                                END IF;

                                                IF (dt_doacao_p <=  data_ultima_doacao_w + (qt_prox_doacao_mes_w * 30)) THEN
                                                        ds_mensagem_w := wheb_mensagem_pck.get_texto(1213953, 'QT_MES_LIMITE_W=' || qt_prox_doacao_mes_w || ' ' || ds_texto_w);
                                                END IF;
                                        END IF;
                                END IF;
                        END IF;

                        IF (qt_dia_w > 0) THEN
                                --validar dias
                                qt_registros_doacao_w := HEMOT_GET_DONATIONS_BY_PERIOD(cd_pessoa_fisica_p, data_ultima_doacao_w, dt_doacao_p, qt_dia_w, 'DIA');

                                IF (qt_registros_doacao_w >= qt_dia_perm_w) THEN
                                        ds_mensagem_w := wheb_mensagem_pck.get_texto(1213250);
                                END IF;
                        END IF;

                        IF (qt_hora_w > 0) THEN
                                --validar horas   
                                qt_registros_doacao_w := HEMOT_GET_DONATIONS_BY_PERIOD(cd_pessoa_fisica_p, data_ultima_doacao_w, dt_doacao_p, qt_hora_w, 'HORA');

                                IF (qt_registros_doacao_w >= qt_hora_perm_w) THEN
                                        ds_mensagem_w := wheb_mensagem_pck.get_texto(1213225);
                                END IF;
                        END IF;
                ELSE
                        --se nao tiver periodo / usa qt_dias_ult_dia
                        IF (qt_dias_ult_dia_w > 0) THEN
                                SELECT	MAX(dt_doacao)
                                INTO STRICT 	dt_doacao_w
                                FROM	san_doacao
                                WHERE	cd_pessoa_fisica = cd_pessoa_fisica_p
                                AND     (dt_coleta IS NOT NULL AND dt_coleta::text <> '') 
                                AND	nr_sequencia <> nr_seq_doacao_p;

                                IF (dt_doacao_w > (clock_timestamp() - qt_dias_ult_dia_w)) THEN
                                        ds_mensagem_w := wheb_mensagem_pck.get_texto(307643, 'QT_DIAS_ULT_DIA_W=' || qt_dias_ult_dia_w); -- A ultima doacao foi a menos de #@QT_DIAS_ULT_DIA_W#@ dias.
                                END IF;
                        END IF;
                END IF;
        END IF;
END IF;
ds_mensagem_p := ds_mensagem_w;	

COMMIT;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_regra_doacao_san (nr_seq_doacao_p bigint, nm_usuario_p text, ie_tipo_coleta_p bigint, cd_pessoa_fisica_p text, ds_mensagem_p INOUT text, nr_seq_derivado_p bigint default null, dt_doacao_p timestamp DEFAULT NULL) FROM PUBLIC;

