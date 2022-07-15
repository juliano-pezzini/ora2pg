-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_w_ipasgo_dados_gerais_at ( nr_interno_conta_p bigint, dt_mesano_referencia_p timestamp, nm_usuario_p text, nr_seq_tipo_fatura_p bigint, qt_linha_arq_p INOUT bigint, qt_linha_atend_p INOUT bigint) AS $body$
DECLARE



vl_atendimento_w			double precision;
ie_tipo_atendimento_w		atendimento_paciente.ie_tipo_atendimento%type;
nr_doc_convenio_w		varchar(11);
nr_doc_convenio_proc_w		varchar(11);
dt_atendimento_w			atendimento_paciente.dt_entrada%type;
cd_cid_principal_w			varchar(05);
cd_cid_2_w			varchar(05);
nr_atendimento_w			atendimento_paciente.nr_atendimento%type;
cd_tipo_fatura_w			fatur_tipo_fatura.cd_tipo_fatura%type;
dt_periodo_inicial_w			conta_paciente.dt_periodo_inicial%type;
ie_data_conta_atend_w			varchar(15) := 'N';


BEGIN
/*
1 - Consulta
2 - Exame
3 - Tratamento Ambulatorial
4 - Internação
5 - Anestesia Capital
6 - Anestesia interior
7 - Odontologia
8 - Tratamento ambulatorial (Box hora e pronto atendimento)
9 - Hemoterapia
12 - Fonoaudiologia
13 - Fisioterapia
14 - Psicologia
17 - Fatura para conferencia
*/
ie_data_conta_atend_w := obter_param_usuario(999, 100, obter_perfil_Ativo, nm_usuario_p, Wheb_Usuario_pck.get_cd_estabelecimento, ie_data_conta_atend_w);

select	a.ie_tipo_atendimento,
	--substr(somente_numero(obter_guia_atend(b.nr_atendimento, b.cd_convenio_parametro, b.cd_categoria_parametro)),1,11) nr_doc_convenio,
	substr(elimina_caractere_especial(obter_guia_atend(b.nr_atendimento, b.cd_convenio_parametro, b.cd_categoria_parametro)),1,11) nr_doc_convenio,
	a.dt_entrada,
	0, --nvl(nvl(ipasgo_obter_valor_conta(b.nr_interno_conta,0),b.vl_conta),0) vl_conta,
	substr(elimina_caracteres_especiais(obter_cid_princ_atend_ipasgo(b.cd_estabelecimento,a.nr_atendimento)),1,5) cd_cid_principal,
	substr(elimina_caracteres_especiais(Obter_cid_secun_atendimento(b.nr_atendimento)),1,5) cd_cid_2,
	a.nr_atendimento,
	b.dt_periodo_inicial
into STRICT	ie_tipo_atendimento_w,
	nr_doc_convenio_w,
	dt_atendimento_w,
	vl_atendimento_w,
	cd_cid_principal_w,
	cd_cid_2_w,
	nr_atendimento_w,
	dt_periodo_inicial_w
from	atendimento_paciente a,
	conta_paciente b
where	a.nr_atendimento	= b.nr_atendimento
and	b.nr_interno_conta	= nr_interno_conta_p;

if (coalesce(ie_data_conta_atend_w,'N') = 'S') then
	begin
	dt_atendimento_w := coalesce(dt_periodo_inicial_w,dt_atendimento_w);
	end;
end if;

/*Tratamento para gerar a guia da conta - desdobrar a conta em 2 e gerar o numero da guia em cada uma delas - Solicitação Hemolabor  OS221877 23-11-2010*/


--select	substr(decode(somente_numero(nvl(max(b.nr_doc_convenio),max(a.nr_doc_convenio))),0,''),1,10)
select	substr(elimina_caractere_especial(coalesce(max(b.nr_doc_convenio),max(a.nr_doc_convenio))),1,11)
into STRICT	nr_doc_convenio_proc_w
from	prescr_procedimento a,
	procedimento_Paciente b
