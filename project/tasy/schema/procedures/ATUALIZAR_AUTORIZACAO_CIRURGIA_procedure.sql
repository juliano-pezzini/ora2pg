-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_autorizacao_cirurgia (nr_seq_autor_conv_p bigint, nr_seq_estagio_p bigint, nr_seq_autor_cirurgia_p bigint, cd_convenio_p bigint, ie_tipo_autorizacao_p text, cd_estabelecimento_p bigint, nm_usuario_p text, ie_commit_p text) AS $body$
DECLARE


ie_estagio_ame_w		autorizacao_cirurgia.ie_estagio_autor%type;
nr_seq_autor_cirurgia_w		autorizacao_cirurgia.nr_sequencia%type;
ie_estagio_novo_ame_w		regra_estagio_aut_mat_esp.ie_estagio_novo_ame%type;
qt_regra_w			bigint;


C01 CURSOR FOR
	SELECT	a.ie_estagio_novo_ame
	from	regra_estagio_aut_mat_esp a
	where	a.nr_seq_estagio_ac = nr_seq_estagio_p
	and	a.cd_estabelecimento = cd_estabelecimento_p
	and	coalesce(a.ie_situacao,'A') = 'A'
	and	coalesce(a.cd_convenio,cd_convenio_p) 	= cd_convenio_p
	AND	((coalesce(a.ie_tipo_autorizacao,ie_tipo_autorizacao_p) = ie_tipo_autorizacao_p) OR (coalesce(ie_tipo_autorizacao_p,'X') = 'X'))
	and	((coalesce(a.ie_estagio_ame,ie_estagio_ame_w)	= ie_estagio_ame_w) OR (coalesce(ie_estagio_ame_w,0) = 0))
	order by coalesce(a.cd_convenio,0),
		 coalesce(a.ie_tipo_autorizacao,0);



BEGIN

select	count(*)
into STRICT	qt_regra_w
from	regra_estagio_aut_mat_esp
where	cd_estabelecimento = cd_estabelecimento_p
and	coalesce(ie_situacao,'A') = 	'A';

if (qt_regra_w > 0) then

	if (nr_seq_autor_cirurgia_p IS NOT NULL AND nr_seq_autor_cirurgia_p::text <> '') then

		select	max(a.ie_estagio_autor),
			max(nr_seq_autor_cirurgia_p)
		into STRICT	ie_estagio_ame_w,
			nr_seq_autor_cirurgia_w
		from	autorizacao_cirurgia a
		where	a.nr_sequencia = nr_seq_autor_cirurgia_p;
	else

		select	max(a.ie_estagio_autor),
			max(a.nr_sequencia)
		into STRICT	ie_estagio_ame_w,
			nr_seq_autor_cirurgia_w
		from	autorizacao_cirurgia a
		where	nr_seq_autor_conv = nr_seq_autor_conv_p;

	end if;

	open C01;
	loop
	fetch C01 into
		ie_estagio_novo_ame_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		ie_estagio_novo_ame_w := ie_estagio_novo_ame_w;

		end;
	end loop;
	close C01;

	if (ie_estagio_novo_ame_w IS NOT NULL AND ie_estagio_novo_ame_w::text <> '') and (nr_seq_autor_cirurgia_w IS NOT NULL AND nr_seq_autor_cirurgia_w::text <> '') then
		update	autorizacao_cirurgia
		set	ie_estagio_autor 	= ie_estagio_novo_ame_w,
			nm_usuario	 	= nm_usuario_p,
			dt_atualizacao  	= clock_timestamp(),
			dt_autorizacao	 	= CASE WHEN ie_estagio_novo_ame_w=3 THEN clock_timestamp() WHEN ie_estagio_novo_ame_w=2 THEN null END ,
			nm_usuario_autorizacao	= CASE WHEN ie_estagio_novo_ame_w=3 THEN nm_usuario_p WHEN ie_estagio_novo_ame_w=2 THEN null END
		where	nr_sequencia		= nr_seq_autor_cirurgia_w
		and	ie_estagio_autor	<> ie_estagio_novo_ame_w;
	end if;



if (ie_commit_p = 'S') then
	if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;
end if;

end if;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_autorizacao_cirurgia (nr_seq_autor_conv_p bigint, nr_seq_estagio_p bigint, nr_seq_autor_cirurgia_p bigint, cd_convenio_p bigint, ie_tipo_autorizacao_p text, cd_estabelecimento_p bigint, nm_usuario_p text, ie_commit_p text) FROM PUBLIC;
