-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_w_ipasgo_dados_exame_tr ( nr_interno_conta_p bigint, dt_mesano_referencia_p timestamp, nm_usuario_p text, nr_seq_tipo_fatura_p bigint, qt_linha_arq_p INOUT bigint, qt_linha_atend_p INOUT bigint) AS $body$
DECLARE



nr_atendimento_w		atendimento_paciente.nr_atendimento%type;
cd_procedimento_w	procedimento_paciente.cd_procedimento%type;
ie_origem_proced_w	procedimento_paciente.ie_origem_proced%type;
qt_procedimento_w		procedimento_paciente.qt_procedimento%type;
vl_procedimento_w		double precision;--Nao alterar as casas decimais
dt_procedimento_w		procedimento_paciente.dt_procedimento%type;
nr_matricula_prestador_w	varchar(08);
cd_convenio_parametro_w	conta_paciente.cd_convenio_parametro%type;
qt_ato_w			bigint := 1;
qt_ato_ww		bigint := 1;
nr_seq_proc_w		bigint := -1;
cd_cgc_prestador_w	procedimento_paciente.cd_cgc_prestador%type;
cd_estabelecimento_w	conta_paciente.cd_estabelecimento%type;
cd_tipo_fatura_w		fatur_tipo_fatura.cd_tipo_fatura%type;
nr_ato_ipasgo_w		procedimento_paciente.nr_ato_ipasgo%type;
cd_cgc_w		estabelecimento.cd_cgc%type;
ie_somente_anest_w	varchar(15) := 'S';

c01 CURSOR FOR
SELECT	coalesce(b.cd_procedimento_convenio,b.cd_procedimento),
	b.ie_origem_proced,
	b.qt_procedimento,
	CASE WHEN ie_somente_anest_w='S' THEN		CASE WHEN obter_se_proc_anestesista(b.nr_sequencia)='S' THEN 		coalesce((b.qt_procedimento * Obter_preco_proc_ipasgo_atend(b.nr_atendimento,b.dt_conta,b.cd_procedimento,b.ie_origem_proced,b.nr_seq_proc_interno,b.ie_responsavel_credito,'IPDE', b.nr_sequencia)),0)  ELSE (coalesce((b.qt_procedimento * Obter_preco_proc_ipasgo_atend(b.nr_atendimento,b.dt_conta,b.cd_procedimento,b.ie_origem_proced,b.nr_seq_proc_interno,b.ie_responsavel_credito,'M', b.nr_sequencia)),0) + 		coalesce((b.qt_procedimento * Obter_preco_proc_ipasgo_atend(b.nr_atendimento,b.dt_conta,b.cd_procedimento,b.ie_origem_proced,b.nr_seq_proc_interno,b.ie_responsavel_credito,'F', b.nr_sequencia)),0)) END   ELSE coalesce((b.qt_procedimento * Obter_preco_proc_ipasgo_atend(b.nr_atendimento,b.dt_conta,b.cd_procedimento,b.ie_origem_proced,b.nr_seq_proc_interno,b.ie_responsavel_credito,'IPDE', b.nr_sequencia)),0) END ,
	b.dt_procedimento,
	b.cd_cgc_prestador,
	coalesce(b.nr_ato_ipasgo,0) nr_ato_ipasgo
from	procedimento a,
	procedimento_paciente b
