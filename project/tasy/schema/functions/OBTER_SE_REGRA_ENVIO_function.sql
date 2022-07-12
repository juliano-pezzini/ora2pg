-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_regra_envio ( nr_seq_regra_p bigint, nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


ie_regra_w		varchar(1) := 'S';
qt_registros_w		bigint;
ie_tipo_atendimento_w	smallint;
ie_carater_inter_sus_w	varchar(3);
ie_clinica_w		integer;
nr_seq_classificacao_w	bigint;


BEGIN

select	max(ie_carater_inter_sus),
	max(ie_tipo_atendimento),
	max(ie_clinica),
	max(nr_seq_classificacao)
into STRICT	ie_carater_inter_sus_w,
	ie_tipo_atendimento_w,
	ie_clinica_w,
	nr_seq_classificacao_w
from	atendimento_paciente
where	nr_atendimento = nr_atendimento_p;

select	count(*)
into STRICT	qt_registros_w
from	regra_envio_sms_atend
where	nr_seq_regra	= nr_seq_regra_p;

if (qt_registros_w > 0) then
	select	coalesce(MAX('S'),'N')
	into STRICT	ie_regra_w
	from	regra_envio_sms_atend
	where	nr_seq_regra	= nr_seq_regra_p
	and	coalesce(ie_carater_inter_sus,coalesce(ie_carater_inter_sus_w,'XPTO')) 	= coalesce(ie_carater_inter_sus_w,'XPTO')
	and	coalesce(ie_clinica,coalesce(ie_clinica_w,0)) = coalesce(ie_clinica_w,'0')
	and	coalesce(ie_tipo_atendimento,coalesce(ie_tipo_atendimento_w,0)) 		= coalesce(ie_tipo_atendimento_w,0)
	and	coalesce(nr_seq_classificacao,coalesce(nr_seq_classificacao_w,0))		= coalesce(nr_seq_classificacao_w,0);

end if;

return	ie_regra_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_regra_envio ( nr_seq_regra_p bigint, nr_atendimento_p bigint) FROM PUBLIC;

