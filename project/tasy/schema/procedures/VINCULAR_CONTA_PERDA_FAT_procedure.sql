-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE vincular_conta_perda_fat ( cd_estabelecimento_p bigint, nr_seq_perda_p bigint, nr_interno_conta_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
dt_alta_w			timestamp;
dt_final_w			timestamp;
dt_referencia_w			timestamp;
nr_atendimento_w		bigint;
nr_interno_conta_w		bigint;
qt_dias_conta_w			bigint	:= 0;
qt_registro_w			bigint;
vl_conta_w			double precision;


BEGIN 
 
nr_interno_conta_w	:= nr_interno_conta_p;
 
select	max(dt_referencia) 
into STRICT	dt_referencia_w 
from	pre_fatur_perda 
where	nr_sequencia	= nr_seq_perda_p;
 
dt_final_w	:= fim_mes(dt_referencia_w);
 
select	count(*) 
into STRICT	qt_registro_w 
from	pre_fatur_perda_conta 
where	nr_interno_conta	= nr_interno_conta_w 
and	nr_seq_perda	= nr_seq_perda_p;
 
 
if (qt_registro_w = 0) then 
	begin 
 
	select	max(nr_atendimento) 
	into STRICT	nr_atendimento_w 
	from	conta_paciente 
	where	nr_interno_conta	= nr_interno_conta_p;
	 
	select	max(dt_alta) 
	into STRICT	dt_alta_w 
	from	atendimento_paciente 
	where	nr_atendimento		= nr_atendimento_w;
	 
	if (dt_alta_w IS NOT NULL AND dt_alta_w::text <> '') then 
	 
		qt_dias_conta_w	:= round((obter_dias_entre_datas(dt_alta_w, clock_timestamp()))::numeric,0);
	 
	end if;
	 
	select	coalesce(sum(coalesce(b.vl_procedimento,0) + coalesce(b.vl_material,0)),0) 
	into STRICT	vl_conta_w 
	from	conta_paciente_resumo b 
	where	b.nr_interno_conta	= nr_interno_conta_p 
	and	b.dt_referencia	<= dt_final_w;
	 
	 
	insert into pre_fatur_perda_conta( 
		nr_sequencia, 
		dt_atualizacao, 
		nm_usuario, 
		dt_atualizacao_nrec, 
		nm_usuario_nrec, 
		nr_seq_perda, 
		nr_interno_conta, 
		nr_lote_contabil, 
		qt_dias_conta, 
		vl_conta) 
	values (	nextval('pre_fatur_perda_conta_seq'), 
		clock_timestamp(), 
		nm_usuario_p, 
		clock_timestamp(), 
		nm_usuario_p, 
		nr_seq_perda_p, 
		nr_interno_conta_w, 
		null, 
		qt_dias_conta_w, 
		vl_conta_w);
		 
	end;
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE vincular_conta_perda_fat ( cd_estabelecimento_p bigint, nr_seq_perda_p bigint, nr_interno_conta_p bigint, nm_usuario_p text) FROM PUBLIC;
