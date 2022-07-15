-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE med_gerar_interf_conta_cab ( nr_seq_protocolo_p bigint, nr_seq_envio_convenio_p bigint, cd_convenio_p bigint, nr_atendimento_p bigint, nr_interno_conta_p bigint, cd_cgc_hospital_p text, cd_cgc_convenio_p text, cd_interno_p text, nm_usuario_p text, nr_sequencia_p INOUT bigint) AS $body$
DECLARE


nr_sequencia_w			bigint;
cd_proc_principal_w			bigint;
cd_proc_princ_conv_w			varchar(20);
nr_doc_convenio_w			varchar(20);
ds_proc_princ_conv_w			procedimento.ds_procedimento%type;
cd_plano_convenio_w			varchar(10);
cd_usuario_convenio_w		varchar(30);
cd_dependente_w			smallint;
dt_validade_carteira_w		timestamp;
cd_tipo_acomodacao_w			smallint;
ie_tipo_protocolo_w			smallint;
cd_setor_atendimento_w		integer		:= 0;
cd_setor_cirurgia_w			integer		:= 0;
ie_tipo_atendimento_w             	smallint;
cd_cgc_estab_w			varchar(14);
cd_interno_w				varchar(15);
nr_seq_internado_w			bigint;
ie_internado_w			varchar(1);
qt_setor_int_w			integer	:= 0;
qt_setor_ps_w				integer	:= 0;
qt_setor_cc_w				integer	:= 0;
ie_tipo_atend_real_w			smallint	:= 0;
qt_dia_internacao_w			smallint		:= 0;
nr_cirurgia_w				bigint;
cd_senha_guia_w			varchar(20);
cd_estabelecimento_w			bigint;
cd_estab_usuario_w			smallint := coalesce(wheb_usuario_pck.get_cd_estabelecimento,0);


BEGIN
ie_internado_w		:= 'N';
nr_seq_internado_w		:= 0;
ie_tipo_atendimento_w	:= 1;
ie_tipo_protocolo_w 		:= 1;
cd_setor_atendimento_w	:= null;
cd_setor_cirurgia_w		:= null;

select 	max(a.cd_cgc)
into STRICT	cd_cgc_estab_w
from	med_prot_convenio a
where	a.nr_sequencia		= nr_seq_protocolo_p
and	a.ie_beneficiario	= 'C';


/* Obter o codigo interno padrão do Atendimento */

select	coalesce(max(a.cd_interno), cd_interno_p)
into STRICT	cd_interno_w
from	param_interface a
where	a.cd_convenio			= cd_convenio_p
and	coalesce(ie_tipo_atendimento, ie_tipo_atendimento_w)	= ie_tipo_atendimento_w
and	coalesce(a.cd_cgc,cd_cgc_estab_w)	= cd_cgc_estab_w
and	coalesce(cd_estabelecimento,cd_estab_usuario_w) = cd_estab_usuario_w
and	a.nr_sequencia			=
	(SELECT max(x.nr_sequencia)
	from	param_interface x
	where	x.cd_convenio		= cd_convenio_p
	and	coalesce(ie_tipo_atendimento, ie_tipo_atendimento_w)	= ie_tipo_atendimento_w
	and	coalesce(cd_estabelecimento,cd_estab_usuario_w) = cd_estab_usuario_w
	and	x.cd_cgc		= cd_cgc_estab_w);



select 	nextval('w_interf_conta_cab_seq')
into STRICT	nr_sequencia_w
;

nr_sequencia_p		:= nr_sequencia_w;

insert into w_interf_conta_cab(
	 nr_sequencia,
	 cd_tipo_registro,
	 nr_seq_registro,
	 nr_seq_interface,
	 nr_remessa,
	 nr_interno_conta,
	 dt_periodo_inicial,
	 dt_periodo_final,
	 nr_atendimento,
	 dt_entrada,
	 dt_alta,
	 ie_tipo_atendimento,
	 cd_motivo_alta,
	 ie_retorno,
	 ie_clinica,
	 ie_carater_inter,
	 cd_medico_resp,
	 cd_paciente,
	 nm_paciente,
	 dt_nascimento,
	 ie_sexo,
	 ie_estado_civil,
	 nr_cpf_paciente,
	 nr_identidade,
	 nr_prontuario,
	 cd_nacionalidade,
	 nr_cert_nasc,
	 dt_obito,
	 nm_medico_resp,
	 nr_cpf_medico_resp,
	 nr_crm_medico_resp,
	 uf_crm_medico_resp,
	 cd_conv_medico_resp,
	 cd_proc_principal,
	 ds_proc_principal,
	 cd_cid_principal,
	 cd_cid_secundario,
	 ie_tipo_paciente,
	 cd_classe_atendimento,
	 nr_seq_protocolo,
	 cd_convenio,
	 cd_cgc_hospital,
	 cd_cgc_convenio,
	 cd_interno,
	 ie_tipo_protocolo,
	 cd_setor_atendimento,
	 cd_setor_cirurgia,
	 ie_medico_credenciado,
	 ie_carater_sus,
	 cd_categoria_convenio,
	ie_tipo_nascimento,
	ie_tipo_atend_real,
	nm_usuario)
