-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_ans_relat11575 (ie_opcao_p text, dt_inicio_p timestamp, dt_fim_p timestamp, CD_ESTABELECIMENTO_P bigint) RETURNS varchar AS $body$
DECLARE

 
NR_NUMERADOR_w varchar(10);
NR_DENOMINADOR_w varchar(10);
QT_PROPORCAO_w varchar(10);
ds_retorno_w varchar(10);
cd_estabelecimento_w estabelecimento.cd_estabelecimento%TYPE;

BEGIN
cd_estabelecimento_w := cd_estabelecimento_p;
IF (CD_ESTABELECIMENTO_w = 0) THEN 
 CD_ESTABELECIMENTO_w := null;
END IF;
 
IF (ie_opcao_p = 'N') OR (ie_opcao_p = 'P') THEN 
 SELECT SUM(1) 
 INTO STRICT NR_NUMERADOR_w 
  FROM  atendimento_paciente a 
  WHERE trunc(a.dt_entrada) BETWEEN dt_inicio_p AND dt_fim_p 
  AND  a.ie_tipo_atendimento = 1 
  AND  EXISTS (SELECT 1 FROM atendimento_paciente b 
		WHERE b.nr_atendimento > a.nr_atendimento 
		AND  b.ie_tipo_atendimento = 1 
		AND a.cd_pessoa_fisica = b.cd_pessoa_fisica 
		AND B.dt_entrada BETWEEN A.dt_entrada AND A.dt_entrada+30 
		AND (b.dt_alta IS NOT NULL AND b.dt_alta::text <> '') 
		AND B.cd_estabelecimento = coalesce(cd_estabelecimento_w, B.cd_estabelecimento)  LIMIT 1) 
  AND  NOT EXISTS (SELECT 1 FROM parto b WHERE b.nr_atendimento = a.nr_atendimento  LIMIT 1) 
  AND  NOT EXISTS (SELECT 1 FROM CAN_FICHA_ADMISSAO b WHERE b.cd_pessoa_fisica = a.cd_pessoa_fisica  LIMIT 1) 
  AND  NOT EXISTS (SELECT 1 FROM CAN_LOCO_REGIONAL b WHERE b.nr_atendimento = a.nr_atendimento  LIMIT 1) 
  AND  a.cd_estabelecimento = coalesce(CD_ESTABELECIMENTO_w, a.cd_estabelecimento) 
  and	coalesce(a.nr_atendimento_mae::text, '') = '';
 ds_retorno_w := SUBSTR(NR_NUMERADOR_w, 1, 10);
END IF;
 
IF (ie_opcao_p = 'D') OR (ie_opcao_p = 'P') THEN 
 SELECT CASE WHEN COUNT(*)=0 THEN  1  ELSE COUNT(*) END  NR_DENOMINADOR 
 INTO STRICT NR_DENOMINADOR_w 
 FROM (SELECT 1 
  FROM  atendimento_paciente a 
  WHERE trunc(a.dt_entrada) BETWEEN dt_inicio_p AND dt_fim_p 
  AND  a.ie_tipo_atendimento = 1 
  AND (a.dt_entrada <> a.dt_alta OR coalesce(a.dt_alta::text, '') = '') 
  AND  NOT EXISTS (SELECT 1 FROM motivo_alta b WHERE a.cd_motivo_alta = b.cd_motivo_alta AND b.ie_obito = 'S'  LIMIT 1) 
  AND  NOT EXISTS (SELECT 1 FROM parto b WHERE b.nr_atendimento = a.nr_atendimento  LIMIT 1) 
  AND  NOT EXISTS (SELECT 1 FROM CAN_FICHA_ADMISSAO b WHERE b.cd_pessoa_fisica = a.cd_pessoa_fisica AND DT_ATUALIZACAO_NREC > a.dt_entrada-365  LIMIT 1) 
  AND  NOT EXISTS (SELECT 1 FROM CAN_LOCO_REGIONAL b WHERE b.cd_pessoa_fisica = a.cd_pessoa_fisica AND DT_ATUALIZACAO_NREC > a.dt_entrada-365  LIMIT 1) 
  AND  NOT EXISTS (SELECT 1 FROM AGENDA_QUIMIO b WHERE a.cd_pessoa_fisica = b.cd_pessoa_fisica AND DT_ATUALIZACAO_NREC > a.dt_entrada-365  LIMIT 1) 
  AND  a.cd_estabelecimento = coalesce(CD_ESTABELECIMENTO_w, a.cd_estabelecimento) 
  and	coalesce(a.nr_atendimento_mae::text, '') = '' 
  GROUP BY cd_pessoa_fisica) alias14;
 ds_retorno_w := SUBSTR(NR_DENOMINADOR_w, 1, 10);
END IF;
 
IF (ie_opcao_p = 'P') THEN 
 QT_PROPORCAO_w := SUBSTR(TO_CHAR(round((NR_NUMERADOR_w*100/NR_DENOMINADOR_w)::numeric, 2)), 1, 10);
 ds_retorno_w := SUBSTR(QT_PROPORCAO_w, 1, 10);
END IF;
 
RETURN ds_retorno_w;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_ans_relat11575 (ie_opcao_p text, dt_inicio_p timestamp, dt_fim_p timestamp, CD_ESTABELECIMENTO_P bigint) FROM PUBLIC;
