-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE plt_avisar_nao_copiado ( ds_item_p text, ie_motivo_p text, ie_tipo_item_p text, nr_prescricao_p bigint, qt_registros_p bigint, nm_usuario_p text, nr_seq_item_p bigint, ds_observacao_p text, ie_permite_p text, cd_intervalo_p text, cd_perfil_p bigint, cd_estabelecimento_p bigint) AS $body$
DECLARE


ie_estende_nao_liberado_w	varchar(1);
ie_manter_w			varchar(1);
ie_estender_w			varchar(1);


BEGIN

ie_estende_nao_liberado_w := Obter_Param_Usuario(950, 110, cd_perfil_p, nm_usuario_p, cd_estabelecimento_p, ie_estende_nao_liberado_w);

if (ie_estende_nao_liberado_w	= 'S') and (ie_motivo_p			= 'IE') and (ie_permite_p			= 'S') then
	ie_manter_w	:= 'N';
	ie_estender_w	:= 'S';
else
	ie_manter_w	:= 'S';
	ie_estender_w	:= 'N';
end if;

insert into w_copia_plano(	ds_item,
				ie_motivo,
				dt_atualizacao,
				dt_atualizacao_nrec,
				ie_tipo_item,
				nm_usuario,
				nm_usuario_nrec,
				nr_prescricao,
				qt_registros,
				nr_sequencia,
				nr_seq_item,
				ds_observacao,
				ie_check_manter,
				ie_check_suspender,
				ie_check_estender,
				ie_permite,
				cd_intervalo)
		values (	ds_item_p,
				ie_motivo_p,
				clock_timestamp(),
				clock_timestamp(),
				ie_tipo_item_p,
				nm_usuario_p,
				nm_usuario_p,
				nr_prescricao_p,
				qt_registros_p,
				nextval('w_copia_plano_seq'),
				nr_seq_item_p,
				substr(ds_observacao_p,1,2000),
				ie_manter_w,
				'N',
				ie_estender_w,
				ie_permite_p,
				cd_intervalo_p);

if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE plt_avisar_nao_copiado ( ds_item_p text, ie_motivo_p text, ie_tipo_item_p text, nr_prescricao_p bigint, qt_registros_p bigint, nm_usuario_p text, nr_seq_item_p bigint, ds_observacao_p text, ie_permite_p text, cd_intervalo_p text, cd_perfil_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;
