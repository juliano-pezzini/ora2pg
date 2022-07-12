-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lab_cons_valor_res_anterior ( nr_prescricao_p bigint, nr_seq_result_p bigint, nr_seq_prescr_p bigint, nr_seq_exame_p bigint) RETURNS varchar AS $body$
DECLARE



ie_exames_aprov_w			varchar(1);
ie_normalidade_ant_w		exame_lab_result_item.ie_normalidade%type;
cd_pessoa_fisica_w			pessoa_fisica.cd_pessoa_fisica%type;


BEGIN
ie_exames_aprov_w := 'S';

select  MAX(cd_pessoa_fisica)
into STRICT	cd_pessoa_fisica_w
from  	prescr_medica
where 	nr_prescricao = nr_prescricao_p;

select  MAX(d.ie_normalidade)
into STRICT	ie_normalidade_ant_w
from 	prescr_procedimento a,
		prescr_medica b,
		exame_lab_resultado c,
		exame_lab_result_item d
where   a.nr_prescricao = b.nr_prescricao
and		b.nr_prescricao = c.nr_prescricao
and		c.nr_seq_resultado = d.nr_seq_resultado
and		a.nr_sequencia = d.nr_seq_prescr
and		a.nr_prescricao < nr_prescricao_p
and		d.nr_seq_exame = nr_seq_exame_p
and		b.cd_pessoa_fisica	= cd_pessoa_fisica_w;

if (ie_normalidade_ant_w = 1088) then --fora do valor de referência;
	ie_exames_aprov_w := 'N';
end if;

return	ie_exames_aprov_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lab_cons_valor_res_anterior ( nr_prescricao_p bigint, nr_seq_result_p bigint, nr_seq_prescr_p bigint, nr_seq_exame_p bigint) FROM PUBLIC;
