-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_exibe_reg_oft ( nr_seq_item_p bigint, nr_seq_consulta_p bigint, nr_atendimento_p bigint, cd_pessoa_fisica_p text, nm_usuario_p text) RETURNS varchar AS $body$
DECLARE


qt_registro_w  		bigint;
ds_retorno_w		varchar(255);
ie_auto_refracao_w	varchar(2);
cd_perfil_w		integer;
ie_visualiza_inativos_w	varchar(1) := 'S';
visualizar_aval_inati_w	varchar(1);
ie_libera_evolucao_w	varchar(1);
ie_lib_atestado_w	varchar(1);
ie_lib_solic_externo_w	varchar(1);
ie_libera_exames_oft_w	varchar(1);



BEGIN
cd_perfil_w := obter_perfil_ativo;

ie_auto_refracao_w := Obter_Param_Usuario(3010, 45, cd_perfil_w, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_auto_refracao_w);
ie_libera_evolucao_w := Obter_Param_Usuario(0, 37, cd_perfil_w, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_libera_evolucao_w);

SELECT	MAX(ie_libera_exames_oft),
	MAX(ie_lib_atestado),
	MAX(ie_lib_solic_externo)
INTO STRICT	ie_libera_exames_oft_w,
	ie_lib_atestado_w,
	ie_lib_solic_externo_w
FROM 	parametro_medico
WHERE 	cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento;

