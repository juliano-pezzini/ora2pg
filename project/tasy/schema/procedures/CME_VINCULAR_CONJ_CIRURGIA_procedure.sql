-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cme_vincular_conj_cirurgia ( cd_barras_p bigint, nr_cirurgia_p bigint, nm_usuario_p text, nr_seq_pepo_p bigint) AS $body$
DECLARE


nm_paciente_w		 varchar(100);
nr_atendimento_w	 bigint;
nr_atendimento_ww	 bigint;
nr_atendimento_www	 bigint;
ds_observacao_w		 varchar(255);
nr_cirurgia_w		 bigint;
dt_validade_w		 timestamp;
ie_vinc_conj_req_w	 varchar(1);
cd_estabelecimento_w	 smallint;
cd_estab_conj_w 	 smallint;
nr_seq_pepo_w		 bigint;
nr_cirurgia_ww		 bigint;
ie_status_conjunto_w	 smallint;
ds_param_status_conj_w   varchar(10);
ds_param_status_avulso_w varchar(10);
cd_local_repassar_w	 bigint;
cd_local_estoque_w	 bigint := null;
nr_seq_conjunto_w        bigint;
ie_tela_itens_item_cont_w varchar(1);
ie_status_conjunto_parametro_w smallint;
ie_vinc_conj_outr_estab_w varchar(1);


BEGIN

IF (coalesce(nr_cirurgia_p,0) > 0) THEN
	SELECT	SUBSTR(obter_nome_pf(cd_pessoa_fisica),1,100),
		nr_atendimento,
		cd_estabelecimento
	INTO STRICT	nm_paciente_w,
		nr_atendimento_w,
		cd_estabelecimento_w
	FROM	cirurgia
	WHERE	nr_cirurgia = nr_cirurgia_p;
ELSE
	SELECT	SUBSTR(obter_nome_pf(cd_pessoa_fisica),1,100),
		nr_atendimento
	INTO STRICT	nm_paciente_w,
		nr_atendimento_w
	FROM	pepo_cirurgia
	WHERE	nr_sequencia = nr_seq_pepo_p;
	cd_estabelecimento_w := wheb_usuario_pck.get_cd_estabelecimento;
END IF;


SELECT	coalesce(MAX(obter_valor_param_usuario(406, 75, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w)), 0)
INTO STRICT	ie_vinc_conj_req_w
;

ds_param_status_conj_w := Obter_Param_Usuario(872, 372, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ds_param_status_conj_w);
ds_param_status_avulso_w := Obter_Param_Usuario(872, 373, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ds_param_status_avulso_w);
cd_local_repassar_w := Obter_Param_Usuario(872, 376, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, cd_local_repassar_w);
ie_tela_itens_item_cont_w := Obter_Param_Usuario(872, 406, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_tela_itens_item_cont_w);
ie_status_conjunto_parametro_w := Obter_Param_Usuario(872, 426, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_status_conjunto_parametro_w);
ie_vinc_conj_outr_estab_w := Obter_Param_Usuario(872, 464, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_vinc_conj_outr_estab_w);

ds_observacao_w	:= SUBSTR(WHEB_MENSAGEM_PCK.get_texto(300051,'NM_PACIENTE_W='||nm_paciente_w||';NR_ATENDIMENTO_W='||nr_atendimento_w),1,255);

BEGIN

SELECT	nr_cirurgia,
	dt_validade,
	nr_atendimento,
	nr_seq_pepo,
	ie_status_conjunto,
	nr_seq_conjunto,
	cd_estabelecimento
INTO STRICT	nr_cirurgia_w,
	dt_validade_w,
	nr_atendimento_www,
	nr_seq_pepo_w,
	ie_status_conjunto_w,
	nr_seq_conjunto_w,
	cd_estab_conj_w
FROM	cm_conjunto_cont
WHERE	nr_sequencia	= cd_barras_p
AND	coalesce(ie_situacao,'A') = 'A';

EXCEPTION
	WHEN OTHERS THEN
	CALL WHEB_MENSAGEM_PCK.Exibir_Mensagem_Abort(181056);
END;


IF (TRUNC(coalesce(dt_validade_w,clock_timestamp())) < TRUNC(clock_timestamp())) THEN
	CALL WHEB_MENSAGEM_PCK.Exibir_Mensagem_Abort(181059);
END IF;

IF (ds_param_status_avulso_w IS NOT NULL AND ds_param_status_avulso_w::text <> '') AND (cm_obter_se_conj_avulso(nr_seq_conjunto_w) = 'N') AND (obter_se_contido(ie_status_conjunto_w, ds_param_status_conj_w ) = 'N') THEN
   CALL WHEB_MENSAGEM_PCK.Exibir_Mensagem_Abort(181060);
