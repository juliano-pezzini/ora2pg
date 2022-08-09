-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baixar_prescr_pendente_herasto ( qt_hora_adicional_p bigint, cd_motivo_baixa_p bigint, dt_parametro_p timestamp) AS $body$
BEGIN

update prescr_procedimento a
set cd_motivo_baixa = cd_motivo_baixa_p
where cd_motivo_baixa = 0
and	coalesce(ie_status_atend,1) < 35
  and exists
	(SELECT 1
	from 	Procedimento c,
		prescr_medica b
     	where a.nr_prescricao = b.nr_prescricao
	  and (a.dt_prev_execucao + (coalesce(c.qt_hora_baixar_prescr,300) / 24) < dt_parametro_p)
	  and (b.dt_prescricao +
            ((b.nr_horas_validade + coalesce(c.qt_hora_baixar_prescr,300)) /24) < dt_parametro_p)
	  and c.cd_procedimento = a.cd_procedimento
        and c.ie_origem_proced = a.ie_origem_proced)
  and not exists (	select 1 from procedimento_paciente x
			where x.nr_prescricao = a.nr_prescricao
			  and x.nr_sequencia_prescricao = a.nr_sequencia);
commit;

update	prescr_material a
set	cd_motivo_baixa	= cd_motivo_baixa_p
where	cd_motivo_baixa	= 0
/*	Retirado por Marcus em 15/5/2005 OS 18319 (SUGERI UTILIZA A PROCEDURE WHEB
and	((ie_se_necessario = 'S') or (ie_acm = 'S'))
*/
and exists (SELECT 1
	from 	prescr_medica b
     	where a.nr_prescricao = b.nr_prescricao
	  and (b.dt_prescricao + dividir(qt_hora_adicional_p,24)) < dt_parametro_p);
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baixar_prescr_pendente_herasto ( qt_hora_adicional_p bigint, cd_motivo_baixa_p bigint, dt_parametro_p timestamp) FROM PUBLIC;
