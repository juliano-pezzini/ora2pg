-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE check_mandatory_insurance_fee (nr_atendimento_p atend_categoria_convenio.nr_atendimento%type) AS $body$
DECLARE


qt_insurance_without_fee_w smallint;


BEGIN

if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then

	select 	count(1)
	into STRICT 	qt_insurance_without_fee_w
	from 	atend_categoria_convenio acc,
			convenio con,
			atendimento_paciente ap
	where 	ap.nr_atendimento		= nr_atendimento_p
	and 	acc.nr_atendimento 		= ap.nr_atendimento
	and   	acc.cd_convenio 		= con.cd_convenio
	and 	ap.ie_tipo_atendimento 	= 1
	and	  	not exists (SELECT 1
						from pessoa_fisica_taxa pft
						where pft.nr_atendimento 	= acc.nr_atendimento
						and pft.nr_seq_atecaco		= acc.nr_seq_interno)
	and   	obter_regra_taxa_convenio(con.ie_tipo_convenio, con.cd_convenio) = 'S';

	if (qt_insurance_without_fee_w > 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(1076247);
	end if;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE check_mandatory_insurance_fee (nr_atendimento_p atend_categoria_convenio.nr_atendimento%type) FROM PUBLIC;
