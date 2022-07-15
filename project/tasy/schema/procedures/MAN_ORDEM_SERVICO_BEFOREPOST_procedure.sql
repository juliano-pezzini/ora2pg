-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_ordem_servico_beforepost ( NM_USUARIO_P text, NR_SEQ_NC_P bigint, CD_PF_RESP_OCOR_P text, NR_SEQ_ORDEM_P bigint, IE_EDICAO_P text, IE_STATUS_ORDEM_P text, IE_STATUS_OLD_P text, NR_SEQ_EQUIPAMENTO_P text, NR_SEQ_LOCALIZACAO_P INOUT bigint) AS $body$
DECLARE



IE_NAO_CONFORM_ENCERRA_W 	varchar(1);
IE_REABRI_ACAO_ENCERRADA_W	varchar(1);
IE_TRAZ_SETOR_USUARIO_W		varchar(1);
QT_NAO_CONFORMIDADE_W		integer;
QT_MAN_ORDEM_SERVICO_W		integer;
ds_retorno_w			varchar(255);



BEGIN
IE_NAO_CONFORM_ENCERRA_W := OBTER_PARAM_USUARIO(4000, 181, OBTER_PERFIL_ATIVO, NM_USUARIO_P, WHEB_USUARIO_PCK.GET_CD_ESTABELECIMENTO, IE_NAO_CONFORM_ENCERRA_W);
IE_REABRI_ACAO_ENCERRADA_W := OBTER_PARAM_USUARIO(4000, 237, OBTER_PERFIL_ATIVO, NM_USUARIO_P, WHEB_USUARIO_PCK.GET_CD_ESTABELECIMENTO, IE_REABRI_ACAO_ENCERRADA_W);
IE_TRAZ_SETOR_USUARIO_W := OBTER_PARAM_USUARIO(4000, 117, OBTER_PERFIL_ATIVO, NM_USUARIO_P, WHEB_USUARIO_PCK.GET_CD_ESTABELECIMENTO, IE_TRAZ_SETOR_USUARIO_W);

/*SELECT	(SELECT	COUNT(*) QT_NAO_CONFORMIDADE
	FROM	QUA_NAO_CONFORMIDADE
	WHERE	NR_SEQUENCIA = NR_SEQ_NC_P
	AND	CD_PF_RESP_OCORRENCIA = CD_PF_RESP_OCOR_P
	AND 	(UPPER(IE_NAO_CONFORM_ENCERRA_W) <> 'T'
	OR	UPPER(IE_NAO_CONFORM_ENCERRA_W) <> 'S')) QT_NAO_CONFORMIDADE,
	(SELECT   COUNT(*) QT_MAN_ORDEM_SERVICO
	FROM     MAN_ORDEM_SERVICO_EXEC
	WHERE    NR_SEQ_ORDEM  = NR_SEQ_ORDEM_P
	AND      NM_USUARIO_EXEC = NM_USUARIO_P
	AND 	(UPPER(IE_NAO_CONFORM_ENCERRA_W) <> 'T'
	OR	UPPER(IE_NAO_CONFORM_ENCERRA_W) <> 'E')) QT_MAN_ORDEM_SERVICO
INTO	QT_NAO_CONFORMIDADE_W,
	QT_MAN_ORDEM_SERVICO_W
FROM	DUAL;

IF(IE_EDICAO_P = '1')
	AND (IE_STATUS_ORDEM_P = '3')
	AND (IE_STATUS_ORDEM_P <> IE_STATUS_OLD_P)
	AND (UPPER(IE_NAO_CONFORM_ENCERRA_W) <> 'X')
	AND (QT_NAO_CONFORMIDADE_W = 0)
	AND (QT_MAN_ORDEM_SERVICO_W = 0)THEN
WHEB_MENSAGEM_PCK.EXIBIR_MENSAGEM_ABORT(189174, NULL);
END IF;*/
IF (IE_REABRI_ACAO_ENCERRADA_W = 'N') AND (IE_EDICAO_P = '1') AND (IE_STATUS_OLD_P = '3') AND (IE_STATUS_ORDEM_P in ('1','2')) THEN
	CALL WHEB_MENSAGEM_PCK.EXIBIR_MENSAGEM_ABORT(189180, NULL);
END IF;

IF (IE_TRAZ_SETOR_USUARIO_W = 'N') THEN
	SELECT	max(NR_SEQ_LOCAL)
	INTO STRICT    NR_SEQ_LOCALIZACAO_P
	FROM	MAN_EQUIPAMENTO
	WHERE	NR_SEQUENCIA = NR_SEQ_EQUIPAMENTO_P;
END IF;

if (IE_STATUS_ORDEM_P = '3') then
	ds_retorno_w := CONSISTE_ORDEM_SERV_VINCULADA(NR_SEQ_ORDEM_P, ds_retorno_w);
	if (ds_retorno_w IS NOT NULL AND ds_retorno_w::text <> '') then
		CALL WHEB_MENSAGEM_PCK.EXIBIR_MENSAGEM_ABORT(ds_retorno_w);
	end if;
end if;

COMMIT;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_ordem_servico_beforepost ( NM_USUARIO_P text, NR_SEQ_NC_P bigint, CD_PF_RESP_OCOR_P text, NR_SEQ_ORDEM_P bigint, IE_EDICAO_P text, IE_STATUS_ORDEM_P text, IE_STATUS_OLD_P text, NR_SEQ_EQUIPAMENTO_P text, NR_SEQ_LOCALIZACAO_P INOUT bigint) FROM PUBLIC;

