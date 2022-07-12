-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


--Obt?m o tipo de guia  que ser? atualizada a an?lise.



CREATE OR REPLACE FUNCTION pls_analise_cta_pck.obter_tipo_guia_analise_update ( nr_seq_analise_p pls_analise_conta.nr_sequencia%type, ie_tipo_guia_conta_p pls_conta.ie_tipo_guia%type) RETURNS PLS_ANALISE_CONTA.IE_TIPO_GUIA%TYPE AS $body$
DECLARE


ie_tipo_guia_w    pls_analise_conta.ie_tipo_guia%type;
ie_tipo_guia_analise_w  pls_analise_conta.ie_tipo_guia%type;


BEGIN

if (ie_tipo_guia_conta_p = '5') then
  ie_tipo_guia_w  := '5';
else
  select  max(ie_tipo_guia)
  into STRICT  ie_tipo_guia_analise_w
  from  pls_analise_conta
  where   nr_sequencia = nr_seq_analise_p;

  if (ie_tipo_guia_analise_w = '5') then
    ie_tipo_guia_w  := '5';
  elsif (ie_tipo_guia_conta_p = '6') then
    ie_tipo_guia_w  := '6';
  elsif (ie_tipo_guia_conta_p = '4') then
    ie_tipo_guia_w  := '4';
  else
    ie_tipo_guia_w  := '3';
  end if;

end if;

return ie_tipo_guia_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_analise_cta_pck.obter_tipo_guia_analise_update ( nr_seq_analise_p pls_analise_conta.nr_sequencia%type, ie_tipo_guia_conta_p pls_conta.ie_tipo_guia%type) FROM PUBLIC;