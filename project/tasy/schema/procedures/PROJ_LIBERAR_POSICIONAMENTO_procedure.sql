-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE proj_liberar_posicionamento ( nr_sequencia_p bigint, ie_acao_p text, nm_usuario_p text, nr_seq_proj_p bigint ) AS $body$
DECLARE


dt_posicao_w	timestamp;


BEGIN

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
	begin
	select	trunc(dt_posicao)
	into STRICT	dt_posicao_w
	from	proj_posicao_coordenacao
	where	nr_sequencia = nr_sequencia_p;

	if (ie_acao_p = 'LD') then

		update	proj_posicao_coordenacao
		set	dt_liberacao  = clock_timestamp(),
			nm_usuario    = nm_usuario_p
		where	trunc(dt_posicao) = trunc(dt_posicao_w)
		and	nr_seq_proj = nr_seq_proj_p;
	end if;

	if (ie_acao_p = 'L') then
		update	proj_posicao_coordenacao
		set	dt_liberacao  = clock_timestamp(),
			nm_usuario    = nm_usuario_p
		where	nr_sequencia  = nr_sequencia_p;
	end if;

	if (ie_acao_p = 'D') then
		update	proj_posicao_coordenacao
		set	dt_liberacao   = NULL,
			nm_usuario    = nm_usuario_p
		where	nr_sequencia  = nr_sequencia_p;
	end if;
	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE proj_liberar_posicionamento ( nr_sequencia_p bigint, ie_acao_p text, nm_usuario_p text, nr_seq_proj_p bigint ) FROM PUBLIC;

