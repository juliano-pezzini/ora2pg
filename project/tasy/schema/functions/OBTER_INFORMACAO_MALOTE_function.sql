-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_informacao_malote (nr_seq_envelope_p bigint, opcao_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno  varchar(255);


BEGIN

if (opcao_p = 'M') then
  SELECT max(a.nr_seq_malote) INTO STRICT ds_retorno FROM malote_envelope_item a WHERE a.nr_seq_envelope = nr_seq_envelope_p;
end if;

if (opcao_p = 'DT') then
  SELECT to_char(max(dt_atualizacao),'dd/mm/yyyy hh24:mi:ss') INTO STRICT ds_retorno FROM malote_envelope_item a WHERE a.nr_seq_envelope = nr_seq_envelope_p;
end if;

if (opcao_p = 'DT_SAIDA_ENTREGA') then
  SELECT to_char(max(b.DT_SAIDA_ENTREGA),'dd/mm/yyyy hh24:mi:ss')
  INTO STRICT ds_retorno
  FROM malote_envelope_item a,
       malote_envelope_laudo b
  WHERE a.nr_seq_envelope = nr_seq_envelope_p
  and   a.nr_seq_malote = b.nr_sequencia;
end if;

if (opcao_p = 'DT_ENTREGA') then
  SELECT to_char(max(a.dt_entrega),'dd/mm/yyyy hh24:mi:ss')
  INTO STRICT ds_retorno
  FROM envelope_laudo a
  WHERE a.nr_sequencia = nr_seq_envelope_p;
end if;

if (opcao_p = 'DT_CONFERENCIA') then
  SELECT to_char(max(a.dt_checagem),'dd/mm/yyyy hh24:mi:ss')
  INTO STRICT ds_retorno
  FROM envelope_laudo a
  WHERE a.nr_sequencia = nr_seq_envelope_p;
end if;

if (opcao_p = 'DT_RECEB_MALOTE') then
  SELECT to_char(max(b.dt_recebimento_malote),'dd/mm/yyyy hh24:mi:ss')
  INTO STRICT ds_retorno
  FROM malote_envelope_item a,
       malote_envelope_laudo b
  WHERE a.nr_seq_envelope = nr_seq_envelope_p
  and   a.nr_seq_malote = b.nr_sequencia;
end if;

return ds_retorno;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_informacao_malote (nr_seq_envelope_p bigint, opcao_p text) FROM PUBLIC;

