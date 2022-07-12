-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_tipo_adt_ispm ( nr_atendimento_p atendimento_paciente.nr_atendimento%type ) RETURNS varchar AS $body$
DECLARE


tipo_adt_w				varchar(3);
cd_pessoa_fisica_w		varchar(64);
ie_pessoa_cadastrada_w	bigint;
cd_estabelecimento_w estabelecimento.cd_estabelecimento%type;


BEGIN
  tipo_adt_w := 'A01';

	select wheb_usuario_pck.get_cd_estabelecimento
	into STRICT cd_estabelecimento_w
	;

	select max(cd_pessoa_fisica)
	into STRICT  cd_pessoa_fisica_w
	from  atendimento_paciente
	where nr_atendimento = nr_atendimento_p;

	if (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') then
		select max(nr_sequencia)
		into STRICT ie_pessoa_cadastrada_w
		from pf_codigo_externo
		where cd_pessoa_fisica = cd_pessoa_fisica_w and
			  ie_tipo_codigo_externo = 'ISPM'
			  and (coalesce(cd_estabelecimento,cd_estabelecimento_w) = cd_estabelecimento_w);
		
		if (ie_pessoa_cadastrada_w IS NOT NULL AND ie_pessoa_cadastrada_w::text <> '') then
			tipo_adt_w := 'A08';
		end if;
	end if;

return tipo_adt_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_tipo_adt_ispm ( nr_atendimento_p atendimento_paciente.nr_atendimento%type ) FROM PUBLIC;
