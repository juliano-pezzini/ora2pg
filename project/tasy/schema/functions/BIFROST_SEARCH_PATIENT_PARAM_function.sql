-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION bifrost_search_patient_param (TIPO_FILTRO_P bigint, CD_ESTABELECIMENTO_P bigint, CD_PESSOA_FISICA_P text DEFAULT NULL, NM_PESSOA_FISICA_P text DEFAULT NULL, DT_NASCIMENTO_P timestamp DEFAULT NULL, NR_CPF_P text DEFAULT NULL, IE_SEXO_P text DEFAULT NULL, CD_SISTEMA_ANT_P text DEFAULT NULL, NR_CARTAO_NAC_SUS_P text DEFAULT NULL, NR_CERTIDAO_OBITO_P text DEFAULT NULL, CD_DECLARACAO_NASC_VIVO_P text DEFAULT NULL, NR_PIS_PASEP_P text DEFAULT NULL, NR_IDENTIDADE_P text DEFAULT NULL, NR_PRONTUARIO_P bigint DEFAULT NULL) RETURNS varchar AS $body$
DECLARE

  JSON_PARAM_W  PHILIPS_JSON := PHILIPS_JSON();
  DS_RESPONSE_W text;

BEGIN
  IF (TIPO_FILTRO_P IS NOT NULL AND TIPO_FILTRO_P::text <> '') THEN
     JSON_PARAM_W.PUT('nrFilterType', TIPO_FILTRO_P);
  END IF;

  IF (CD_ESTABELECIMENTO_P IS NOT NULL AND CD_ESTABELECIMENTO_P::text <> '') THEN
     JSON_PARAM_W.PUT('cdEstablishment', CD_ESTABELECIMENTO_P);
  END IF;

  IF ((trim(both CD_PESSOA_FISICA_P) IS NOT NULL AND (trim(both CD_PESSOA_FISICA_P))::text <> '')) THEN
     JSON_PARAM_W.PUT('cdPersonCode', CD_PESSOA_FISICA_P);
  END IF;

  IF ((trim(both NM_PESSOA_FISICA_P) IS NOT NULL AND (trim(both NM_PESSOA_FISICA_P))::text <> '')) THEN
     JSON_PARAM_W.PUT('dsPersonName', NM_PESSOA_FISICA_P);
  END IF;

  IF (DT_NASCIMENTO_P IS NOT NULL AND DT_NASCIMENTO_P::text <> '') THEN
     JSON_PARAM_W.PUT('dtBirthDate', TO_CHAR(DT_NASCIMENTO_P, 'DD/MM/YYYY'));
  END IF;

  IF ((trim(both NR_CPF_P) IS NOT NULL AND (trim(both NR_CPF_P))::text <> '')) THEN
     JSON_PARAM_W.PUT('nrTaxpayerID', NR_CPF_P);
  END IF;

  IF ((trim(both IE_SEXO_P) IS NOT NULL AND (trim(both IE_SEXO_P))::text <> '')) THEN
     JSON_PARAM_W.PUT('dsGender', IE_SEXO_P);
  END IF;

  IF ((trim(both CD_SISTEMA_ANT_P) IS NOT NULL AND (trim(both CD_SISTEMA_ANT_P))::text <> '')) THEN
     JSON_PARAM_W.PUT('cdPreviousSystem', CD_SISTEMA_ANT_P);
  END IF;

  IF ((trim(both NR_CARTAO_NAC_SUS_P) IS NOT NULL AND (trim(both NR_CARTAO_NAC_SUS_P))::text <> '')) THEN
     JSON_PARAM_W.PUT('nrSUSCard', NR_CARTAO_NAC_SUS_P);
  END IF;

  IF ((trim(both NR_CERTIDAO_OBITO_P) IS NOT NULL AND (trim(both NR_CERTIDAO_OBITO_P))::text <> '')) THEN
     JSON_PARAM_W.PUT('nrDeathCertificate', NR_CERTIDAO_OBITO_P);
  END IF;

  IF ((trim(both CD_DECLARACAO_NASC_VIVO_P) IS NOT NULL AND (trim(both CD_DECLARACAO_NASC_VIVO_P))::text <> '')) THEN
     JSON_PARAM_W.PUT('cdCertificateLiveBirth', CD_DECLARACAO_NASC_VIVO_P);
  END IF;

  IF ((trim(both NR_PIS_PASEP_P) IS NOT NULL AND (trim(both NR_PIS_PASEP_P))::text <> '')) THEN
     JSON_PARAM_W.PUT('nrPIS', NR_PIS_PASEP_P);
  END IF;

  IF ((trim(both NR_IDENTIDADE_P) IS NOT NULL AND (trim(both NR_IDENTIDADE_P))::text <> '')) THEN
     JSON_PARAM_W.PUT('nrCivilID', NR_IDENTIDADE_P);
  END IF;

  IF (NR_PRONTUARIO_P IS NOT NULL AND NR_PRONTUARIO_P::text <> '') THEN
     JSON_PARAM_W.PUT('nrMedicalRecord', NR_PRONTUARIO_P);
  END IF;

  DBMS_LOB.CREATETEMPORARY(DS_RESPONSE_W, TRUE);

  JSON_PARAM_W.(DS_RESPONSE_W);

  RETURN DS_RESPONSE_W;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION bifrost_search_patient_param (TIPO_FILTRO_P bigint, CD_ESTABELECIMENTO_P bigint, CD_PESSOA_FISICA_P text DEFAULT NULL, NM_PESSOA_FISICA_P text DEFAULT NULL, DT_NASCIMENTO_P timestamp DEFAULT NULL, NR_CPF_P text DEFAULT NULL, IE_SEXO_P text DEFAULT NULL, CD_SISTEMA_ANT_P text DEFAULT NULL, NR_CARTAO_NAC_SUS_P text DEFAULT NULL, NR_CERTIDAO_OBITO_P text DEFAULT NULL, CD_DECLARACAO_NASC_VIVO_P text DEFAULT NULL, NR_PIS_PASEP_P text DEFAULT NULL, NR_IDENTIDADE_P text DEFAULT NULL, NR_PRONTUARIO_P bigint DEFAULT NULL) FROM PUBLIC;
