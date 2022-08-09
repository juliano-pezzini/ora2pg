-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consiste_solic_exame ( nr_sequencia_p bigint, nr_prontuario_p bigint, cd_setor_atendimento_p bigint, cd_agenda_p bigint, dt_solicitacao_p timestamp, cd_estabelecimento_p bigint, nm_usuario_p text, ds_retorno_p INOUT text) AS $body$
DECLARE


qt_existe_w		bigint;
cd_pessoa_fisica_w	varchar(10) := '0';
cd_agenda_w		bigint;
nr_sequencia_w		bigint;


BEGIN

cd_agenda_w	:= coalesce(cd_agenda_p,0);

select	count(*)
into STRICT	qt_existe_w
from	exame_prontuario
where	cd_estabelecimento	= cd_estabelecimento_p
and	nr_prontuario		= nr_prontuario_p;

if (qt_existe_w = 0) then

	select	coalesce(max(cd_pessoa_fisica),'0')
	into STRICT	cd_pessoa_fisica_w
	from	pessoa_fisica
	where	cd_estabelecimento	= cd_estabelecimento_p
	and	nr_prontuario		= nr_prontuario_p;


	if (cd_pessoa_fisica_w <> '0') then
		begin

		insert 	into exame_prontuario(
	   		nr_sequencia,
		   	cd_estabelecimento,
		   	dt_atualizacao,
		   	nm_usuario,
		   	nr_prontuario,
		   	cd_pessoa_fisica,
		   	qt_volume,
		  	ds_localizacao,
			dt_atualizacao_nrec,
			nm_usuario_nrec)
		values (nextval('exame_prontuario_seq'),
	   		cd_estabelecimento_p,
	   		clock_timestamp(),
	   		nm_usuario_p,
	   		nr_prontuario_p,
   			cd_pessoa_fisica_w,
	   		1,
   			'',
			clock_timestamp(),
	   		nm_usuario_p);

		commit;
		end;
	else
		ds_retorno_p	:= wheb_mensagem_pck.get_texto(800320);
	end if;
end if;


select	count(*)
into STRICT	qt_existe_w
from	exame_solicitacao
where	cd_estabelecimento	= cd_estabelecimento_p
and	cd_setor_atendimento	= cd_setor_atendimento_p
and	nr_prontuario		= nr_prontuario_p
and	nr_sequencia		<> nr_sequencia_p
and	ie_status_solic		= 'A'
and	trunc(dt_desejada)	= trunc(dt_solicitacao_p)
and	((cd_agenda		= cd_agenda_w) or ((coalesce(cd_agenda::text, '') = '') and (cd_agenda_w = 0)));

if (qt_existe_w <> 0) then
	ds_retorno_p	:= wheb_mensagem_pck.get_texto(800321);
end if;

select	count(*)
into STRICT	qt_existe_w
from	exame_emprestimo
where	cd_estabelecimento	= cd_estabelecimento_p
and	cd_setor_atendimento	= cd_setor_atendimento_p
and	nr_prontuario		= nr_prontuario_p
and	coalesce(dt_devolucao::text, '') = ''
and	((cd_agenda		= cd_agenda_w) or ((coalesce(cd_agenda::text, '') = '') and (cd_agenda_w = 0)))
and	trunc(dt_solicitacao_p)	= trunc(clock_timestamp());

if (qt_existe_w <> 0) then
	ds_retorno_p	:= wheb_mensagem_pck.get_texto(800323);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consiste_solic_exame ( nr_sequencia_p bigint, nr_prontuario_p bigint, cd_setor_atendimento_p bigint, cd_agenda_p bigint, dt_solicitacao_p timestamp, cd_estabelecimento_p bigint, nm_usuario_p text, ds_retorno_p INOUT text) FROM PUBLIC;
