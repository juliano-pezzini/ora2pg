-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_w_ipasgo_dados_ato_tr ( nr_interno_conta_p bigint, dt_mesano_referencia_p timestamp, nm_usuario_p text, nr_seq_tipo_fatura_p bigint, qt_linha_arq_p INOUT bigint, qt_linha_atend_p INOUT bigint) AS $body$
DECLARE


nr_sequencia_w		bigint;
nr_atendimento_w		atendimento_paciente.nr_atendimento%type;
dt_procedimento_w		procedimento_paciente.dt_procedimento%type;
dt_conta_w		procedimento_paciente.dt_conta%type;
ie_plantao_w		smallint := 0;
qt_ato_w			bigint := 0;
cd_convenio_parametro_w	conta_paciente.cd_convenio_parametro%type;
cd_cnpj_w		convenio.cd_cgc%type;
ie_funcao_medico_w	procedimento_paciente.ie_funcao_medico%type;
ie_w			smallint;
nr_seq_proc_hemot_w	procedimento_paciente.nr_sequencia%type;
cd_tipo_fatura_w		fatur_tipo_fatura.cd_tipo_fatura%type;
dt_inicio_ato_w		timestamp;
dt_fim_ato_w		timestamp;
cd_estabelecimento_w	conta_paciente.cd_estabelecimento%type;
ie_tipo_atendimento_w	atendimento_paciente.ie_tipo_atendimento%type;
nr_ato_ipasgo_w		procedimento_paciente.nr_ato_ipasgo%type;
qt_ato_informado_w	bigint := 0;
ie_funcao_parecer_w	procedimento_paciente.ie_funcao_medico%type;


c01 CURSOR FOR
SELECT	1,
	min(b.dt_procedimento) dt_procedimento,
	b.ie_funcao_medico,
	min(b.dt_conta) dt_conta,
	coalesce(b.nr_ato_ipasgo,0) nr_ato_ipasgo
from	procedimento a,
	procedimento_paciente b
where	b.nr_atendimento 	= nr_atendimento_w
and	b.nr_interno_conta	= nr_interno_conta_p
and	coalesce(b.cd_motivo_exc_conta::text, '') = ''
and	obter_classif_material_proced(null, b.cd_procedimento, b.ie_origem_proced) = 1
and	a.cd_procedimento	= b.cd_procedimento
and	a.ie_origem_proced	= b.ie_origem_proced
and	coalesce(b.nr_seq_proc_pacote,0) <> b.nr_sequencia
and	((coalesce(ie_funcao_parecer_w,'X') = 'X') or (b.ie_funcao_medico <> ie_funcao_parecer_w))
and	a.cd_tipo_procedimento not in (1,2,3,4,5,8,12,13,14,15,16,20,25,26,30,31,33,34,39,74,75,80,85,91,92,94,96,97,103)
and	b.cd_procedimento_convenio not in (70025,70033)	--Estes s?alto custo devem sair no union 5
and	coalesce(b.qt_procedimento,0) <> 0
and	cd_tipo_fatura_w not in (3,17)
and	obter_se_gera_ato_ipasgo(b.cd_procedimento,b.ie_origem_proced,cd_estabelecimento_w,cd_tipo_fatura_w,ie_tipo_atendimento_w,b.cd_setor_atendimento) = 'N'
and	qt_ato_informado_w = 0
group by	a.cd_tipo_procedimento,
	b.ie_funcao_medico,
	coalesce(b.nr_ato_ipasgo,0)

union all

select	2,
	b.dt_procedimento,
	b.ie_funcao_medico,
	b.dt_conta,
	coalesce(b.nr_ato_ipasgo,0) nr_ato_ipasgo
from	procedimento a,
	procedimento_paciente b