IF (nr_seq_item_p = 2) THEN
	IF (ie_libera_exames_oft_w = 'N') THEN
		SELECT 	COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    oft_anamnese
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND	coalesce(ie_situacao,'A') 	= 'A';
	ELSE
		SELECT 	COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    oft_anamnese
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND	coalesce(ie_situacao,'A') 	= 'A'
		AND	((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') OR (nm_usuario = nm_usuario_p));
	END IF;
ELSIF (nr_seq_item_p = 233) THEN
	IF (ie_libera_exames_oft_w = 'N') THEN
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    oft_consulta_padrao
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND	coalesce(ie_situacao,'A') 	= 'A';
	ELSE
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    oft_consulta_padrao
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND	coalesce(ie_situacao,'A') 	= 'A'
		AND	((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') OR (nm_usuario = nm_usuario_p));
	END IF;
ELSIF (nr_seq_item_p = 4) THEN

	IF ((ie_auto_refracao_w = 'AR') OR (ie_auto_refracao_w = 'N')) THEN
		IF (ie_libera_exames_oft_w = 'N') THEN
			SELECT COUNT(*)
			INTO STRICT 	qt_registro_w
			FROM    OFT_AUTO_REFRACAO
			WHERE   nr_seq_consulta  	= nr_seq_consulta_p
			AND 	((ie_refracao_sugerida = 'N') OR (coalesce(ie_refracao_sugerida::text, '') = ''))
			AND	coalesce(ie_situacao,'A') 	= 'A';
		ELSE
			SELECT COUNT(*)
			INTO STRICT 	qt_registro_w
			FROM    OFT_AUTO_REFRACAO
			WHERE   nr_seq_consulta  	= nr_seq_consulta_p
			AND 	((ie_refracao_sugerida = 'N') OR (coalesce(ie_refracao_sugerida::text, '') = ''))
			AND	coalesce(ie_situacao,'A') 	= 'A'
			AND	((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') OR (nm_usuario = nm_usuario_p));
		END IF;
	ELSIF (ie_auto_refracao_w = 'S') THEN
		IF (ie_libera_exames_oft_w = 'N') THEN
			SELECT COUNT(*)
			INTO STRICT 	qt_registro_w
			FROM    OFT_REFRACAO
			WHERE   nr_seq_consulta  	= nr_seq_consulta_p
			AND ((ie_refracao_sugerida = 'N') OR (coalesce(ie_refracao_sugerida::text, '') = ''))
			AND	coalesce(ie_situacao,'A') 	= 'A';
		ELSE
			SELECT COUNT(*)
			INTO STRICT 	qt_registro_w
			FROM    OFT_REFRACAO
			WHERE   nr_seq_consulta  	= nr_seq_consulta_p
			AND ((ie_refracao_sugerida = 'N') OR (coalesce(ie_refracao_sugerida::text, '') = ''))
			AND	coalesce(ie_situacao,'A') 	= 'A'
			AND	((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') OR (nm_usuario = nm_usuario_p));
		END IF;
	END IF;

ELSIF (nr_seq_item_p = 6) THEN
	IF (ie_libera_exames_oft_w = 'N') THEN
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_EXAME_EXTERNO
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND	coalesce(ie_situacao,'A') 	= 'A';
	ELSE
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_EXAME_EXTERNO
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND	coalesce(ie_situacao,'A') 	= 'A'
		AND	((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') OR (nm_usuario = nm_usuario_p));
	END IF;
ELSIF (nr_seq_item_p = 7) THEN
	IF (ie_libera_exames_oft_w = 'N') THEN
		SELECT 	COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_MOTILIDADE_OCULAR
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND	coalesce(ie_situacao,'A') 	= 'A';
	ELSE
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_MOTILIDADE_OCULAR
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND	coalesce(ie_situacao,'A') 	= 'A'
		AND	((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') OR (nm_usuario = nm_usuario_p));
	END IF;

ELSIF (nr_seq_item_p = 8) THEN
	IF (ie_libera_exames_oft_w = 'N') THEN
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_TONOMETRIA
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND 	ie_tipo_tonometria 		= 1
		AND	coalesce(ie_situacao,'A') 	= 'A';
	ELSE
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_TONOMETRIA
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND 	ie_tipo_tonometria 		= 1
		AND	coalesce(ie_situacao,'A') 	= 'A'
		AND	((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') OR (nm_usuario = nm_usuario_p));
	END IF;

ELSIF (nr_seq_item_p = 9) THEN
	IF (ie_libera_exames_oft_w = 'N') THEN
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_FUNDOSCOPIA
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND	coalesce(ie_situacao,'A') 	= 'A';
	ELSE
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_FUNDOSCOPIA
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND	coalesce(ie_situacao,'A') 	= 'A'
		AND	((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') OR (nm_usuario = nm_usuario_p));
	END IF;
ELSIF (nr_seq_item_p = 10) THEN
	IF (ie_libera_exames_oft_w = 'N') THEN
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_BIOMICROSCOPIA
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND	coalesce(ie_situacao,'A') 	= 'A';
	ELSE
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_BIOMICROSCOPIA
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND	coalesce(ie_situacao,'A') 	= 'A'
		AND	((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') OR (nm_usuario = nm_usuario_p));
	END IF;
ELSIF (nr_seq_item_p = 12) THEN
	IF (ie_libera_exames_oft_w = 'N') THEN
		SELECT	COUNT(*)
		INTO STRICT	qt_registro_w
		FROM	oft_diagnostico
		WHERE	nr_seq_consulta 	= nr_seq_consulta_p
		AND	coalesce(ie_situacao,'A') 	= 'A';
	ELSE
		SELECT	COUNT(*)
		INTO STRICT	qt_registro_w
		FROM	oft_diagnostico
		WHERE	nr_seq_consulta 	= nr_seq_consulta_p
		AND	coalesce(ie_situacao,'A') 	= 'A'
		AND	((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') OR (nm_usuario = nm_usuario_p));
	END IF;
ELSIF (nr_seq_item_p = 13) THEN
	IF (ie_libera_exames_oft_w = 'N') THEN
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_OCULOS
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND	coalesce(ie_situacao,'A') 	= 'A';
	ELSE
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_OCULOS
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND	coalesce(ie_situacao,'A') 	= 'A'
		AND	((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') OR (nm_usuario = nm_usuario_p));
	END IF;

ELSIF (nr_seq_item_p = 14) THEN
	IF (ie_libera_exames_oft_w = 'N') THEN
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_CONSULTA_LENTE
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND	coalesce(ie_situacao,'A') 	= 'A';
	ELSE
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_CONSULTA_LENTE
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND	coalesce(ie_situacao,'A') 	= 'A'
		AND	((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') OR (nm_usuario = nm_usuario_p));
	END IF;

ELSIF (nr_seq_item_p = 15) THEN
	SELECT 	COUNT(*)
	INTO STRICT 	qt_registro_w
	FROM    cirurgia
	WHERE   nr_atendimento  = nr_atendimento_p
	AND	ie_status_cirurgia NOT IN (3,4);

ELSIF (nr_seq_item_p = 16) THEN
	IF (ie_libera_exames_oft_w = 'N') THEN
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    MED_RECEITA
		WHERE   nr_atendimento_hosp 	= nr_atendimento_p
		AND	coalesce(ie_situacao,'A') 	= 'A';
	ELSE
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    MED_RECEITA
		WHERE   nr_atendimento_hosp 	= nr_atendimento_p
		AND	coalesce(ie_situacao,'A') 	= 'A'
		AND	((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') OR (nm_usuario = nm_usuario_p));
	END IF;

ELSIF (nr_seq_item_p = 17) THEN
	IF (ie_libera_exames_oft_w = 'N') THEN
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_DNP
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND	coalesce(ie_situacao,'A') 	= 'A';
	ELSE
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_DNP
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND	coalesce(ie_situacao,'A') 	= 'A'
		AND	((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') OR (nm_usuario = nm_usuario_p));
	END IF;
ELSIF (nr_seq_item_p = 19) THEN
	IF (ie_libera_exames_oft_w = 'N') THEN
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_CorRECAO_ATUAL
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND	coalesce(ie_situacao,'A') 	= 'A';
	ELSE
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_CorRECAO_ATUAL
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND	coalesce(ie_situacao,'A') 	= 'A'
		AND	((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') OR (nm_usuario = nm_usuario_p));
	END IF;
ELSIF (nr_seq_item_p = 20) THEN
	IF (ie_libera_exames_oft_w = 'N') THEN
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_ACUIDADE_VISUAL
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND	coalesce(ie_situacao,'A') 	= 'A';
	ELSE
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_ACUIDADE_VISUAL
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND	coalesce(ie_situacao,'A') 	= 'A'
		AND	((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') OR (nm_usuario = nm_usuario_p));
	END IF;
ELSIF (nr_seq_item_p = 21) THEN
	IF (ie_libera_exames_oft_w = 'N') THEN
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    PEP_PAC_CI
		WHERE   nr_atendimento 	= nr_atendimento_p
		AND	coalesce(ie_situacao,'A') 	= 'A';
	ELSE
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    PEP_PAC_CI
		WHERE   nr_atendimento 	= nr_atendimento_p
		AND	coalesce(ie_situacao,'A') 	= 'A'
		AND	((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') OR (nm_usuario = nm_usuario_p));
	END IF;

ELSIF (nr_seq_item_p = 23) THEN
	IF (ie_libera_exames_oft_w = 'N') THEN
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_TONOMETRIA
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND ie_tipo_tonometria 		= 2
		AND	coalesce(ie_situacao,'A') 	= 'A';
	ELSE
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_TONOMETRIA
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND ie_tipo_tonometria 		= 2
		AND	coalesce(ie_situacao,'A') 	= 'A'
		AND	((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') OR (nm_usuario = nm_usuario_p));
	END IF;

ELSIF (nr_seq_item_p = 24) THEN
	IF (ie_libera_exames_oft_w = 'N') THEN
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_CONDUTA
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND	coalesce(ie_situacao,'A') 	= 'A';
	ELSE
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_CONDUTA
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND	coalesce(ie_situacao,'A') 	= 'A'
		AND	((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') OR (nm_usuario = nm_usuario_p));
	END IF;

ELSIF (nr_seq_item_p = 28) THEN
	IF (ie_lib_atestado_w = 'N') THEN
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    ATESTADO_PACIENTE
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND	coalesce(ie_situacao,'A') 	= 'A';
	ELSE
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    ATESTADO_PACIENTE
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND	((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') OR (nm_usuario = nm_usuario_p));
	END IF;

ELSIF (nr_seq_item_p = 31) THEN
	IF (ie_libera_exames_oft_w = 'N') THEN
		SELECT   COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM     OFT_ANEXO
		WHERE    nr_seq_consulta  	= nr_seq_consulta_p
		AND	coalesce(ie_situacao,'A') 	= 'A';
	ELSE
		SELECT   COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM     OFT_ANEXO
		WHERE    nr_seq_consulta  	= nr_seq_consulta_p
		AND	coalesce(ie_situacao,'A') 	= 'A'
		AND	((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') OR (nm_usuario = nm_usuario_p));
	END IF;

ELSIF (nr_seq_item_p = 69) THEN
	IF (ie_libera_exames_oft_w = 'N') THEN
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_CURVA_TENCIONAL
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND	coalesce(ie_situacao,'A') 	= 'A';
	ELSE
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_CURVA_TENCIONAL
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND	coalesce(ie_situacao,'A') 	= 'A'
		AND	((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') OR (nm_usuario = nm_usuario_p));
	END IF;
ELSIF (nr_seq_item_p = 71) THEN
	IF (ie_libera_exames_oft_w = 'N') THEN
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_ANGIO_RETINO
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
      and   coalesce(ie_tipo_registro,'A') = 'A'
		AND	coalesce(ie_situacao,'A') 	= 'A';
	ELSE
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_ANGIO_RETINO
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND	coalesce(ie_situacao,'A') 	= 'A'
      and   coalesce(ie_tipo_registro,'A') = 'A'
		AND	((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') OR (nm_usuario = nm_usuario_p));
	END IF;
ELSIF (nr_seq_item_p = 298) THEN
	IF (ie_libera_exames_oft_w = 'N') THEN
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_ANGIO_RETINO
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
      and   coalesce(ie_tipo_registro,'A') = 'R'
		AND	coalesce(ie_situacao,'A') 	= 'A';
	ELSE
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_ANGIO_RETINO
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND	coalesce(ie_situacao,'A') 	= 'A'
      and   coalesce(ie_tipo_registro,'A') = 'R'
		AND	((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') OR (nm_usuario = nm_usuario_p));
	END IF;
ELSIF (nr_seq_item_p = 73) THEN
	IF (ie_libera_exames_oft_w = 'N') THEN
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_GONIOSCOPIA
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND	coalesce(ie_situacao,'A') 	= 'A';
	ELSE
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_GONIOSCOPIA
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND	coalesce(ie_situacao,'A') 	= 'A'
		AND	((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') OR (nm_usuario = nm_usuario_p));
	END IF;
ELSIF (nr_seq_item_p = 75) THEN
	IF (ie_lib_solic_externo_w = 'N') THEN
		SELECT	COUNT(*)
		INTO STRICT	qt_registro_w
		FROM   	pedido_exame_externo a,
			pedido_exame_externo_item b
		WHERE  	a.nr_sequencia		= b.nr_seq_pedido
		AND	a.nr_seq_consulta  	= nr_seq_consulta_p
		AND	coalesce(ie_situacao,'A') 	= 'A';
	ELSE
		SELECT	COUNT(*)
		INTO STRICT	qt_registro_w
		FROM   	pedido_exame_externo a,
			pedido_exame_externo_item b
		WHERE  	a.nr_sequencia		= b.nr_seq_pedido
		AND	a.nr_seq_consulta  	= nr_seq_consulta_p
		AND	coalesce(ie_situacao,'A') 	= 'A'
		AND	((a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '') OR (a.nm_usuario = nm_usuario_p));
	END IF;
ELSIF (nr_seq_item_p = 78) THEN
	IF (ie_libera_exames_oft_w = 'N') THEN
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_BIOMETRIA
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND	coalesce(ie_situacao,'A') 	= 'A';
	ELSE
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_BIOMETRIA
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND	coalesce(ie_situacao,'A') 	= 'A'
		AND	((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') OR (nm_usuario = nm_usuario_p));
	END IF;
ELSIF (nr_seq_item_p = 80) THEN
	IF (ie_libera_exames_oft_w = 'N') THEN
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_MICROSCOPIA_ESPECULAR
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND	coalesce(ie_situacao,'A') 	= 'A';
	ELSE
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_MICROSCOPIA_ESPECULAR
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND	coalesce(ie_situacao,'A') 	= 'A'
		AND	((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') OR (nm_usuario = nm_usuario_p));
	END IF;

ELSIF (nr_seq_item_p = 82) THEN
	IF (ie_libera_exames_oft_w = 'N') THEN
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_PUPILOMETRIA
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND	coalesce(ie_situacao,'A') 	= 'A';
	ELSE
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_PUPILOMETRIA
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND	coalesce(ie_situacao,'A') 	= 'A'
		AND	((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') OR (nm_usuario = nm_usuario_p));
	END IF;

ELSIF (nr_seq_item_p = 84) THEN
	IF (ie_libera_exames_oft_w = 'N') THEN
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_PAQUIMETRIA
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND 	((IE_TIPO_PAQUIMETRIA = 'S') OR (coalesce(IE_TIPO_PAQUIMETRIA::text, '') = ''))
		AND	coalesce(ie_situacao,'A') 	= 'A';
	ELSE
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_PAQUIMETRIA
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND 	((IE_TIPO_PAQUIMETRIA = 'S') OR (coalesce(IE_TIPO_PAQUIMETRIA::text, '') = ''))
		AND	coalesce(ie_situacao,'A') 	= 'A'
		AND	((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') OR (nm_usuario = nm_usuario_p));
	END IF;

ELSIF (nr_seq_item_p = 86) THEN
	IF (ie_libera_exames_oft_w = 'N') THEN
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_MOTILIDADE_OCULAR
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND	coalesce(ie_situacao,'A') 	= 'A';
	ELSE
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_MOTILIDADE_OCULAR
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND	coalesce(ie_situacao,'A') 	= 'A'
		AND	((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') OR (nm_usuario = nm_usuario_p));
	END IF;

ELSIF (nr_seq_item_p = 160) THEN
	SELECT COUNT(*)
	INTO STRICT 	qt_registro_w
	FROM    PEP_orIENTACAO_GERAL
	WHERE   nr_seq_consulta  	= nr_seq_consulta_p
	AND	coalesce(ie_situacao,'A') 	= 'A';
ELSIF (nr_seq_item_p = 162) THEN
	IF (ie_libera_evolucao_w = 'N') THEN
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    EVOLUCAO_PACIENTE
		WHERE   nr_atendimento 		= nr_atendimento_p
		AND 	ie_tipo_evolucao 	<> '9'
		AND	coalesce(ie_situacao,'A') 	= 'A';
	ELSE
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    EVOLUCAO_PACIENTE
		WHERE   nr_atendimento 		= nr_atendimento_p
		AND 	ie_tipo_evolucao 	<> '9'
		AND	coalesce(ie_situacao,'A') 	= 'A'
		AND	((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') OR (nm_usuario = nm_usuario_p));
	END IF;

ELSIF (nr_seq_item_p = 168) THEN
	IF (ie_libera_exames_oft_w = 'N') THEN
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_TOPOGRAFIA_CorNEANA
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND	coalesce(ie_situacao,'A') 	= 'A';
	ELSE
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_TOPOGRAFIA_CorNEANA
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND	coalesce(ie_situacao,'A') 	= 'A'
		AND	((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') OR (nm_usuario = nm_usuario_p));
	END IF;

ELSIF (nr_seq_item_p = 171) THEN
	IF (ie_libera_exames_oft_w = 'N') THEN
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_CAMPIMETRIA
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND	coalesce(ie_situacao,'A') 	= 'A';
	ELSE
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_CAMPIMETRIA
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND	coalesce(ie_situacao,'A') 	= 'A'
		AND	((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') OR (nm_usuario = nm_usuario_p));
	END IF;
ELSIF (nr_seq_item_p = 173) THEN
	IF (ie_libera_exames_oft_w = 'N') THEN
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_TOMOGRAFIA_OLHO
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND	coalesce(ie_situacao,'A') 	= 'A';
	ELSE
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_TOMOGRAFIA_OLHO
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND	coalesce(ie_situacao,'A') 	= 'A'
		AND	((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') OR (nm_usuario = nm_usuario_p));
	END IF;
ELSIF (nr_seq_item_p = 175) THEN
	IF (ie_libera_exames_oft_w = 'N') THEN
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_CERASTOCOPIA
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND	coalesce(ie_situacao,'A') 	= 'A';
	ELSE
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_CERASTOCOPIA
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND	coalesce(ie_situacao,'A') 	= 'A'
		AND	((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') OR (nm_usuario = nm_usuario_p));
	END IF;
ELSIF (nr_seq_item_p = 177) THEN
	IF (ie_libera_exames_oft_w = 'N') THEN
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_OCT
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND	coalesce(ie_situacao,'A') 	= 'A';
	ELSE
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_OCT
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND	coalesce(ie_situacao,'A') 	= 'A'
		AND	((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') OR (nm_usuario = nm_usuario_p));
	END IF;
ELSIF (nr_seq_item_p = 165) THEN
	SELECT 	COUNT(*)
	INTO STRICT 	qt_registro_w
	FROM   	laudo_paciente_v a
	WHERE  	a.nr_atendimento = nr_atendimento_p;
ELSIF (nr_seq_item_p = 236) THEN
	IF (ie_libera_exames_oft_w = 'N') THEN
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_POTENCIAL_ACUIDADE
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND	coalesce(ie_situacao,'A') 	= 'A';
	ELSE
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_POTENCIAL_ACUIDADE
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND	coalesce(ie_situacao,'A') 	= 'A'
		AND	((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') OR (nm_usuario = nm_usuario_p));
	END IF;
ELSIF (nr_seq_item_p = 242) THEN
	IF (ie_libera_exames_oft_w = 'N') THEN
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_IRIDECTOMIA
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND	coalesce(ie_situacao,'A') 	= 'A';
	ELSE
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_IRIDECTOMIA
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND	coalesce(ie_situacao,'A') 	= 'A'
		AND	((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') OR (nm_usuario = nm_usuario_p));
	END IF;
ELSIF (nr_seq_item_p = 254) THEN
	IF (ie_libera_exames_oft_w = 'N') THEN
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_FOTOCOAGULACAO_LASER
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND	coalesce(ie_situacao,'A') 	= 'A';
	ELSE
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_FOTOCOAGULACAO_LASER
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND	coalesce(ie_situacao,'A') 	= 'A'
		AND	((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') OR (nm_usuario = nm_usuario_p));
	END IF;
ELSIF (nr_seq_item_p = 255) THEN
	IF (ie_libera_exames_oft_w = 'N') THEN
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_SOBRECARGA_HIDRICA
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND	coalesce(ie_situacao,'A') 	= 'A';
	ELSE
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_SOBRECARGA_HIDRICA
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND	coalesce(ie_situacao,'A') 	= 'A'
		AND	((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') OR (nm_usuario = nm_usuario_p));
	END IF;
ELSIF (nr_seq_item_p = 256) THEN
	IF (ie_libera_exames_oft_w = 'N') THEN
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_CAPSULOTOMIA
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND	coalesce(ie_situacao,'A') 	= 'A';
	ELSE
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_CAPSULOTOMIA
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND	coalesce(ie_situacao,'A') 	= 'A'
		AND	((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') OR (nm_usuario = nm_usuario_p));
	END IF;
ELSIF (nr_seq_item_p = 244) THEN
	IF (ie_libera_exames_oft_w = 'N') THEN
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_OLHO_SECO
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND	coalesce(ie_situacao,'A') 	= 'A';
	ELSE
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_OLHO_SECO
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND	coalesce(ie_situacao,'A') 	= 'A'
		AND	((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') OR (nm_usuario = nm_usuario_p));
	END IF;
ELSIF (nr_seq_item_p = 245) THEN
	IF (ie_libera_exames_oft_w = 'N') THEN
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_DALTONISMO
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND	coalesce(ie_situacao,'A') 	= 'A';
	ELSE
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_DALTONISMO
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND	coalesce(ie_situacao,'A') 	= 'A'
		AND	((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') OR (nm_usuario = nm_usuario_p));
	END IF;
ELSIF (nr_seq_item_p = 247) THEN
	IF (ie_libera_exames_oft_w = 'N') THEN
		SELECT 	COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_REFRACAO
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND 	((ie_refracao_sugerida = 'N') OR (coalesce(ie_refracao_sugerida::text, '') = ''))
		AND	coalesce(ie_situacao,'A') 	= 'A';
	ELSE
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_REFRACAO
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND 	((ie_refracao_sugerida = 'N') OR (coalesce(ie_refracao_sugerida::text, '') = ''))
		AND	coalesce(ie_situacao,'A') 	= 'A'
		AND	((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') OR (nm_usuario = nm_usuario_p));
	END IF;
ELSIF (nr_seq_item_p = 248) THEN
	IF (ie_libera_exames_oft_w = 'N') THEN
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_AUTO_REFRACAO
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND 	((ie_refracao_sugerida = 'N') OR (coalesce(ie_refracao_sugerida::text, '') = ''))
		AND	coalesce(ie_situacao,'A') 	= 'A';
	ELSE
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_AUTO_REFRACAO
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p
		AND 	((ie_refracao_sugerida = 'N') OR (coalesce(ie_refracao_sugerida::text, '') = ''))
		AND	coalesce(ie_situacao,'A') 	= 'A'
		AND	((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') OR (nm_usuario = nm_usuario_p));
	END IF;
ELSIF (nr_seq_item_p = 277) THEN
	IF (ie_libera_exames_oft_w = 'N') THEN
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_ULTRASSONOGRAFIA
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p	
		AND	coalesce(ie_situacao,'A') 	= 'A';
	ELSE
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_ULTRASSONOGRAFIA
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p		
		AND	coalesce(ie_situacao,'A') 	= 'A'
		AND	((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') OR (nm_usuario = nm_usuario_p));
	END IF;		
ELSIF (nr_seq_item_p = 276) THEN
	IF (ie_libera_exames_oft_w = 'N') THEN
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_MAPEAMENTO_RETINA
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p	
		AND	coalesce(ie_situacao,'A') 	= 'A';
	ELSE
		SELECT COUNT(*)
		INTO STRICT 	qt_registro_w
		FROM    OFT_MAPEAMENTO_RETINA
		WHERE   nr_seq_consulta  	= nr_seq_consulta_p		
		AND	coalesce(ie_situacao,'A') 	= 'A'
		AND	((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') OR (nm_usuario = nm_usuario_p));
	END IF;	
END IF;

IF (qt_registro_w > 0) THEN
	ds_retorno_w := 'S';
ELSE
    ds_retorno_w := 'N';
END IF;

RETURN	ds_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_exibe_reg_oft ( nr_seq_item_p bigint, nr_seq_consulta_p bigint, nr_atendimento_p bigint, cd_pessoa_fisica_p text, nm_usuario_p text) FROM PUBLIC;

