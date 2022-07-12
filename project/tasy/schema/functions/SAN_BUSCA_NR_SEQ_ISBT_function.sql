-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION san_busca_nr_seq_isbt (P_NR_SEQUENCIA SAN_PRODUCAO.NR_SEQUENCIA%TYPE) RETURNS bigint AS $body$
DECLARE


 NR_SEQ_ISBT_W SAN_PRODUCAO.NR_SEQ_ISBT%TYPE;	

  C_PRODUCAO CURSOR FOR
    SELECT P.*
      FROM SAN_PRODUCAO P 
    WHERE P.NR_SEQUENCIA = P_NR_SEQUENCIA;
  R_PRODUCAO  C_PRODUCAO%ROWTYPE;

  C_DOACAO CURSOR(P_NR_SEQ_DOACAO  SAN_PRODUCAO.NR_SEQ_DOACAO%TYPE) FOR
    SELECT D.*
      FROM SAN_DOACAO D
    WHERE D.NR_SEQUENCIA = P_NR_SEQ_DOACAO;
  R_DOACAO   C_DOACAO%ROWTYPE;

BEGIN
  NR_SEQ_ISBT_W := NULL;
   
  OPEN C_PRODUCAO;
    FETCH C_PRODUCAO
    INTO R_PRODUCAO;

    IF (R_PRODUCAO.NR_SEQ_ISBT IS NOT NULL AND R_PRODUCAO.NR_SEQ_ISBT::text <> '') THEN
      NR_SEQ_ISBT_W := R_PRODUCAO.NR_SEQ_ISBT;
    ELSE
      IF (R_PRODUCAO.NR_SEQ_DOACAO IS NOT NULL AND R_PRODUCAO.NR_SEQ_DOACAO::text <> '') THEN
        OPEN C_DOACAO(R_PRODUCAO.NR_SEQ_DOACAO);
          FETCH C_DOACAO
          INTO R_DOACAO;
          IF (R_DOACAO.NR_SEQ_ISBT IS NOT NULL AND R_DOACAO.NR_SEQ_ISBT::text <> '') THEN
            NR_SEQ_ISBT_W := R_DOACAO.NR_SEQ_ISBT;
          END IF;
        CLOSE C_DOACAO;
      END IF;
    END IF;
  CLOSE C_PRODUCAO;

  
  RETURN NR_SEQ_ISBT_W;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION san_busca_nr_seq_isbt (P_NR_SEQUENCIA SAN_PRODUCAO.NR_SEQUENCIA%TYPE) FROM PUBLIC;

