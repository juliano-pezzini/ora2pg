-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION ish_diagnosis_pck.ish_obter_atepacu_data (nr_atendimento_p bigint, dt_referencia_p timestamp) RETURNS bigint AS $body$
DECLARE


nr_seq_interno_w	atend_paciente_unidade.nr_seq_interno%type;


BEGIN

select	obter_atepacu_data(nr_atendimento_p,'A',dt_referencia_p)
into STRICT	nr_seq_interno_w
;

if (coalesce(nr_seq_interno_w,0) = 0) and (obter_se_atendimento_futuro(nr_atendimento_p) = 'S') then

	select	Obter_Atepacu_paciente(nr_atendimento_p,'A')
	into STRICT	nr_seq_interno_w
	;

end if;

return nr_seq_interno_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION ish_diagnosis_pck.ish_obter_atepacu_data (nr_atendimento_p bigint, dt_referencia_p timestamp) FROM PUBLIC;