where	b.nr_atendimento 	= nr_atendimento_w
and	b.nr_interno_conta	= nr_interno_conta_p
and	coalesce(b.cd_motivo_exc_conta::text, '') = ''
and	a.cd_procedimento	= b.cd_procedimento
and	a.ie_origem_proced	= b.ie_origem_proced
and (obter_classif_material_proced(null, b.cd_procedimento, b.ie_origem_proced) <> 2)	/*no reg. 10 nao pode ter taxas*/
and	((cd_cgc_w not in ('02780488000142','02780488000223','02780488000304','26878439000105') and a.cd_tipo_procedimento in (1,2,3,4,5,12,13,14,15,16,20,25,26,30,31,33,34,39,74,75,85,87,91,92,94,96,97,103,116)) or (cd_cgc_w in ('02780488000142','02780488000223','02780488000304','26878439000105') and a.nr_seq_grupo_rec = 5))
and	coalesce(b.nr_seq_proc_pacote::text, '') = ''
and	coalesce(b.nr_ato_ipasgo,0) = 0
and	(CASE WHEN ie_somente_anest_w='S' THEN 		CASE WHEN obter_se_proc_anestesista(b.nr_sequencia)='S' THEN 		coalesce((b.qt_procedimento * Obter_preco_proc_ipasgo_atend(b.nr_atendimento,b.dt_conta,b.cd_procedimento,b.ie_origem_proced,b.nr_seq_proc_interno,b.ie_responsavel_credito,'IPDE', b.nr_sequencia)),0)  ELSE (coalesce((b.qt_procedimento * Obter_preco_proc_ipasgo_atend(b.nr_atendimento,b.dt_conta,b.cd_procedimento,b.ie_origem_proced,b.nr_seq_proc_interno,b.ie_responsavel_credito,'M', b.nr_sequencia)),0) + 		coalesce((b.qt_procedimento * Obter_preco_proc_ipasgo_atend(b.nr_atendimento,b.dt_conta,b.cd_procedimento,b.ie_origem_proced,b.nr_seq_proc_interno,b.ie_responsavel_credito,'F', b.nr_sequencia)),0)) END   ELSE coalesce((b.qt_procedimento * Obter_preco_proc_ipasgo_atend(b.nr_atendimento,b.dt_conta,b.cd_procedimento,b.ie_origem_proced,b.nr_seq_proc_interno,b.ie_responsavel_credito,'IPDE', b.nr_sequencia)),0) END ) > 0

union all

SELECT	coalesce(b.cd_procedimento_convenio,b.cd_procedimento),
	b.ie_origem_proced,
	b.qt_procedimento,
	coalesce((b.qt_procedimento * Obter_preco_proc_ipasgo_atend(b.nr_atendimento,b.dt_conta,b.cd_procedimento,b.ie_origem_proced,b.nr_seq_proc_interno,b.ie_responsavel_credito,'IPDE', b.nr_sequencia)),0),
	b.dt_procedimento,
	b.cd_cgc_prestador,
	coalesce(b.nr_ato_ipasgo,0) nr_ato_ipasgo
from	procedimento a,
	procedimento_paciente b
where	b.nr_atendimento 	= nr_atendimento_w
and	b.nr_interno_conta	= nr_interno_conta_p
and	coalesce(b.cd_motivo_exc_conta::text, '') = ''
and	a.cd_procedimento	= b.cd_procedimento
and	a.ie_origem_proced	= b.ie_origem_proced
and (obter_classif_material_proced(null, b.cd_procedimento, b.ie_origem_proced) <> 2)	/*no reg. 10 nao pode ter taxas*/
and (cd_cgc_w not in ('02780488000142','02780488000223','02780488000304','26878439000105') and a.cd_tipo_procedimento in (80))
and	somente_numero(coalesce(b.cd_procedimento_convenio,b.cd_procedimento)) <> 20010	/*Gerar todas as hemoterapias menos 20010 */
and	coalesce(b.nr_seq_proc_pacote::text, '') = ''
and	coalesce(b.nr_ato_ipasgo,0) = 0
and	coalesce((b.qt_procedimento * Obter_preco_proc_ipasgo_atend(b.nr_atendimento,b.dt_conta,b.cd_procedimento,b.ie_origem_proced,b.nr_seq_proc_interno,b.ie_responsavel_credito,'IPDE', b.nr_sequencia)),0) > 0
order by nr_ato_ipasgo, dt_procedimento;


BEGIN


begin
select	cd_convenio_parametro,
	nr_atendimento,
	cd_estabelecimento
into STRICT	cd_convenio_parametro_w,
	nr_atendimento_w,
	cd_estabelecimento_w
from	conta_paciente
where	nr_interno_conta = nr_interno_conta_p;
exception
when others then
	cd_convenio_parametro_w	:= 0;
	nr_atendimento_w	:= 0;
	cd_estabelecimento_w	:= 0;
end;

ie_somente_anest_w	:= coalesce(obter_valor_param_usuario(999,89,obter_perfil_ativo,nm_usuario_p,cd_estabelecimento_w),'S');

