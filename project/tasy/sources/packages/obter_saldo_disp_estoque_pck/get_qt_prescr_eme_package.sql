-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION obter_saldo_disp_estoque_pck.get_qt_prescr_eme ( cd_estabelecimento_p bigint, cd_material_p bigint, cd_local_estoque_p bigint default null, nr_seq_lote_p bigint default null) RETURNS bigint AS $body$
DECLARE


	qt_emergencia_w			double precision	:= 0;
	cd_material_estoque_ww		material.cd_material%type;

	
BEGIN
	CALL CALL CALL CALL CALL CALL CALL CALL CALL obter_saldo_disp_estoque_pck.set_cd_estabelecimento(cd_estabelecimento_p);
	CALL obter_saldo_disp_estoque_pck.set_nr_seq_lote(nr_seq_lote_p);
	CALL obter_saldo_disp_estoque_pck.set_cd_material(cd_material_p);
	cd_material_estoque_ww		:=	obter_saldo_disp_estoque_pck.get_cd_material_estoque();

	/*Busca as quantidades que estão prescrição de emergência. indice definido, motivo OS276540*/

	if (current_setting('obter_saldo_disp_estoque_pck.ie_disp_prescr_eme_w')::parametro_estoque.ie_disp_prescr_eme%type = 'S') then
		if (cd_local_estoque_p > 0) then
			if	((nr_seq_lote_p > 0) and (current_setting('obter_saldo_disp_estoque_pck.ie_estoque_lote_w')::material_estab.ie_estoque_lote%type = 'S')) then
				select	coalesce(sum(qt_total_dispensar),0)
				into STRICT	qt_emergencia_w
				from	setor_atendimento c,
					material x,
					prescr_medica b,
					prescr_material a
				where	a.nr_prescricao		= b.nr_prescricao
				and	a.cd_material           = x.cd_material
				and	b.cd_setor_atendimento  = c.cd_setor_atendimento
				and	b.ie_emergencia		= 'S'
				and	x.cd_material_estoque   = cd_material_estoque_ww
				and	c.cd_local_estoque     	= cd_local_estoque_p
				and	a.cd_motivo_baixa	= 0
				and	a.ie_status_cirurgia	= 'PE'
				and	a.nr_seq_lote_fornec 	= nr_seq_lote_p;
			else
				select	coalesce(sum(qt_total_dispensar),0)
				into STRICT	qt_emergencia_w
				from	setor_atendimento c,
					material x,
					prescr_medica b,
					prescr_material a
				where	a.nr_prescricao		= b.nr_prescricao
				and	a.cd_material           = x.cd_material
				and	b.cd_setor_atendimento  = c.cd_setor_atendimento
				and	b.ie_emergencia		= 'S'
				and	x.cd_material_estoque   = cd_material_estoque_ww
				and	c.cd_local_estoque     	= cd_local_estoque_p
				and	a.cd_motivo_baixa	= 0
				and	a.ie_status_cirurgia	= 'PE';
			end if;
		else
			if	((nr_seq_lote_p > 0) and (current_setting('obter_saldo_disp_estoque_pck.ie_estoque_lote_w')::material_estab.ie_estoque_lote%type = 'S')) then
				select	coalesce(sum(qt_total_dispensar),0)
				into STRICT	qt_emergencia_w
				from	setor_atendimento c,
					material x,
					prescr_medica b,
					prescr_material a
				where	a.nr_prescricao		= b.nr_prescricao
				and	a.cd_material           = x.cd_material
				and	b.cd_setor_atendimento  = c.cd_setor_atendimento
				and	b.ie_emergencia		= 'S'
				and	x.cd_material_estoque   = cd_material_estoque_ww
				and	exists (	SELECT	1
						from	local_estoque loc
						where	loc.cd_local_estoque = c.cd_local_estoque
						and	loc.cd_estabelecimento = cd_estabelecimento_p
						and	loc.ie_tipo_local = '2'
						
union all

						SELECT	1
						from	local_estoque loc
						where	loc.cd_local_estoque = c.cd_local_estoque
						and	loc.cd_estabelecimento = cd_estabelecimento_p
						and	loc.ie_baixa_disp = 'S')
				and	a.cd_motivo_baixa	= 0
				and	a.ie_status_cirurgia	= 'PE'
				and	a.nr_seq_lote_fornec 	= nr_seq_lote_p;
			else
				select	coalesce(sum(qt_total_dispensar),0)
				into STRICT	qt_emergencia_w
				from	setor_atendimento c,
					material x,
					prescr_medica b,
					prescr_material a
				where	a.nr_prescricao		= b.nr_prescricao
				and	a.cd_material           = x.cd_material
				and	b.cd_setor_atendimento  = c.cd_setor_atendimento
				and	b.ie_emergencia		= 'S'
				and	x.cd_material_estoque   = cd_material_estoque_ww
				and	exists (	SELECT	1
						from	local_estoque loc
						where	loc.cd_local_estoque = c.cd_local_estoque
						and	loc.cd_estabelecimento = cd_estabelecimento_p
						and	loc.ie_tipo_local = '2'
						
union all

						SELECT	1
						from	local_estoque loc
						where	loc.cd_local_estoque = c.cd_local_estoque
						and	loc.cd_estabelecimento = cd_estabelecimento_p
						and	loc.ie_baixa_disp = 'S')
				and	a.cd_motivo_baixa	= 0
				and	a.ie_status_cirurgia	= 'PE';
			end if;
		end if;
	end if;

	return dividir(qt_emergencia_w, current_setting('obter_saldo_disp_estoque_pck.qt_conv_estoque_w')::material.qt_conv_estoque_consumo%type);
	end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_saldo_disp_estoque_pck.get_qt_prescr_eme ( cd_estabelecimento_p bigint, cd_material_p bigint, cd_local_estoque_p bigint default null, nr_seq_lote_p bigint default null) FROM PUBLIC;