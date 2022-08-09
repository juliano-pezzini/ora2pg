-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_recalc_prot_resp_cred ( dt_mesano_inicial_p timestamp, dt_mesano_final_p timestamp, cd_convenio_p bigint) AS $body$
DECLARE

 
nr_seq_protocolo_w		bigint;
nr_interno_conta_w			bigint;
ie_tipo_convenio_w			smallint;
nr_sequencia_w			bigint;
cd_estabelecimento_w		bigint;
cd_convenio_w			bigint;
cd_categoria_w			varchar(10);
cd_procedimento_w		bigint;
ie_origem_proced_w		bigint;
dt_procedimento_w			timestamp;
ie_tipo_atendimento_w		smallint;
cd_setor_atendimento_w		bigint;
cd_medico_executor_w		varchar(20);
cd_regra_honorario_orig_w		varchar(20);
cd_regra_honorario_w		varchar(20);
ie_conta_honorario_w		varchar(20);
ie_calcula_honorario_w		varchar(20);
cd_cgc_honorario_w		varchar(20);
cd_pessoa_honorario_w		varchar(20);
nr_seq_criterio_w			bigint;
ie_valor_informado_w		varchar(5);
cd_cgc_prestador_w		varchar(14);
nr_seq_proc_pacote_w		bigint;
ie_pacote_w			varchar(1):=	'A';
ie_carater_inter_sus_w		varchar(2);
ie_doc_executor_w			smallint;
cd_cbo_w			varchar(06);
nr_seq_proc_interno_w		bigint;
nr_seq_exame_w			bigint;

c02 CURSOR FOR 
SELECT	nr_seq_protocolo 
from	protocolo_convenio 
where	trunc(dt_mesano_referencia,'month') between trunc(dt_mesano_inicial_p,'month') and trunc(dt_mesano_final_p,'month') 
and	cd_convenio = coalesce(cd_convenio_p, cd_convenio) 
order	by 1;

c01 CURSOR FOR 
SELECT	a.nr_interno_conta 		-- contas sem pacote 
from 	conta_paciente a 
where	a.nr_seq_protocolo	 	= nr_seq_protocolo_w 
and	not exists (SELECT	1 
	from	procedimento_paciente b 
	where	a.nr_interno_conta 	= b.nr_interno_conta 
 	and	(nr_seq_proc_pacote IS NOT NULL AND nr_seq_proc_pacote::text <> '')) 
order by a.nr_interno_conta;

c03 CURSOR FOR 
SELECT	a.nr_interno_conta 		-- contas com pacote 
from 	conta_paciente a 
where	a.nr_seq_protocolo	 	= nr_seq_protocolo_w 
and	exists (SELECT	1 
	from	procedimento_paciente b 
	where	a.nr_interno_conta 	= b.nr_interno_conta 
 	and	(nr_seq_proc_pacote IS NOT NULL AND nr_seq_proc_pacote::text <> '')) 
order	by a.nr_interno_conta;

c04 CURSOR FOR 
SELECT	a.nr_sequencia, 
	b.cd_estabelecimento, 
	a.cd_convenio, 
	a.cd_categoria, 
	a.cd_procedimento, 
	a.ie_origem_proced, 
	a.dt_procedimento, 
	c.ie_tipo_atendimento, 
	a.cd_setor_atendimento, 
	a.cd_medico_executor, 
	a.ie_responsavel_credito, 
	a.ie_valor_informado, 
	a.cd_cgc_prestador, 
	a.nr_seq_proc_pacote, 
	c.ie_carater_inter_sus, 
	a.ie_doc_executor, 
	a.cd_cbo, 
	a.nr_seq_proc_interno, 
	a.nr_seq_exame 
from	atendimento_paciente c, 
	conta_paciente b, 
	procedimento_paciente a 
where	a.nr_interno_conta	= nr_interno_conta_w 
and	a.nr_interno_conta	= b.nr_interno_conta 
and	b.nr_atendimento	= c.nr_atendimento;


BEGIN 
 
open c02;
loop 
fetch c02 into 
	nr_seq_protocolo_w;
EXIT WHEN NOT FOUND; /* apply on c02 */
	open c01;
	loop 
	fetch c01 into 
		nr_interno_conta_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin 
 
		CALL recalcular_conta_paciente(nr_interno_conta_w, 'Baca');
		/*insert into logxxxx_tasy values(sysdate,'Baca',379,'nr_interno_conta: ' || nr_interno_conta_w);*/
 
 
		end;
	end loop;
	close c01;
 
	open c03;
	loop 
	fetch c03 into 
		nr_interno_conta_w;
	EXIT WHEN NOT FOUND; /* apply on c03 */
 
		open c04;
		loop 
		fetch c04 into 
			nr_sequencia_w, 
			cd_estabelecimento_w, 
			cd_convenio_w, 
			cd_categoria_w, 
			cd_procedimento_w, 
			ie_origem_proced_w, 
			dt_procedimento_w, 
			ie_tipo_atendimento_w, 
			cd_setor_atendimento_w, 
			cd_medico_executor_w, 
			cd_regra_honorario_orig_w, 
			ie_valor_informado_w, 
			cd_cgc_prestador_w, 
			nr_seq_proc_pacote_w, 
			ie_carater_inter_sus_w, 
			ie_doc_executor_w, 
			cd_cbo_w, 
			nr_seq_proc_interno_w, 
			nr_seq_exame_w;
		EXIT WHEN NOT FOUND; /* apply on c04 */
 
			begin 
			ie_pacote_w:= obter_se_pacote(nr_sequencia_w, nr_seq_proc_pacote_w);
 
			SELECT * FROM obter_regra_honorario(cd_estabelecimento_w, cd_convenio_w, cd_categoria_w, cd_procedimento_w, ie_origem_proced_w, dt_procedimento_w, ie_tipo_atendimento_w, cd_setor_atendimento_w, null, null, cd_medico_executor_w, cd_cgc_prestador_w, ie_pacote_w, ie_carater_inter_sus_w, null, cd_regra_honorario_w, ie_conta_honorario_w, ie_calcula_honorario_w, cd_cgc_honorario_w, cd_pessoa_honorario_w, nr_seq_criterio_w, null, null, null, null, null, null, null, ie_doc_executor_w, cd_cbo_w, nr_seq_proc_interno_w, nr_seq_exame_w) INTO STRICT cd_regra_honorario_w, ie_conta_honorario_w, ie_calcula_honorario_w, cd_cgc_honorario_w, cd_pessoa_honorario_w, nr_seq_criterio_w;
			end;
 
			if (ie_valor_informado_w = 'S') then 
				cd_regra_honorario_w	:= cd_regra_honorario_orig_w;
			end if;
 
			update	procedimento_paciente 
			set	ie_responsavel_credito	= cd_regra_honorario_w 
			where	nr_sequencia		= nr_sequencia_w;
 
		end loop;
		close c04;
 
	end loop;
	close c03;
end loop;
close c02;
 
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_recalc_prot_resp_cred ( dt_mesano_inicial_p timestamp, dt_mesano_final_p timestamp, cd_convenio_p bigint) FROM PUBLIC;
