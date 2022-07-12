-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_nivel_complexidade ( nr_pessoa_p text, nr_seq_prescricao_p bigint) RETURNS bigint AS $body$
DECLARE


qt_minutos_nivel_complex_w	bigint;
ie_idade_w 					integer;
ie_nivel_compl_w 			paciente_compl_assist.ie_nivel_compl%type;
ie_dominio_w 				integer;


BEGIN
	qt_minutos_nivel_complex_w := 0;
	ie_dominio_w := 8694;

	select trunc((months_between(clock_timestamp(), dt_nascimento))/12)
	into STRICT ie_idade_w
	from pessoa_fisica
	where cd_pessoa_fisica = nr_pessoa_p;
	
	select coalesce(max(ie_nivel_compl), 0)
	into STRICT ie_nivel_compl_w
	from paciente_compl_assist
	where nr_sequencia = nr_seq_prescricao_p;

	if ie_idade_w > 0 and ie_nivel_compl_w > 0 then
		select coalesce(max(qt_nivel_min), 0)
		into STRICT qt_minutos_nivel_complex_w
		from valores_nivel_complexidade
		where ie_nivel_compl = ie_nivel_compl_w
			and nr_seq_nivel_compl = (
				SELECT max(nr_sequencia)
				from nivel_complexidade
				where ie_idade_w >= qt_faixa_min and ie_idade_w <= qt_faixa_max 
			 LIMIT 1);
	end if;
	
	return qt_minutos_nivel_complex_w;
	
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_nivel_complexidade ( nr_pessoa_p text, nr_seq_prescricao_p bigint) FROM PUBLIC;