ELSIF (ds_param_status_conj_w IS NOT NULL AND ds_param_status_conj_w::text <> '') AND (cm_obter_se_conj_avulso(nr_seq_conjunto_w) = 'S') AND (obter_se_contido_char(ie_status_conjunto_w, ds_param_status_avulso_w) = 'N') THEN
   CALL WHEB_MENSAGEM_PCK.Exibir_Mensagem_Abort(181064);
ELSIF (ds_param_status_conj_w IS NOT NULL AND ds_param_status_conj_w::text <> '') AND (coalesce(ds_param_status_avulso_w::text, '') = '') AND (obter_se_contido(ie_status_conjunto_w, ds_param_status_conj_w) = 'N') THEN
   CALL WHEB_MENSAGEM_PCK.Exibir_Mensagem_Abort(181065);
END IF;
IF (nr_cirurgia_w IS NOT NULL AND nr_cirurgia_w::text <> '') OR (nr_seq_pepo_w IS NOT NULL AND nr_seq_pepo_w::text <> '') THEN
	IF (nr_cirurgia_w IS NOT NULL AND nr_cirurgia_w::text <> '') THEN
		SELECT	nr_atendimento
		INTO STRICT	nr_atendimento_ww
		FROM	cirurgia
		WHERE	nr_cirurgia = nr_cirurgia_w;
		CALL WHEB_MENSAGEM_PCK.Exibir_Mensagem_Abort(181087,'NR_CIRURGIA_W='||to_char(nr_cirurgia_w)||';NR_ATENDIMENTO_WW='||to_char(nr_atendimento_ww));
	ELSE
		SELECT	MAX(nr_atendimento),
			MAX(nr_cirurgia)
		INTO STRICT	nr_atendimento_ww,
			nr_cirurgia_ww
		FROM	cirurgia
		WHERE	nr_seq_pepo = nr_seq_pepo_w;
		CALL WHEB_MENSAGEM_PCK.Exibir_Mensagem_Abort(181093, 'NR_SEQ_PEPO_W='||to_char(nr_seq_pepo_w)||';NR_CIRURGIA_WW='||to_char(nr_cirurgia_ww)||';NR_ATENDIMENTO_WW='||to_char(nr_atendimento_ww));
	END IF;
ELSIF (nr_atendimento_www IS NOT NULL AND nr_atendimento_www::text <> '') THEN
	CALL WHEB_MENSAGEM_PCK.Exibir_Mensagem_Abort(181095, 'NR_ATENDIMENTO_WWW='||to_char(nr_atendimento_www));
ELSIF (ie_vinc_conj_outr_estab_w = 'N') and (cd_estab_conj_w <> wheb_usuario_pck.get_cd_estabelecimento) THEN
	CALL WHEB_MENSAGEM_PCK.Exibir_Mensagem_Abort(226215);
ELSE
	IF (cd_local_repassar_w <> 0) THEN
		cd_local_estoque_w	:= cd_local_repassar_w;
	END IF;	
	UPDATE	cm_conjunto_cont
	SET	nr_cirurgia	  = CASE WHEN nr_cirurgia_p=0 THEN NULL  ELSE nr_cirurgia_p END ,
		ds_observacao	  = ds_observacao_w,
		dt_atualizacao	  = clock_timestamp(),
		nm_usuario	  = nm_usuario_p,
		nr_atendimento	  = nr_atendimento_w,
		nr_seq_pepo	  = CASE WHEN nr_seq_pepo_p=0 THEN NULL  ELSE nr_seq_pepo_p END ,
		NM_USUARIO_VINC	  = nm_usuario_p,
		DT_VINCULO_CONJ   = clock_timestamp(),
		cd_local_estoque  = coalesce(cd_local_estoque_w,cd_local_estoque),
		ie_status_conjunto = coalesce(ie_status_conjunto_parametro_w, ie_status_conjunto)
	WHERE	nr_sequencia	  = cd_barras_p;
	COMMIT;
if (ie_tela_itens_item_cont_w = 'N') then
	CALL vinc_desv_item_controle_cme(nr_cirurgia_p,nr_seq_pepo_p,cd_barras_p,'V',nm_usuario_p);
end if;
	
END IF;

IF (ie_vinc_conj_req_w = 'S') THEN
	CALL cm_vincula_conj_cirurgia_req(cd_barras_p,nr_cirurgia_p,nm_usuario_p);
END IF;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cme_vincular_conj_cirurgia ( cd_barras_p bigint, nr_cirurgia_p bigint, nm_usuario_p text, nr_seq_pepo_p bigint) FROM PUBLIC;

