-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_gravar_envio_laudo_aih_ws (cd_laudo_internacao_p text, ds_mensagem_retorno_p text, nm_usuario_p text, nr_seq_laudo_pac_p bigint, tp_situacao_p bigint) AS $body$
DECLARE


qt_registros_laudo_pac_w	bigint;
nm_paciente_w			varchar(255);
nr_atendimento_w			bigint;
nr_seq_lote_laudo_w			bigint;


BEGIN

begin
	select substr(obter_nome_pf(b.cd_pessoa_fisica),1,120) nm_pessoa_fisica, a.nr_atendimento
	into STRICT nm_paciente_w, nr_atendimento_w
	from sus_laudo_paciente a, atendimento_paciente b
	where a.nr_atendimento  = b.nr_atendimento
	and a.nr_seq_interno = nr_seq_laudo_pac_p;
exception
when others then
	nm_paciente_w := null;
	nr_atendimento_w := null;
end;

select count(nr_seq_laudo_pac)
into STRICT qt_registros_laudo_pac_w
from sus_retorno_laudo_aih_ws
where nr_seq_laudo_pac = nr_seq_laudo_pac_p;

if (qt_registros_laudo_pac_w = 0)	then

	insert into sus_retorno_laudo_aih_ws(
	cd_laudo_internacao,
	ds_mensagem_retorno,
	dt_atualizacao,
	nm_usuario,
	nr_seq_laudo_pac,
	nr_atendimento,
	nm_paciente,
	nr_sequencia)
	values (cd_laudo_internacao_p,
	ds_mensagem_retorno_p,
	clock_timestamp(),
	nm_usuario_p,
	nr_seq_laudo_pac_p,
	nr_atendimento_w,
	nm_paciente_w,
	nextval('sus_retorno_laudo_aih_ws_seq'));

else

	update sus_retorno_laudo_aih_ws
	set cd_laudo_internacao = cd_laudo_internacao_p,
	ds_mensagem_retorno = ds_mensagem_retorno_p,
	nm_paciente = nm_paciente_w,
	nr_atendimento = nr_atendimento_w,
	dt_atualizacao = clock_timestamp(),
	nm_usuario = nm_usuario_p
	where nr_seq_laudo_pac = nr_seq_laudo_pac_p;

end if;

update sus_laudo_paciente
set cd_laudo_intern_ws = cd_laudo_internacao_p,
tp_situacao = coalesce(tp_situacao_p, tp_situacao),
dt_envio_webservice = clock_timestamp()
where nr_seq_interno = nr_seq_laudo_pac_p;

select nr_seq_lote
into STRICT nr_seq_lote_laudo_w
from sus_laudo_paciente
where nr_seq_interno = nr_seq_laudo_pac_p;

commit;

CALL atualizar_lote_laudo_sus(nr_seq_lote_laudo_w, 1, nm_usuario_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_gravar_envio_laudo_aih_ws (cd_laudo_internacao_p text, ds_mensagem_retorno_p text, nm_usuario_p text, nr_seq_laudo_pac_p bigint, tp_situacao_p bigint) FROM PUBLIC;
