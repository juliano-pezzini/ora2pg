-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_rec_resumo_alta ( NR_SEQ_ATEND_SUMARIO_p bigint, cd_recomendacao_p text, cd_material_p bigint default 0, nr_prescricao_p bigint DEFAULT NULL, nm_usuario_p text DEFAULT NULL) AS $body$
DECLARE


ds_auxiliar_w		varchar(4000);
ie_par1455_w		varchar(1);


BEGIN

ie_par1455_w := obter_param_usuario(281, 1455, obter_perfil_ativo, nm_usuario_p, obter_estabelecimento_ativo, ie_par1455_w);

if (coalesce(cd_material_p,0) > 0)  then
	if (ie_par1455_w <> 'T') then
		begin
			select	substr(obter_desc_material(a.cd_material),1,255) || ' - ' || a.qt_dose || ' / ' ||a.cd_unidade_medida_dose||' / '||Obter_desc_intervalo(	a.CD_INTERVALO)||
			' / ' || wheb_mensagem_pck.get_texto(1115163, null)|| ' : ' ||b.dt_prescricao 
			|| (CASE WHEN (c.dt_suspensao IS NOT NULL AND c.dt_suspensao::text <> '') THEN ' / '|| wheb_mensagem_pck.get_texto(1115162, null) || ' : ' || c.dt_suspensao ELSE '' END)
			into STRICT	ds_auxiliar_w
			from	prescr_material a, prescr_medica b, cpoe_material c
			where	a.cd_material = cd_material_p
			and a.nr_prescricao = b.nr_prescricao
			and b.nr_prescricao = nr_prescricao_p
			and a.NR_SEQ_MAT_CPOE = c.nr_sequencia  LIMIT 1; -- Adicionado o rownum = 1 pois o MAX() deixava a rotina lenta
		exception
		when others then
			select	substr(obter_desc_material(cd_material),1,255) || ' - ' || qt_dose || ' / ' ||cd_unidade_medida_dose||' / '||CD_INTERVALO
			into STRICT	ds_auxiliar_w
			from	prescr_material
			where	cd_material = cd_material_p  LIMIT 1;
		end;
	else
		select	substr(obter_desc_material(cd_material),1,255)
		into STRICT	ds_auxiliar_w
		from	prescr_material
		where	cd_material = cd_material_p  LIMIT 1; -- Adicionado o rownum = 1 pois o MAX() deixava a rotina lenta
	end if;
end if;

if (coalesce(cd_recomendacao_p,0) > 0) then
	select	substr(obter_desc_recomendacao(cd_recomendacao_p),1,255)
	into STRICT	ds_auxiliar_w
	;
end if;

insert into ATEND_SUMARIO_ALTA_ITEM(
			 NR_SEQUENCIA,
			 CD_DOENCA,
			 DT_ATUALIZACAO,
			 NM_USUARIO,
			 DT_ATUALIZACAO_NREC,
			 NM_USUARIO_NREC,
			 NR_SEQ_EXAME,
			 IE_TIPO_ITEM,
			 CD_RECOMENDACAO,
			 CD_PROCEDIMENTO,
			 IE_ORIGEM_PROCED,
			 NR_SEQ_ATEND_SUMARIO,
			 cd_material,
			 ds_auxiliar)
		values (
			 nextval('atend_sumario_alta_item_seq'),
			 null,
			 clock_timestamp(),
			 nm_usuario_p,
			 clock_timestamp(),
			 nm_usuario_p,
			 null,
			 'C',
			 cd_recomendacao_p,
			 null,
			 null,
			 NR_SEQ_ATEND_SUMARIO_p,
			 CASE WHEN cd_material_p=0 THEN null  ELSE cd_material_p END ,
			 ds_auxiliar_w);



commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_rec_resumo_alta ( NR_SEQ_ATEND_SUMARIO_p bigint, cd_recomendacao_p text, cd_material_p bigint default 0, nr_prescricao_p bigint DEFAULT NULL, nm_usuario_p text DEFAULT NULL) FROM PUBLIC;

