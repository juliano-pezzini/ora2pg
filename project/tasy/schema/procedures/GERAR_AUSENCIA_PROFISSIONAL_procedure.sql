-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_ausencia_profissional ( cd_pessoa_fisica_p text, dt_inicio_p timestamp, dt_fim_p timestamp, nr_seq_motivo_p text, ds_mensagem_p text, nm_usuario_p text) AS $body$
DECLARE


nm_usuario_ausente_w		varchar(15);
nr_seq_ausencia_w			bigint;


BEGIN

select	max(nm_usuario)
into STRICT	nm_usuario_ausente_w
from	usuario
where	cd_pessoa_fisica = cd_pessoa_fisica_p;

if (coalesce(nm_usuario_ausente_w,'X') <> 'X') then
	begin
	select	nextval('ausencia_tasy_seq')
	into STRICT	nr_seq_ausencia_w
	;

	insert into ausencia_tasy(
			nr_sequencia,
			cd_motivo_ausencia,
			nm_usuario_ausente,
			dt_inicio,
			dt_fim,
			ds_mensagem,
			dt_atualizacao,
			nm_usuario)
		values (nr_seq_ausencia_w,
			nr_seq_motivo_p,
			nm_usuario_ausente_w,
			dt_inicio_p,
			dt_fim_p,
			ds_mensagem_p,
			clock_timestamp(),
			nm_usuario_p);
	end;
else
	CALL wheb_mensagem_pck.exibir_mensagem_abort(263186); --Pessoa não possui usuário informado para registro da ausência.
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_ausencia_profissional ( cd_pessoa_fisica_p text, dt_inicio_p timestamp, dt_fim_p timestamp, nr_seq_motivo_p text, ds_mensagem_p text, nm_usuario_p text) FROM PUBLIC;

