-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE nut_liberar_todos_cardapios (nr_atendimento_p bigint, dt_referencia_p timestamp, cd_setor_atendimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w		bigint;

C01 CURSOR FOR
	SELECT	a.nr_sequencia
	FROM	nut_pac_opcao_rec a,
		nut_atend_serv_dia b
	WHERE	a.nr_seq_servico_dia		= b.nr_sequencia
	AND	b.nr_atendimento		= nr_atendimento_p
	and	b.dt_servico between PKG_DATE_UTILS.start_of(dt_referencia_p,'DAY') and PKG_DATE_UTILS.end_of(dt_referencia_p, 'DAY')
  and	b.cd_setor_atendimento 	= cd_setor_atendimento_p
	and	coalesce(a.dt_liberacao::text, '') = '';


BEGIN

open C01;
loop
fetch C01 into	
	nr_sequencia_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
		update 	nut_pac_opcao_rec
		set	dt_liberacao	= clock_timestamp(),
			dt_atualizacao	= clock_timestamp(),
			nm_usuario	= nm_usuario_p
		where	nr_sequencia	= nr_sequencia_w;
	end;
end loop;
close C01;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE nut_liberar_todos_cardapios (nr_atendimento_p bigint, dt_referencia_p timestamp, cd_setor_atendimento_p bigint, nm_usuario_p text) FROM PUBLIC;

