-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_eclipse_claim_type (NR_INTERNO_CONTA_W CONTA_PACIENTE.NR_INTERNO_CONTA%TYPE) RETURNS varchar AS $body$
DECLARE


insurance_type_w bigint;
encounter_type_w bigint;
cd_convenio_parametro_w		conta_paciente.cd_convenio_parametro%type;
nr_atendimento_w		conta_paciente.nr_atendimento%type;
nationality_w		        pessoa_fisica.cd_nacionalidade%type;
ie_brasileiro_w             	nacionalidade.ie_brasileiro%TYPE := NULL;
result_w 			varchar(10) :='IHC';
encounter_clasfi_w varchar(10);
ie_imc_type_w  varchar(10);

BEGIN
select	max(cd_convenio_parametro),
	max(nr_atendimento)
into STRICT	cd_convenio_parametro_w,
	nr_atendimento_w
from	conta_paciente
where	nr_interno_conta	= nr_interno_conta_w;

select	max(ie_tipo_convenio)
into STRICT	insurance_type_w
from	convenio
where	cd_convenio	= cd_convenio_parametro_w;

select	max(ie_tipo_atendimento),
	obter_nacionalidade_pf(cd_pessoa_fisica) as cd_pessoa_fisica,
	max(nr_seq_classificacao)
into STRICT	encounter_type_w,
	nationality_w,
	encounter_clasfi_w
from	atendimento_paciente
where	nr_atendimento	= nr_atendimento_w
group by
	ie_tipo_atendimento,
	cd_pessoa_fisica;

select	max(IE_IMC_TYPE)
into STRICT 	ie_imc_type_w
from  	ECLIPSE_PARAMETERS;

select  coalesce(max(ie_brasileiro), 'N')
into STRICT    ie_brasileiro_w
from    nacionalidade
where   cd_nacionalidade = nationality_w;

if ( insurance_type_w = 13 and encounter_type_w = 8 ) then -- if DVA and encounter is outpatient
	result_w := 'DVA';
ELSIF ((nationality_w IS NOT NULL AND nationality_w::text <> '') and nationality_w <> '53') then
	result_w := 'OVS';
ELSIF (insurance_type_w = 12 and encounter_type_w = 8) then -- Outpatient and Medicare
	result_w := 'DBS';
ELSIF (insurance_type_w = 12 and (encounter_type_w = 1) and (ie_imc_type_w = encounter_clasfi_w )) then -- Inpatient and Medicare
	result_w := 'IMC';

end if;
RETURN result_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_eclipse_claim_type (NR_INTERNO_CONTA_W CONTA_PACIENTE.NR_INTERNO_CONTA%TYPE) FROM PUBLIC;
