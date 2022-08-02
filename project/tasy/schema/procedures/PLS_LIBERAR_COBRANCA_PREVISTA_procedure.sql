-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_liberar_cobranca_prevista ( nr_seq_guia_p bigint, nr_seq_guia_proc_p bigint, nr_seq_guia_mat_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_guia_w			pls_guia_plano_proc.nr_seq_guia%type;
cd_procedimento_w		pls_guia_plano_proc.cd_procedimento%type;
nr_seq_material_w		pls_guia_plano_mat.nr_seq_material%type;
cd_material_w			varchar(255);
ie_permite_lib_cob_prev_w	varchar(1) := 'N';


BEGIN

if (coalesce(nr_seq_guia_proc_p,0) <> 0) then
	select	nr_seq_guia,
		cd_procedimento
	into STRICT	nr_seq_guia_w,
		cd_procedimento_w
	from	pls_guia_plano_proc
	where	nr_sequencia	= nr_seq_guia_proc_p;

elsif (coalesce(nr_seq_guia_mat_p,0) <> 0) then
	select	nr_seq_guia,
		substr(pls_obter_seq_codigo_material(nr_seq_material,''),1,255),
		nr_seq_material
	into STRICT	nr_seq_guia_w,
		cd_material_w,
		nr_seq_material_w
	from	pls_guia_plano_mat
	where	nr_sequencia	= nr_seq_guia_mat_p;
end if;

ie_permite_lib_cob_prev_w	:= pls_obter_se_proc_mat_cob_prev(nr_seq_guia_p, null, null, null, null, null);

if (ie_permite_lib_cob_prev_w	= 'S') then

	if (coalesce(nr_seq_guia_p,0) <> 0) then
		update	pls_guia_plano
		set	ie_cobranca_prevista	= 'S',
			dt_atualizacao	= clock_timestamp(),
			nm_usuario	= nm_usuario_p
		where	nr_sequencia	= nr_seq_guia_p;

		CALL pls_guia_gravar_historico( 	nr_seq_guia_p, 7, 'O usuário ' || nm_usuario_p || ' liberou a guia com cobrança prevista',
						null, nm_usuario_p);

	elsif (coalesce(nr_seq_guia_proc_p,0) <> 0) then

		update	pls_guia_plano_proc
		set	ie_cobranca_prevista	= 'S',
			dt_atualizacao	= clock_timestamp(),
			nm_usuario	= nm_usuario_p
		where	nr_sequencia	= nr_seq_guia_proc_p;

		CALL pls_guia_gravar_historico( 	nr_seq_guia_w, 7, 'O usuário ' || nm_usuario_p || ' liberou o procedimento ' || cd_procedimento_w || ' com cobrança prevista',
						null, nm_usuario_p);

	elsif (coalesce(nr_seq_guia_mat_p,0) <> 0) then

		update	pls_guia_plano_mat
		set	ie_cobranca_prevista	= 'S',
			dt_atualizacao		= clock_timestamp(),
			nm_usuario		= nm_usuario_p
		where	nr_sequencia		= nr_seq_guia_mat_p;

		CALL pls_guia_gravar_historico( 	nr_seq_guia_w, 7, 'O usuário ' || nm_usuario_p || ' liberou o material ' || coalesce(cd_material_w,nr_seq_material_w) || ' com cobrança prevista',
						null, nm_usuario_p);
	end if;

elsif (ie_permite_lib_cob_prev_w = 'N') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(334509);
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_liberar_cobranca_prevista ( nr_seq_guia_p bigint, nr_seq_guia_proc_p bigint, nr_seq_guia_mat_p bigint, nm_usuario_p text) FROM PUBLIC;