where	b.nr_atendimento 	= nr_atendimento_w
and	b.nr_interno_conta	= nr_interno_conta_p
and	coalesce(b.cd_motivo_exc_conta::text, '') = ''
and	obter_classif_material_proced(null, b.cd_procedimento, b.ie_origem_proced) = 1
and	a.cd_procedimento	= b.cd_procedimento
and	a.ie_origem_proced	= b.ie_origem_proced
and	coalesce(b.nr_seq_proc_pacote,0) <> b.nr_sequencia
and	a.cd_tipo_procedimento not in (1,2,3,4,5,12,13,14,15,16,20,25,26,30,31,34,39,74,75,80,85,91,92,94,96,97,115)
and	b.cd_procedimento_convenio not in (70025,70033)	--Estes s alto custo devem sair no union 5
and	coalesce(b.qt_procedimento,0) <> 0
and	cd_tipo_fatura_w	= 17
and	qt_ato_informado_w = 0
group by	b.dt_procedimento,
	b.ie_funcao_medico,
	b.dt_conta,
	coalesce(b.nr_ato_ipasgo,0)

union all

/*Anderson em 27/01/2011 - Gerar uma unica linha de Hemoterapia (proced. 20010)*/

select	3,
	b.dt_procedimento,
	b.ie_funcao_medico,
	b.dt_conta,
	coalesce(b.nr_ato_ipasgo,0) nr_ato_ipasgo
from	procedimento a,
	procedimento_paciente b
where	b.nr_atendimento 	= nr_atendimento_w
and	b.nr_interno_conta	= nr_interno_conta_p
and	coalesce(b.cd_motivo_exc_conta::text, '') = ''
and	obter_classif_material_proced(null, b.cd_procedimento, b.ie_origem_proced) = 1
and	a.cd_procedimento	= b.cd_procedimento
and	a.ie_origem_proced	= b.ie_origem_proced
and	a.cd_tipo_procedimento in (80)
and	coalesce(b.ie_proc_princ_atend,'N') = 'S'
and	qt_ato_informado_w = 0

union all

/*Box hora*/

select	4,
	b.dt_procedimento,
	b.ie_funcao_medico,
	b.dt_conta,
	coalesce(b.nr_ato_ipasgo,0) nr_ato_ipasgo
from	procedimento a,
	procedimento_paciente b
where	b.nr_atendimento 	= nr_atendimento_w
and	b.nr_interno_conta	= nr_interno_conta_p
and	coalesce(b.cd_motivo_exc_conta::text, '') = ''
and	obter_classif_material_proced(null, b.cd_procedimento, b.ie_origem_proced) = 2
and	a.cd_procedimento	= b.cd_procedimento
and	a.ie_origem_proced	= b.ie_origem_proced
and	coalesce(b.ie_proc_princ_atend,'S') = 'S'
and	cd_tipo_fatura_w = 8
and	qt_ato_informado_w = 0

union all

/*Alto custo*/

select	5,
	b.dt_procedimento,
	b.ie_funcao_medico,
	b.dt_conta,
	coalesce(b.nr_ato_ipasgo,0) nr_ato_ipasgo
from	procedimento a,
	procedimento_paciente b
where	b.nr_atendimento 	= nr_atendimento_w
and	b.nr_interno_conta	= nr_interno_conta_p
and	coalesce(b.cd_motivo_exc_conta::text, '') = ''
and	a.cd_procedimento	= b.cd_procedimento
and	a.ie_origem_proced	= b.ie_origem_proced
and	coalesce(b.ie_proc_princ_atend,'S') = 'S'
and	cd_tipo_fatura_w 	= 3
and	b.cd_procedimento_convenio in (70025,70033)
and	qt_ato_informado_w = 0
group by	b.dt_procedimento,
	b.ie_funcao_medico,
	b.dt_conta,
	coalesce(b.nr_ato_ipasgo,0)

union all

/*93 ?spec?co pra gerar uma linha s?OS416225*/

select	6,
	b.dt_procedimento,
	b.ie_funcao_medico,
	b.dt_conta,
	coalesce(b.nr_ato_ipasgo,0) nr_ato_ipasgo
from	procedimento a,
	procedimento_paciente b
