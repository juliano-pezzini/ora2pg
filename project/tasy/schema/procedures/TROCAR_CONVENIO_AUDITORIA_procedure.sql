-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE trocar_convenio_auditoria ( cd_convenio_p bigint, cd_categoria_p text, ie_tipo_auditoria_p text, nr_seq_motivo_p bigint, ie_tipo_item_p text, nr_sequencia_p bigint, nm_usuario_p text, ds_erro_p INOUT text) AS $body$
DECLARE


ds_erro_w			varchar(2000);
cd_estabelecimento_w		estabelecimento.cd_estabelecimento%type := wheb_usuario_pck.get_cd_estabelecimento;
ie_altera_item_repasse_w	varchar(1) := 'S';

BEGIN

begin
ie_altera_item_repasse_w := obter_param_usuario(1116, 189, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_altera_item_repasse_w);
exception
when others then
	ie_altera_item_repasse_w := 'S';
end;

if (cd_convenio_p IS NOT NULL AND cd_convenio_p::text <> '') and (cd_categoria_p IS NOT NULL AND cd_categoria_p::text <> '') then

	if (ie_tipo_item_p = 'P') then

		begin
		update	auditoria_propaci a
		set	a.cd_convenio_ajuste		= cd_convenio_p,
			a.cd_categoria_ajuste		= cd_categoria_p,
			a.ie_tipo_auditoria		= ie_tipo_auditoria_p,
			a.nr_seq_motivo			= nr_seq_motivo_p,
			a.dt_atualizacao		= clock_timestamp(),
			a.nm_usuario			= nm_usuario_p
		where	a.nr_sequencia			= nr_sequencia_p
		and	not exists (	SELECT	1
					from	procedimento_repasse x
					where	x.nr_seq_procedimento = a.nr_seq_propaci
					and	coalesce(ie_altera_item_repasse_w,'S') = 'N');
		exception
		when others then
			ds_erro_w	:= sqlerrm;
		end;

	elsif (ie_tipo_item_p = 'M') then

		begin
		update	auditoria_matpaci a
		set	a.cd_convenio_ajuste		= cd_convenio_p,
			a.cd_categoria_ajuste		= cd_categoria_p,
			a.ie_tipo_auditoria		= ie_tipo_auditoria_p,
			a.nr_seq_motivo			= nr_seq_motivo_p,
			a.dt_atualizacao		= clock_timestamp(),
			a.nm_usuario			= nm_usuario_p
		where	a.nr_sequencia			= nr_sequencia_p
		and	not exists (	SELECT	1
					from	material_repasse x
					where	x.nr_seq_material = a.nr_seq_matpaci
					and	coalesce(ie_altera_item_repasse_w,'S') = 'N');
		exception
		when others then
			ds_erro_w	:= sqlerrm;
		end;

	end if;

end if;

ds_erro_p	:= ds_erro_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE trocar_convenio_auditoria ( cd_convenio_p bigint, cd_categoria_p text, ie_tipo_auditoria_p text, nr_seq_motivo_p bigint, ie_tipo_item_p text, nr_sequencia_p bigint, nm_usuario_p text, ds_erro_p INOUT text) FROM PUBLIC;
