-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE reverter_processo_horario ( nr_seq_horario_p bigint, nr_seq_processo_p bigint, nm_usuario_p text) AS $body$
DECLARE


ie_outros_horarios_w	varchar(1);
nr_seq_processo_w	bigint;
ie_status_anterior_w	varchar(10);
ie_status_Atual_w		varchar(10);


BEGIN
if (nr_seq_horario_p IS NOT NULL AND nr_seq_horario_p::text <> '') and (nr_seq_processo_p IS NOT NULL AND nr_seq_processo_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin

	select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ie_outros_horarios_w
	from	prescr_mat_hor
	where	nr_seq_processo	= nr_seq_processo_p
	and		nr_sequencia	<> nr_seq_horario_p
	and		coalesce(nr_seq_superior::text, '') = ''
	and		Obter_se_horario_liberado(dt_lib_horario, dt_horario) = 'S'
	and		coalesce(dt_suspensao::text, '') = '';

	if (ie_outros_horarios_w = 'N') then
		begin
		ie_status_anterior_w := Obter_status_ant_processo(nr_seq_processo_p);
		ie_status_Atual_w	:= obter_status_processo(nr_seq_processo_p);
		nr_seq_processo_w := nr_seq_processo_p;
		end;
	else
		begin
		nr_seq_processo_w := adep_desdobrar_processo(nr_seq_processo_p, nr_seq_horario_p, null, nm_usuario_p, nr_seq_processo_w);
		ie_status_anterior_w := Obter_status_ant_processo(nr_seq_processo_w);
		end;
	end if;

	if (ie_status_anterior_w = 'R') then
		update	adep_processo
		Set	dt_paciente  = NULL,
			nm_usuario_paciente  = NULL
		where	nr_sequencia	= nr_seq_processo_w;
	elsif (ie_status_anterior_w = 'L') then
		update	adep_processo
		Set	dt_paciente  = NULL,
			nm_usuario_paciente  = NULL,
			dt_retirada  = NULL,
			nm_usuario_retirada  = NULL
		where	nr_sequencia	= nr_seq_processo_w;
	elsif (ie_status_anterior_w = 'P') or (ie_status_Atual_w = 'P') then
		update	adep_processo
		Set	dt_paciente  = NULL,
			nm_usuario_paciente  = NULL,
			dt_retirada  = NULL,
			nm_usuario_retirada  = NULL,
			dt_leitura  = NULL,
			nm_usuario_leitura  = NULL
		where	nr_sequencia	= nr_seq_processo_w;
	elsif (ie_status_anterior_w = 'H') then
		update	adep_processo
		Set	dt_paciente  = NULL,
			nm_usuario_paciente  = NULL,
			dt_retirada  = NULL,
			nm_usuario_retirada  = NULL,
			dt_leitura  = NULL,
			nm_usuario_leitura  = NULL,
			dt_preparo  = NULL,
			nm_usuario_preparo  = NULL
		where	nr_sequencia	= nr_seq_processo_w;
	elsif (ie_status_anterior_w = 'D') then
		update	adep_processo
		Set	dt_paciente  = NULL,
			nm_usuario_paciente  = NULL,
			dt_retirada  = NULL,
			nm_usuario_retirada  = NULL,
			dt_leitura  = NULL,
			nm_usuario_leitura  = NULL,
			dt_preparo  = NULL,
			nm_usuario_preparo  = NULL,
			dt_higienizacao  = NULL,
			nm_usuario_higienizacao  = NULL
		where	nr_sequencia	= nr_seq_processo_w;
	elsif (ie_status_anterior_w = 'G') then
		update	adep_processo
		Set	dt_paciente  = NULL,
			nm_usuario_paciente  = NULL,
			dt_retirada  = NULL,
			nm_usuario_retirada  = NULL,
			dt_leitura  = NULL,
			nm_usuario_leitura  = NULL,
			dt_preparo  = NULL,
			nm_usuario_preparo  = NULL,
			dt_higienizacao  = NULL,
			nm_usuario_higienizacao  = NULL,
			dt_dispensacao  = NULL,
			nm_usuario_dispensacao  = NULL
		where	nr_sequencia	= nr_seq_processo_w;
	end if;

	update	adep_processo
	set	nm_usuario = nm_usuario_p,
		dt_atualizacao = clock_timestamp(),
		ie_status_processo	= ie_status_anterior_w
	where	nr_sequencia	= nr_seq_processo_w;
	end;

end if;
if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE reverter_processo_horario ( nr_seq_horario_p bigint, nr_seq_processo_p bigint, nm_usuario_p text) FROM PUBLIC;
