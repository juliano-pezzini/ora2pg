-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_minhas_tarefas_parametro (nm_usuario_p wl_item.nm_usuario%type) RETURNS varchar AS $body$
DECLARE


ds_retorno_w varchar(1) := 'N';


BEGIN

  SELECT PU.VL_PARAMETRO
  into STRICT ds_retorno_w
  FROM FUNCAO_PARAMETRO FP
  INNER JOIN FUNCAO_PARAM_USUARIO PU ON FP.NR_SEQUENCIA = PU.NR_SEQUENCIA
  WHERE PU.CD_FUNCAO = 357
  AND PU.NR_SEQUENCIA = 5
  AND FP.DS_PARAMETRO = 'Permitir visualizar todas as tarefas'
  AND PU.NM_USUARIO = nm_usuario_p;


  return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_minhas_tarefas_parametro (nm_usuario_p wl_item.nm_usuario%type) FROM PUBLIC;
