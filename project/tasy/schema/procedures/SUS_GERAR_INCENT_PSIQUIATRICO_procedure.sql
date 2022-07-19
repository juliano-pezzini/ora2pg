-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_gerar_incent_psiquiatrico (nr_atendimento_p bigint, nr_interno_conta_p bigint, nm_usuario_p text) AS $body$
DECLARE

					
dt_entrada_w			timestamp;
dt_final_w			timestamp;
dt_alta_w			timestamp;	
qt_diarias_w			bigint;
cd_motivo_cobranca_w		smallint;
cd_procedimento_real_w		bigint;
cd_estabelecimento_w		smallint;
qt_proc_hosp_hab_w		bigint;
ie_verifica_data_alta_w		varchar(2) 	:= 'N';
nr_sequencia_w			bigint;

C01 CURSOR FOR
	SELECT	nr_sequencia	
	from	procedimento_paciente
	where	nr_interno_conta = nr_interno_conta_p
	and	cd_procedimento  = cd_procedimento_real_w;


BEGIN

ie_verifica_data_alta_w := obter_valor_param_usuario(1123,113,obter_perfil_ativo,nm_usuario_p,0);

/* Selecao das datas de entrada e alta do Paciente */

begin
select	cd_procedimento_real,
	coalesce(a.dt_inicial,b.dt_entrada),
	a.dt_final,
	coalesce(b.dt_alta,clock_timestamp()),
	a.cd_motivo_cobranca,
	b.cd_estabelecimento
into STRICT	cd_procedimento_real_w,
	dt_entrada_w,
	dt_final_w,
	dt_alta_w,
	cd_motivo_cobranca_w,
	cd_estabelecimento_w
from	atendimento_paciente	b,
	sus_aih_unif		a
where	a.nr_atendimento	= nr_atendimento_p
and	a.nr_interno_conta	= nr_interno_conta_p
and	a.nr_atendimento	= b.nr_atendimento;
exception
	when others then
	begin
	Select	dt_entrada,
		coalesce(dt_alta,clock_timestamp()),
		cd_motivo_alta,
		cd_estabelecimento
	into STRICT	dt_entrada_w,
		dt_alta_w,
		cd_motivo_cobranca_w,
		cd_estabelecimento_w
	from 	atendimento_paciente
	where	nr_atendimento	= nr_atendimento_p;
	
	select 	coalesce(max(cd_motivo_alta_sus),0)
	into STRICT	cd_motivo_cobranca_w
	from	motivo_alta
	where	cd_motivo_alta = cd_motivo_cobranca_w;	
	end;
end;

if (dt_final_w IS NOT NULL AND dt_final_w::text <> '') then
	if (ie_verifica_data_alta_w = 'S') and (dt_final_w <= dt_alta_w) then
		dt_alta_w := dt_final_w;
	elsif (ie_verifica_data_alta_w = 'N') then	
		dt_alta_w := dt_final_w;
	end if;	
end if;

/* Identificar se tem permanencia para o procedimento realizado */

qt_diarias_w	:= (establishment_timezone_utils.startofday(dt_alta_w) - establishment_timezone_utils.startofday(dt_entrada_w));

select	count(*)
into STRICT	qt_proc_hosp_hab_w
from	sus_habilitacao_hospital	a
where	a.cd_estabelecimento	= cd_estabelecimento_w
and	dt_entrada_w between coalesce(a.dt_inicio_vigencia,dt_entrada_w) and coalesce(a.dt_final_vigencia,dt_final_w)
and	a.cd_habilitacao in (601,602,603,604);
	
if (cd_procedimento_real_w	in (303170093,303170085)) and (qt_proc_hosp_hab_w > 0) and (qt_diarias_w <= 20) and (cd_motivo_cobranca_w = 19) and (dt_entrada_w >= to_date('01/11/2009','dd/mm/yyyy'))then
	begin
	open C01;
	loop
	fetch C01 into	
		nr_sequencia_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		
		update	procedimento_paciente
		set	vl_materiais 	= (vl_materiais * 1.1),
			vl_medico	= (vl_medico *1.1),
			vl_procedimento = (vl_procedimento + (vl_materiais * 0.1) + (vl_medico * 0.1)),
			ds_observacao	= substr(ds_observacao|| WHEB_MENSAGEM_PCK.get_texto(299788) ,1,255)
		where	nr_sequencia	= nr_sequencia_w;
		
		update	sus_valor_proc_paciente
		set	vl_matmed	= (vl_matmed * 1.1),
			vl_medico	= (vl_medico * 1.1)
		where 	nr_sequencia  	= nr_sequencia_w;
		
		end;
	end loop;
	close C01;
	
	end;
end if;
	
if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_gerar_incent_psiquiatrico (nr_atendimento_p bigint, nr_interno_conta_p bigint, nm_usuario_p text) FROM PUBLIC;

