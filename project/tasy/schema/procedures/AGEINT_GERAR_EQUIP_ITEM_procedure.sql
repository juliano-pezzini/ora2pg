-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ageint_gerar_equip_item ( nr_seq_proc_interno_p bigint, nr_seq_item_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_classif_equip_w		bigint;
nr_seq_conjunto_w			bigint;
qt_conjunto_w			bigint;
cd_material_w			bigint;
qt_material_w			double precision;
nr_sequencia_w			bigint;
nr_seq_proc_servico_w		bigint;
ie_tipo_orientacao_w		smallint;
qt_equip_class_w			smallint;
cd_equipamento_w			bigint;
ie_obrigatorio_w			varchar(3);
ie_padrao_w			varchar(1);
nr_seq_tipo_caixa_opme_w		bigint;
ie_consiste_w			varchar(15);
ds_erro_w			varchar(255) := '';
ds_erro_equip_w			varchar(255);
ie_consiste_cme_w			varchar(15);
ds_erro_cme_w			varchar(255);
cd_medico_conjunto_w		varchar(10);
cd_equipamento_proc_w		bigint;
nr_seq_classif_equip_ww		bigint;
cd_equipamento_ww		bigint;
cd_cgc_w			varchar(14);
nr_seq_proc_interno_w		bigint;
ie_classif_equip_w			varchar(15);
nr_seq_grupo_w			bigint;
ie_tipagem_sanguinea_w		varchar(1);
qt_servico_w			bigint;
ie_modo_obter_sangue_w		varchar(1);
ie_possui_registro_w		varchar(1);
ie_GerarCMEIndividualizado_w	varchar(1);
ie_tem_medico_w				varchar(1);
ds_observacao_w				varchar(255);
ie_registra_observacao_w	varchar(1);
ie_gera_equip_w				varchar(1);
ie_utilizar_equip_presc_w	varchar(1);

c01 CURSOR FOR
	SELECT	coalesce(a.nr_seq_classif_equip,0),
		coalesce(a.cd_equipamento,0),
		coalesce(a.ie_obrigatorio,'S')
	from	proc_interno_equip a
	where	a.nr_seq_proc_interno	=	nr_seq_proc_interno_p
	and 	coalesce(a.cd_medico::text, '') = ''
	and	((coalesce(ie_agenda_integrada, 'N')	= 'S')	or (ie_gera_equip_w	= 'S'))
	and	((ie_classif_equip_w = 'C' AND nr_seq_classif_equip IS NOT NULL AND nr_seq_classif_equip::text <> '') or (ie_classif_equip_w = 'E' AND cd_equipamento IS NOT NULL AND cd_equipamento::text <> ''))
	and not exists (	SELECT	1
			from	ageint_equip_item x
			where	x.nr_seq_agenda_item	= nr_seq_item_p
			and (x.nr_seq_classif_equip	= a.nr_seq_classif_equip
			or 	x.cd_equipamento 	= a.cd_equipamento));
	/*union
	select	nvl(a.nr_seq_classif_equip,0),
		nvl(a.cd_equipamento,0),
		nvl(a.ie_obrigatorio,'S')
	from	proc_interno_equip a
	where	a.nr_seq_proc_interno	=	nr_seq_proc_interno_p
	--and 	a.cd_medico		= 	cd_medico_p
	and	(((ie_classif_equip_w = 'C') and (nr_seq_classif_equip is not null)) or ((ie_classif_equip_w = 'E') and (cd_equipamento is not null)))
	and not exists(	select	1
			from	ageint_equip_item x
			where	x.nr_seq_agenda_item	= nr_seq_item_p
			and	(x.nr_seq_classif_equip	= a.nr_seq_classif_equip
			or 	x.cd_equipamento 	= a.cd_equipamento));*/
BEGIN

ie_utilizar_equip_presc_w := Obter_Param_Usuario(869, 417, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_utilizar_equip_presc_w);

if (coalesce(ie_utilizar_equip_presc_w,'N') = 'N') then

	ie_classif_equip_w := Obter_Param_Usuario(869, 23, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_classif_equip_w);
	ie_gera_equip_w := Obter_Param_Usuario(869, 24, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_gera_equip_w);

	if (nr_seq_proc_interno_p > 0) then

		delete	FROM ageint_equip_item
		where	nr_seq_agenda_item	= nr_seq_item_p;

		open c01;
		loop
		fetch c01 into
			nr_seq_classif_equip_w,
			cd_equipamento_proc_w,
			ie_obrigatorio_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
			begin

			cd_equipamento_w	:= null;
			if (nr_seq_classif_equip_w > 0) then
				begin
				select	count(*)
				into STRICT	qt_equip_class_w
				from	equipamento
				where	cd_classificacao = nr_seq_classif_equip_w;

				if (qt_equip_class_w = 1) then
					begin
					select	cd_equipamento
					into STRICT	cd_equipamento_w
					from	equipamento
					where	cd_classificacao = nr_seq_classif_equip_w;
					end;
				end if;
				end;
			end if;

			nr_seq_classif_equip_ww	:= null;
			if (nr_seq_classif_equip_w > 0) then
				begin
				nr_seq_classif_equip_ww	:= nr_seq_classif_equip_w;
				cd_equipamento_ww	:= cd_equipamento_w;
				end;
			elsif (cd_equipamento_proc_w > 0) then
				cd_equipamento_ww	:= cd_equipamento_proc_w;
			end if;

			if (ie_classif_equip_w = 'C') then
				cd_equipamento_ww	:= null;
			else
				nr_seq_classif_equip_ww	:= null;
			end if;
			insert into ageint_equip_item(nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					nr_seq_agenda_item,
					cd_equipamento,
					nr_seq_classif_equip)
				values (nextval('ageint_equip_item_seq'),
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					nr_seq_item_p,
					cd_equipamento_ww,
					nr_seq_classif_equip_ww);
			end;
		end loop;
		close c01;
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ageint_gerar_equip_item ( nr_seq_proc_interno_p bigint, nr_seq_item_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
