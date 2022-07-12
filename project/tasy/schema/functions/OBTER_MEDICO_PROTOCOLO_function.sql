-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_medico_protocolo (nr_prescricao_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

ds_resultado_w		varchar(80);
nr_seq_paciente_w	bigint;
/* 	ie_opcao_p: 
	C = Código 
	N = Nome 
*/
BEGIN 
if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (ie_opcao_p IS NOT NULL AND ie_opcao_p::text <> '') then 
	select	max(a.nr_seq_paciente) 
	into STRICT	nr_seq_paciente_w 
	from	paciente_atendimento a 
	where	a.nr_prescricao = nr_prescricao_p;
	if (nr_seq_paciente_w IS NOT NULL AND nr_seq_paciente_w::text <> '') then 
		if (ie_opcao_p = 'C')then 
			select	max(p.cd_medico_resp) 
			into STRICT	ds_resultado_w 
			from	paciente_setor p 
			where	p.nr_seq_paciente 	= nr_seq_paciente_w;
		elsif (ie_opcao_p = 'N') then 
			select	max(substr(obter_nome_pf(p.cd_medico_resp),1,80)) 
			into STRICT	ds_resultado_w 
			from	paciente_setor p 
			where	p.nr_seq_paciente = nr_seq_paciente_w;
		end if;
	end if;
end if;
return ds_resultado_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_medico_protocolo (nr_prescricao_p bigint, ie_opcao_p text) FROM PUBLIC;
