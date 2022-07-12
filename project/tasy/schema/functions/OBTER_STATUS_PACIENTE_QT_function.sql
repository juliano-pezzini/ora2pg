-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_status_paciente_qt (nr_seq_atendimento_p bigint, dt_inicio_adm_p timestamp, dt_fim_adm_p timestamp, nr_seq_local_p bigint, ie_exige_lib_p text, dt_chegada_p timestamp, ie_codigo_desc_p text) RETURNS varchar AS $body$
DECLARE

/*ie_codigo_desc_p D - Descrição C- Código */

ds_status_w		varchar(80);
qt_intercorrencia_w	bigint;
qt_total_atend_w	bigint;
qt_total_geral_w	bigint;
ie_considera_med_disp_w varchar(2);
qt_motivo_baixa_w	bigint;
nr_prescricao_w		bigint := 0;


BEGIN

ie_considera_med_disp_w := Obter_Param_Usuario(3130, 465, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, ie_considera_med_disp_w);

select 	coalesce(max(nr_prescricao),0)
into STRICT 	nr_prescricao_w
from 	paciente_atendimento
where 	nr_seq_atendimento = nr_seq_atendimento_p;

if (ie_considera_med_disp_w = 'S')	then
	select	count(cd_motivo_baixa)
	into STRICT	qt_motivo_baixa_w
	from	prescr_material
	where 	coalesce(cd_motivo_baixa,0) = 0
	and	ie_agrupador = 1
	and	nr_prescricao = nr_prescricao_w;
end if;

if (ie_exige_lib_p = 'S') then
	ds_status_w		:= '357';
elsif (dt_fim_adm_p IS NOT NULL AND dt_fim_adm_p::text <> '') then
	ds_status_w		:= '83';
else
	begin
	select	count(*)
	into STRICT	qt_intercorrencia_w
	from	paciente_atend_interc
	where	nr_seq_atendimento	= nr_seq_atendimento_p
	and	(dt_intercorrencia IS NOT NULL AND dt_intercorrencia::text <> '')
	and	coalesce(dt_fim_intercorrencia::text, '') = '';
	if (qt_intercorrencia_w > 0) then
		ds_status_w		:= '82';
	elsif (dt_inicio_adm_p IS NOT NULL AND dt_inicio_adm_p::text <> '') then
		ds_status_w		:= '81';
	else
		begin
		select	count(*)
		into STRICT	qt_total_atend_w
		from	can_ordem_prod
		where	(dt_entrega_setor IS NOT NULL AND dt_entrega_setor::text <> '')
		and	nr_seq_atendimento	 = nr_seq_atendimento_p;
		select	count(*)
		into STRICT	qt_total_geral_w
		from	can_ordem_prod
		where	nr_seq_atendimento	 = nr_seq_atendimento_p;
		if	((dt_chegada_p IS NOT NULL AND dt_chegada_p::text <> '') and (nr_seq_local_p IS NOT NULL AND nr_seq_local_p::text <> '') and (qt_total_atend_w <= qt_total_geral_w) and (qt_total_geral_w > 0 ) and (qt_total_atend_w > 0)) or ((nr_prescricao_w IS NOT NULL AND nr_prescricao_w::text <> '') and
			qt_motivo_baixa_w = 0 and
			ie_considera_med_disp_w = 'S') then
			ds_status_w 		:= '524';
		elsif (dt_chegada_p IS NOT NULL AND dt_chegada_p::text <> '') and (nr_seq_local_p IS NOT NULL AND nr_seq_local_p::text <> '')  then
			ds_status_w		:= '214';
		elsif (dt_chegada_p IS NOT NULL AND dt_chegada_p::text <> '') and (coalesce(nr_seq_local_p::text, '') = '')  then
			ds_status_w		:= '80';
		else
			ds_status_w		:= '76';
		end if;
		end;
	end if;
	end;
end if;
if (ie_codigo_desc_p = 'D') then
	ds_status_w	:= obter_valor_dominio(1242, ds_status_w);
end if;
return ds_status_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_status_paciente_qt (nr_seq_atendimento_p bigint, dt_inicio_adm_p timestamp, dt_fim_adm_p timestamp, nr_seq_local_p bigint, ie_exige_lib_p text, dt_chegada_p timestamp, ie_codigo_desc_p text) FROM PUBLIC;

