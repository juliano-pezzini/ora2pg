-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_compl_pf_setor ( nm_usuario_p text, nr_seq_empresa_ref_setor_p bigint, nr_seq_compl_pessoa_fisica_p bigint, cd_pessoa_fisica_p text) AS $body$
DECLARE


nr_seq_empresa_ref_setor_w		compl_pessoa_fisica_setor.nr_seq_empresa_ref_setor%type;
						

BEGIN

	select	max(coalesce(nr_seq_empresa_ref_setor,0))
	into STRICT	nr_seq_empresa_ref_setor_w
	from	compl_pessoa_fisica_setor
	where	nr_seq_compl_pessoa_fisica = nr_seq_compl_pessoa_fisica_p
	and		cd_pessoa_fisica = cd_pessoa_fisica_p;

	if (nr_seq_empresa_ref_setor_w > 0) then
		begin
			update compl_pessoa_fisica_setor
			set		nr_seq_empresa_ref_setor = nr_seq_empresa_ref_setor_p,
					dt_atualizacao = clock_timestamp(),
					nm_usuario = nm_usuario_p
			where	nr_seq_compl_pessoa_fisica = nr_seq_compl_pessoa_fisica_p
			and		cd_pessoa_fisica = cd_pessoa_fisica_p;
		end;
	else
		begin
			insert into compl_pessoa_fisica_setor(
					nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					nr_seq_empresa_ref_setor,
					nr_seq_compl_pessoa_fisica,
					cd_pessoa_fisica)
			values (nextval('compl_pessoa_fisica_setor_seq'),
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					nr_seq_empresa_ref_setor_p,
					nr_seq_compl_pessoa_fisica_p,
					cd_pessoa_fisica_p);
		end;
	end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_compl_pf_setor ( nm_usuario_p text, nr_seq_empresa_ref_setor_p bigint, nr_seq_compl_pessoa_fisica_p bigint, cd_pessoa_fisica_p text) FROM PUBLIC;

