-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_reg_import_base ( ie_origem_import_p text, nm_usuario_p text) AS $body$
DECLARE


C01 CURSOR FOR
	SELECT	*
	from	cadastro_medico
	where	ie_origem_import = ie_origem_import_p
	order by 1;

c01_w				c01%rowtype;
qt_registros_w			bigint;
ie_situacao_w			varchar(2);
ds_situacao_base_w		varchar(50);
cd_medico_w			varchar(10);
ie_situacao_base_w		varchar(15);
qt_registros_atualizados_w	bigint := 0;


BEGIN

if (coalesce(nm_usuario_p,'0') <> '0') and (coalesce(ie_origem_import_p,'0') <> '0') then
	open C01;
	loop
	fetch C01 into
		c01_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		select	count(cd_pessoa_fisica)
		into STRICT	qt_registros_w
		from	medico
		where	nr_crm = c01_w.nr_crm
		and	uf_crm = c01_w.uf_crm;

		if (qt_registros_w > 0) then
			select	ie_situacao,
				cd_pessoa_fisica
			into STRICT	ie_situacao_w,
				cd_medico_w
			from	medico
			where	cd_pessoa_fisica = 	(
							SELECT	max(cd_pessoa_fisica)
							from	medico
							where	nr_crm = c01_w.nr_crm
							and	uf_crm = c01_w.uf_crm
							);

			if (coalesce(ie_situacao_w,'A') = 'A') then
				ds_situacao_base_w := wheb_mensagem_pck.get_texto(306302); --'Ativo - (Existente na base)';
				ie_situacao_base_w := 'A';
			elsif (coalesce(ie_situacao_w,'A') = 'I') then
				ds_situacao_base_w := wheb_mensagem_pck.get_texto(306303); --'Inativo - (Existente na base)';
				ie_situacao_base_w := 'I';
			end if;
		else
			ds_situacao_base_w := wheb_mensagem_pck.get_texto(306304); --'Não existente na base';
			ie_situacao_base_w := 'N';
			cd_medico_w := '';
		end if;

		update	cadastro_medico
		set	ie_situacao_reg_base = ie_situacao_base_w,
			ds_situacao_reg_base = ds_situacao_base_w,
			cd_pessoa_fisica = cd_medico_w,
			nm_usuario = nm_usuario_p,
			dt_atualizacao = clock_timestamp()
		where	ie_origem_import = ie_origem_import_p
		and	nr_crm = c01_w.nr_crm
		and	uf_crm = c01_w.uf_crm;
		end;

		qt_registros_atualizados_w := qt_registros_atualizados_w + 1;
		if (qt_registros_atualizados_w = 100) then
			commit;
			qt_registros_atualizados_w := 0;
		end if;

	end loop;
	close C01;

	commit;

	select	count(nr_sequencia)
	into STRICT	qt_registros_w
	from	cadastro_medico
	where	ie_origem_import = ie_origem_import_p
	and	coalesce(ds_situacao_reg_base::text, '') = '';

	if (qt_registros_w > 0) then
		qt_registros_atualizados_w := 0;
		open C01;
		loop
		fetch C01 into
			c01_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			begin
			if (coalesce(c01_w.ds_situacao_reg_base,'X') = 'X') then
				update	cadastro_medico
				set	ie_situacao_reg_base = 'D',
					ds_situacao_reg_base = wheb_mensagem_pck.get_texto(306305), --'Dados insuficientes para realizar a verificação',
					nm_usuario = nm_usuario_p,
					dt_atualizacao = clock_timestamp()
				where	ie_origem_import = ie_origem_import_p
				and	nr_sequencia = c01_w.nr_sequencia;

			qt_registros_atualizados_w := qt_registros_atualizados_w + 1;
			if (qt_registros_atualizados_w = 100) then
				commit;
				qt_registros_atualizados_w := 0;
			end if;
			end if;

			end;
		end loop;
		close C01;
	end if;

	commit;
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_reg_import_base ( ie_origem_import_p text, nm_usuario_p text) FROM PUBLIC;

