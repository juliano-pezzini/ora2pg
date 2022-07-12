-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_projeto_ordem_servico (nr_seq_ordem_def_p bigint) RETURNS MAN_DOC_ERRO.NR_SEQ_PROJ_DEF%TYPE AS $body$
DECLARE

			
  nr_seq_proj_def_w	man_doc_erro.nr_seq_proj_def%type;


BEGIN
    if (nr_seq_ordem_def_p IS NOT NULL AND nr_seq_ordem_def_p::text <> '') then
      begin
      SELECT 
        pp.nr_sequencia into STRICT	nr_seq_proj_def_w
      FROM
        proj_projeto pp
      LEFT JOIN proj_cronograma pc 
        ON  pc.nr_seq_proj = pp.nr_sequencia
      LEFT JOIN proj_cron_etapa pce 
        ON pce.nr_seq_cronograma = pc.nr_sequencia
      LEFT JOIN man_ordem_servico mos
        ON mos.nr_seq_proj_cron_etapa = pce.nr_sequencia 
      WHERE 1 = 1
        AND mos.nr_sequencia = nr_seq_ordem_def_p;
      end;
    end if;
  return nr_seq_proj_def_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_projeto_ordem_servico (nr_seq_ordem_def_p bigint) FROM PUBLIC;
