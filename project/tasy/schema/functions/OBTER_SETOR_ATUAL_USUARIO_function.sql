-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_setor_atual_usuario ( nm_usuario_p text, nm_tabela_p text, dt_inicial_p timestamp, dt_final_p timestamp) RETURNS varchar AS $body$
DECLARE


nr_seq_log_alteracao_w	bigint;
cd_setor_atend_atual_w	varchar(4000);

C01 CURSOR FOR
	SELECT	max(a.nr_sequencia)
	from	tasy_log_alteracao a,
			tasy_log_alt_campo b
	where	a.nr_sequencia	= b.nr_seq_log_alteracao
	and		a.dt_atualizacao between dt_inicial_p and dt_final_p
	and		a.nm_usuario 	= nm_usuario_p
	and		b.nm_atributo	= 'CD_SETOR_ATENDIMENTO'
	and		a.nm_tabela 	= upper(nm_tabela_p)
	order by 1 desc;


BEGIN

if (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') and (nm_tabela_p IS NOT NULL AND nm_tabela_p::text <> '')then
	begin

	open C01;
	loop
	fetch C01 into
		nr_seq_log_alteracao_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		if (nr_seq_log_alteracao_w IS NOT NULL AND nr_seq_log_alteracao_w::text <> '')then
			begin

			select	max(a.ds_valor_new)
			into STRICT	cd_setor_atend_atual_w
			from	tasy_log_alt_campo a
			where	a.nr_seq_log_alteracao 	= nr_seq_log_alteracao_w;

			end;
		else

			begin

			select	max(a.cd_setor_atendimento)
			into STRICT	cd_setor_atend_atual_w
			from	usuario a
			where	a.nm_usuario = nm_usuario_p;

			end;

		end if;

		end;
	end loop;
	close C01;

	end;

end if;

return	cd_setor_atend_atual_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_setor_atual_usuario ( nm_usuario_p text, nm_tabela_p text, dt_inicial_p timestamp, dt_final_p timestamp) FROM PUBLIC;

