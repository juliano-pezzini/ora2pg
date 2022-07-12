-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_mensagem_dias_abt (nr_atendimento_p bigint, cd_material_p bigint) RETURNS varchar AS $body$
DECLARE


nr_prescricao_w			bigint;
qt_dias_solicitado_w	smallint;
qt_dias_liberado_w		smallint;
ds_retorno_w			varchar(2000);


BEGIN

select	max(a.nr_prescricao) nr_prescricao,
		max(a.qt_dias_solicitado),
		max(a.qt_dias_liberado)
into STRICT	nr_prescricao_w,
		qt_dias_solicitado_w,
		qt_dias_liberado_w
from	material b,
		prescr_medica c,
		prescr_material a
where	a.cd_material = b.cd_material
and		a.nr_prescricao = c.nr_prescricao
and		c.nr_atendimento = nr_atendimento_p
and    	(coalesce(c.dt_liberacao,c.dt_liberacao_medico) IS NOT NULL AND (coalesce(c.dt_liberacao,c.dt_liberacao_medico))::text <> '')
and		a.qt_dias_liberado 	< a.qt_dias_solicitado
and		a.qt_dias_solicitado 	> 0
and		c.dt_prescricao		> clock_timestamp() - interval '30 days'
and		(a.qt_dias_liberado IS NOT NULL AND a.qt_dias_liberado::text <> '')
and		a.cd_material 		= cd_material_p
and 	a.ie_agrupador 		= 1
and 	b.ie_controle_medico 	> 0;

if (nr_prescricao_w IS NOT NULL AND nr_prescricao_w::text <> '') then
	ds_retorno_w	:=  Wheb_mensagem_pck.get_texto(807447,
													'NR_PRESCRICAO='||nr_prescricao_w||
													';QT_DIAS_SOLICITADO= '|| qt_dias_solicitado_w||
													';QT_DIAS_LIBERADOS= '|| qt_dias_liberado_w);
													/*'Na prescrição nº '||nr_prescricao_w||' foi solicitado '||qt_dias_solicitado_w||' dia(s) e foi liberado somente '||qt_dias_liberado_w||' dias(s).'*/

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_mensagem_dias_abt (nr_atendimento_p bigint, cd_material_p bigint) FROM PUBLIC;
