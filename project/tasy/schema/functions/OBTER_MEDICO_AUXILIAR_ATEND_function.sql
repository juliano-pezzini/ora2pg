-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_medico_auxiliar_atend (nr_atendimento_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

 
ds_retorno_w varchar(100);


BEGIN 
 
 
if (ie_opcao_p = 'N') then 
  begin 
 select substr(obter_nome_pf(max(a.cd_prescritor)),1,99) 
 into STRICT ds_retorno_w 
 from  medico b, 
 prescr_medica a 
 where  a.cd_prescritor = b.cd_pessoa_fisica 
 and   a.nr_atendimento = nr_atendimento_p 
 and   b.ie_situacao = 'A';
 
 if (coalesce(ds_retorno_w::text, '') = '') then 
 begin 
 select substr(obter_nome_pf(max(a.cd_medico)),1,99) 
 into STRICT ds_retorno_w 
 from  medico b, 
  evolucao_paciente a 
 where  a.cd_medico = b.cd_pessoa_fisica 
 and   a.nr_atendimento = nr_atendimento_p 
 and b.ie_situacao = 'A';
    end;
 end if;
  end;
end if;
 
return ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_medico_auxiliar_atend (nr_atendimento_p bigint, ie_opcao_p text) FROM PUBLIC;
