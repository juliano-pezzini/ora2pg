-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_passagem_setor_evt_pepo (nr_cirurgia_p bigint DEFAULT 0, nr_seq_pepo_p bigint DEFAULT 0, cd_setor_atendimento_p bigint DEFAULT NULL, cd_unidade_basica_p text DEFAULT NULL, cd_unidade_compl_p text DEFAULT NULL, dt_entrada_unidade_p timestamp DEFAULT NULL, dt_saida_unidade_p timestamp DEFAULT NULL, nr_seq_interno_p bigint DEFAULT NULL, ie_opcao_p text DEFAULT NULL, nm_usuario_p text DEFAULT NULL, ie_atualizar_evt_cirurgia_p text DEFAULT NULL, nr_seq_aten_pac_unid_p INOUT bigint DEFAULT NULL) AS $body$
DECLARE


nr_atendimento_w 	bigint;
nr_atend_W 	bigint;
ie_cirurgia_w	varchar(1) := 'S';
ie_alter_status_pas_cc_w	varchar(1);
nr_seq_evt_cir_pac_w	evento_cirurgia_paciente.nr_sequencia%TYPE;


BEGIN
IF	((nr_cirurgia_p IS NOT NULL AND nr_cirurgia_p::text <> '') OR (nr_seq_pepo_p IS NOT NULL AND nr_seq_pepo_p::text <> '')) AND (cd_setor_atendimento_p IS NOT NULL AND cd_setor_atendimento_p::text <> '') AND (cd_unidade_basica_p IS NOT NULL AND cd_unidade_basica_p::text <> '') AND (cd_unidade_compl_p IS NOT NULL AND cd_unidade_compl_p::text <> '') AND (dt_entrada_unidade_p IS NOT NULL AND dt_entrada_unidade_p::text <> '') AND
	--(dt_saida_unidade_p     is not null) and

	--(nr_seq_interno_p       is not null) and
	(ie_opcao_p IS NOT NULL AND ie_opcao_p::text <> '') AND (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') THEN
	BEGIN

	IF (coalesce(nr_seq_pepo_p,0) > 0) THEN
		SELECT	coalesce(MAX('S'),'N')
		INTO STRICT	ie_cirurgia_w
		FROM	cirurgia
		WHERE	nr_seq_pepo = nr_seq_pepo_p;
	END IF;

	IF (ie_cirurgia_w = 'S') THEN
		SELECT	coalesce(MAX(nr_atendimento), 0)
		INTO STRICT	nr_atendimento_w
		FROM	cirurgia
		WHERE	(((coalesce(nr_cirurgia_p,0) > 0) AND (nr_cirurgia = 	nr_cirurgia_p)) OR
				 ((coalesce(nr_seq_pepo_p,0) > 0) AND (nr_seq_pepo = 	nr_seq_pepo_p)));
	ELSE
		SELECT	coalesce(MAX(nr_atendimento), 0)
		INTO STRICT	nr_atendimento_w
		FROM	pepo_cirurgia
		WHERE	nr_sequencia = nr_seq_pepo_p;
	END IF;

	IF (nr_atendimento_w = 0) THEN
		CALL Wheb_mensagem_pck.exibir_mensagem_abort(313473);
	END IF;

	nr_atend_W := gerar_passagem_setor_evento(	nr_atendimento_w, nr_cirurgia_p, nr_seq_pepo_p, cd_setor_atendimento_p, cd_unidade_basica_p, cd_unidade_compl_p, dt_entrada_unidade_p, dt_saida_unidade_p, nr_seq_interno_p, ie_opcao_p, nm_usuario_p, nr_atend_W);
					
	SELECT	MAX(nr_sequencia)
	INTO STRICT 	nr_seq_evt_cir_pac_w
	FROM 	evento_cirurgia_paciente
	WHERE 	coalesce(ie_situacao,'A') = 'A'
	AND 	((nr_cirurgia = nr_cirurgia_p AND coalesce(nr_cirurgia_p,0) > 0) OR (nr_seq_pepo = nr_seq_pepo_p AND coalesce(nr_seq_pepo_p,0) > 0));

	IF (ie_atualizar_evt_cirurgia_p = 'S') THEN
		BEGIN
		UPDATE	evento_cirurgia_paciente
		SET		nr_seq_aten_pac_unid = nr_atend_W
		WHERE	nr_sequencia = nr_seq_evt_cir_pac_w;
		END;
	END IF;
	
	SELECT 	coalesce(MAX(a.ie_alter_status_pas_cc), 'N')
	INTO STRICT 	ie_alter_status_pas_cc_w
	FROM    evento_cirurgia a,
			evento_cirurgia_paciente b
	WHERE   a.nr_sequencia = b.nr_seq_evento
	AND 	b.nr_sequencia = nr_seq_evt_cir_pac_w;
	
	IF (coalesce(ie_alter_status_pas_cc_w, 'N') = 'S') THEN
			
		UPDATE  unidade_atendimento a
		SET     a.ie_status_unidade   	= 	'P'
		WHERE	a.cd_unidade_basica 	=  	cd_unidade_basica_p
		AND 	a.cd_unidade_compl  	= 	cd_unidade_compl_p
		AND		a.cd_setor_atendimento 	= 	cd_setor_atendimento_p;
	END IF;
	END;
END IF;

COMMIT;

nr_seq_aten_pac_unid_p	:= nr_atend_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_passagem_setor_evt_pepo (nr_cirurgia_p bigint DEFAULT 0, nr_seq_pepo_p bigint DEFAULT 0, cd_setor_atendimento_p bigint DEFAULT NULL, cd_unidade_basica_p text DEFAULT NULL, cd_unidade_compl_p text DEFAULT NULL, dt_entrada_unidade_p timestamp DEFAULT NULL, dt_saida_unidade_p timestamp DEFAULT NULL, nr_seq_interno_p bigint DEFAULT NULL, ie_opcao_p text DEFAULT NULL, nm_usuario_p text DEFAULT NULL, ie_atualizar_evt_cirurgia_p text DEFAULT NULL, nr_seq_aten_pac_unid_p INOUT bigint DEFAULT NULL) FROM PUBLIC;
