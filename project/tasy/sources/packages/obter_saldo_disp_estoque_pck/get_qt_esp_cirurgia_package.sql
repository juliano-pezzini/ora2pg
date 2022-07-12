-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION obter_saldo_disp_estoque_pck.get_qt_esp_cirurgia ( cd_estabelecimento_p bigint, cd_material_p bigint, cd_local_estoque_p bigint default null, nr_seq_lote_p bigint default null) RETURNS bigint AS $body$
DECLARE


	qt_esp_cirurgia_w		double precision	:=	0;
	cd_material_estoque_ww		material.cd_material%type;

	
BEGIN
	CALL CALL CALL CALL CALL CALL CALL CALL CALL obter_saldo_disp_estoque_pck.set_cd_estabelecimento(cd_estabelecimento_p);
	CALL obter_saldo_disp_estoque_pck.set_nr_seq_lote(nr_seq_lote_p);
	CALL obter_saldo_disp_estoque_pck.set_cd_material(cd_material_p);
	cd_material_estoque_ww		:=	obter_saldo_disp_estoque_pck.get_cd_material_estoque();

	if (cd_local_estoque_p > 0) then
		if	((nr_seq_lote_p > 0) and (current_setting('obter_saldo_disp_estoque_pck.ie_estoque_lote_w')::material_estab.ie_estoque_lote%type = 'S')) then
			if (current_setting('obter_saldo_disp_estoque_pck.ie_disp_esp_cirurgia_w')::parametro_estoque.ie_disp_esp_cirurgia%type = 'S') then
				SELECT	coalesce(SUM(obter_quantidade_convertida(d.cd_material, d.qt_total_dispensar, d.cd_unidade_medida, 'UME')),0)
				into STRICT	qt_esp_cirurgia_w
				FROM	setor_atendimento a,
					cirurgia b,
					prescr_medica c,
					prescr_material d,
					material e
				WHERE	b.nr_cirurgia		= c.nr_cirurgia
				AND	c.nr_prescricao		= d.nr_prescricao
				AND	a.cd_setor_atendimento	= b.cd_setor_atendimento
				AND	d.cd_material		= e.cd_material
				AND	a.cd_local_estoque	= cd_local_estoque_p
				AND	e.cd_material_estoque	= cd_material_estoque_ww
				AND	d.cd_motivo_baixa	= 0
				AND	d.ie_status_cirurgia	IN ('CB','AD')
				AND	coalesce(d.ie_baixa_estoque_cir::text, '') = ''
				and	d.nr_seq_lote_fornec 	= nr_seq_lote_p;
			elsif (current_setting('obter_saldo_disp_estoque_pck.ie_disp_esp_cirurgia_w')::parametro_estoque.ie_disp_esp_cirurgia%type = 'C') then
				SELECT	coalesce(SUM(obter_quantidade_convertida(d.cd_material, d.qt_total_dispensar, d.cd_unidade_medida, 'UME')),0)
				into STRICT	qt_esp_cirurgia_w
				FROM	setor_atendimento a,
					cirurgia b,
					prescr_medica c,
					prescr_material d,
					material e
				WHERE	b.nr_cirurgia		= c.nr_cirurgia
				AND	c.nr_prescricao		= d.nr_prescricao
				AND	a.cd_setor_atendimento	= b.cd_setor_atendimento
				AND	d.cd_material		= e.cd_material
				and	coalesce(d.cd_local_estoque, a.cd_local_estoque) = cd_local_estoque_p
				AND	e.cd_material_estoque	= cd_material_estoque_ww
				AND	d.cd_motivo_baixa	= 0
				AND	d.ie_status_cirurgia	IN ('CB','AD')
				AND	coalesce(d.ie_baixa_estoque_cir::text, '') = ''
				and	d.nr_seq_lote_fornec 	= nr_seq_lote_p;
			end if;
		else
			if (current_setting('obter_saldo_disp_estoque_pck.ie_disp_esp_cirurgia_w')::parametro_estoque.ie_disp_esp_cirurgia%type = 'S') then
				SELECT	coalesce(SUM(obter_quantidade_convertida(d.cd_material, d.qt_total_dispensar, d.cd_unidade_medida, 'UME')),0)
				into STRICT	qt_esp_cirurgia_w
				FROM	setor_atendimento a,
					cirurgia b,
					prescr_medica c,
					prescr_material d,
					material e
				WHERE	b.nr_cirurgia		= c.nr_cirurgia
				AND	c.nr_prescricao		= d.nr_prescricao
				AND	a.cd_setor_atendimento	= b.cd_setor_atendimento
				AND	d.cd_material		= e.cd_material
				AND	a.cd_local_estoque	= cd_local_estoque_p
				AND	e.cd_material_estoque	= cd_material_estoque_ww
				AND	d.cd_motivo_baixa	= 0
				AND	d.ie_status_cirurgia	IN ('CB','AD')
				AND	coalesce(d.ie_baixa_estoque_cir::text, '') = '';
			elsif (current_setting('obter_saldo_disp_estoque_pck.ie_disp_esp_cirurgia_w')::parametro_estoque.ie_disp_esp_cirurgia%type = 'C') then
				SELECT	coalesce(SUM(obter_quantidade_convertida(d.cd_material, d.qt_total_dispensar, d.cd_unidade_medida, 'UME')),0)
				into STRICT	qt_esp_cirurgia_w
				FROM	setor_atendimento a,
					cirurgia b,
					prescr_medica c,
					prescr_material d,
					material e
				WHERE	b.nr_cirurgia		= c.nr_cirurgia
				AND	c.nr_prescricao		= d.nr_prescricao
				AND	a.cd_setor_atendimento	= b.cd_setor_atendimento
				AND	d.cd_material		= e.cd_material
				and	coalesce(d.cd_local_estoque, a.cd_local_estoque) = cd_local_estoque_p
				AND	e.cd_material_estoque	= cd_material_estoque_ww
				AND	d.cd_motivo_baixa	= 0
				AND	d.ie_status_cirurgia	IN ('CB','AD')
				AND	coalesce(d.ie_baixa_estoque_cir::text, '') = '';
			end if;
		end if;
	else
		if	((nr_seq_lote_p > 0) and (current_setting('obter_saldo_disp_estoque_pck.ie_estoque_lote_w')::material_estab.ie_estoque_lote%type = 'S')) then
			if (current_setting('obter_saldo_disp_estoque_pck.ie_disp_esp_cirurgia_w')::parametro_estoque.ie_disp_esp_cirurgia%type = 'S') then
				SELECT	coalesce(SUM(obter_quantidade_convertida(d.cd_material, d.qt_total_dispensar, d.cd_unidade_medida, 'UME')),0)
				into STRICT	qt_esp_cirurgia_w
				FROM	setor_atendimento a,
					cirurgia b,
					prescr_medica c,
					prescr_material d,
					material e
				WHERE	b.nr_cirurgia		= c.nr_cirurgia
				AND	c.nr_prescricao		= d.nr_prescricao
				AND	a.cd_setor_atendimento	= b.cd_setor_atendimento
				AND	d.cd_material		= e.cd_material
				and	exists (	SELECT	1
						from	local_estoque loc
						where	loc.cd_local_estoque = a.cd_local_estoque
						and	loc.cd_estabelecimento = cd_estabelecimento_p
						and	loc.ie_tipo_local = '2'
						
union all

						SELECT	1
						from	local_estoque loc
						where	loc.cd_local_estoque = a.cd_local_estoque
						and	loc.cd_estabelecimento = cd_estabelecimento_p
						and	loc.ie_baixa_disp = 'S')
				AND	e.cd_material_estoque	= cd_material_estoque_ww
				AND	d.cd_motivo_baixa	= 0
				AND	d.ie_status_cirurgia	IN ('CB','AD')
				AND	coalesce(d.ie_baixa_estoque_cir::text, '') = ''
				and	d.nr_seq_lote_fornec 	= nr_seq_lote_p;
			elsif (current_setting('obter_saldo_disp_estoque_pck.ie_disp_esp_cirurgia_w')::parametro_estoque.ie_disp_esp_cirurgia%type = 'C') then
				SELECT	coalesce(SUM(obter_quantidade_convertida(d.cd_material, d.qt_total_dispensar, d.cd_unidade_medida, 'UME')),0)
				into STRICT	qt_esp_cirurgia_w
				FROM	setor_atendimento a,
					cirurgia b,
					prescr_medica c,
					prescr_material d,
					material e
				WHERE	b.nr_cirurgia		= c.nr_cirurgia
				AND	c.nr_prescricao		= d.nr_prescricao
				AND	a.cd_setor_atendimento	= b.cd_setor_atendimento
				AND	d.cd_material		= e.cd_material
				and	exists (	SELECT	1
						from	local_estoque loc
						where	loc.cd_local_estoque = coalesce(d.cd_local_estoque, a.cd_local_estoque)
						and	loc.cd_estabelecimento = cd_estabelecimento_p
						and	loc.ie_tipo_local = '2'
						
union all

						SELECT	1
						from	local_estoque loc
						where	loc.cd_local_estoque = coalesce(d.cd_local_estoque, a.cd_local_estoque)
						and	loc.cd_estabelecimento = cd_estabelecimento_p
						and	loc.ie_baixa_disp = 'S')
				AND	e.cd_material_estoque	= cd_material_estoque_ww
				AND	d.cd_motivo_baixa	= 0
				AND	d.ie_status_cirurgia	IN ('CB','AD')
				AND	coalesce(d.ie_baixa_estoque_cir::text, '') = ''
				and	d.nr_seq_lote_fornec 	= nr_seq_lote_p;
			end if;
		else
			if (current_setting('obter_saldo_disp_estoque_pck.ie_disp_esp_cirurgia_w')::parametro_estoque.ie_disp_esp_cirurgia%type = 'S') then
				SELECT	coalesce(SUM(obter_quantidade_convertida(d.cd_material, d.qt_total_dispensar, d.cd_unidade_medida, 'UME')),0)
				into STRICT	qt_esp_cirurgia_w
				FROM	setor_atendimento a,
					cirurgia b,
					prescr_medica c,
					prescr_material d,
					material e
				WHERE	b.nr_cirurgia		= c.nr_cirurgia
				AND	c.nr_prescricao		= d.nr_prescricao
				AND	a.cd_setor_atendimento	= b.cd_setor_atendimento
				AND	d.cd_material		= e.cd_material
				and	exists (	SELECT	1
						from	local_estoque loc
						where	loc.cd_local_estoque = a.cd_local_estoque
						and	loc.cd_estabelecimento = cd_estabelecimento_p
						and	loc.ie_tipo_local = '2'
						
union all

						SELECT	1
						from	local_estoque loc
						where	loc.cd_local_estoque = a.cd_local_estoque
						and	loc.cd_estabelecimento = cd_estabelecimento_p
						and	loc.ie_baixa_disp = 'S')
				AND	e.cd_material_estoque	= cd_material_estoque_ww
				AND	d.cd_motivo_baixa	= 0
				AND	d.ie_status_cirurgia	IN ('CB','AD')
				AND	coalesce(d.ie_baixa_estoque_cir::text, '') = '';
			elsif (current_setting('obter_saldo_disp_estoque_pck.ie_disp_esp_cirurgia_w')::parametro_estoque.ie_disp_esp_cirurgia%type = 'C') then
				SELECT	coalesce(SUM(obter_quantidade_convertida(d.cd_material, d.qt_total_dispensar, d.cd_unidade_medida, 'UME')),0)
				into STRICT	qt_esp_cirurgia_w
				FROM	setor_atendimento a,
					cirurgia b,
					prescr_medica c,
					prescr_material d,
					material e
				WHERE	b.nr_cirurgia		= c.nr_cirurgia
				AND	c.nr_prescricao		= d.nr_prescricao
				AND	a.cd_setor_atendimento	= b.cd_setor_atendimento
				AND	d.cd_material		= e.cd_material
				and	exists (	SELECT	1
						from	local_estoque loc
						where	loc.cd_local_estoque = coalesce(d.cd_local_estoque, a.cd_local_estoque)
						and	loc.cd_estabelecimento = cd_estabelecimento_p
						and	loc.ie_tipo_local = '2'
						
union all

						SELECT	1
						from	local_estoque loc
						where	loc.cd_local_estoque = coalesce(d.cd_local_estoque, a.cd_local_estoque)
						and	loc.cd_estabelecimento = cd_estabelecimento_p
						and	loc.ie_baixa_disp = 'S')
				AND	e.cd_material_estoque	= cd_material_estoque_ww
				AND	d.cd_motivo_baixa	= 0
				AND	d.ie_status_cirurgia	IN ('CB','AD')
				AND	coalesce(d.ie_baixa_estoque_cir::text, '') = '';
			end if;
		end if;
	end if;

	return qt_esp_cirurgia_w;
	end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_saldo_disp_estoque_pck.get_qt_esp_cirurgia ( cd_estabelecimento_p bigint, cd_material_p bigint, cd_local_estoque_p bigint default null, nr_seq_lote_p bigint default null) FROM PUBLIC;
