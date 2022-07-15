-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE dispositivo_atribfocuslost ( nr_seq_dispositivo_p bigint, nr_atendimento_p bigint, cd_estabelecimento_p bigint, ie_curativo_disp_p INOUT text, qt_horas_prev_curativo_p INOUT bigint, cd_setor_atendimento_p INOUT bigint, ie_permanencia_p INOUT text, qt_horas_prev_disp_p INOUT bigint, ie_topografia_p INOUT text) AS $body$
DECLARE

 
ie_curativo_disp_w		varchar(15)	:= '';
qt_horas_prev_curativo_w	bigint	:= 0;
cd_setor_atendimento_w	integer	:= 0;
ie_permanencia_w		varchar(15)	:= '';
qt_horas_prev_disp_w	bigint	:= 0;
ie_topografia_w		varchar(5)	:= '';
	

BEGIN 
 
if (nr_seq_dispositivo_p IS NOT NULL AND nr_seq_dispositivo_p::text <> '') then 
	begin 
		 
	select 	coalesce(ie_curativo_disp,'N'), 
		ie_permanencia 
	into STRICT	ie_curativo_disp_w, 
		ie_permanencia_w 
	from 	dispositivo 
	where 	nr_sequencia = nr_seq_dispositivo_p;
		 
	qt_horas_prev_curativo_w		:= obter_horas_prev_curativo(nr_seq_dispositivo_p, null, cd_estabelecimento_p);		
	cd_setor_atendimento_w	 	:= obter_setor_atendimento(nr_atendimento_p);		
	qt_horas_prev_disp_w		:= obter_horas_prev_disp(nr_seq_dispositivo_p, cd_setor_atendimento_w, cd_estabelecimento_p);
	ie_topografia_w			:= substr(obter_se_topografia(nr_seq_dispositivo_p),1,5);
		 
	end;
end if;
 
ie_curativo_disp_p		:= ie_curativo_disp_w;
qt_horas_prev_curativo_p	:= qt_horas_prev_curativo_w;
cd_setor_atendimento_p	:= cd_setor_atendimento_w;
ie_permanencia_p		:= ie_permanencia_w;
qt_horas_prev_disp_p	:= qt_horas_prev_disp_w;
ie_topografia_p		:= ie_topografia_w;
	 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE dispositivo_atribfocuslost ( nr_seq_dispositivo_p bigint, nr_atendimento_p bigint, cd_estabelecimento_p bigint, ie_curativo_disp_p INOUT text, qt_horas_prev_curativo_p INOUT bigint, cd_setor_atendimento_p INOUT bigint, ie_permanencia_p INOUT text, qt_horas_prev_disp_p INOUT bigint, ie_topografia_p INOUT text) FROM PUBLIC;

