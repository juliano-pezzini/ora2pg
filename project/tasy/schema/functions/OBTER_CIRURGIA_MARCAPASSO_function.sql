-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_cirurgia_marcapasso ( nr_seq_cir_marcapasso_p bigint, ie_tipo_p text ) RETURNS varchar AS $body$
DECLARE


const_ds_gerador_marcador_w	constant varchar(5) := 'DS_GM';
const_qt_freq_magnetica_w	constant varchar(5) := 'QT_FM';
const_qt_eri_w				constant varchar(5) := 'QT_ER';
const_ds_eletr_atrial_w		constant varchar(5) := 'DS_EA';
const_dt_impl_eletr_atr_w	constant varchar(5) := 'DT_EA';
const_ds_eletr_vent_w		constant varchar(5) := 'DS_EV';
const_dt_impl_eletr_vent_w	constant varchar(5) := 'DT_EV';
const_nr_seq_nivel_seg_w	constant varchar(7) := 'NVL_SEG';

ds_retorno_w varchar(255);


BEGIN

	if (ie_tipo_p = const_ds_gerador_marcador_w) then
		select	max(cm.ds_gerador) ds_marcador_marcapasso
		into STRICT	ds_retorno_w
		from	cir_marcapasso cm
		where	cm.nr_seq_pac_acessorio = nr_seq_cir_marcapasso_p;

	elsif (ie_tipo_p = const_qt_freq_magnetica_w) then
		select	max(cm.qt_freq_magnetica) qt_freq_magnetica
		into STRICT	ds_retorno_w
		from	cir_marcapasso cm
		where	cm.nr_seq_pac_acessorio = nr_seq_cir_marcapasso_p;

	elsif (ie_tipo_p = const_qt_eri_w) then
		select	max(cm.qt_eri) qt_eri
		into STRICT	ds_retorno_w
		from	cir_marcapasso cm
		where	cm.nr_seq_pac_acessorio = nr_seq_cir_marcapasso_p;

	elsif (ie_tipo_p = const_ds_eletr_atrial_w) then
		select	max(cm.ds_eletr_atrial) ds_eletr_atrial
		into STRICT	ds_retorno_w
		from	cir_marcapasso cm
		where	cm.nr_seq_pac_acessorio = nr_seq_cir_marcapasso_p;

	elsif (ie_tipo_p = const_dt_impl_eletr_atr_w) then
		select	pkg_date_formaters.to_varchar(max(cm.dt_impl_eletrodo_atrial), 'shortDate', wheb_usuario_pck.get_cd_estabelecimento, wheb_usuario_pck.get_nm_usuario) dt_impl_eletrodo_atrial
		into STRICT	ds_retorno_w
		from	cir_marcapasso cm
		where	cm.nr_seq_pac_acessorio = nr_seq_cir_marcapasso_p;

	elsif (ie_tipo_p = const_ds_eletr_vent_w) then
		select	max(cm.ds_eletr_ventricular) ds_eletr_ventricular
		into STRICT	ds_retorno_w
		from	cir_marcapasso cm
		where	cm.nr_seq_pac_acessorio = nr_seq_cir_marcapasso_p;
		
	elsif (ie_tipo_p = const_dt_impl_eletr_vent_w) then
		select	pkg_date_formaters.to_varchar(max(cm.dt_impl_eletr_ventricular), 'shortDate', wheb_usuario_pck.get_cd_estabelecimento, wheb_usuario_pck.get_nm_usuario) dt_impl_eletr_ventricular
		into STRICT	ds_retorno_w
		from	cir_marcapasso cm
		where	cm.nr_seq_pac_acessorio = nr_seq_cir_marcapasso_p;
		
	elsif (ie_tipo_p = const_nr_seq_nivel_seg_w) then
		select	max(nsa.ds_nivel)
		into STRICT	ds_retorno_w
		from	nivel_seguranca_alerta nsa
		where	nsa.nr_sequencia = (SELECT	max(pa.nr_seq_nivel_seg)
									from 	paciente_acessorio pa
									where 	pa.nr_sequencia = nr_seq_cir_marcapasso_p);
	end if;

	return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_cirurgia_marcapasso ( nr_seq_cir_marcapasso_p bigint, ie_tipo_p text ) FROM PUBLIC;

