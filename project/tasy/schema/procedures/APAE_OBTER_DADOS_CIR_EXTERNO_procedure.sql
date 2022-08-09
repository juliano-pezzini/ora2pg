-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE apae_obter_dados_cir_externo ( nr_cirurgia_p bigint, qt_apae_p INOUT bigint, nr_atendimento_p INOUT bigint, cd_procedimento_princ_p INOUT bigint, ie_origem_proced_p INOUT bigint, cd_medico_cirurgiao_p INOUT text, cd_medico_anestesista_p INOUT text, dt_cirurgia_p INOUT timestamp, nr_seq_proc_interno_p INOUT bigint) AS $body$
DECLARE


qt_existe_cir_w		bigint;
qt_existe_apae_w	bigint;
nr_atendimento_w	bigint	:= 0;
cd_procedimento_princ_w	bigint;
ie_origem_proced_w	bigint;
cd_medico_cirurgiao_w	varchar(10);
cd_medico_anestesista_w varchar(10);
dt_cirurgia_w		timestamp;
nr_seq_proc_interno_w	bigint;


BEGIN

if (nr_cirurgia_p > 0) then
	begin

	select 	count(*)
	into STRICT	qt_existe_cir_w
	from 	cirurgia
	where 	nr_cirurgia = nr_cirurgia_p;

	if (qt_existe_cir_w > 0)then
		begin
		select	nr_atendimento,
			cd_procedimento_princ,
			ie_origem_proced,
			cd_medico_cirurgiao,
			cd_medico_anestesista,
			coalesce(dt_inicio_real,dt_inicio_prevista) dt_cirurgia,
			nr_seq_proc_interno
		into STRICT	nr_atendimento_w,
			cd_procedimento_princ_w,
			ie_origem_proced_w,
			cd_medico_cirurgiao_w,
			cd_medico_anestesista_w,
			dt_cirurgia_w,
			nr_seq_proc_interno_w
		from 	cirurgia
		where 	nr_cirurgia = nr_cirurgia_p;
		end;
	end if;

	select	count(*)
	into STRICT	qt_existe_apae_w
	from	aval_pre_anestesica
	where	nr_cirurgia = nr_cirurgia_p
	and	coalesce(ie_situacao,'A') = 'A';
	end;
end if;

qt_apae_p 	 	:= qt_existe_apae_w;
nr_atendimento_p 	:= nr_atendimento_w;
cd_procedimento_princ_p := cd_procedimento_princ_w;
ie_origem_proced_p 	:= ie_origem_proced_w;
cd_medico_cirurgiao_p 	:= cd_medico_cirurgiao_w;
cd_medico_anestesista_p := cd_medico_anestesista_w;
dt_cirurgia_p 		:= dt_cirurgia_w;
nr_seq_proc_interno_p := nr_seq_proc_interno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE apae_obter_dados_cir_externo ( nr_cirurgia_p bigint, qt_apae_p INOUT bigint, nr_atendimento_p INOUT bigint, cd_procedimento_princ_p INOUT bigint, ie_origem_proced_p INOUT bigint, cd_medico_cirurgiao_p INOUT text, cd_medico_anestesista_p INOUT text, dt_cirurgia_p INOUT timestamp, nr_seq_proc_interno_p INOUT bigint) FROM PUBLIC;