where	a.nr_sequencia 		= b.nr_sequencia_prescricao
and	a.nr_prescricao		= b.nr_prescricao
and	a.cd_procedimento		= b.cd_procedimento
and	a.ie_origem_proced 	= b.ie_origem_proced
and	b.nr_atendimento		= nr_atendimento_w
and	b.nr_interno_conta		= nr_interno_conta_p;
	
if (coalesce(nr_doc_convenio_proc_w::text, '') = '') then
	--select	substr(somente_numero(max(b.nr_doc_convenio)),1,11)
	select	substr(elimina_caractere_especial(max(b.nr_doc_convenio)),1,11)
	into STRICT	nr_doc_convenio_proc_w
	from	procedimento_Paciente b
	where	b.nr_atendimento	= nr_atendimento_w
	and	b.nr_interno_conta	= nr_interno_conta_p;
end if;

if (coalesce(nr_doc_convenio_proc_w,'X') <> 'X') and
	(((coalesce(nr_doc_convenio_w,'X') <> 'X') and (nr_doc_convenio_w <> nr_doc_convenio_proc_w)) or (coalesce(nr_doc_convenio_w,'X') = 'X')) then
	nr_doc_convenio_w := nr_doc_convenio_proc_w;
end if;

/*Fim alteração OS221877 23-11-2010*/

select	cd_tipo_fatura
into STRICT	cd_tipo_fatura_w
from	fatur_tipo_fatura
where	nr_sequencia = nr_seq_tipo_fatura_p;

if (cd_tipo_fatura_w = 2) then
	begin
	vl_atendimento_w := coalesce(ipasgo_obter_valor_conta(nr_interno_conta_p,0),0);
	end;
end if;

qt_linha_arq_p 	:= qt_linha_arq_p + 1;
qt_linha_atend_p	:= qt_linha_atend_p + 1;

insert into w_ipasgo_dados_gerais_at(
	nr_sequencia,
	nm_usuario,
	dt_atualizacao,
	nm_usuario_nrec,
	dt_atualizacao_nrec,
	nr_linha,
	tp_registro,
	nr_linha_atend,
	ie_tipo_atendimento,
	nr_atendimento,
	nr_guia,
	dt_atendimento,
	vl_atendimento,
	cd_cid_principal,
	cd_cid_2,
	cd_cid_3,
	cd_cid_4,
	cd_cid_5,
	cd_cid_6,
	dt_mesano_referencia,
	nr_interno_conta,
	ds_linha,
	nr_seq_tipo_fatura,
	cd_tipo_fatura,
	dt_atendimento_gravado,
	vl_atendimento_gravado)
values (	nextval('w_ipasgo_dados_gerais_at_seq'),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	qt_linha_arq_p,
	2,
	qt_linha_atend_p,
	ie_tipo_atendimento_w,
	nr_atendimento_w,
	somente_numero(nr_doc_convenio_w),
	dt_atendimento_w,
	vl_atendimento_w,
	cd_cid_principal_w,
	cd_cid_2_w,
	'',
	'',
	'',
	'',
	dt_mesano_referencia_p,
	nr_interno_conta_p,
	qt_linha_arq_p || '|' ||
	'2' || '|' ||
	qt_linha_atend_p || '|' ||	
	cd_tipo_fatura_w || '|' || 
	nr_doc_convenio_w || '|' || 
	to_char(dt_atendimento_w,'YYYY-MM-DD') || '|' ||
	replace(replace(Campo_Mascara_virgula_casas(vl_atendimento_w,4),'.',''),',','.') || '|' ||
	cd_cid_principal_w || '|' || 
	cd_cid_2_w || '|' ||
	'||||',
	nr_seq_tipo_fatura_p,
	cd_tipo_fatura_w,
	to_char(dt_atendimento_w,'YYYY-MM-DD'),
	replace(replace(Campo_Mascara_virgula_casas(vl_atendimento_w,4),'.',''),',','.'));
	
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_w_ipasgo_dados_gerais_at ( nr_interno_conta_p bigint, dt_mesano_referencia_p timestamp, nm_usuario_p text, nr_seq_tipo_fatura_p bigint, qt_linha_arq_p INOUT bigint, qt_linha_atend_p INOUT bigint) FROM PUBLIC;

