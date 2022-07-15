-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_log_inf_sensivel ( nr_seq_log_acesso_p bigint, ie_liberar_tipo_p text, ds_motivo_p text, nr_ordem_servico_p bigint) AS $body$
DECLARE


ds_motivo_w		varchar(255);



BEGIN


/*
ie_liberar_tipo_p

A - Sem alteração
N - Normal

*/
ds_motivo_w		:= ds_motivo_p;

-- Gravar log
update  log_inf_sensivel_os
set		dt_liberacao 			= clock_timestamp(),
		nm_usuario_liberacao	= wheb_usuario_pck.get_nm_usuario
where	nr_sequencia			= nr_seq_log_acesso_p;


if (ie_liberar_tipo_p = 'A') then
	begin

	insert into 	man_ordem_serv_tecnico(nr_sequencia,
						nr_seq_ordem_serv,
						dt_atualizacao,
						dt_historico,
						dt_liberacao,
						nm_usuario,
						nr_seq_tipo,
						ie_origem,
						ds_relat_tecnico)
				values (nextval('man_ordem_serv_tecnico_seq'),
						nr_ordem_servico_p,
						clock_timestamp(),
						clock_timestamp(),
						clock_timestamp(),
						wheb_usuario_pck.get_nm_usuario,
						7,
						'I',
						 obter_desc_exp_idioma(916291,5,'DS_MOTIVO=' || ds_motivo_w));


	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_log_inf_sensivel ( nr_seq_log_acesso_p bigint, ie_liberar_tipo_p text, ds_motivo_p text, nr_ordem_servico_p bigint) FROM PUBLIC;

