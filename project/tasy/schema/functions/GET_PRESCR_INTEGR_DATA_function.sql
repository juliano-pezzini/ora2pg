-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_prescr_integr_data (ds_value_p text, ds_intgr_type_p text, ds_data_type_p text) RETURNS varchar AS $body$
DECLARE


ds_outbound_code_w 		PRESCR_ITEM_INTEGRACAO.CD_INTEGRACAO%type;
ds_outbound_system_w 	PRESCR_ITEM_INTEGRACAO.IE_SISTEMA_EXTERNO%type;

/* ds_intgr_type_p - types of acceptable values
R - recomendation
P - procedure
G - gas
I - internal procedure
T - type of fasting (diet)
O - oral diet
*/
/* ds_data_type_p
OC = outbound code
OS = outbound system
*/
BEGIN

if (ds_intgr_type_p not in ('R','P','G','I','T','O'))
	or (ds_data_type_p not in ('OC', 'OS'))
	or (coalesce(ds_value_p::text, '') = '') then
	return null;
end if;

select d.cd_integracao,
	d.ie_sistema_externo
into STRICT ds_outbound_code_w,
	ds_outbound_system_w
from PRESCRICAO_INTEGRACAO c, 
	PRESCR_ITEM_INTEGRACAO d
where c.nr_sequencia = d.nr_presc_integracao
and (
	(ds_intgr_type_p = 'R' and c.CD_RECOMENDACAO = ds_value_p)
	or (ds_intgr_type_p = 'P' and c.CD_PROCEDIMENTO = ds_value_p)
	or (ds_intgr_type_p = 'G' and c.NR_SEQ_GAS = ds_value_p)
	or (ds_intgr_type_p = 'I' and c.NR_SEQ_PROC_INTERNO = ds_value_p)
	or (ds_intgr_type_p = 'T' and c.NR_SEQ_TIPO = ds_value_p)
	or (ds_intgr_type_p = 'O' and c.CD_DIETA = ds_value_p)
	)
and d.IE_ENVIO_RECEB in ('E', 'A')
order by d.nr_sequencia desc;	

if (ds_data_type_p = 'OC') then
	return ds_outbound_code_w;
elsif (ds_data_type_p = 'OS') then
	return ds_outbound_system_w;
end if;

return null;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_prescr_integr_data (ds_value_p text, ds_intgr_type_p text, ds_data_type_p text) FROM PUBLIC;
