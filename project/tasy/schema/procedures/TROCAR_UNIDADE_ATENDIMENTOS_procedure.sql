-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE trocar_unidade_atendimentos (nr_atend_origem_p bigint, nr_atend_destino_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_setor_atendimento_orig_w		bigint;
CD_UNIDADE_BASICA_orig_w		varchar(10);
CD_UNIDADE_COMPL_orig_w			varchar(10);
cd_setor_atendimento_dest_w		bigint;
CD_UNIDADE_BASICA_dest_w		varchar(10);
CD_UNIDADE_COMPL_dest_w			varchar(10);
nr_seq_interno_orig_w			bigint;
nr_seq_interno_dest_w			bigint;
cd_tipo_acomodacao_orig_w		bigint;
cd_tipo_acomodacao_dest_w		bigint;
nr_paciente_unidade_w			bigint;
nr_seq_atepacu_w			bigint;
cd_estabelecimento_w			bigint;
ie_tipo_unidade_w			varchar(05);
ie_unid_atend_w				varchar(01);
ds_param_integ_hl7_w			varchar(4000);
cd_classif_setor_orig_w			varchar(15);
cd_classif_setor_dest_w			varchar(15);
ds_sep_bv_w					varchar(100);
ie_leito_monit_orig_w			varchar(1);
ie_leito_monit_dest_w			varchar(1);
dt_saida_unidade_orig_w     atend_paciente_unidade.dt_saida_unidade%type;
dt_atualizacao_at_pac_orig_w atend_paciente_unidade.dt_atualizacao%type;
nm_usuario_at_pac_orig_w 	atend_paciente_unidade.nm_usuario%type;
dt_saida_unidade_dest_w	atend_paciente_unidade.dt_saida_unidade%type;
dt_atualizacao_at_pac_dest_w	atend_paciente_unidade.dt_atualizacao%type;
nm_usuario_at_pac_dest_w 	atend_paciente_unidade.nm_usuario%type;
nr_atendimento_orig_w	unidade_atendimento.nr_atendimento%type;
nm_usuario_orig_w		unidade_atendimento.nm_usuario%type;
dt_atualizacao_orig_w	unidade_atendimento.dt_atualizacao%type;
ie_status_unidade_orig_w	unidade_atendimento.ie_status_unidade%type;
nr_atendimento_dest_w	unidade_atendimento.nr_atendimento%type;
nm_usuario_dest_w		unidade_atendimento.nm_usuario%type;
dt_atualizacao_dest_w	unidade_atendimento.dt_atualizacao%type;
ie_status_unidade_dest_w	unidade_atendimento.ie_status_unidade%type;


BEGIN

ds_sep_bv_w := obter_separador_bv;

select	cd_estabelecimento
into STRICT	cd_estabelecimento_w
from 	atendimento_paciente
where	nr_atendimento		= nr_atend_origem_p;

select	coalesce(obter_valor_param_usuario(3111, 48, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w),'N')
into STRICT	ie_unid_atend_w
;

ie_tipo_unidade_w	:= 'A';

if (ie_unid_atend_w	= 'S') then
	ie_tipo_unidade_w	:= 'IA';
end if;

begin
select	a.cd_setor_atendimento,
	a.cd_unidade_basica,
	a.cd_unidade_compl,
	a.nr_seq_interno,	
	a.cd_tipo_acomodacao,
	b.cd_classif_setor
into STRICT	cd_setor_atendimento_orig_w,
	CD_UNIDADE_BASICA_orig_w,
	CD_UNIDADE_COMPL_orig_w,
	nr_seq_interno_orig_w,	
	cd_tipo_acomodacao_orig_w,
	cd_classif_setor_orig_w
from	setor_atendimento b,
	atend_paciente_unidade a
where	b.cd_setor_atendimento = a.cd_setor_atendimento
and	a.nr_atendimento		= nr_atend_origem_p
and	coalesce(a.dt_saida_unidade::text, '') = ''
and	a.nr_seq_interno		=
	obter_atepacu_paciente(nr_atend_origem_p, ie_tipo_unidade_w);
exception
	when others then
	CALL Wheb_mensagem_pck.exibir_mensagem_abort( 262411 , 'NR_ATEND_ORIGEM_P='||nr_atend_destino_p);
end;

begin
select	a.cd_setor_atendimento,
	a.cd_unidade_basica,
	a.cd_unidade_compl,
	a.nr_seq_interno,	
	a.cd_tipo_acomodacao,
	b.cd_classif_setor
into STRICT	cd_setor_atendimento_dest_w,
	CD_UNIDADE_BASICA_dest_w,
	CD_UNIDADE_COMPL_dest_w,
	nr_seq_interno_dest_w,	
	cd_tipo_acomodacao_dest_w,
	cd_classif_setor_dest_w
from	setor_atendimento b,
	atend_paciente_unidade a
where	b.cd_setor_atendimento = a.cd_setor_atendimento
and	a.nr_atendimento		= nr_atend_destino_p
and	coalesce(a.dt_saida_unidade::text, '') = ''
and	a.nr_seq_interno		=
	obter_atepacu_paciente(nr_atend_destino_p, ie_tipo_unidade_w);
exception
	when others then
	CALL Wheb_mensagem_pck.exibir_mensagem_abort( 262411 , 'NR_ATEND_ORIGEM_P='||nr_atend_destino_p);
end;

select	coalesce(obter_se_leito_atual_monit(nr_atend_origem_p),'N')
into STRICT	ie_leito_monit_orig_w
;

select	coalesce(obter_se_leito_atual_monit(nr_atend_destino_p),'N')
into STRICT	ie_leito_monit_dest_w
;


begin
lock table unidade_atendimento in exclusive mode;

/* Setar a saida da unidade dos atendimentos */

select dt_saida_unidade, dt_atualizacao, nm_usuario
into STRICT dt_saida_unidade_orig_w, dt_atualizacao_orig_w, nm_usuario_orig_w 
from atend_paciente_unidade
where	nr_seq_interno		= nr_seq_interno_orig_w;

select dt_saida_unidade, dt_atualizacao, nm_usuario
into STRICT dt_saida_unidade_dest_w, dt_atualizacao_at_pac_dest_w, nm_usuario_at_pac_dest_w 
from atend_paciente_unidade
where	nr_seq_interno		= nr_seq_interno_dest_w;

select nr_atendimento, nm_usuario, dt_atualizacao, ie_status_unidade
into STRICT nr_atendimento_orig_w, nm_usuario_at_pac_orig_w, dt_atualizacao_at_pac_orig_w, ie_status_unidade_orig_w
from unidade_atendimento
where cd_setor_atendimento	= cd_setor_atendimento_orig_w
and	cd_unidade_basica	= cd_unidade_basica_orig_w
and	cd_unidade_compl	= cd_unidade_compl_orig_w;

select nr_atendimento, nm_usuario, dt_atualizacao, ie_status_unidade
into STRICT nr_atendimento_dest_w, nm_usuario_dest_w, dt_atualizacao_dest_w, ie_status_unidade_dest_w
from unidade_atendimento
where cd_setor_atendimento	= cd_setor_atendimento_dest_w
and	cd_unidade_basica	= cd_unidade_basica_dest_w
and	cd_unidade_compl	= cd_unidade_compl_dest_w;

update	atend_paciente_unidade
set	dt_saida_unidade	= clock_timestamp(),
	dt_atualizacao		= clock_timestamp(),
	nm_usuario		= nm_usuario_p
where	nr_seq_interno		= nr_seq_interno_orig_w;

update	atend_paciente_unidade
set	dt_saida_unidade	= clock_timestamp(),
	dt_atualizacao		= clock_timestamp(),
	nm_usuario		= nm_usuario_p
where	nr_seq_interno		= nr_seq_interno_dest_w;

update	unidade_atendimento
set	nr_atendimento	 = NULL,
	nm_usuario	= nm_usuario_p,
	dt_atualizacao	= clock_timestamp(),
	ie_status_unidade = 'L'
where	cd_setor_atendimento	= cd_setor_atendimento_orig_w
and	cd_unidade_basica	= cd_unidade_basica_orig_w
and	cd_unidade_compl	= cd_unidade_compl_orig_w;

update	unidade_atendimento
set	nr_atendimento	 = NULL,
	nm_usuario	= nm_usuario_p,
	dt_atualizacao	= clock_timestamp(),
	ie_status_unidade = 'L'
where	cd_setor_atendimento	= cd_setor_atendimento_dest_w
and	cd_unidade_basica	= cd_unidade_basica_dest_w
and	cd_unidade_compl	= cd_unidade_compl_dest_w;

commit; /* commit para liberar o lock da tabela e nao gerar deadlock da integracao GERINT*/


/* Inserir unidade atendimento origem */

select	nextval('atend_paciente_unidade_seq')
into STRICT	nr_paciente_unidade_w
;

select	coalesce(max(nr_sequencia),0) + 1
into STRICT	nr_seq_atepacu_w
from	atend_paciente_unidade
where	nr_atendimento		= nr_atend_origem_p;

insert	into atend_paciente_unidade(nr_atendimento,
	nr_sequencia,
	cd_setor_atendimento,
	cd_unidade_basica,
	cd_unidade_compl,
	dt_entrada_unidade,
	dt_atualizacao,
	nm_usuario,
	cd_tipo_acomodacao,
	dt_saida_interno,
	nr_seq_interno,
	IE_CALCULAR_DIF_DIARIA)
values (nr_atend_origem_p,
	nr_seq_atepacu_w,
	cd_setor_atendimento_dest_w,
	cd_unidade_basica_dest_w,
	cd_unidade_compl_dest_w,
	clock_timestamp(),
	clock_timestamp(),
	nm_usuario_p,
	cd_tipo_acomodacao_dest_w,
	clock_timestamp(),
	nr_paciente_unidade_w,
	'S');

insert	into log_mov(dt_atualizacao,
	nm_usuario,
	cd_log,
	ds_log)
values (clock_timestamp(),
	nm_usuario_p,
	5700,
	Wheb_mensagem_pck.get_texto(307860) || ' '  /*'Transf. unidade Atend.: '*/ || nr_atend_origem_p ||
	Wheb_mensagem_pck.get_texto(307861) || ' '  /*' Setor: '*/ || cd_setor_atendimento_orig_w || ' ' || Wheb_mensagem_pck.get_texto(307864) || ' ' /*' para '*/ || cd_setor_atendimento_dest_w ||
	Wheb_mensagem_pck.get_texto(307862) || ': ' /*' Unid: '*/ || cd_unidade_basica_orig_w || ' ' || Wheb_mensagem_pck.get_texto(307864) || ' ' /*' para '*/ || cd_unidade_basica_dest_w ||
	Wheb_mensagem_pck.get_texto(307863) || ': ' /*' Compl: '*/ || cd_unidade_compl_orig_w || ' ' || Wheb_mensagem_pck.get_texto(307864) || ' ' /*' para '*/ || cd_unidade_compl_dest_w);
 

/* Inserir unidade atendimento destino */

select	nextval('atend_paciente_unidade_seq')
into STRICT	nr_paciente_unidade_w
;

select	coalesce(max(nr_sequencia),0) + 1
into STRICT	nr_seq_atepacu_w
from	atend_paciente_unidade
where	nr_atendimento		= nr_atend_origem_p;

insert	into atend_paciente_unidade(nr_atendimento,
	nr_sequencia,
	cd_setor_atendimento,
	cd_unidade_basica,
	cd_unidade_compl,
	dt_entrada_unidade,
	dt_atualizacao,
	nm_usuario,
	cd_tipo_acomodacao,
	dt_saida_interno,
	nr_seq_interno,
	IE_CALCULAR_DIF_DIARIA)
values (nr_atend_destino_p,
	nr_seq_atepacu_w,
	cd_setor_atendimento_orig_w,
	cd_unidade_basica_orig_w,
	cd_unidade_compl_orig_w,
	clock_timestamp(),
	clock_timestamp(),
	nm_usuario_p,
	cd_tipo_acomodacao_orig_w,
	clock_timestamp(),
	nr_paciente_unidade_w,
	'S');

insert	into log_mov(dt_atualizacao,
	nm_usuario,
	cd_log,
	ds_log)
values (clock_timestamp(),
	nm_usuario_p,
	5700,
	Wheb_mensagem_pck.get_texto(307860) || ' ' /*'Transf. unidade Atend.: '*/ || nr_atend_destino_p ||
	Wheb_mensagem_pck.get_texto(307861) || ' ' /*' Setor: '*/ || cd_setor_atendimento_dest_w || ' ' || Wheb_mensagem_pck.get_texto(307864) || ' ' /*' para '*/ || cd_setor_atendimento_orig_w ||
	Wheb_mensagem_pck.get_texto(307862) || ': ' /*' Unid: '*/ || cd_unidade_basica_dest_w || ' ' || Wheb_mensagem_pck.get_texto(307864) || ' ' /*' para '*/ || cd_unidade_basica_orig_w ||
	Wheb_mensagem_pck.get_texto(307863) || ': ' /*' Compl: '*/ || cd_unidade_compl_dest_w || ' ' || Wheb_mensagem_pck.get_texto(307864) || ' ' /*' para '*/ || cd_unidade_compl_orig_w);

if	((ie_leito_monit_orig_w = 'S') or (ie_leito_monit_dest_w = 'S')) then
	begin
	ds_param_integ_hl7_w :=	'nr_atendimento=' || nr_atend_origem_p || ds_sep_bv_w ||
				'nr_seq_interno=' || nr_seq_interno_orig_w || ds_sep_bv_w ||
				'nr_atendimento_dois=' || nr_atend_destino_p || ds_sep_bv_w ||
				'nr_seq_interno_dois=' || nr_seq_interno_dest_w || ds_sep_bv_w;
	CALL gravar_agend_integracao(22, ds_param_integ_hl7_w);
	
	CALL patient_swap_tie(nm_usuario_p,nr_atend_origem_p,nr_atend_destino_p);
	
	end;
end if;

exception
	when others then
		rollback;
		
		update	atend_paciente_unidade
		set	dt_saida_unidade	= dt_saida_unidade_orig_w,
			dt_atualizacao		= dt_atualizacao_orig_w,
			nm_usuario		= nm_usuario_orig_w
		where	nr_seq_interno		= nr_seq_interno_orig_w;

		update	atend_paciente_unidade
		set	dt_saida_unidade	= dt_saida_unidade_dest_w,
			dt_atualizacao		= dt_atualizacao_at_pac_dest_w,
			nm_usuario		= nm_usuario_at_pac_dest_w
		where	nr_seq_interno		= nr_seq_interno_dest_w;

		update	unidade_atendimento
		set	nr_atendimento	= nr_atendimento_orig_w,
			nm_usuario	= nm_usuario_at_pac_orig_w,
			dt_atualizacao	= dt_atualizacao_at_pac_orig_w,
			ie_status_unidade = ie_status_unidade_orig_w
		where	cd_setor_atendimento	= cd_setor_atendimento_orig_w
		and	cd_unidade_basica	= cd_unidade_basica_orig_w
		and	cd_unidade_compl	= cd_unidade_compl_orig_w;

		update	unidade_atendimento
		set	nr_atendimento	= nr_atendimento_dest_w,
			nm_usuario	= nm_usuario_dest_w,
			dt_atualizacao	= dt_atualizacao_dest_w,
			ie_status_unidade = ie_status_unidade_dest_w
		where	cd_setor_atendimento	= cd_setor_atendimento_dest_w
		and	cd_unidade_basica	= cd_unidade_basica_dest_w
		and	cd_unidade_compl	= cd_unidade_compl_dest_w;

		commit;
end;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE trocar_unidade_atendimentos (nr_atend_origem_p bigint, nr_atend_destino_p bigint, nm_usuario_p text) FROM PUBLIC;
