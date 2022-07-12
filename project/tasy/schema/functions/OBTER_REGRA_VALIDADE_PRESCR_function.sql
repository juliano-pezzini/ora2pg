-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_regra_validade_prescr ( nr_prescricao_copia_p bigint, nr_prescricao_nova_p bigint) RETURNS varchar AS $body$
DECLARE


dt_validade_prescr_w	timestamp;
dt_inicio_prescr_w	timestamp;
qt_horas_w		bigint;
ds_erro_w		varchar(255);


BEGIN

select	max(dt_validade_prescr)
into STRICT	dt_validade_prescr_w
from	prescr_medica
where	nr_prescricao = nr_prescricao_copia_p;

select	max(dt_inicio_prescr)
into STRICT	dt_inicio_prescr_w
from	prescr_medica
where	nr_prescricao	= nr_prescricao_nova_p;

if (dt_validade_prescr_w < dt_inicio_prescr_w) then
	select	max(obter_hora_entre_datas(dt_inicio_prescr_w, dt_validade_prescr_w))
	into STRICT	qt_horas_w
	;

	if (qt_horas_w > 0) then
		ds_erro_w	:= wheb_mensagem_pck.get_texto(309248,	'DT_VALIDADE_PRESCR_W=' || PKG_DATE_FORMATERS.TO_VARCHAR(dt_validade_prescr_w, 'short', WHEB_USUARIO_PCK.GET_CD_ESTABELECIMENTO, WHEB_USUARIO_PCK.GET_NM_USUARIO) || ';' ||
															'DT_INICIO_PRESCR_W=' || PKG_DATE_FORMATERS.TO_VARCHAR(dt_inicio_prescr_w, 'short', WHEB_USUARIO_PCK.GET_CD_ESTABELECIMENTO, WHEB_USUARIO_PCK.GET_NM_USUARIO) || ';' ||
															'QT_HORAS_W=' || qt_horas_w);
					-- A prescrição original termina as #@DT_VALIDADE_PRESCR_W#@ horas e a cópia inicia as #@DT_INICIO_PRESCR_W#@ horas. O paciente ficará #@QT_HORAS_W#@ horas sem prescrição. Favor verificar!
	end if;
end if;

return	ds_erro_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_regra_validade_prescr ( nr_prescricao_copia_p bigint, nr_prescricao_nova_p bigint) FROM PUBLIC;
