-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gravar_panorama_icone_click (cd_icone_p bigint, cd_perfil_p bigint, nr_atendimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

nr_seq_regra_w		bigint;
ie_remove_icone_w	varchar(1);


BEGIN

select	max(a.nr_sequencia)
into STRICT 	nr_seq_regra_w
from	regra_perm_panorama a
where	a.cd_perfil = cd_perfil_p
and exists (	SELECT	1
		from	regra_panorama_icone_click x
		where	x.nr_seq_regra = a.nr_sequencia);

if (coalesce(nr_seq_regra_w::text, '') = '') then -- se não encontrou a regra para o perfil, busca uma regra sem perfil definido.
	select	max(a.nr_sequencia)
	into STRICT 	nr_seq_regra_w
	from	regra_perm_panorama a
	where	coalesce(a.cd_perfil::text, '') = ''
	and exists (	SELECT	1
			from	regra_panorama_icone_click x
			where	x.nr_seq_regra = a.nr_sequencia);
end if;

if (nr_seq_regra_w IS NOT NULL AND nr_seq_regra_w::text <> '') then
	select	CASE WHEN count(*)=0 THEN  'N'  ELSE 'S' END
	into STRICT	ie_remove_icone_w
	from	regra_panorama_icone_click
	where	nr_seq_regra = nr_seq_regra_w
	and	cd_icone_panorama = cd_icone_p;
end if;

if (ie_remove_icone_w = 'S') then
	insert into panorama_icone_click(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_atendimento,
		cd_icone_panorama
	) values (
		nextval('panorama_icone_click_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_atendimento_p,
		cd_icone_p
	);
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gravar_panorama_icone_click (cd_icone_p bigint, cd_perfil_p bigint, nr_atendimento_p bigint, nm_usuario_p text) FROM PUBLIC;

