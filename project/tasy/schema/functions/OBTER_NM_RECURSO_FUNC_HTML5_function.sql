-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_nm_recurso_func_html5 ( CD_FUNCAO_P bigint, IE_TIPO_P text) RETURNS varchar AS $body$
DECLARE

 PR_RETORNO_W varchar(100) := '';

BEGIN
 
/* 
Profissionais: 
 
ASHTML = Analista de Sistemas HTML 5 
ASOPER = Analista de Sistemas Operação 
AN   = Analista de Negócio 
DL   = Dev Leader 
*/
 
 
 IF IE_TIPO_P = 'ASHTML' THEN 
 BEGIN 
  SELECT OBTER_NOME_SOBRENOME_PESSOA(FH.CD_PESSOA_FISICA, 'P') || ' ' || OBTER_NOME_SOBRENOME_PESSOA(FH.CD_PESSOA_FISICA, 'S') 
   INTO STRICT PR_RETORNO_W 
   FROM FUNCOES_HTML5 FH 
   WHERE FH.CD_FUNCAO = CD_FUNCAO_P 
    AND (FH.CD_PESSOA_FISICA IS NOT NULL AND FH.CD_PESSOA_FISICA::text <> '')  LIMIT 1;
 EXCEPTION 
  WHEN no_data_found THEN 
   PR_RETORNO_W := '';
  WHEN OTHERS THEN 
   PR_RETORNO_W := '';
 END;
 ELSIF IE_TIPO_P = 'ASOPER' THEN 
 BEGIN 
  SELECT OBTER_NOME_SOBRENOME_PESSOA(FH.CD_PESSOA_ANALISTA_OPER, 'P') || ' ' || OBTER_NOME_SOBRENOME_PESSOA(FH.CD_PESSOA_ANALISTA_OPER, 'S') 
   INTO STRICT PR_RETORNO_W 
   FROM FUNCOES_HTML5 FH 
   WHERE FH.CD_FUNCAO = CD_FUNCAO_P 
    AND (FH.CD_PESSOA_ANALISTA_OPER IS NOT NULL AND FH.CD_PESSOA_ANALISTA_OPER::text <> '')  LIMIT 1;
 EXCEPTION 
  WHEN no_data_found THEN 
   PR_RETORNO_W := '';
  WHEN OTHERS THEN 
   PR_RETORNO_W := '';
 END;
 ELSIF IE_TIPO_P = 'AN' THEN 
 BEGIN 
  SELECT OBTER_NOME_SOBRENOME_PESSOA(FH.CD_PESSOA_ANALISTA_NEG, 'P') || ' ' || OBTER_NOME_SOBRENOME_PESSOA(FH.CD_PESSOA_ANALISTA_NEG, 'S') 
   INTO STRICT PR_RETORNO_W 
   FROM FUNCOES_HTML5 FH 
   WHERE FH.CD_FUNCAO = CD_FUNCAO_P 
    AND (FH.CD_PESSOA_ANALISTA_NEG IS NOT NULL AND FH.CD_PESSOA_ANALISTA_NEG::text <> '')  LIMIT 1;
 EXCEPTION 
  WHEN no_data_found THEN 
   PR_RETORNO_W := '';
  WHEN OTHERS THEN 
   PR_RETORNO_W := '';
 END;
 ELSIF IE_TIPO_P = 'DL' THEN 
 BEGIN 
  SELECT OBTER_NOME_SOBRENOME_PESSOA(FH.CD_PESSOA_DEV_LED, 'P') || ' ' || OBTER_NOME_SOBRENOME_PESSOA(FH.CD_PESSOA_DEV_LED, 'S') 
   INTO STRICT PR_RETORNO_W 
   FROM FUNCOES_HTML5 FH 
   WHERE FH.CD_FUNCAO = CD_FUNCAO_P 
    AND (FH.CD_PESSOA_DEV_LED IS NOT NULL AND FH.CD_PESSOA_DEV_LED::text <> '')  LIMIT 1;
 EXCEPTION 
  WHEN no_data_found THEN 
   PR_RETORNO_W := '';
  WHEN OTHERS THEN 
   PR_RETORNO_W := '';
 END;
 END IF;
 
 RETURN PR_RETORNO_W;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_nm_recurso_func_html5 ( CD_FUNCAO_P bigint, IE_TIPO_P text) FROM PUBLIC;
