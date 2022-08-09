-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE san_gerar_resultado_rh ( nr_seq_lote_exame_p bigint, ds_abreviacao_resultado_p text, cd_estabelecimento_p bigint, nm_usuario_p text, ds_erro_p INOUT text) AS $body$
DECLARE


ie_fator_rh_w			varchar(1);
ie_tipo_sangue_w			varchar(2);
nr_seq_exame_rh_param_w 		bigint;
nr_seq_exame_tipo_param_w		bigint;
qtd_w				bigint;
IE_localizou_w			boolean;

BEGIN
begin
Select	coalesce(ds_fator_rh,'N'),
	coalesce(ds_tipo_sangue,'N')
into STRICT	ie_fator_rh_w,
	ie_tipo_sangue_w
from	san_regra_grupo_sanguineo a
where	ds_abreviacao = ds_abreviacao_resultado_p;
IE_localizou_w := true;
exception
when too_many_rows then
	if (ds_erro_p IS NOT NULL AND ds_erro_p::text <> '') then
		ds_erro_p := ds_erro_p || ';';
	end if;
	ds_erro_p := ds_erro_p || WHEB_MENSAGEM_PCK.get_texto(282240,null);
	IE_localizou_w := false;
when no_data_found then
	if (ds_erro_p IS NOT NULL AND ds_erro_p::text <> '') then
		ds_erro_p := ds_erro_p || ';';
	end if;
	ds_erro_p := ds_erro_p || WHEB_MENSAGEM_PCK.get_texto(282241,null);
	IE_localizou_w := false;
end;
if IE_localizou_w then
	SELECT 	max(nr_seq_exame_RH),
		max(nr_seq_exame_tipo)
	into STRICT	nr_seq_exame_rh_param_w,
		nr_seq_exame_tipo_param_w
	FROM 	san_parametro
	where	cd_estabelecimento = cd_estabelecimento_p;

	if (ie_fator_rh_w <> 'N') then --insere o exame de fator rh
		if (nr_seq_exame_rh_param_w IS NOT NULL AND nr_seq_exame_rh_param_w::text <> '') then

			select 	count(*)
			into STRICT	qtd_w
			from	san_exame_realizado
			where	nr_seq_exame_lote	 	= nr_seq_lote_exame_p
			and	nr_seq_exame		= nr_seq_exame_rh_param_w;

			if (qtd_w = 0) then
				insert into san_exame_realizado(
						nr_seq_exame_lote,
						nr_seq_exame,
						dt_atualizacao,
						nm_usuario,
						dt_realizado,
						vl_resultado,
						ds_resultado,
						cd_setor_atendimento)
				values (	nr_seq_lote_exame_p,
						nr_seq_exame_rh_param_w,
						clock_timestamp(),
						nm_usuario_p,
						clock_timestamp(),
						null,
						ie_fator_rh_w,
						null);
			else
				update 	san_exame_realizado
				set	ds_resultado 		= ie_fator_rh_w,
					nm_usuario		= nm_usuario_p,
					dt_atualizacao		= clock_timestamp()
				where 	nr_seq_exame_lote	 	= nr_seq_lote_exame_p
				and	nr_seq_exame		= nr_seq_exame_rh_param_w;
			end if;
		else
			if (ds_erro_p IS NOT NULL AND ds_erro_p::text <> '') then
				ds_erro_p := ds_erro_p || ';';
			end if;
			ds_erro_p := ds_erro_p || WHEB_MENSAGEM_PCK.get_texto(282243,null);
		end if;
	else
		if (ds_erro_p IS NOT NULL AND ds_erro_p::text <> '') then
			ds_erro_p := ds_erro_p || ';';
		end if;
		ds_erro_p := ds_erro_p || WHEB_MENSAGEM_PCK.get_texto(282244,null);
	end if;

	if (ie_tipo_sangue_w <> 'N') then -- insere o exame de tipo de sangue
		if (nr_seq_exame_tipo_param_w IS NOT NULL AND nr_seq_exame_tipo_param_w::text <> '') then
			select 	count(*)
			into STRICT	qtd_w
			from	san_exame_realizado
			where	nr_seq_exame_lote	 	= nr_seq_lote_exame_p
			and	nr_seq_exame		= nr_seq_exame_tipo_param_w;

			if (qtd_w = 0) then
				insert into san_exame_realizado(
						nr_seq_exame_lote,
						nr_seq_exame,
						dt_atualizacao,
						nm_usuario,
						dt_realizado,
						vl_resultado,
						ds_resultado,
						cd_setor_atendimento)
				values (	nr_seq_lote_exame_p,
						nr_seq_exame_tipo_param_w,
						clock_timestamp(),
						nm_usuario_p,
						clock_timestamp(),
						null,
						ie_tipo_sangue_w,
						null);
			else
				update 	san_exame_realizado
				set	ds_resultado 		= ie_tipo_sangue_w,
					nm_usuario		= nm_usuario_p,
					dt_atualizacao		= clock_timestamp()
				where 	nr_seq_exame_lote 		= nr_seq_lote_exame_p
				and	nr_seq_exame		= nr_seq_exame_tipo_param_w;
			end if;
		else

			if (ds_erro_p IS NOT NULL AND ds_erro_p::text <> '') then
				ds_erro_p := ds_erro_p || ';';
			end if;
			ds_erro_p := ds_erro_p || WHEB_MENSAGEM_PCK.get_texto(282246,null);
		end if;
	else
		if (ds_erro_p IS NOT NULL AND ds_erro_p::text <> '') then
			ds_erro_p := ds_erro_p || ';';
		end if;
		ds_erro_p := ds_erro_p || WHEB_MENSAGEM_PCK.get_texto(282247,null);
	end if;
end if;

commit;
if (IE_localizou_w) then
	if 	(ds_erro_p IS NOT NULL AND ds_erro_p::text <> '') then
		ds_erro_p := ds_erro_p || ';';
	end if;
	ds_erro_p := ds_erro_p || WHEB_MENSAGEM_PCK.get_texto(282248,null);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE san_gerar_resultado_rh ( nr_seq_lote_exame_p bigint, ds_abreviacao_resultado_p text, cd_estabelecimento_p bigint, nm_usuario_p text, ds_erro_p INOUT text) FROM PUBLIC;