where	b.nr_atendimento 	= nr_atendimento_w
and	b.nr_interno_conta	= nr_interno_conta_p
and	coalesce(b.cd_motivo_exc_conta::text, '') = ''
and	obter_classif_material_proced(null, b.cd_procedimento, b.ie_origem_proced) = 1
and	a.cd_procedimento	= b.cd_procedimento
and	a.ie_origem_proced	= b.ie_origem_proced
and	coalesce(b.nr_seq_proc_pacote,0) <> b.nr_sequencia
and	a.cd_tipo_procedimento = 93
and	obter_se_gera_ato_ipasgo(b.cd_procedimento,b.ie_origem_proced,cd_estabelecimento_w,cd_tipo_fatura_w,ie_tipo_atendimento_w,b.cd_setor_atendimento) = 'N'
and	coalesce(b.qt_procedimento,0) <> 0
and	cd_tipo_fatura_w 	= 3
and	qt_ato_informado_w = 0 
and 	((b.cd_procedimento_convenio <> 70033) or
	((b.cd_procedimento_convenio = 70033) and (coalesce(b.ie_proc_princ_atend,'S') = 'N')))
and 	((b.cd_procedimento_convenio <> 70025) or
	((b.cd_procedimento_convenio = 70025) and (coalesce(b.ie_proc_princ_atend,'S') = 'N')))
group by	b.dt_procedimento,
	b.ie_funcao_medico,
	b.dt_conta,
	coalesce(b.nr_ato_ipasgo,0)

union all

select	7,
	b.dt_procedimento,
	b.ie_funcao_medico,
	b.dt_conta,
	coalesce(b.nr_ato_ipasgo,0) nr_ato_ipasgo
from	procedimento_paciente b
where	b.nr_atendimento 	= nr_atendimento_w
and	b.nr_interno_conta	= nr_interno_conta_p
and	coalesce(b.cd_motivo_exc_conta::text, '') = ''
and	obter_classif_material_proced(null, b.cd_procedimento, b.ie_origem_proced) = 1
and	coalesce(b.nr_seq_proc_pacote,0) <> b.nr_sequencia
and	coalesce(b.qt_procedimento,0) <> 0
and	obter_se_gera_ato_ipasgo(b.cd_procedimento,b.ie_origem_proced,cd_estabelecimento_w,cd_tipo_fatura_w,ie_tipo_atendimento_w,b.cd_setor_atendimento) = 'S'
and	qt_ato_informado_w = 0
group by	b.dt_procedimento,
	b.ie_funcao_medico,
	b.dt_conta,
	coalesce(b.nr_ato_ipasgo,0)

union all

select	8,
	b.dt_procedimento,
	b.ie_funcao_medico,
	b.dt_conta,
	coalesce(b.nr_ato_ipasgo,0) nr_ato_ipasgo
from	procedimento_paciente b
where	b.nr_atendimento 	= nr_atendimento_w
and	b.nr_interno_conta	= nr_interno_conta_p
and	coalesce(b.cd_motivo_exc_conta::text, '') = ''
and	obter_classif_material_proced(null, b.cd_procedimento, b.ie_origem_proced) = 1
and	coalesce(b.nr_seq_proc_pacote,0) <> b.nr_sequencia
and	coalesce(b.qt_procedimento,0) <> 0
and	obter_se_gera_ato_ipasgo(b.cd_procedimento,b.ie_origem_proced,cd_estabelecimento_w,cd_tipo_fatura_w,ie_tipo_atendimento_w,b.cd_setor_atendimento) = 'S'
and	qt_ato_informado_w > 0
and	coalesce(b.nr_ato_ipasgo,0) > 0
group by	b.dt_procedimento,
	b.ie_funcao_medico,
	b.dt_conta,
	coalesce(b.nr_ato_ipasgo,0)

union all

select	9,
	min(b.dt_procedimento) dt_procedimento,
	b.ie_funcao_medico,
	min(b.dt_conta) dt_conta,
	coalesce(b.nr_ato_ipasgo,0) nr_ato_ipasgo
from	procedimento a,
	procedimento_paciente b
