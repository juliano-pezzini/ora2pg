-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE alterar_atend_categoria_conv ( nr_atendimento_p bigint, nr_seq_interno_p bigint, cd_tipo_acomodacao_p bigint, cd_autorizacao_p text, cd_senha_p text, nm_usuario_p text) AS $body$
BEGIN

/* OS 1596754
if (cd_convenio_p <> 0) then
	begin
	update	atend_categoria_convenio
		set	cd_convenio    = cd_convenio_p,
			dt_atualizacao = sysdate,
			nm_usuario     = nm_usuario_p
	where	nr_atendimento = nr_atendimento_p
	and	nr_seq_interno = nr_seq_interno_p;
	end;
end if;
*/
if (cd_tipo_acomodacao_p <> 0) then
	update	atend_categoria_convenio
	set	cd_tipo_acomodacao   = cd_tipo_acomodacao_p,
		dt_atualizacao       = clock_timestamp(),
		nm_usuario           = nm_usuario_p
	where	nr_atendimento       = nr_atendimento_p
	and	nr_seq_interno       = nr_seq_interno_p;
end if;

if (coalesce(cd_autorizacao_p,'X') <> 'X') then
	update	atend_categoria_convenio
	set	nr_doc_convenio   = cd_autorizacao_p,
		dt_atualizacao    = clock_timestamp(),
		nm_usuario        = nm_usuario_p
	where	nr_atendimento    = nr_atendimento_p
	and	nr_seq_interno    = nr_seq_interno_p;
end if;

if (coalesce(cd_senha_p,'X') <> 'X') then
	update	atend_categoria_convenio
	set	cd_senha       = cd_senha_p,
		dt_atualizacao = clock_timestamp(),
		nm_usuario     = nm_usuario_p
	where	nr_atendimento = nr_atendimento_p
	and	nr_seq_interno = nr_seq_interno_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE alterar_atend_categoria_conv ( nr_atendimento_p bigint, nr_seq_interno_p bigint, cd_tipo_acomodacao_p bigint, cd_autorizacao_p text, cd_senha_p text, nm_usuario_p text) FROM PUBLIC;

