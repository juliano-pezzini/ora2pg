-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sinan_gerar_ficha_atendimento (NR_ATENDIMENTO_P bigint, IE_TIPO_NOTIFICACAO_P bigint, NM_USUARIO_P text, CD_DOENCA_P text DEFAULT NULL) AS $body$
DECLARE

  CD_PESSOA_FISICA_W          ATENDIMENTO_PACIENTE.CD_PESSOA_FISICA%TYPE;
  DS_BAIRRO_W                 COMPL_PESSOA_FISICA.DS_BAIRRO%TYPE;
  CD_CEP_W                    COMPL_PESSOA_FISICA.CD_CEP%TYPE;
  CD_MUNICIPIO_IBGE_W         COMPL_PESSOA_FISICA.CD_MUNICIPIO_IBGE%TYPE;
  DS_ENDERECO_W               COMPL_PESSOA_FISICA.DS_ENDERECO%TYPE;
  IE_UF_W                     COMPL_PESSOA_FISICA.SG_ESTADO%TYPE;
  CD_ZONA_PACIENTE_W          COMPL_PESSOA_FISICA.CD_ZONA_PROCEDENCIA%TYPE;
  DS_PAIS_W                   PAIS.NM_PAIS%TYPE;
  NR_SEQ_DOENCA_COMPULSORIA_W CIH_DOENCA_COMPULSORIA.NR_SEQUENCIA%TYPE;
  NR_SEQ_COR_PELE_W           PESSOA_FISICA.NR_SEQ_COR_PELE%TYPE;
  IE_RACA_SINAN_W             COR_PELE.IE_RACA_SINAN%TYPE;
  CD_ESTABELECIMENTO_W        ESTABELECIMENTO.CD_ESTABELECIMENTO%TYPE;
  NR_TELEFONE_W               varchar(20);
  DS_COMPLEMENTO_W            varchar(90);
  NR_ENDERECO_W               varchar(10);
  NR_SEQ_ZONA_W               integer;
  IE_PERMITE_CID_W            varchar(1);
  QT_DOENCA_CID_W             bigint;


