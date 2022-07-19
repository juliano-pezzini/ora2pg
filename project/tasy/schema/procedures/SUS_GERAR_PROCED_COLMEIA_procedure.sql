-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_gerar_proced_colmeia ( cd_procedimento_p text, dt_entrada_p text, dt_alta_p text, dt_execucao_p text, qt_procedimento_p text, nr_atendimento_p text, cd_cns_medico_resp_p text, cd_estabelecimento_p text, nm_usuario_p text) AS $body$
DECLARE

 
dt_entrada_unidade_w		procedimento_paciente.dt_entrada_unidade%type;
nr_seq_propaci_w		procedimento_paciente.nr_sequencia%type;
nr_seq_proc_princ_w		procedimento_paciente.nr_sequencia%type := 0;
cd_setor_atendimento_w		procedimento_paciente.cd_setor_atendimento%type;
nr_seq_atepacu_w		procedimento_paciente.nr_seq_atepacu%type;
cd_convenio_w			procedimento_paciente.cd_convenio%type;
cd_categoria_w			procedimento_paciente.cd_categoria%type;
cd_medico_responsavel_w		procedimento_paciente.cd_medico_executor%type;
cd_cgc_prestador_w		procedimento_paciente.cd_cgc_prestador%type;
dt_entrada_w			procedimento_paciente.dt_entrada_unidade%type;
dt_alta_w			timestamp;
ds_erro_w			sus_erro_imp_colmeia.ds_erro%type;
dt_execucao_w			procedimento_paciente.dt_procedimento%type;


BEGIN 
 
select	nextval('procedimento_paciente_seq') 
into STRICT	nr_seq_propaci_w
;
 
begin 
dt_entrada_w	:= to_date(dt_entrada_p,'dd/mm/yyyy hh24:mi:ss');
dt_alta_w 	:= to_date(dt_alta_p,'dd/mm/yyyy hh24:mi:ss');
dt_execucao_w	:= to_date(dt_execucao_p,'dd/mm/yyyy hh24:mi:ss');
exception 
when others then 
	ds_erro_w := substr('dt_entrada_p:'|| dt_entrada_p || ';dt_alta_p:'|| dt_alta_p || ';dt_execucao_p:'|| dt_execucao_p,1,2000);
end;
 
begin 
select	a.cd_setor_atendimento, 
	a.dt_entrada_unidade, 
	a.nr_seq_interno 
into STRICT	cd_setor_atendimento_w, 
	dt_entrada_unidade_w, 
	nr_seq_atepacu_w 
from	atend_paciente_unidade a 
where	a.nr_atendimento	= nr_atendimento_p 
and	a.dt_entrada_unidade 	= (	SELECT max(x.dt_entrada_unidade) 
					from atend_paciente_unidade x 
					where x.nr_atendimento = a.nr_atendimento);
exception 
	when others then 
	cd_setor_atendimento_w	:= null;
	dt_entrada_unidade_w	:= null;
	nr_seq_atepacu_w	:= null;
end;
 
if (coalesce(dt_entrada_unidade_w,clock_timestamp()) < dt_entrada_w) or (coalesce(dt_entrada_unidade_w,clock_timestamp()) > dt_alta_w) then 
	dt_entrada_unidade_w := dt_entrada_w;
end if;
 
if (dt_execucao_w < dt_entrada_w) or (dt_execucao_w > dt_alta_w) then 
	dt_execucao_w := dt_entrada_w;
end if;
 
begin 
select	cd_convenio, 
	cd_categoria 
into STRICT	cd_convenio_w, 
	cd_categoria_w 
from	atend_categoria_convenio 
where	nr_atendimento = nr_atendimento_p;
exception 
when others then 
	ds_erro_w := substr(ds_erro_w || wheb_mensagem_pck.get_texto(282485) || sqlerrm || ';', 2000);
end;
 
cd_medico_responsavel_w := obter_dados_pf_cns(cd_cns_medico_resp_p,'CD');
 
begin 
select	cd_cgc 
into STRICT	cd_cgc_prestador_w 
from	estabelecimento 
where	cd_estabelecimento	= cd_estabelecimento_p  LIMIT 1;
exception 
when others then 
	ds_erro_w := substr(ds_erro_w || wheb_mensagem_pck.get_texto(282485) || sqlerrm || ';', 2000);
end;
 
