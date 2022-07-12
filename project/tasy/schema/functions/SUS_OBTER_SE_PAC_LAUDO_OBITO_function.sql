-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sus_obter_se_pac_laudo_obito ( nr_seq_interno_p bigint , nr_atendimento_p bigint , nr_prontuario_p bigint , cd_estabelecimento_p bigint ) RETURNS varchar AS $body$
DECLARE

					 
ds_retorno_w		varchar(15)	:= 'N';
qt_obito_motivo_w		smallint	:= 0;
qt_obito_cadastro_w	smallint	:= 0;


BEGIN 
 
if (coalesce(nr_seq_interno_p,0) > 0) then 
	begin 
	 
	select	count(*) 
	into STRICT	qt_obito_motivo_w 
	from	motivo_alta b, 
		atendimento_paciente a, 
		sus_laudo_paciente c 
	where	(a.dt_alta IS NOT NULL AND a.dt_alta::text <> '') 
	and	b.ie_obito = 'S' 
	and	a.cd_motivo_alta 		= b.cd_motivo_alta 
	and	a.cd_estabelecimento	= cd_estabelecimento_p 
	and	a.nr_atendimento		= c.nr_atendimento 
	and	c.nr_seq_interno		= nr_seq_interno_p;
	 
	select	count(*) 
	into STRICT	qt_obito_cadastro_w 
	from	pessoa_fisica a, 
		atendimento_paciente b, 
		sus_laudo_paciente c 
	where	(a.dt_obito IS NOT NULL AND a.dt_obito::text <> '') 
	and	a.cd_pessoa_fisica 		= b.cd_pessoa_fisica 
	and	b.nr_atendimento		= c.nr_atendimento 
	and	b.cd_estabelecimento	= cd_estabelecimento_p 
	and	c.nr_seq_interno		= nr_seq_interno_p;
	 
	if (qt_obito_motivo_w > 0) or (qt_obito_cadastro_w > 0) then 
		ds_retorno_w := 'S';
	end if;
		 
	end;
elsif (coalesce(nr_atendimento_p,0) > 0) then 
	begin 
	 
	select	count(*) 
	into STRICT	qt_obito_motivo_w 
	from	motivo_alta b, 
		atendimento_paciente a 
	where	(a.dt_alta IS NOT NULL AND a.dt_alta::text <> '') 
	and	b.ie_obito = 'S' 
	and	a.cd_motivo_alta 		= b.cd_motivo_alta 
	and	a.cd_estabelecimento	= cd_estabelecimento_p 
	and	a.nr_atendimento		= nr_atendimento_p;
	 
	select	count(*) 
	into STRICT	qt_obito_cadastro_w 
	from	pessoa_fisica a, 
		atendimento_paciente b 
	where	(a.dt_obito IS NOT NULL AND a.dt_obito::text <> '') 
	and	a.cd_pessoa_fisica 		= b.cd_pessoa_fisica 
	and	b.cd_estabelecimento	= cd_estabelecimento_p 
	and	b.nr_atendimento		= nr_atendimento_p;
	 
	if (qt_obito_motivo_w > 0) or (qt_obito_cadastro_w > 0) then 
		ds_retorno_w := 'S';
	end if;
	 
	end;
elsif (coalesce(nr_prontuario_p,0) > 0) then 
	begin 
	select	count(*) 
	into STRICT	qt_obito_motivo_w 
	from	motivo_alta b, 
		pessoa_fisica c, 
		atendimento_paciente a 
	where	(a.dt_alta IS NOT NULL AND a.dt_alta::text <> '') 
	and	b.ie_obito = 'S' 
	and	a.cd_motivo_alta 	= b.cd_motivo_alta 
	and	a.cd_estabelecimento	= cd_estabelecimento_p 
	and	a.cd_pessoa_fisica 	= c.cd_pessoa_fisica 
	and	c.nr_prontuario 	= nr_prontuario_p;
	 
	select	count(*) 
	into STRICT	qt_obito_cadastro_w 
	from	pessoa_fisica a, 
		atendimento_paciente b 
	where	(a.dt_obito IS NOT NULL AND a.dt_obito::text <> '') 
	and	a.cd_pessoa_fisica 	= b.cd_pessoa_fisica 
	and	b.cd_estabelecimento	= cd_estabelecimento_p 
	and	a.nr_prontuario		= nr_prontuario_p;
	 
	if (qt_obito_motivo_w > 0) or (qt_obito_cadastro_w > 0) then 
		ds_retorno_w := 'S';
	end if;
	end;	
end if;
 
return ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sus_obter_se_pac_laudo_obito ( nr_seq_interno_p bigint , nr_atendimento_p bigint , nr_prontuario_p bigint , cd_estabelecimento_p bigint ) FROM PUBLIC;
