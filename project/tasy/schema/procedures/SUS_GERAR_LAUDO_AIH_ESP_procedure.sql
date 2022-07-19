-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_gerar_laudo_aih_esp ( nr_interno_conta_p bigint, nm_usuario_p text) AS $body$
DECLARE


qt_proc_esp_w		bigint;
nr_laudo_sus_w		bigint;
nr_seq_interno_w		bigint;
nr_seq_laudo_w		bigint;
cd_procedimento_w	bigint;
ie_origem_proced_w	bigint;
nr_atendimento_w		bigint;
cd_medico_executor_w	varchar(15);
cd_medico_solic_w		varchar(15);
cd_medico_autorizador_w	varchar(15);
cd_estabelecimento_w	integer;
qt_procedimento_w		bigint;
nr_aih_w			bigint;
dt_procedimento_w		timestamp;
dt_periodo_inicial_w	timestamp;
nr_seq_interno_ww		bigint;
ds_erro_w		varchar(2000);
cd_medico_requisitante_w	varchar(10);	

C01 CURSOR FOR
	SELECT	a.cd_procedimento,
		a.ie_origem_proced,
		a.nr_atendimento,
		round(sum(a.qt_procedimento)),
		trunc(a.dt_procedimento,'month') dt_procedimento
	from	procedimento_paciente a
	where	a.nr_interno_conta = nr_interno_conta_p
	and	coalesce(a.cd_motivo_exc_conta::text, '') = ''
	and	exists (SELECT	1
			from	sus_regra_laudo_aih_esp x
			where	x.cd_procedimento	= a.cd_procedimento
			and	x.ie_origem_proced	= a.ie_origem_proced
			and	x.ie_situacao		= 'A')
	group by	a.cd_procedimento,
		a.ie_origem_proced,
		a.nr_atendimento,
		trunc(a.dt_procedimento,'month')
	order by cd_procedimento;

C02 CURSOR FOR
	SELECT	a.nr_seq_interno
	from	sus_laudo_paciente a
	where	a.nr_interno_conta	= nr_interno_conta_p
	and	a.ie_classificacao	= 1
	and	a.ie_tipo_laudo_sus	= 2
	and	not exists (	SELECT	1
				from	procedimento_paciente x
				where	x.nr_interno_conta = a.nr_interno_conta
				and	x.cd_procedimento = a.cd_procedimento_solic
				and	coalesce(x.cd_motivo_exc_conta::text, '') = ''
				and	trunc(x.dt_procedimento,'month') = trunc(a.dt_emissao,'month'))
	and	exists (select	1
			from	sus_regra_laudo_aih_esp x
			where	x.cd_procedimento	= a.cd_procedimento_solic
			and	x.ie_origem_proced	= a.ie_origem_proced
			and	x.ie_situacao		= 'A')
	order by nr_seq_interno;


BEGIN

begin
select	max(a.cd_estabelecimento),
	max(b.nr_aih),
	max(a.dt_periodo_inicial)
into STRICT	cd_estabelecimento_w,
	nr_aih_w,
	dt_periodo_inicial_w
FROM conta_paciente a
LEFT OUTER JOIN sus_aih_unif b ON (a.nr_interno_conta = b.nr_interno_conta)
LEFT OUTER JOIN sus_laudo_paciente c ON (a.nr_interno_conta = c.nr_interno_conta)
WHERE a.nr_interno_conta = nr_interno_conta_p;
exception
when others then
	cd_estabelecimento_w := 0;
end;

begin
select	max(cd_medico_autorizador)
into STRICT	cd_medico_autorizador_w
from	sus_parametros_aih
where	cd_estabelecimento = cd_estabelecimento_w;
exception
when others then
	cd_medico_autorizador_w := null;
end;

