-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_paciente_atend_visita ( nr_atendimento_p bigint, cd_pessoa_fisica_p text, nm_usuario_p text, nr_controle_acesso_p INOUT bigint, nr_identidade_p INOUT text, nr_seq_visitante_p INOUT bigint) AS $body$
DECLARE


nr_seq_atend_visita_w	bigint;
cd_pf_funcionario_w	varchar(10);
nr_identidade_w		varchar(15);
nr_telefone_w		varchar(50);
dt_nascimento_w		timestamp;


BEGIN

select	max(nr_sequencia)
into STRICT	nr_seq_atend_visita_w
from	atendimento_visita
where	nr_atendimento	= nr_atendimento_p
and	cd_pessoa_fisica = cd_pessoa_fisica_p;

select	max(nr_identidade),
	max(nr_telefone_celular),
	max(dt_nascimento)
into STRICT	nr_identidade_w,
	nr_telefone_w,
	dt_nascimento_w
from	pessoa_fisica
where	cd_pessoa_fisica = cd_pessoa_fisica_p;

if (coalesce(nr_seq_atend_visita_w,0) = 0) then

	select	max(cd_pessoa_fisica)
	into STRICT	cd_pf_funcionario_w
	from	usuario
	where	nm_usuario = nm_usuario_p;

	select	nextval('atendimento_visita_seq')
	into STRICT	nr_seq_atend_visita_w
	;

	insert into atendimento_visita(nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_entrada,
		ie_status,
		cd_pessoa_fisica,
		cd_funcionario,
		nr_identidade,
		nr_telefone,
		dt_nascimento,
		nr_atendimento,
		ie_paciente)
	values (nr_seq_atend_visita_w,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		'E',
		cd_pessoa_fisica_p,
		cd_pf_funcionario_w,
		nr_identidade_w,
		substr(trim(both nr_telefone_w),1,15),
		dt_nascimento_w,
		nr_atendimento_p,
		'S');
end if;

commit;

select	max(nr_controle_acesso)
into STRICT	nr_controle_acesso_p
from	atendimento_visita
where	nr_sequencia	= nr_seq_atend_visita_w;

nr_seq_visitante_p	:= nr_seq_atend_visita_w;
nr_identidade_p		:= nr_identidade_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_paciente_atend_visita ( nr_atendimento_p bigint, cd_pessoa_fisica_p text, nm_usuario_p text, nr_controle_acesso_p INOUT bigint, nr_identidade_p INOUT text, nr_seq_visitante_p INOUT bigint) FROM PUBLIC;

