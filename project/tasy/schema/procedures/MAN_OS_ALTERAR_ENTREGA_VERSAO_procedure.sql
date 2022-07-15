-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_os_alterar_entrega_versao ( nr_seq_ordem_serv_p bigint, cd_versao_p text, ie_opcao_p text, nm_usuario_p text) AS $body$
DECLARE


/*	IE_OPCAO_P:

	I - Inclusao
	A - Atualizacao
	E - Exclusao
	N - Nova versao
*/
dt_lib_versao_w			timestamp;
nr_seq_entrega_w		bigint;


BEGIN

if (nr_seq_ordem_serv_p IS NOT NULL AND nr_seq_ordem_serv_p::text <> '') and (ie_opcao_p IS NOT NULL AND ie_opcao_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then

	update	man_ordem_servico
	set	cd_versao_entrega = cd_versao_p,
		dt_atualizacao = clock_timestamp(),
		nm_usuario = nm_usuario_p
	where	nr_sequencia = nr_seq_ordem_serv_p;

	if (ie_opcao_p = 'I') then

		select	max(dt_fim)
		into STRICT	dt_lib_versao_w
		from	escala_diaria
		where	nr_seq_escala = 21
		and	ds_observacao = cd_versao_p;

		if (dt_lib_versao_w IS NOT NULL AND dt_lib_versao_w::text <> '') then

			insert into man_ordem_serv_entrega(
				nr_sequencia,
				dt_atualizacao, 
				nm_usuario, 
				dt_atualizacao_nrec, 
				nm_usuario_nrec, 
				nr_seq_ordem_serv, 
				cd_versao, 
				dt_lib_versao,
				ie_tipo_entrega)
			values (nextval('man_ordem_serv_entrega_seq'),
				clock_timestamp(),
				nm_usuario_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_ordem_serv_p,
				cd_versao_p,
				dt_lib_versao_w,
				'V');

		end if;

	elsif (ie_opcao_p = 'A') then

		select	nr_sequencia
		into STRICT	nr_seq_entrega_w
		from	man_ordem_serv_entrega
		where	nr_seq_ordem_serv = nr_seq_ordem_serv_p
		and	ie_tipo_entrega = 'V';

		select	max(dt_fim)
		into STRICT	dt_lib_versao_w
		from	escala_diaria
		where	nr_seq_escala = 21
		and	ds_observacao = cd_versao_p;

		if (dt_lib_versao_w IS NOT NULL AND dt_lib_versao_w::text <> '') then

			update	man_ordem_serv_entrega
			set	cd_versao = cd_versao_p,
				dt_lib_versao = dt_lib_versao_w,
				dt_atualizacao = clock_timestamp(),
				nm_usuario = nm_usuario_p
			where	nr_sequencia = nr_seq_entrega_w;

		end if;

	elsif (ie_opcao_p = 'E') then

		select	max(nr_sequencia)
		into STRICT	nr_seq_entrega_w
		from	man_ordem_serv_entrega
		where	nr_seq_ordem_serv = nr_seq_ordem_serv_p
		and	ie_tipo_entrega = 'V';

		if (nr_seq_entrega_w IS NOT NULL AND nr_seq_entrega_w::text <> '') then

			delete	FROM man_ordem_serv_entrega
			where	nr_sequencia = nr_seq_entrega_w;

		end if;
	elsif (ie_opcao_p = 'N') then
		begin
			
			select	min(ed.dt_fim)
			into STRICT	dt_lib_versao_w
			from	escala_diaria ed
			where	ed.nr_seq_escala = 21
			and	ed.dt_inicio > clock_timestamp();

			if (dt_lib_versao_w IS NOT NULL AND dt_lib_versao_w::text <> '') then
	
				insert into man_ordem_serv_entrega(
					nr_sequencia,
					dt_atualizacao, 
					nm_usuario, 
					dt_atualizacao_nrec, 
					nm_usuario_nrec, 
					nr_seq_ordem_serv, 
					cd_versao, 
					dt_lib_versao,
					ie_tipo_entrega)
				values (nextval('man_ordem_serv_entrega_seq'),
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					nr_seq_ordem_serv_p,
					cd_versao_p,
					dt_lib_versao_w,
					'V');
			end if;
		end;
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_os_alterar_entrega_versao ( nr_seq_ordem_serv_p bigint, cd_versao_p text, ie_opcao_p text, nm_usuario_p text) FROM PUBLIC;