open C01;
loop
fetch C01 into	
	cd_procedimento_w,
	ie_origem_proced_w,
	nr_atendimento_w,
	qt_procedimento_w,
	dt_procedimento_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	if	((sus_validar_regra(7,cd_procedimento_w,ie_origem_proced_w,dt_procedimento_w) > 0) or (sus_validar_regra(13,cd_procedimento_w,ie_origem_proced_w,dt_procedimento_w) > 0) or (sus_validar_regra(28,cd_procedimento_w,ie_origem_proced_w,dt_procedimento_w) > 0) or (sus_validar_regra(31,cd_procedimento_w,ie_origem_proced_w,dt_procedimento_w) > 0)) then
		begin
		
		begin
		select	coalesce(max(nr_seq_interno),0)
		into STRICT	nr_seq_laudo_w
		from	sus_laudo_paciente
		where	nr_atendimento 		= nr_atendimento_w
		and	cd_procedimento_solic 	= cd_procedimento_w
		and	nr_interno_conta 	= nr_interno_conta_p
		and	ie_classificacao 	= 1
		and	ie_tipo_laudo_sus	= 2
		and	trunc(dt_emissao,'month') = dt_procedimento_w;
		exception
		when others then
			nr_seq_laudo_w := 0;
		end;
	
		end;
	else	
		begin
		
		begin
		select	coalesce(max(nr_seq_interno),0)
		into STRICT	nr_seq_laudo_w
		from	sus_laudo_paciente
		where	nr_atendimento 		= nr_atendimento_w
		and	cd_procedimento_solic 	= cd_procedimento_w
		and	nr_interno_conta 	= nr_interno_conta_p
		and	ie_classificacao 	= 1
		and	ie_tipo_laudo_sus	= 2
		and	trunc(dt_emissao,'month') = dt_procedimento_w;
		exception
		when others then
			nr_seq_laudo_w := 0;
		end;
		
		if (dt_procedimento_w = trunc(dt_periodo_inicial_w,'month')) then
			begin
			dt_procedimento_w := dt_periodo_inicial_w;			
			end;
		end if;	
		
		end;
	end if;
	
	if (coalesce(cd_medico_executor_w,'X') = 'X') then
		cd_medico_executor_w := cd_medico_solic_w;
	end if;
	
	if (nr_seq_laudo_w = 0) then
		begin
		
		select	coalesce(max(nr_laudo_sus),0) + 1
		into STRICT	nr_laudo_sus_w	
		from	sus_laudo_paciente
		where	nr_atendimento	= nr_atendimento_w;
					
		select	nextval('sus_laudo_paciente_seq')
		into STRICT	nr_seq_interno_w
		;
	
		insert into sus_laudo_paciente(
			nr_seq_interno,
			nr_laudo_sus,
			nr_atendimento,
			nr_interno_conta,
			nr_aih,
			ie_classificacao,
			ie_tipo_laudo_sus,
			ie_status_processo,
			ie_diaria_acomp,
			ie_diaria_uti,
			cd_procedimento_solic,
			ie_origem_proced,
			qt_procedimento_solic,
			cd_medico_responsavel,
			dt_emissao,
			dt_atualizacao,
			nm_usuario)
		values ( nr_seq_interno_w,
			nr_laudo_sus_w,
			nr_atendimento_w,
			nr_interno_conta_p,
			nr_aih_w,
			1,
			2,
			1,
			'N',
			'N',
			cd_procedimento_w,
			ie_origem_proced_w,
			qt_procedimento_w,
			cd_medico_autorizador_w,
			dt_procedimento_w,
			clock_timestamp(),
			nm_usuario_p);	
		
		end;
	else
		begin
		
		update	sus_laudo_paciente
		set	qt_procedimento_solic	= qt_procedimento_w,
			nr_interno_conta	= nr_interno_conta_p,
			dt_atualizacao 		= clock_timestamp(),
			nm_usuario		= nm_usuario_p
		where	nr_seq_interno 		= nr_seq_laudo_w;
		
		end;
	end if;
	
	end;
end loop;
close C01;

open C02;
loop
fetch C02 into	
	nr_seq_interno_ww;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin
	
	begin
	delete from sus_laudo_paciente
	where	nr_seq_interno = nr_seq_interno_ww;	
	exception
	when others then
		ds_erro_w := substr(sqlerrm(SQLSTATE),1,2000);
		CALL wheb_mensagem_pck.exibir_mensagem_abort(231091,'NR_SEQ_INTERNO='||nr_seq_interno_ww||';NR_INTERNO_CONTA='||nr_interno_conta_p||';DS_ERRO='||ds_erro_w);
		/*Não foi possível excluir o laudo #@NR_SEQ_INTERNO#@ da conta #@NR_INTERNO_CONTA#@, pois ocorreu o seguinte problema: #@DS_ERRO#@*/

	end;	
	
	end;
end loop;
close C02;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_gerar_laudo_aih_esp ( nr_interno_conta_p bigint, nm_usuario_p text) FROM PUBLIC;

