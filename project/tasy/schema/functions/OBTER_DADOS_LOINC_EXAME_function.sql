-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_loinc_exame (nr_prescricao_p bigint, nr_seq_prescr_p bigint, IE_OPCAO_P text) RETURNS varchar AS $body$
DECLARE


cd_loinc_w	    varchar(10);
ds_componente_w	varchar(255);
ds_retorno_w		varchar(255);

/*
CL - Código Loinc
DC - Componente
*/
BEGIN
  if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '' AND nr_seq_prescr_p IS NOT NULL AND nr_seq_prescr_p::text <> '') then

  	select lld.cd_loinc, lldr.ds_componente
      into STRICT cd_loinc_w, ds_componente_w
      from PRESCR_PROCEDIMENTO_LOINC ppl
     inner join LAB_LOINC_DADOS lld on lld.nr_sequencia = ppl.nr_seq_loinc_dados
     inner join LAB_LOINC_DADOS_REG lldr on lldr.nr_seq_loinc_dados = lld.nr_sequencia
     where ppl.nr_prescricao = nr_prescricao_p and
           ppl.nr_seq_prescr = nr_seq_prescr_p;

    if (coalesce(ie_opcao_p, 'CL') = 'CL') then
      ds_retorno_w := cd_loinc_w;
    elsif (coalesce(ie_opcao_p, 'CL') = 'DC') then
      ds_retorno_w := ds_componente_w;
    end if;
  end if;

  RETURN	ds_retorno_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_loinc_exame (nr_prescricao_p bigint, nr_seq_prescr_p bigint, IE_OPCAO_P text) FROM PUBLIC;