where	b.nr_atendimento 	= nr_atendimento_w
and	b.nr_interno_conta	= nr_interno_conta_p
and	coalesce(b.cd_motivo_exc_conta::text, '') = ''
and	obter_classif_material_proced(null, b.cd_procedimento, b.ie_origem_proced) = 1
and	a.cd_procedimento	= b.cd_procedimento
and	a.ie_origem_proced	= b.ie_origem_proced
and	coalesce(b.nr_seq_proc_pacote,0) <> b.nr_sequencia
and	((coalesce(ie_funcao_parecer_w,'X') = 'X') or (b.ie_funcao_medico <> ie_funcao_parecer_w))
and	a.cd_tipo_procedimento not in (1,2,3,4,5,8,12,13,14,15,16,20,25,26,30,31,33,34,39,74,75,80,85,91,92,94,96,97,103)
and	b.cd_procedimento_convenio not in (70025,70033)	--Estes sao alto custo devem sair no union 5
and	coalesce(b.qt_procedimento,0) <> 0
and	obter_se_gera_ato_ipasgo(b.cd_procedimento,b.ie_origem_proced,cd_estabelecimento_w,cd_tipo_fatura_w,ie_tipo_atendimento_w,b.cd_setor_atendimento) = 'N'
and	qt_ato_informado_w > 0
and 	b.ie_responsavel_credito = 'TH'
and	cd_tipo_fatura_w 	= 4
group by	a.cd_tipo_procedimento,
	b.ie_funcao_medico,
	coalesce(b.nr_ato_ipasgo,0)
order by nr_ato_ipasgo, dt_procedimento LIMIT 1;


BEGIN

begin
select	a.nr_atendimento,
	a.cd_convenio_parametro,
	a.cd_estabelecimento,
	b.ie_tipo_atendimento
into STRICT	nr_atendimento_w,
	cd_convenio_parametro_w,
	cd_estabelecimento_w,
	ie_tipo_atendimento_w
from	conta_paciente a,
	atendimento_paciente b
where	a.nr_atendimento = b.nr_atendimento
and	a.nr_interno_conta = nr_interno_conta_p;
exception
when others then
	nr_atendimento_w		:= 0;
	cd_convenio_parametro_w		:= 0;
	cd_estabelecimento_w		:= 0;
	ie_tipo_atendimento_w		:= 0;
end;

begin
select	cd_cgc
into STRICT	cd_cnpj_w
from	convenio
where	cd_convenio = cd_convenio_parametro_w;
exception
when others then
	cd_cnpj_w := '0';
end;

begin
select	cd_tipo_fatura
into STRICT	cd_tipo_fatura_w
from	fatur_tipo_fatura
where	nr_sequencia = nr_seq_tipo_fatura_p;
exception
when others then
	cd_tipo_fatura_w := 0;
end;

begin
select	count(*)
into STRICT	qt_ato_informado_w
from	procedimento_paciente
where	nr_atendimento = nr_atendimento_w
and	nr_interno_conta = nr_interno_conta_p
and	coalesce(nr_ato_ipasgo,0) > 0;
exception
when others then
	qt_ato_informado_w := 0;
end;

begin
select	coalesce(max(cd_interno),'X')			
into STRICT	ie_funcao_parecer_w
from	conversao_meio_externo
where	cd_cgc = cd_cnpj_w
and	upper(nm_tabela) 	= 'W_IPASGO_DADOS_PROF_TRAT'
and	upper(nm_atributo)	= 'CD_FUNCAO'
and	cd_externo		= '8';
exception
when others then
	ie_funcao_parecer_w := 'X';
end;

