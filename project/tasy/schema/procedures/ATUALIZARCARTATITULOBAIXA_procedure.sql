-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizarcartatitulobaixa (NR_SEQUENCIA_P bigint, NR_TITULO_BAIXA_P bigint) AS $body$
BEGIN

  update CARTA_COMPROMISSO
  set NR_TITULO_BAIXA = NR_TITULO_BAIXA_P,
      nm_usuario = WHEB_USUARIO_PCK.GET_NM_USUARIO,
      dt_atualizacao = clock_timestamp()
  where NR_SEQUENCIA = NR_SEQUENCIA_P;
  commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizarcartatitulobaixa (NR_SEQUENCIA_P bigint, NR_TITULO_BAIXA_P bigint) FROM PUBLIC;
