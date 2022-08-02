-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_incon_pre_unimed_fed ( nr_seq_mat_imp_p pls_mat_uni_sc_pre_imp.nr_sequencia%type, cd_material_p pls_mat_uni_sc_pre_imp.cd_material%type, ie_inconsistencia_p text, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


ds_inconsistencia_w		pls_mat_uni_sc_pre_incons.ds_inconsistencia%type;


BEGIN
if (ie_inconsistencia_p IS NOT NULL AND ie_inconsistencia_p::text <> '') then
	case	ie_inconsistencia_p
		when '1' then ds_inconsistencia_w := 'O valor do preço importado esta diferente do valor do preço original. Produto: '||to_char(cd_material_p);
		when '2' then ds_inconsistencia_w := 'Não foi encontrado na base o material do preço importado. Produto: '||to_char(cd_material_p);
		else ds_inconsistencia_w := null;
	end case;

	insert into pls_mat_uni_sc_pre_incons(nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_mat_imp,
		ds_inconsistencia)
	values (nextval('pls_mat_uni_sc_pre_incons_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_mat_imp_p,
		ds_inconsistencia_w);

	update	pls_mat_uni_sc_pre_imp
	set	ie_inconsistente = 'S'
	where	nr_sequencia = nr_seq_mat_imp_p;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_incon_pre_unimed_fed ( nr_seq_mat_imp_p pls_mat_uni_sc_pre_imp.nr_sequencia%type, cd_material_p pls_mat_uni_sc_pre_imp.cd_material%type, ie_inconsistencia_p text, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;