open C01;
loop
fetch C01 into
	ie_w,
	dt_procedimento_w,
	ie_funcao_medico_w,
	dt_conta_w,
	nr_ato_ipasgo_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	if (ie_w = 3) then
		select	max(b.nr_sequencia)
		into STRICT	nr_seq_proc_hemot_w
		from	procedimento a,
			procedimento_paciente b
		where	b.nr_atendimento 	= nr_atendimento_w
		and	b.nr_interno_conta	= nr_interno_conta_p
		and	coalesce(b.cd_motivo_exc_conta::text, '') = ''
		and	obter_classif_material_proced(null, b.cd_procedimento, b.ie_origem_proced) = 1
		and	a.cd_procedimento	= b.cd_procedimento
		and	a.ie_origem_proced	= b.ie_origem_proced
		and	somente_numero(coalesce(b.cd_procedimento_convenio,b.cd_procedimento)) = 20010
		and	a.cd_tipo_procedimento in (80);

		if (coalesce(nr_seq_proc_hemot_w,0) > 0) then
			select	dt_procedimento,
				ie_funcao_medico,
				dt_conta
			into STRICT	dt_procedimento_w,
				ie_funcao_medico_w,
				dt_conta_w
			from	procedimento_paciente
			where	nr_sequencia = nr_seq_proc_hemot_w;
		else
			select	max(b.nr_sequencia)
			into STRICT	nr_seq_proc_hemot_w
			from	procedimento_paciente b
			where	b.nr_atendimento 	= nr_atendimento_w
			and	b.nr_interno_conta	= nr_interno_conta_p
			and	coalesce(b.cd_motivo_exc_conta::text, '') = ''
			and	obter_classif_material_proced(null, b.cd_procedimento, b.ie_origem_proced) = 1
			and	coalesce(b.ie_proc_princ_atend,'S') = 'S';

			if (coalesce(nr_seq_proc_hemot_w,0) > 0) then
				select	dt_procedimento,
					ie_funcao_medico,
					dt_conta
				into STRICT	dt_procedimento_w,
					ie_funcao_medico_w,
					dt_conta_w
				from	procedimento_paciente
				where	nr_sequencia = nr_seq_proc_hemot_w;
			end if;
		end if;
	end if;

	begin
	select	coalesce(max(cd_externo), ie_funcao_medico_w)
	into STRICT	ie_funcao_medico_w
	from	conversao_meio_externo
	where	cd_cgc = cd_cnpj_w
	and	upper(nm_tabela) 	= 'W_IPASGO_DADOS_PROF_TRAT'
	and	upper(nm_atributo)	= 'CD_FUNCAO'
	and	cd_interno	= ie_funcao_medico_w;
	exception
	when others then
		ie_funcao_medico_w := 0;
	end;

	if (coalesce(ie_funcao_medico_w,'0') <> '8') then
		begin
		qt_linha_arq_p 	:= qt_linha_arq_p + 1;
		qt_ato_w		:= qt_ato_w + 1;

		dt_inicio_ato_w	:= dt_procedimento_w;
		dt_fim_ato_w	:= dt_conta_w;

		if (dt_procedimento_w > dt_conta_w) then
			dt_inicio_ato_w	:= dt_conta_w;
			dt_fim_ato_w	:= dt_procedimento_w;
		end if;

		if (nr_ato_ipasgo_w > 0) then
			begin
			qt_ato_w := nr_ato_ipasgo_w;
			end;
		end if;		

		insert into w_ipasgo_dados_ato_trat(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_linha,
			tp_registro,
			nr_linha_atend,
			nr_linha_ato,
			dt_inicio_ato,
			dt_fim_ato,
			ie_plantao,
			dt_mesano_referencia,
			nr_interno_conta,
			ds_linha,
			nr_seq_tipo_fatura)
		values (	nextval('w_ipasgo_dados_ato_trat_seq'),
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			qt_linha_arq_p,
			5,
			qt_linha_atend_p,
			qt_ato_w,
			dt_procedimento_w,
			dt_conta_w,
			ie_plantao_w,
			dt_mesano_referencia_p,
			nr_interno_conta_p,
			qt_linha_arq_p || '|' ||
			5 || '|' ||
			qt_linha_atend_p || '|' ||
			qt_ato_w || '|' ||
			to_char(dt_inicio_ato_w, 'YYYY-MM-DD HH24:MI:SS') || '|' ||
			to_char(dt_fim_ato_w, 'YYYY-MM-DD HH24:MI:SS') || '|' ||
			ie_plantao_w || '|' ||
			'||||||',
			nr_seq_tipo_fatura_p);
		end;
	end if;
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_w_ipasgo_dados_ato_tr ( nr_interno_conta_p bigint, dt_mesano_referencia_p timestamp, nm_usuario_p text, nr_seq_tipo_fatura_p bigint, qt_linha_arq_p INOUT bigint, qt_linha_atend_p INOUT bigint) FROM PUBLIC;
