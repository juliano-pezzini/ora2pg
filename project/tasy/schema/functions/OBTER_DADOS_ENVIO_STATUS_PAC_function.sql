-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_envio_status_pac (nr_seq_status_p text, nr_seq_agenda_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(4000) := '';
nr_seq_regra_w	bigint;
nm_paciente_w	varchar(60);
cd_pessoa_fisica_w	varchar(10);


BEGIN

select	max(nr_sequencia)
into STRICT	nr_seq_regra_w
from	regra_status_pac_email
where	nr_seq_status_pac = nr_seq_status_p;

if (nr_seq_regra_w IS NOT NULL AND nr_seq_regra_w::text <> '') then
	if (ie_opcao_p = 'T') then
		select	max(ds_titulo)
		into STRICT	ds_retorno_w
		from	regra_status_pac_email
		where	nr_sequencia = nr_seq_regra_w;
	elsif (ie_opcao_p = 'R') then
		select	max(ds_remetente)
		into STRICT	ds_retorno_w
		from	regra_status_pac_email
		where	nr_sequencia = nr_seq_regra_w;
	elsif (ie_opcao_p = 'M') then

		select	max(ds_email)
		into STRICT	ds_retorno_w
		from	regra_status_pac_email
		where	nr_sequencia = nr_seq_regra_w;

		select	max(nm_paciente)
		into STRICT	nm_paciente_w
		from	agenda_paciente
		where	nr_sequencia = nr_seq_agenda_p;

		ds_retorno_w	:= replace_macro(ds_retorno_w, '@Paciente', nm_paciente_w);

	elsif (ie_opcao_p = 'A') then
		select	max(ds_anexo)
		into STRICT	ds_retorno_w
		from	regra_status_pac_email
		where	nr_sequencia = nr_seq_regra_w;
	elsif (ie_opcao_p = 'D') then
		select	max(cd_pessoa_fisica)
		into STRICT	cd_pessoa_fisica_w
		from	agenda_paciente
		where	nr_sequencia = nr_seq_agenda_p;

		select	max(b.ds_email)
		into STRICT	ds_retorno_w
		from	pessoa_fisica a,
			compl_pessoa_fisica b
		where	a.cd_pessoa_fisica 	= b.cd_pessoa_fisica
		and	b.ie_tipo_complemento 	= 1
		and	a.cd_pessoa_fisica	= cd_pessoa_fisica_w;
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_envio_status_pac (nr_seq_status_p text, nr_seq_agenda_p bigint, ie_opcao_p text) FROM PUBLIC;
