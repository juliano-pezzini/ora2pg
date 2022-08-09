-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE generate_report_batch_request ( nr_batch_conta_p bigint, --account batch number patient billing
 cd_estabelecimento_p bigint, nm_usuario_p text, dt_from_p timestamp, dt_to_p timestamp, ie_condition_p text, cd_error_string_p INOUT text) AS $body$
DECLARE


c03 CURSOR FOR
SELECT	b.nr_interno_conta
from	protocolo_convenio a,
	conta_paciente b
where	a.nr_seq_protocolo 	= nr_batch_conta_p
and  	a.nr_seq_protocolo 	= b.nr_seq_protocolo
and	get_eclipse_claim_status(b.nr_interno_conta, 'REPORT') = 'Under processing';-- put the claim status check as well, only send those claims for which the recipt is not generated  
c04 CURSOR FOR 
SELECT	d.nr_interno_conta
from 	convenio_retorno a,
	atend_categoria_convenio b,
	atendimento_paciente c,
	conta_paciente d
where	a.nr_sequencia = nr_batch_conta_p
and	a.cd_convenio = b.cd_convenio
and	c.nr_atendimento = b.nr_atendimento
and	d.nr_atendimento = c.nr_atendimento
and	d.dt_periodo_inicial >= dt_from_p
and	d.dt_periodo_final <= dt_to_p
and	get_eclipse_claim_status(d.nr_interno_conta, 'REPORT') = 'Under processing';
BEGIN


if	ie_condition_p = 'P' then
	for r03 in c03 loop
		if (GET_ECLIPSE_CLAIM_TYPE(r03.nr_interno_conta) = 'IHC') then
			CALL generate_ihc_rtv_request(r03.nr_interno_conta, cd_estabelecimento_p, nm_usuario_p);
		else
			cd_error_string_p := generate_dvr_request_data(r03.nr_interno_conta, cd_estabelecimento_p, nm_usuario_p, cd_error_string_p);
		end if;
	end loop;
end if;


if	ie_condition_p = 'I' then
	for r04 in c04 loop
		if (GET_ECLIPSE_CLAIM_TYPE(r04.nr_interno_conta) = 'IHC') then
			CALL generate_ihc_rtv_request(r04.nr_interno_conta, cd_estabelecimento_p, nm_usuario_p);
		else
			cd_error_string_p := generate_dvr_request_data(r04.nr_interno_conta, cd_estabelecimento_p, nm_usuario_p, cd_error_string_p);
		end if;
	end loop;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE generate_report_batch_request ( nr_batch_conta_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, dt_from_p timestamp, dt_to_p timestamp, ie_condition_p text, cd_error_string_p INOUT text) FROM PUBLIC;
