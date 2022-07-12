-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qt_in_care_interv ( nr_atendimento_p bigint, dt_conta_p timestamp, ie_opcao_p text ) RETURNS bigint AS $body$
DECLARE


 qt_dias_in_care_inter_w		bigint := 0;
 nr_sequencia_w				bigint:=0;


BEGIN

	if ((nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and (dt_conta_p IS NOT NULL AND dt_conta_p::text <> '') and (ie_opcao_p IS NOT NULL AND ie_opcao_p::text <> '')) then

		select	max(nr_sequencia)
		into STRICT	nr_sequencia_w
		from	icunsw
		where	nr_atendimento = nr_atendimento_p
		and ie_situacao = 'A'
		and coalesce(dt_inativacao::text, '') = '';

		if (nr_sequencia_w IS NOT NULL AND nr_sequencia_w::text <> '') then
		select count(*)
		into STRICT qt_dias_in_care_inter_w
		from icunsw_daily
		where nr_seq_icunsw = nr_sequencia_w
		and dt_registration <= dt_conta_p
		and ie_situacao = 'A'
		and coalesce(dt_inativacao::text, '') = ''
		and ie_patient_category = ie_opcao_p;
		end  if;

	end if;

	return qt_dias_in_care_inter_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qt_in_care_interv ( nr_atendimento_p bigint, dt_conta_p timestamp, ie_opcao_p text ) FROM PUBLIC;

