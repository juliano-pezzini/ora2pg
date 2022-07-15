-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_transfusao_reserva (NR_SEQ_RESERVA_P bigint, CD_PF_REALIZOU_P text, NM_USUARIO_P text, IE_DATA_ATUAL_P text, IE_DATA_UTILIZACAO_P text, CD_ESTABELECIMENTO_P bigint, NR_SEQ_TRANSFUSAO_P INOUT bigint ) AS $body$
DECLARE


cd_pessoa_fisica_w		varchar(10);
nr_atendimento_w		bigint;
nr_prescricao_w			bigint;
dt_cirurgia_w			timestamp;
cd_medico_req_w			varchar(10);
cd_medico_cir_w			varchar(10);

nr_seq_trans_w			bigint;

nr_sequencia_w			bigint;
nr_seq_producao_w		bigint;


cd_estabelecimento_w		smallint;

nr_seq_entidade_w		bigint;
cd_unidade_externa_w		varchar(60);
nm_solicitante_w		varchar(255);
cd_pessoa_resp_w		varchar(10);
nr_seq_classif_w		varchar(10);
nr_seq_prod_w			bigint;
nr_identificacao_w		varchar(20);
nr_cirurgia_w			bigint;

c01 CURSOR FOR
	SELECT	nr_sequencia,
		nr_seq_producao
	FROM san_reserva_prod
	WHERE nr_seq_reserva = nr_seq_reserva_p
	  AND ie_status = 'T';

C02 CURSOR FOR
	SELECT	nr_sequencia
	FROM	san_producao
	WHERE 	nr_sequencia IN (SELECT	nr_seq_producao
				FROM	san_reserva_prod
				WHERE	nr_seq_reserva = nr_seq_reserva_p
				AND	ie_status = 'R');


BEGIN

	BEGIN
	SELECT	cd_pessoa_fisica,
		nr_atendimento,
		CASE WHEN ie_data_atual_p='S' THEN clock_timestamp()  ELSE dt_cirurgia END  dt_cirurgia,
		cd_medico_requisitante,
		cd_medico_cirurgiao,
		cd_estabelecimento,
		nr_prescricao,
		nr_seq_entidade,
		cd_unidade_externa,
		nm_solicitante,
		cd_pessoa_resp,
		nr_seq_classif,
		SUBSTR(nr_identificacao,1,20),
		nr_cirurgia
	INTO STRICT	cd_pessoa_fisica_w,
		nr_atendimento_w,
		dt_cirurgia_w,
		cd_medico_req_w,
		cd_medico_cir_w,
		cd_estabelecimento_w,
		nr_prescricao_w,
		nr_seq_entidade_w,
		cd_unidade_externa_w,
		nm_solicitante_w,
		cd_pessoa_resp_w,
		nr_seq_classif_w,
		nr_identificacao_w,
		nr_cirurgia_w
	FROM	san_reserva
	WHERE	nr_sequencia = nr_seq_reserva_p;
	EXCEPTION
		WHEN	no_data_found THEN
			nr_atendimento_w := NULL;
	END;