SELECT
	 nr_sequencia_w,
	 1,
	 1,
	 1,
	 nr_seq_envio_convenio_p,
	 b.nr_atendimento,
	 c.dt_inicio,
	 c.dt_fim,
	 b.nr_atendimento,
	 b.dt_entrada,
	 b.dt_saida,
 	 0,
	 null,
	 CASE WHEN coalesce(b.nr_atend_original::text, '') = '' THEN 'N'  ELSE 'S' END ,
	 0,
	 null,
	 c.cd_medico,
	 d.cd_pessoa_fisica,
	 Elimina_Acentuacao(SUBSTR(OBTER_NOME_PF(e.CD_PESSOA_FISICA), 0, 80)),
	 e.dt_nascimento,
	 e.ie_sexo,
	 e.ie_estado_civil,
	 e.nr_cpf,
	 e.nr_identidade,
	 e.nr_prontuario,
	 e.cd_nacionalidade,
	 e.nr_cert_nasc,
	 e.dt_obito,
	 Elimina_Acentuacao(SUBSTR(OBTER_NOME_PF(f.CD_PESSOA_FISICA), 0, 80)),
	 f.nr_cpf,
	 g.nr_crm,
	 substr(g.uf_crm,1,2),
	 Obter_Medico_Convenio(cd_estabelecimento_w,c.cd_medico,cd_convenio_p, null, null, null, null,null, null,null,null),
	 '',
	 '',
	 null,
	 null,
	 'E',
	 null,
	 nr_seq_protocolo_p,
	 cd_convenio_p,
	 cd_cgc_hospital_p,
	 cd_cgc_convenio_p,
	 cd_interno_w,
	 ie_tipo_protocolo_w,
	 cd_setor_atendimento_w,
	 cd_setor_cirurgia_w,
	 coalesce(g.ie_conveniado_sus,'N'),
	 null,
	 null,
	 null,
	 null,
	 nm_usuario_p
from	 Medico g,
	 Pessoa_Fisica f,
	 Pessoa_Fisica e,
	 med_cliente d,
	 med_prot_convenio c,
	 med_atendimento b
where  	b.nr_seq_cliente	= d.nr_sequencia
and	d.cd_pessoa_fisica	= e.cd_pessoa_fisica
and	c.cd_medico		= f.cd_pessoa_fisica
and	f.cd_pessoa_fisica	= g.cd_pessoa_fisica
and	b.nr_atendimento	= nr_atendimento_p
and	c.nr_sequencia		= nr_seq_protocolo_p;

/* Obter procedimento_principal */

cd_proc_principal_w	:= 0;
cd_proc_princ_conv_w	:= 0;
ds_proc_princ_conv_w	:= '';

select 	max(nr_seq_plano),
	max(cd_usuario_convenio),
	null,
	max(dt_validade_carteira),
	null,
	null,
	null,
	null
into STRICT	cd_plano_convenio_w,
	cd_usuario_convenio_w,
	cd_dependente_w,
	dt_validade_carteira_w,
	cd_tipo_acomodacao_w,
	nr_doc_convenio_w,
	qt_dia_internacao_w,
	cd_senha_guia_w
from	med_atendimento
where	nr_atendimento		= nr_atendimento_p;

if (ie_internado_w = 'N') then
	cd_tipo_acomodacao_w := 0;
end if;

qt_setor_ps_w		:= 0;
qt_setor_cc_w		:= 0;
qt_setor_int_w		:= 0;
ie_tipo_atend_real_w	:= 7;
nr_cirurgia_w		:= null;


update w_interf_conta_cab
set	cd_proc_principal	= cd_proc_princ_conv_w,
	ds_proc_principal	= substr(ds_proc_princ_conv_w,1,50),
	cd_plano_convenio	= cd_plano_convenio_w,
	cd_usuario_convenio	= cd_usuario_convenio_w,
	cd_dependente		= cd_dependente_w,
	dt_validade_carteira	= dt_validade_carteira_w,
	cd_tipo_acomodacao	= cd_tipo_acomodacao_w,
	nr_doc_convenio		= nr_doc_convenio_w,
	ie_tipo_atend_real	= ie_tipo_atend_real_w,
	qt_dia_internacao	= qt_dia_internacao_w,
	nr_cirurgia		= nr_cirurgia_w,
	cd_senha_guia		= cd_senha_guia_w
where	nr_sequencia		= nr_sequencia_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE med_gerar_interf_conta_cab ( nr_seq_protocolo_p bigint, nr_seq_envio_convenio_p bigint, cd_convenio_p bigint, nr_atendimento_p bigint, nr_interno_conta_p bigint, cd_cgc_hospital_p text, cd_cgc_convenio_p text, cd_interno_p text, nm_usuario_p text, nr_sequencia_p INOUT bigint) FROM PUBLIC;