if (sus_obter_tiporeg_proc(cd_procedimento_p,7,'C',16) = 6) then 
	begin 
	select	coalesce(max(nr_sequencia),0) 
	into STRICT	nr_seq_proc_princ_w 
	from	procedimento_paciente 
	where	cd_procedimento	= cd_procedimento_p 
	and	dt_procedimento	= dt_entrada_w 
	and	nr_atendimento	= nr_atendimento_p;
	end;
end if;
 
if (dt_entrada_unidade_w IS NOT NULL AND dt_entrada_unidade_w::text <> '') and (cd_setor_atendimento_w IS NOT NULL AND cd_setor_atendimento_w::text <> '') and (nr_seq_atepacu_w IS NOT NULL AND nr_seq_atepacu_w::text <> '') and (cd_procedimento_p IS NOT NULL AND cd_procedimento_p::text <> '') and (dt_execucao_w IS NOT NULL AND dt_execucao_w::text <> '') and (coalesce(qt_procedimento_p,0) > 0) and (nr_seq_proc_princ_w = 0) then 
	begin 
	 
	begin 
	insert into procedimento_paciente( 
			nr_sequencia, 
			nr_atendimento, 
			dt_entrada_unidade, 
			cd_procedimento, 
			dt_procedimento, 
			qt_procedimento, 
			dt_atualizacao, 
			nm_usuario, 
			cd_setor_atendimento, 
			ie_origem_proced, 
			nr_seq_atepacu, 
			cd_convenio, 
			cd_categoria, 
			vl_procedimento, 
			vl_medico, 
			vl_anestesista, 
			vl_materiais, 
			vl_auxiliares, 
			vl_custo_operacional, 
			tx_medico, 
			tx_anestesia, 
			cd_medico_executor, 
			ie_valor_informado, 
			cd_estabelecimento_custo, 
			cd_cgc_prestador, 
			nr_interno_conta, 
			cd_setor_receita, 
			vl_adic_plant) 
		values (	nr_seq_propaci_w, 
			nr_atendimento_p, 
			dt_entrada_unidade_w, 
			cd_procedimento_p, 
			dt_execucao_w, 
			qt_procedimento_p, 
			clock_timestamp(), 
			nm_usuario_p, 
			cd_setor_atendimento_w, 
			7, 
			nr_seq_atepacu_w, 
			cd_convenio_w, 
			cd_categoria_w, 
			0, 
			0, 
			0, 
			0, 
			0, 
			0, 
			1, 
			1, 
			cd_medico_responsavel_w, 
			'N', 
			cd_estabelecimento_p, 
			cd_cgc_prestador_w, 
			null, --nr_interno_conta_p, inicialmente passaremos nulo. Verificar se obtem automaticamente nos testes 
			cd_setor_atendimento_w, 
			0);			
	exception			 
	when others then 
	ds_erro_w	:=	substr(ds_erro_w || wheb_mensagem_pck.get_texto(282485) || sqlerrm || ';', 2000);	
	end;	
 
	CALL sus_atualiza_valor_proc(nr_seq_propaci_w,nm_usuario_p);	
			 
	end;
elsif (nr_seq_proc_princ_w > 0) and (coalesce(qt_procedimento_p,0) > 0) then 
	begin 
	 
	update	procedimento_paciente 
	set	qt_procedimento = qt_procedimento_p, 
		dt_procedimento	= dt_execucao_w, 
		dt_atualizacao	= clock_timestamp(), 
		nm_usuario	= nm_usuario_p 
	where	nr_sequencia	= nr_seq_proc_princ_w;
	 
	end;
end if;
 
if (coalesce(ds_erro_w, 'X') <> 'X') then 
	begin 
	insert into sus_erro_imp_colmeia( 
		ds_erro, 
		dt_atualizacao, 
		nm_usuario, 
		dt_atualizacao_nrec, 
		nm_usuario_nrec, 
		nr_atendimento, 
		nr_seq_interno, 
		nr_sequencia) 
	values (	ds_erro_w, 
		clock_timestamp(), 
		nm_usuario_p, 
		clock_timestamp(), 
		nm_usuario_p, 
		nr_atendimento_p, 
		null, 
		nextval('sus_erro_imp_colmeia_seq'));
	end;
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_gerar_proced_colmeia ( cd_procedimento_p text, dt_entrada_p text, dt_alta_p text, dt_execucao_p text, qt_procedimento_p text, nr_atendimento_p text, cd_cns_medico_resp_p text, cd_estabelecimento_p text, nm_usuario_p text) FROM PUBLIC;

