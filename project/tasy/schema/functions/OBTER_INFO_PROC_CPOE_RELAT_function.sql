-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_info_proc_cpoe_relat (nr_seq_cpoe_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(200);
nr_prescricao_w	prescr_procedimento.nr_prescricao%type;
nr_sequencia_w	prescr_procedimento.nr_sequencia%type;


BEGIN

nr_prescricao_w := coalesce(Obter_Nr_Prescr_Seq_Cpoe('P', nr_seq_cpoe_p),0);

select	max(nr_sequencia)
into STRICT	nr_sequencia_w
from  	prescr_procedimento
where 	nr_seq_proc_cpoe = nr_seq_cpoe_p;

select	CASE WHEN coalesce(qt_procedimento::text, '') = '' THEN ''  ELSE obter_desc_expressao(614525,'')||' '||qt_procedimento||'. ' END
		||CASE WHEN coalesce(cd_intervalo::text, '') = '' THEN ''  ELSE obter_desc_expressao(326105,'')||' '||obter_desc_intervalo(cd_intervalo)||'. ' END 
		||CASE WHEN coalesce(cd_material_exame::text, '') = '' THEN ''  ELSE obter_desc_expressao(292970,'')||': '||obter_desc_material_exame_lab(cd_material_exame) END 
into STRICT	ds_retorno_w
from  	prescr_procedimento
where 	nr_prescricao = nr_prescricao_w
and		nr_sequencia = nr_sequencia_w;

return	substr(ds_retorno_w,1,200);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_info_proc_cpoe_relat (nr_seq_cpoe_p bigint) FROM PUBLIC;
