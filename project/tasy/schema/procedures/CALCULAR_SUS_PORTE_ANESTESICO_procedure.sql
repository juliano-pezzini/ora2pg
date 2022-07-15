-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE calcular_sus_porte_anestesico (NR_INTERNO_CONTA_P bigint) AS $body$
DECLARE

vl_porte_w			double precision	:= 0;
vl_Conta_w			double precision	:= 0;
vl_honorario_w		double precision	:= 0;
ie_conveniado_w		varchar(1)	:= 'N';
nr_sequencia_w		bigint	:= 0;
nr_seq_partic_w		bigint	:= 0;
qt_ato_w			smallint	:= 0;
ie_tipo_serv_partic_w	smallint;

C01 CURSOR FOR
	SELECT 	a.nr_sequencia,
			c.nr_seq_partic,
			b.qt_ato_anestesista,
			coalesce(b.vl_medico,0) + coalesce(b.vl_anestesia,0),
			c.ie_tipo_servico_sus
	from		Procedimento_participante c,
			sus_valor_proc_paciente b,
			procedimento_paciente a
	where		a.nr_interno_conta		= nr_interno_conta_p
	and		a.nr_sequencia			= b.nr_sequencia
	and		a.nr_sequencia			= c.nr_sequencia
	and		coalesce(cd_porte_anestesico,0)	> 0
	and		a.cd_procedimento		<> 45100055
	and		coalesce(c.ie_tipo_ato_sus,0) = 6
	and		coalesce(a.cd_motivo_exc_conta::text, '') = '';


BEGIN

OPEN C01;
LOOP
FETCH C01 into
		nr_sequencia_w,
		nr_seq_partic_w,
		qt_ato_w,
		vl_honorario_w,
		ie_tipo_serv_partic_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	BEGIN
	vl_porte_w			:= vl_honorario_w * .3;
	vl_conta_w			:= 0;
	if (ie_tipo_serv_partic_w = 4) then
		vl_conta_w		:= vl_porte_w;
	end if;
	update	procedimento_participante
	set		vl_participante	= vl_porte_w,
/*			vl_ponto_sus		= vl_porte_w,		Retirado por Marcus em 03/09/2006 */

			vl_conta		= vl_conta_w
	where		nr_sequencia 		= nr_sequencia_w
	and		nr_seq_partic 	= nr_seq_partic_w;

	update	sus_valor_proc_paciente
	set 		vl_ato_anestesista	= vl_porte_w,
			vl_medico			= vl_medico - vl_porte_w
	where		nr_sequencia		= nr_sequencia_w;

	update	procedimento_paciente a
	set		a.vl_medico			= vl_medico  - vl_porte_w,
			a.vl_procedimento		= vl_procedimento + vl_conta_w
	where		a.nr_sequencia 		= nr_sequencia_w;

	END;
END LOOP;
CLOSE C01;

update	procedimento_paciente a
set		a.vl_procedimento		= vl_procedimento + vl_medico
where		a.nr_sequencia 		= nr_sequencia_w
  and		ie_tipo_servico_sus	= 4;


END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE calcular_sus_porte_anestesico (NR_INTERNO_CONTA_P bigint) FROM PUBLIC;