select	max(cd_tipo_fatura)
into STRICT	cd_tipo_fatura_w
from	fatur_tipo_fatura
where	ie_situacao = 'A'
and	nr_sequencia = nr_seq_tipo_fatura_p
and (cd_estabelecimento = cd_estabelecimento_w or cd_estabelecimento_w = 0);

select	coalesce(max(cd_cgc),'0')
into STRICT	cd_cgc_w
from	estabelecimento
where	cd_estabelecimento 	= cd_estabelecimento_w;

open C01;
loop
fetch C01 into
	cd_procedimento_w,
	ie_origem_proced_w,
	qt_procedimento_w,
	vl_procedimento_w,
	dt_procedimento_w,
	cd_cgc_prestador_w,
	nr_ato_ipasgo_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	select	coalesce(max(cd_prestador_convenio),'00000000')
	into STRICT	nr_matricula_prestador_w
	from	convenio_prestador
	where	cd_convenio = cd_convenio_parametro_w
	and	cd_cgc = cd_cgc_prestador_w;

	qt_linha_arq_p	:= qt_linha_arq_p + 1;
	nr_seq_proc_w 	:= nr_seq_proc_w + 1;
	
	if (cd_procedimento_w = 999999) and (cd_tipo_fatura_w = 4) then
		begin
		select	coalesce(min(nr_linha_ato),0)
		into STRICT	qt_ato_w
		from	w_ipasgo_dados_proc_trat
		where	nr_interno_conta	= nr_interno_conta_p
		and	nm_usuario		= nm_usuario_p
		and	cd_procedimento		= cd_procedimento_w;
		
		if (qt_ato_w <> qt_ato_ww) then
			begin
			qt_ato_ww := qt_ato_w;
			nr_seq_proc_w := 0;
			end;
		end if;		
		end;
	end if;
	
	if (nr_ato_ipasgo_w > 0) then
		qt_ato_w := nr_ato_ipasgo_w;
		
		if (qt_ato_w <> qt_ato_ww) then
			begin
			qt_ato_ww := qt_ato_w;
			nr_seq_proc_w := 0;
			end;
		end if;	
	end if;

	insert into w_ipasgo_dados_exame_trat(
		nr_sequencia,
		nm_usuario,
		dt_atualizacao,
		nm_usuario_nrec,
		dt_atualizacao_nrec,
		nr_linha,
		tp_registro,
		nr_linha_atend,
		nr_linha_ato,
		nr_linha_exame,
		nr_matricula_prestador,
		cd_exame,
		qt_exame,
		vl_exame,
		dt_exame,
		dt_mesano_referencia,
		nr_interno_conta,
		ds_linha,
		nr_seq_tipo_fatura,
		qt_exame_gravado,
		vl_exame_gravado,
		dt_exame_gravado)
	values (	nextval('w_ipasgo_dados_exame_trat_seq'),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		qt_linha_arq_p,
		10,
		qt_linha_atend_p,
		qt_ato_w,
		nr_seq_proc_w,
		nr_matricula_prestador_w,
		cd_procedimento_w,
		qt_procedimento_w,
		vl_procedimento_w,
		dt_procedimento_w,
		dt_mesano_referencia_p,
		nr_interno_conta_p,
		qt_linha_arq_p || '|' ||
		'10' || '|' ||
		qt_linha_atend_p || '|' ||
		qt_ato_w || '|' ||
		nr_seq_proc_w || '|' ||
		nr_matricula_prestador_w || '|' ||
		cd_procedimento_w || '|' ||
		qt_procedimento_w || '|' ||
		replace(replace(Campo_Mascara_virgula_casas(vl_procedimento_w,4),'.',''),',','.') || '|' ||
		to_char(dt_procedimento_w,'YYYY-MM-DD') || '|' ||
		'|||',
		nr_seq_tipo_fatura_p,
		qt_procedimento_w,
		replace(replace(Campo_Mascara_virgula_casas(vl_procedimento_w,4),'.',''),',','.'),
		to_char(dt_procedimento_w,'YYYY-MM-DD'));
	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_w_ipasgo_dados_exame_tr ( nr_interno_conta_p bigint, dt_mesano_referencia_p timestamp, nm_usuario_p text, nr_seq_tipo_fatura_p bigint, qt_linha_arq_p INOUT bigint, qt_linha_atend_p INOUT bigint) FROM PUBLIC;
