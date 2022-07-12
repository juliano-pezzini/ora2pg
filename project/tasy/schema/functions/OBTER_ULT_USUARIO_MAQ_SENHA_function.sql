-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ult_usuario_maq_senha (nr_seq_local_senha_p bigint) RETURNS varchar AS $body$
DECLARE


nm_usuario_logado_w	varchar(15);
nm_usuario_w		varchar(15);
nm_usuario_log_maq_w	varchar(15);
nm_computador_w		varchar(40);
qt_usuario_maq_w	bigint;
nr_seq_log_acesso_w	bigint;
ie_verificar_log_w	varchar(1);


BEGIN


if (coalesce(nr_seq_local_senha_p,0) > 0) then
	ie_verificar_log_w := obter_param_usuario(0, 29, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, ie_verificar_log_w);

	select	a.nm_usuario
	into STRICT	nm_usuario_w
	from	paciente_senha_fila a
	where	a.nr_seq_local_senha = nr_seq_local_senha_p
	and	a.dt_inicio_atendimento = (	SELECT	max(b.dt_inicio_atendimento)
						from 	paciente_senha_fila b
						where	b.nr_seq_local_senha = nr_seq_local_senha_p
						and	trunc(b.dt_inicio_atendimento) = trunc(clock_timestamp()));

	select	substr(b.nm_computador,1,40)
	into STRICT	nm_computador_w
	from 	maquina_local_senha a,
		computador b
	where	a.nr_seq_computador = b.nr_sequencia
	and	a.nr_sequencia = nr_seq_local_senha_p
	and	coalesce(a.ie_situacao, 'A') = 'A';

	select	count(*)
	into STRICT	qt_usuario_maq_w
	from	usuario_conectado_v a
	where	upper(a.terminal) = upper(nm_computador_w)
	and	upper(a.program) = upper('Tasy.exe');

	if (coalesce(qt_usuario_maq_w,0) > 0) then
		if (ie_verificar_log_w = 'S') then

			select	max(nr_sequencia)
			into STRICT	nr_seq_log_acesso_w
			from	tasy_log_acesso
			where	upper(ds_maquina) = upper(nm_computador_w);

			select	max(nm_usuario)
			into STRICT	nm_usuario_log_maq_w
			from	tasy_log_acesso
			where	nr_sequencia = nr_seq_log_acesso_w;

			if (upper(nm_usuario_w) = upper(nm_usuario_log_maq_w)) then
				nm_usuario_logado_w := nm_usuario_w;
			else
				nm_usuario_logado_w:= null;
			end if;
		else
			nm_usuario_logado_w := nm_usuario_w;
		end if;
	else
		nm_usuario_logado_w:= null;
	end if;

end if;

return	nm_usuario_logado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ult_usuario_maq_senha (nr_seq_local_senha_p bigint) FROM PUBLIC;