IF (nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '') THEN

	SELECT	nextval('san_transfusao_seq')
	INTO STRICT	nr_seq_trans_w
	;

	INSERT INTO san_transfusao(
		cd_estabelecimento,
		nr_sequencia, 
		nr_atendimento, 
		cd_pessoa_fisica, 
		dt_transfusao, 
		dt_atualizacao,
		nm_usuario, 
		cd_medico_requisitante, 
		cd_pf_realizou, 
		nr_seq_reserva,
		ie_tipo_transfusao, 
		ie_status, 
		nr_prescricao, 
		nr_seq_entidade, 
		cd_unidade_externa, 
		nm_solicitante,
		cd_pessoa_resp, 
		nr_seq_classif, 
		nr_identificacao,
		nr_cirurgia)
	VALUES (cd_estabelecimento_w, 
		nr_seq_trans_w, 
		nr_atendimento_w, 
		cd_pessoa_fisica_w, 
		dt_cirurgia_w, 
		clock_timestamp(),
		nm_usuario_p, 
		coalesce(cd_medico_cir_w, cd_medico_req_w), 
		cd_pf_realizou_p, 
		nr_seq_reserva_p,
		coalesce(obter_valor_prescr_solic(nr_prescricao_w),1), 
		'A', 
		nr_prescricao_w, 
		nr_seq_entidade_w, 
		cd_unidade_externa_w, 
		nm_solicitante_w,
		cd_pessoa_resp_w, 
		nr_seq_classif_w, 
		nr_identificacao_w, 
		nr_cirurgia_w);

	begin
	CALL Gerar_Exame_Realizado(3, nr_seq_trans_w, NULL, cd_pf_realizou_p, nm_usuario_p, 'N', 'N', 'N', 'N',0, NULL, NULL, 'N', 'N', cd_estabelecimento_p);
	CALL San_gerar_identif_transf(nr_seq_trans_w,nm_usuario_p,'T');
	exception when others then
    null;
	end;
	IF (IE_DATA_UTILIZACAO_P = 'S') THEN
		
		UPDATE	san_producao
		SET	nr_seq_transfusao = nr_seq_trans_w,
			dt_utilizacao = clock_timestamp(),
			nm_usuario = nm_usuario_p,
			dt_atualizacao = clock_timestamp()
		WHERE	nr_sequencia IN (	
				SELECT	nr_seq_producao
				FROM	san_reserva_prod
				WHERE	nr_seq_reserva = nr_seq_reserva_p
				AND	ie_status = 'R');
	ELSE
		UPDATE	san_producao
		SET	nr_seq_transfusao = nr_seq_trans_w,
			nm_usuario = nm_usuario_p,
			dt_atualizacao = clock_timestamp()
		WHERE	nr_sequencia IN (
				SELECT	nr_seq_producao
				FROM	san_reserva_prod
				WHERE	nr_seq_reserva = nr_seq_reserva_p
				AND	ie_status = 'R');
	END IF;

	OPEN C02;
	LOOP
	FETCH C02 INTO
		nr_seq_prod_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		BEGIN
		CALL San_gerar_material_aliq(nr_seq_trans_w, nr_seq_prod_w, nm_usuario_p);
		exception when others then
        null;					
		END;
	END LOOP;
	CLOSE C02;

	UPDATE	san_reserva_prod
	SET	ie_status = 'T'
	WHERE	nr_seq_reserva = nr_seq_reserva_p
	AND	ie_status = 'R';

	UPDATE	san_reserva_prod
	SET	ie_status = 'N'
	WHERE	nr_seq_reserva <> nr_seq_reserva_p
	AND	nr_seq_producao IN (	
			SELECT	nr_seq_producao
			FROM	san_reserva_prod
			WHERE	nr_seq_reserva = nr_seq_reserva_p
			AND	ie_status = 'T');

	UPDATE	san_exame_lote
	SET	nr_seq_transfusao = nr_seq_trans_w,
		nm_usuario = nm_usuario_p,
		dt_atualizacao = clock_timestamp()
	WHERE	nr_seq_reserva = nr_seq_reserva_p;

	UPDATE	san_reserva
	SET	ie_status = 'T'
	WHERE	nr_sequencia = nr_seq_reserva_p;

END IF;

OPEN c01;
LOOP
FETCH c01 INTO	nr_sequencia_w,
		nr_seq_producao_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
	
	UPDATE	san_exame_lote
	SET	nr_seq_producao = nr_seq_producao_w,
		ie_origem	  = 'T'
	WHERE	nr_seq_res_prod = nr_sequencia_w;

END LOOP;
CLOSE c01;

UPDATE	san_producao
SET	nr_seq_propaci  = NULL
WHERE	nr_sequencia IN (	
		SELECT	nr_seq_producao
		FROM 	san_reserva_prod
		WHERE 	nr_seq_reserva = nr_seq_reserva_p
		AND 	ie_status = 'N')
AND (nr_seq_propaci IS NOT NULL AND nr_seq_propaci::text <> '');


COMMIT;

nr_seq_transfusao_p := nr_seq_trans_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_transfusao_reserva (NR_SEQ_RESERVA_P bigint, CD_PF_REALIZOU_P text, NM_USUARIO_P text, IE_DATA_ATUAL_P text, IE_DATA_UTILIZACAO_P text, CD_ESTABELECIMENTO_P bigint, NR_SEQ_TRANSFUSAO_P INOUT bigint ) FROM PUBLIC;