BEGIN
  IE_PERMITE_CID_W := OBTER_PARAM_USUARIO(1137, 3, OBTER_PERFIL_ATIVO, NM_USUARIO_P, WHEB_USUARIO_PCK.GET_CD_ESTABELECIMENTO, IE_PERMITE_CID_W);

  SELECT MAX(A.CD_PESSOA_FISICA),
         MAX(SUBSTR(OBTER_COMPL_PF(A.CD_PESSOA_FISICA, 1, 'T'), 1, 20)),
         MAX(SUBSTR(OBTER_COMPL_PF(A.CD_PESSOA_FISICA, 1, 'B'), 1, 60)),
         MAX(SUBSTR(OBTER_COMPL_PF(A.CD_PESSOA_FISICA, 1, 'CEP'), 1, 15)),
         MAX(SUBSTR(OBTER_COMPL_PF(A.CD_PESSOA_FISICA, 1, 'CDM'), 1, 10)),
         MAX(SUBSTR(OBTER_COMPL_PF(A.CD_PESSOA_FISICA, 1, 'CO'), 1, 30)),
         MAX(SUBSTR(OBTER_COMPL_PF(A.CD_PESSOA_FISICA, 1, 'EN'), 1, 60)),
         MAX(SUBSTR(OBTER_COMPL_PF(A.CD_PESSOA_FISICA, 1, 'PAIS'), 1, 60)),
         MAX(SUBSTR(OBTER_COMPL_PF(A.CD_PESSOA_FISICA, 1, 'UF'), 1, 60)),
         MAX(SUBSTR(OBTER_COMPL_PF(A.CD_PESSOA_FISICA, 1, 'NR'), 1, 60)),
         MAX(SUBSTR(OBTER_COMPL_PF(A.CD_PESSOA_FISICA, 1, 'Z'), 1, 60)),
         MAX(B.NR_SEQ_COR_PELE)
    INTO STRICT CD_PESSOA_FISICA_W,
         NR_TELEFONE_W,
         DS_BAIRRO_W,
         CD_CEP_W,
         CD_MUNICIPIO_IBGE_W,
         DS_COMPLEMENTO_W,
         DS_ENDERECO_W,
         DS_PAIS_W,
         IE_UF_W,
         NR_ENDERECO_W,
         CD_ZONA_PACIENTE_W,
         NR_SEQ_COR_PELE_W
    FROM ATENDIMENTO_PACIENTE A, PESSOA_FISICA B
   WHERE A.CD_PESSOA_FISICA = B.CD_PESSOA_FISICA
     AND A.NR_ATENDIMENTO = NR_ATENDIMENTO_P;

  SELECT MAX(IE_RACA_SINAN)
    INTO STRICT IE_RACA_SINAN_W
    FROM COR_PELE
   WHERE NR_SEQUENCIA = NR_SEQ_COR_PELE_W;

  SELECT MAX(A.NR_SEQUENCIA)
    INTO STRICT NR_SEQ_DOENCA_COMPULSORIA_W
    FROM CIH_DOENCA_COMPULSORIA A,
         DIAGNOSTICO_DOENCA     B,
         ATENDIMENTO_PACIENTE   C
   WHERE A.CD_DOENCA_CID = B.CD_DOENCA
     AND B.NR_ATENDIMENTO = C.NR_ATENDIMENTO
     AND C.NR_ATENDIMENTO = NR_ATENDIMENTO_P
     AND B.CD_DOENCA = coalesce(CD_DOENCA_P, B.CD_DOENCA);

  IF (IE_PERMITE_CID_W = 'N') THEN
    SELECT COUNT(*)
      INTO STRICT QT_DOENCA_CID_W
      FROM NOTIFICACAO_SINAN
     WHERE NR_SEQ_DOENCA_COMPULSORIA = NR_SEQ_DOENCA_COMPULSORIA_W
       AND CD_PACIENTE = CD_PESSOA_FISICA_W;

    IF (QT_DOENCA_CID_W > 0) THEN
      CALL WHEB_MENSAGEM_PCK.EXIBIR_MENSAGEM_ABORT(220141, 'DOENCA=' || SUBSTR(OBTER_DESC_DOENCA_COMPULSORIA(NR_SEQ_DOENCA_COMPULSORIA_W), 1, 255));
    END IF;
  END IF;

  IF (CD_ZONA_PACIENTE_W = 'U') THEN
    NR_SEQ_ZONA_W := 1;
  ELSIF (CD_ZONA_PACIENTE_W = 'R') THEN
    NR_SEQ_ZONA_W := 2;
  ELSIF (CD_ZONA_PACIENTE_W = 'I') THEN
    NR_SEQ_ZONA_W := 9;
  END IF;

  CD_ESTABELECIMENTO_W := coalesce(WHEB_USUARIO_PCK.GET_CD_ESTABELECIMENTO, 1);

  IF (CD_PESSOA_FISICA_W IS NOT NULL AND CD_PESSOA_FISICA_W::text <> '') THEN
    INSERT INTO NOTIFICACAO_SINAN(CD_CEP,
       CD_MUNICIPIO_IBGE,
       CD_PACIENTE,
       DS_BAIRRO,
       DS_COMPLEMENTO,
       DS_DISTRITO,
       DS_ENDERECO,
       DS_PAIS,
       DT_ATUALIZACAO,
       DT_ATUALIZACAO_NREC,
       DT_NOTIFICACAO,
       IE_ESCOLARIDADE,
       IE_TIPO_NOTIFICACAO,
       IE_UF,
       NM_USUARIO,
       NM_USUARIO_NREC,
       NR_ATENDIMENTO,
       NR_ENDERECO,
       NR_SEQUENCIA,
       NR_TELEFONE,
       NR_SEQ_DOENCA_COMPULSORIA,
       IE_RACA_COR,
       IE_ZONA,
       CD_MUNICIPIO_IBGE_SURTO,
       CD_ESTABELECIMENTO)
    VALUES (CD_CEP_W,
       CD_MUNICIPIO_IBGE_W,
       CD_PESSOA_FISICA_W,
       DS_BAIRRO_W,
       DS_COMPLEMENTO_W,
       NULL,
       DS_ENDERECO_W,
       DS_PAIS_W,
       clock_timestamp(),
       clock_timestamp(),
       clock_timestamp(),
       NULL,
       IE_TIPO_NOTIFICACAO_P,
       IE_UF_W,
       NM_USUARIO_P,
       NM_USUARIO_P,
       NR_ATENDIMENTO_P,
       NR_ENDERECO_W,
       nextval('notificacao_sinan_seq'),
       NR_TELEFONE_W,
       NR_SEQ_DOENCA_COMPULSORIA_W,
       IE_RACA_SINAN_W,
       NR_SEQ_ZONA_W,
       CD_MUNICIPIO_IBGE_W,
       CD_ESTABELECIMENTO_W);

  END IF;

  COMMIT;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sinan_gerar_ficha_atendimento (NR_ATENDIMENTO_P bigint, IE_TIPO_NOTIFICACAO_P bigint, NM_USUARIO_P text, CD_DOENCA_P text DEFAULT NULL) FROM PUBLIC;
