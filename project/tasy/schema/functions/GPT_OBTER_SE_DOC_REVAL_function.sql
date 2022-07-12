-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION gpt_obter_se_doc_reval (dt_validacao_p cpoe_revalidation_events.dt_validacao%type, nr_seq_revalidation_rule_p cpoe_revalidation_events.nr_seq_revalidation_rule%type) RETURNS varchar AS $body$
DECLARE


ie_revalida_w			varchar(1);
ie_situacao_regra_w		cpoe_revalidation_rule.ie_situacao%type;
qt_horas_anterior_w		cpoe_revalidation_rule.qt_horas_anterior%type;
dt_val_inicio_w			cpoe_revalidation_events.dt_validacao%type;


BEGIN

	ie_revalida_w	:= 'N';

	dt_val_inicio_w	:=	gpt_get_doc_reval_period();

	select	coalesce(max(a.ie_situacao),'A'),
			coalesce(max(a.qt_horas_anterior),0)
	into STRICT	ie_situacao_regra_w,
			qt_horas_anterior_w
	from	cpoe_revalidation_rule	a
	where	a.nr_sequencia	= nr_seq_revalidation_rule_p;

	if (ie_situacao_regra_w = 'A') then
		if	((dt_validacao_p - (qt_horas_anterior_w / 24)) between dt_val_inicio_w and clock_timestamp()) then
			ie_revalida_w	:= 'S';
		end if;
	elsif (ie_situacao_regra_w = 'I') then
		ie_revalida_w	:= 'S';
	end if;

	return	ie_revalida_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION gpt_obter_se_doc_reval (dt_validacao_p cpoe_revalidation_events.dt_validacao%type, nr_seq_revalidation_rule_p cpoe_revalidation_events.nr_seq_revalidation_rule%type) FROM PUBLIC;
