-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_comp_kit_modif_html ( nr_atendimento_p bigint, nr_seq_recomendacao_p bigint default null, cd_recomendacao_p bigint DEFAULT NULL, cd_kit_p bigint DEFAULT NULL, cd_pessoa_fisica_p bigint DEFAULT NULL, nm_usuario_p text DEFAULT NULL) AS $body$
DECLARE


ie_gera_w		varchar(1);
nr_seq_recomendacao_w	bigint;


BEGIN

select	coalesce(max('N'),'S')
into STRICT	ie_gera_w
from	w_kit_modificado
where	((nr_atendimento = nr_atendimento_p) or (coalesce(nr_atendimento,0) = 0))
and	((nr_seq_recomendacao = nr_seq_recomendacao_p) or (coalesce(nr_seq_recomendacao,0) = 0))
and	cd_recomendacao = cd_recomendacao_p
and	cd_kit = cd_kit_p
and	cd_pessoa_fisica = cd_pessoa_fisica_p
and	nm_usuario = nm_usuario_p;

if (ie_gera_w = 'S') then
	insert into w_kit_modificado(	nr_sequencia,
						cd_kit,
						nr_atendimento,
						nr_seq_recomendacao,
						cd_recomendacao,
						cd_material,
						qt_material,
						ie_excluir,
						dt_atualizacao,
						nm_usuario,
						cd_pessoa_fisica)
					(SELECT nextval('w_kit_modificado_seq'),
						cd_kit_material,
						nr_atendimento_p,
						nr_seq_recomendacao_p,
						cd_recomendacao_p,
						cd_material,
						qt_material,
						'N',
						clock_timestamp(),
						nm_usuario_p,
						cd_pessoa_fisica_p
					from   componente_kit
					where  cd_kit_material = cd_kit_p);
else
	select	max(nr_seq_recomendacao_w)
	into STRICT	nr_seq_recomendacao_w
	from	w_kit_modificado
	where	((nr_atendimento = nr_atendimento_p) or (coalesce(nr_atendimento,0) = 0))
	and	nr_seq_recomendacao = nr_seq_recomendacao_p
	and	cd_recomendacao = cd_recomendacao_p
	and	cd_kit = cd_kit_p
	and	cd_pessoa_fisica = cd_pessoa_fisica_p
	and	nm_usuario = nm_usuario_p;

	if (coalesce(nr_seq_recomendacao_w::text, '') = '') then
		update	w_kit_modificado
		set	nr_seq_recomendacao = nr_seq_recomendacao_p
		where	((nr_atendimento = nr_atendimento_p) or (coalesce(nr_atendimento,0) = 0))
		and	coalesce(nr_seq_recomendacao::text, '') = ''
		and	cd_recomendacao = cd_recomendacao_p
		and	cd_kit = cd_kit_p
		and	cd_pessoa_fisica = cd_pessoa_fisica_p
		and	nm_usuario = nm_usuario_p;

		commit;
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_comp_kit_modif_html ( nr_atendimento_p bigint, nr_seq_recomendacao_p bigint default null, cd_recomendacao_p bigint DEFAULT NULL, cd_kit_p bigint DEFAULT NULL, cd_pessoa_fisica_p bigint DEFAULT NULL, nm_usuario_p text DEFAULT NULL) FROM PUBLIC;

