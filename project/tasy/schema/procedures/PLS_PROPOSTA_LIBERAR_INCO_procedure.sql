-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_proposta_liberar_inco ( nr_seq_validacao_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_inconsistencia_w		bigint;
qt_registros_w			bigint;
qt_permitir_liberar_w		bigint;
cd_perfil_w			bigint;
nr_seq_proposta_w		bigint;
qt_inconsistencia_w		bigint;
qt_inconsistencia_doc_w		bigint;
dt_liberacao_w			timestamp;


BEGIN

cd_perfil_w	:= Obter_Perfil_Ativo;

select	nr_seq_inconsistencia,
	nr_seq_proposta,
	dt_liberacao
into STRICT	nr_seq_inconsistencia_w,
	nr_seq_proposta_w,
	dt_liberacao_w
from	pls_proposta_validacao
where	nr_sequencia	= nr_seq_validacao_p;

if (nr_seq_inconsistencia_w IS NOT NULL AND nr_seq_inconsistencia_w::text <> '') then
	select	count(*)
	into STRICT	qt_registros_w
	from	pls_proposta_lib_inconsist
	where	nr_seq_inconsistencia	= nr_seq_inconsistencia_w;

	if (qt_registros_w > 0) then
		select	count(*)
		into STRICT	qt_permitir_liberar_w
		from	pls_proposta_lib_inconsist
		where	nr_seq_inconsistencia	= nr_seq_inconsistencia_w
		and	((cd_perfil		= cd_perfil_w and (cd_perfil IS NOT NULL AND cd_perfil::text <> '')) or (coalesce(cd_perfil::text, '') = ''))
		and	((upper(nm_usuario_lib)	= upper(nm_usuario_p) and (nm_usuario_lib IS NOT NULL AND nm_usuario_lib::text <> '')) or (coalesce(nm_usuario_lib::text, '') = ''));

		if (qt_permitir_liberar_w = 0) then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(262402);
			/* Mensagem: Você não tem permissão para liberar essa inconsistência! Favor verificar as regras de liberação/recusa da inconsistência selecionada. */

		end if;
	end if;
end if;

if (coalesce(dt_liberacao_w::text, '') = '') then
	update	pls_proposta_validacao
	set	dt_liberacao	= clock_timestamp(),
		nm_usuario	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp(),
		ie_consistido	= 'L'
	where	nr_sequencia	= nr_seq_validacao_p;

	insert into pls_proposta_check_list(
		nr_sequencia, nr_seq_validacao, dt_check_list,
		ds_check_list, ie_acao, dt_atualizacao,
		nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec)
	values (	nextval('pls_proposta_check_list_seq'), nr_seq_validacao_p, clock_timestamp(),
		'Inconsistência liberada pelo usuário: ' || nm_usuario_p, 'L', clock_timestamp(),
		nm_usuario_p, clock_timestamp(), nm_usuario_p);

	select	count(*)
	into STRICT	qt_inconsistencia_w
	from	pls_proposta_validacao
	where	nr_seq_proposta	= nr_seq_proposta_w
	and	coalesce(dt_liberacao::text, '') = '';

	select	count(1)
	into STRICT	qt_inconsistencia_doc_w
	from	pls_proposta_inconsist_doc
	where	nr_seq_proposta = nr_seq_proposta_w
	and	coalesce(dt_liberacao::text, '') = '';

	if (qt_inconsistencia_w > 0) or (qt_inconsistencia_doc_w > 0) then
		update	pls_proposta_adesao
		set	ie_inconsistencia = 'S'
		where	nr_sequencia = nr_seq_proposta_w;
	else
		update	pls_proposta_adesao
		set	ie_inconsistencia = 'N'
		where	nr_sequencia = nr_seq_proposta_w;
	end if;

	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_proposta_liberar_inco ( nr_seq_validacao_p bigint, nm_usuario_p text) FROM PUBLIC;

