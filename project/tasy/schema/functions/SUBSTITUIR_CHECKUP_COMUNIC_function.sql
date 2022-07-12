-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION substituir_checkup_comunic (nr_seq_comunicacao_p bigint, nr_seq_checkup_p bigint) RETURNS varchar AS $body$
DECLARE


ds_mensagem_w		varchar(32000);
cd_pessoa_fisica_w	varchar(10);
dt_agendamento_w	timestamp;
dt_previsto_w		timestamp;
ds_Senha_w		varchar(40);
nm_paciente_w		varchar(255);

BEGIN

if (nr_seq_checkup_p IS NOT NULL AND nr_seq_checkup_p::text <> '')  then
	select	cd_pessoa_fisica,
		dt_agendamento,
		dt_previsto
	into STRICT	cd_pessoa_fisica_w,
		dt_agendamento_w,
		dt_previsto_w
	from	checkup
	where	nr_sequencia = nr_seq_checkup_p;

	select 	ds_senha
	into STRICT	ds_Senha_w
	from	usuario
	where	cd_pessoa_fisica = cd_pessoa_fisica_w;

	select	nm_pessoa_fisica
	into STRICT	nm_paciente_w
	from	pessoa_fisica
	where	cd_pessoa_fisica = cd_pessoa_fisica_w;

	if (nr_seq_comunicacao_p IS NOT NULL AND nr_seq_comunicacao_p::text <> '') then

		select 	ds_mensagem_padrao
		into STRICT   	ds_mensagem_w
		from   	checkup_comunicacao
		where  	nr_sequencia = nr_seq_comunicacao_p;

		ds_mensagem_w := replace(ds_mensagem_w,'@cliente',nm_paciente_w);
		ds_mensagem_w := replace(ds_mensagem_w,'@usuario',cd_pessoa_fisica_w);
		ds_mensagem_w := replace(ds_mensagem_w,'@dt_agendamento',dt_agendamento_w);
		ds_mensagem_w := replace(ds_mensagem_w,'@dt_previsto',dt_previsto_w);
		ds_mensagem_w := replace(ds_mensagem_w,'@senha',ds_Senha_w);

	end if;

end if;

return	ds_mensagem_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION substituir_checkup_comunic (nr_seq_comunicacao_p bigint, nr_seq_checkup_p bigint) FROM PUBLIC;

