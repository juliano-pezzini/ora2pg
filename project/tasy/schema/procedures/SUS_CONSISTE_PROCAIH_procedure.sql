-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_consiste_procaih ( nr_interno_conta_p bigint, cd_procedimento_solic_p bigint, ie_origem_proc_solic_p bigint, cd_procedimento_real_p bigint, ie_origem_proc_real_p bigint, ie_mudanca_proc_p text, nm_usuario_p text, ie_tipo_consiste_p bigint, ds_erro_p INOUT text) AS $body$
DECLARE



/* IE_TIPO_CONSISTE_P
	- 1 Fechamento da conta
	- 2 Saida do campo
*/
ds_detalhe_w		varchar(255)	:= '';
cd_estabelecimento_w	smallint;
ds_erro_w		varchar(255)	:= '';
qt_proc_amaior_w	integer;
ie_permanencia_w	varchar(1);
qt_diarias_w		bigint	:= 0;
dt_entrada_w		timestamp;
dt_alta_w		timestamp;
qt_permanencia_w	bigint	:= 0;
qt_curta_perm_w		double precision;
cd_motivo_cobranca_w	smallint	:= 0;
ie_codigo_autorizacao_w	smallint	:= 0;
qt_proc_espec_leito_w	integer	:= 0;
cd_proc_real_conta_w	bigint;
qt_pri_aux_cesaria_w	integer;
qt_proc_anes_cesaria_w	integer;
qt_dados_aih_conta_w	bigint;
dt_periodo_inicial_w	timestamp;
dt_periodo_final_w	timestamp;
cd_modalidade_w		sus_aih_unif.cd_modalidade%type := 0;
dt_emissao_w	sus_aih_unif.dt_emissao%type;
ie_vincular_laudos_aih_w		varchar(1)	:= 'N';
nr_atendimento_w	atendimento_paciente.nr_atendimento%type;
nr_seq_interno_w			bigint	:= 0;
cd_estab_usuario_w		smallint;
dt_procedimento_w		procedimento_paciente.dt_procedimento%type;

BEGIN

ds_detalhe_w	:=	WHEB_MENSAGEM_PCK.get_texto(277313) || cd_procedimento_solic_p || ' - ' ||
			WHEB_MENSAGEM_PCK.get_texto(277314) || cd_procedimento_real_p || ' - ' ||
			WHEB_MENSAGEM_PCK.get_texto(277315) || ie_mudanca_proc_p;
			
cd_estab_usuario_w		:= coalesce(wheb_usuario_pck.get_cd_estabelecimento,0);
ie_vincular_laudos_aih_w 	:= coalesce(obter_valor_param_usuario(1123,180,obter_perfil_ativo, nm_usuario_p, null),'N');

/* Obter dados da conta e do procedimento */

select	coalesce(max(cd_estabelecimento),1)
into STRICT	cd_estabelecimento_w
from	conta_Paciente
where	nr_interno_conta	= nr_interno_conta_p;

select	coalesce(max(a.cd_procedimento),cd_procedimento_real_p),
	max(a.dt_procedimento)
into STRICT	cd_proc_real_conta_w,
	dt_procedimento_w
from	procedimento_paciente a,
	sus_valor_proc_paciente z
where	a.nr_interno_conta	= nr_interno_conta_p
and	coalesce(a.cd_motivo_exc_conta::text, '') = ''
and	a.nr_sequencia = z.nr_sequencia
and	coalesce(z.cd_registro_proc,Sus_Obter_TipoReg_Proc(a.cd_procedimento, a.ie_origem_proced, 'C', 13)) = 3;

/*
Removido para a OS 692759
select	count(1)
into	cont_modalidade_w
from	sus_modalidade_hospital
where	cd_estabelecimento	= cd_estabelecimento_w
and	cd_modalidade		= 3
and	rownum = 1;*/


/* Obter dados do atendimento e da AIH */

begin
select	coalesce(b.dt_inicial,a.dt_entrada),
	coalesce(b.dt_final,a.dt_alta),
	coalesce(b.cd_motivo_cobranca,0),
	coalesce(b.ie_codigo_autorizacao,0),
	c.dt_periodo_inicial,
	c.dt_periodo_final,
	coalesce(b.cd_modalidade,0),
	dt_emissao,
	a.nr_atendimento
into STRICT	dt_entrada_w,
	dt_alta_w,
	cd_motivo_cobranca_w,
	ie_codigo_autorizacao_w,
	dt_periodo_inicial_w,
	dt_periodo_final_w,
	cd_modalidade_w,
	dt_emissao_w,
	nr_atendimento_w
FROM atendimento_paciente a, conta_paciente c
LEFT OUTER JOIN sus_aih_unif b ON (c.nr_interno_conta = b.nr_interno_conta)
WHERE a.nr_atendimento	= c.nr_atendimento  and c.nr_interno_conta	= nr_interno_conta_p;
exception
	when others then
	begin
 	dt_entrada_w		:= null;
	dt_alta_w		:= null;
	cd_motivo_cobranca_w	:= 0;
	ie_codigo_autorizacao_w	:= 0;
	dt_periodo_inicial_w	:= null;
	dt_periodo_final_w	:= null;
	cd_modalidade_w		:= 0;
	end;
end;

if (ie_vincular_laudos_aih_w = 'S') and (coalesce(dt_emissao_w::text, '') = '') then
	
	select	coalesce(max(x.nr_seq_interno),0)
	into STRICT	nr_seq_interno_w
	from	sus_laudo_paciente x
	where	x.nr_interno_conta	= nr_interno_conta_p
	and	x.nr_atendimento	= nr_atendimento_w
	and	x.ie_classificacao 	= 1
	and	x.ie_tipo_laudo_sus 	= 1;

	if (nr_seq_interno_w = 0) then
		begin
		select	coalesce(max(x.nr_seq_interno),0)
		into STRICT	nr_seq_interno_w
		from	sus_laudo_paciente x
		where	x.nr_interno_conta	= nr_interno_conta_p
		and	x.nr_atendimento	= nr_atendimento_w
		and	x.ie_classificacao 	= 1
		and	x.ie_tipo_laudo_sus 	= 0;
		end;
	end if;
	
	if (coalesce(nr_seq_interno_w,0) > 0) then
		SELECT	dt_emissao
		into STRICT	dt_emissao_w
		from	sus_laudo_paciente
		where	nr_seq_interno = nr_seq_interno_w;
	end if;
	
end if;
	
select	count(1)
into STRICT	qt_dados_aih_conta_w
from	sus_dados_aih_conta
where	nr_interno_conta = nr_interno_conta_p  LIMIT 1;

if (qt_dados_aih_conta_w > 0) then
	begin
	
	begin
	select	coalesce(ie_codigo_autorizacao,ie_codigo_autorizacao_w),
		coalesce(cd_motivo_cobranca,cd_motivo_cobranca_w)
	into STRICT	ie_codigo_autorizacao_w,
		cd_motivo_cobranca_w
	from	sus_dados_aih_conta
	where	nr_interno_conta = nr_interno_conta_p;	
	exception
	when others then
		ie_codigo_autorizacao_w	:= 0;
		cd_motivo_cobranca_w	:= 0;
	end;
	
	end;
end if;

/* Calculo da diarias do paciente */
if (dt_periodo_inicial_w IS NOT NULL AND dt_periodo_inicial_w::text <> '') and (dt_periodo_final_w IS NOT NULL AND dt_periodo_final_w::text <> '') and (coalesce(dt_alta_w::text, '') = '') then
	qt_diarias_w := (establishment_timezone_utils.startofday(dt_periodo_final_w) - establishment_timezone_utils.startofday(dt_periodo_inicial_w));
elsif (dt_entrada_w IS NOT NULL AND dt_entrada_w::text <> '') and (dt_alta_w IS NOT NULL AND dt_alta_w::text <> '') then
	qt_diarias_w	:= (establishment_timezone_utils.startofday(dt_alta_w) - establishment_timezone_utils.startofday(dt_entrada_w));	
end if;

/*if	(dt_entrada_w is not null) and
	(dt_alta_w is not null) then
	qt_diarias_w	:= (establishment_timezone_utils.startofday(dt_alta_w) - establishment_timezone_utils.startofday(dt_entrada_w));
end if;*/
if (qt_diarias_w	= 0) then
	qt_diarias_W	:= 1;
end if;

if (qt_diarias_w > 0) and (cd_procedimento_real_p IS NOT NULL AND cd_procedimento_real_p::text <> '') then
	begin
	if (sus_validar_regra(11,cd_procedimento_real_p, ie_origem_proc_real_p,dt_procedimento_w) = 0) then
		select	coalesce(qt_dia_internacao_sus,0)
		into STRICT	qt_permanencia_w
		from	procedimento
		where	cd_procedimento		= cd_procedimento_real_p
		and	ie_origem_proced	= ie_origem_proc_real_p;
	elsif (sus_validar_regra(11,cd_procedimento_real_p, ie_origem_proc_real_p,dt_procedimento_w) > 0) then
		select	coalesce(max(a.qt_dia_internacao_sus),0)
		into STRICT	qt_permanencia_w
		from	procedimento a,
			procedimento_paciente b,
			sus_valor_proc_paciente z
		where	a.cd_procedimento	= b.cd_procedimento
		and	a.ie_origem_proced	= b.ie_origem_proced
		and	b.nr_interno_conta	= nr_interno_conta_p
		and	b.nr_sequencia		= z.nr_sequencia
		and	coalesce(b.cd_motivo_exc_conta::text, '') = ''
		and	coalesce(z.cd_registro_proc,Sus_Obter_TipoReg_Proc(b.cd_procedimento, b.ie_origem_proced, 'C', 13)) = 3;
	end if;
	exception
		when others then
		qt_permanencia_w	:= 0;
	end;
end if;

/* 6 - Procedimento realizado igual ao procedimento solicitado */

if (Sus_Obter_Inco_Ativa(6)) and (cd_procedimento_real_p IS NOT NULL AND cd_procedimento_real_p::text <> '') and (ie_mudanca_proc_p		= 'S') and (cd_procedimento_solic_p	= cd_procedimento_real_p) and (ie_origem_proc_solic_p		= ie_origem_proc_real_p) then
	if (ie_tipo_consiste_p = 1) then
		CALL sus_gravar_inconsistencia(nr_interno_conta_p, 6, ds_detalhe_w, cd_estabelecimento_w, nm_usuario_p);
	elsif (ie_tipo_consiste_p = 2) then
		ds_erro_w	:= ds_erro_w || '6, ';	
	end if;
end if;

/* 7 - Procedimento realizado diferente do procedimento solicitado */

if (Sus_Obter_Inco_Ativa(7)) and (cd_procedimento_real_p IS NOT NULL AND cd_procedimento_real_p::text <> '') and (ie_mudanca_proc_p		= 'N') and (cd_procedimento_solic_p	<> cd_procedimento_real_p) and (ie_origem_proc_solic_p		<> ie_origem_proc_real_p) then
	if (ie_tipo_consiste_p = 1) then
		CALL sus_gravar_inconsistencia(nr_interno_conta_p, 7, ds_detalhe_w, cd_estabelecimento_w, nm_usuario_p);
	elsif (ie_tipo_consiste_p = 2) then
		ds_erro_w	:= ds_erro_w || '7, ';	
	end if;
end if;

/* 23 - Procedimento solicitado nao permite mudanca de procedimento */

if (Sus_Obter_Inco_Ativa(23)) and (ie_mudanca_proc_p = 'S') and (sus_validar_regra(8, cd_procedimento_solic_p, ie_origem_proc_solic_p,dt_procedimento_w) > 0) then
	if (ie_tipo_consiste_p = 1) then
		CALL sus_gravar_inconsistencia(nr_interno_conta_p, 23, ds_detalhe_w, cd_estabelecimento_w, nm_usuario_p);
	elsif (ie_tipo_consiste_p = 2) then
		ds_erro_w	:= ds_erro_w || '23, ';	
	end if;
end if;

/* 27 - Procedimento realizado nao permite permanencia a maior */

begin
select	count(1)
into STRICT	qt_proc_amaior_w
from	procedimento_paciente
where	nr_interno_conta	= nr_interno_conta_p
and	cd_procedimento		= 0802010199
and	ie_origem_proced	= 7  LIMIT 1;
exception
when others then
	qt_proc_amaior_w := 0;
end;

begin
select	ie_permanencia
into STRICT	ie_permanencia_w
from 	sus_procedimento
where	cd_procedimento		= cd_procedimento_real_p
and	ie_origem_proced	= ie_origem_proc_real_p;
exception
when others then
	ie_permanencia_w := '';
end;

if (Sus_Obter_Inco_Ativa(27)) and (cd_procedimento_real_p IS NOT NULL AND cd_procedimento_real_p::text <> '') and (qt_proc_amaior_w > 0) and (Sus_Obter_Se_Detalhe_Proc(cd_procedimento_real_p, ie_origem_proc_real_p, '004',dt_emissao_w) = 0) then
	ds_detalhe_w	:= WHEB_MENSAGEM_PCK.get_texto(277316) || cd_procedimento_real_p || ' - ' ||
			WHEB_MENSAGEM_PCK.get_texto(277317) || qt_proc_amaior_w || ' - ' ||
			WHEB_MENSAGEM_PCK.get_texto(277318) || ie_permanencia_w;
	if (ie_tipo_consiste_p = 1) then
		CALL sus_gravar_inconsistencia(nr_interno_conta_p, 27, ds_detalhe_w, cd_estabelecimento_w, nm_usuario_p);
	end if;
end if;

/* 30 - Dias de internacao menor que a minima exigida */

qt_curta_perm_w	:= trunc(qt_permanencia_w / 2);

if (Sus_Obter_Inco_Ativa(30)) and (qt_diarias_w > 0) and (cd_modalidade_w <> 3) and (cd_motivo_cobranca_w not in (27,31,41,42,43)) and (qt_permanencia_w > 0) and (qt_diarias_w < qt_curta_perm_w) and (coalesce(sus_verificar_codigo_autor(coalesce(ie_codigo_autorizacao_w,0),'PER'),'N') = 'N') then
	ds_detalhe_w	:= WHEB_MENSAGEM_PCK.get_texto(277316) || cd_procedimento_real_p || ' - ' ||
			WHEB_MENSAGEM_PCK.get_texto(277319) || qt_diarias_w || ' - ' ||
			WHEB_MENSAGEM_PCK.get_texto(277320) || qt_curta_perm_w || ' - ' ||
			WHEB_MENSAGEM_PCK.get_texto(277321) || qt_permanencia_w;
	if (ie_tipo_consiste_p = 1) then
		CALL sus_gravar_inconsistencia(nr_interno_conta_p, 30, ds_detalhe_w, cd_estabelecimento_w, nm_usuario_p);
	end if;
end if;

/* 87 - Tipo de leito nao cadastrado para o hospital */

if (Sus_Obter_Inco_Ativa(87)) and (cd_procedimento_real_p IS NOT NULL AND cd_procedimento_real_p::text <> '') then
	begin
	
	select	count(1)
	into STRICT	qt_proc_espec_leito_w
	from	sus_espec_leito_hosp c,
		sus_espec_leito b,
		sus_procedimento_leito a
	where	c.nr_Seq_espec_leito 	= b.nr_sequencia
	and	a.nr_seq_espec_leito 	= b.nr_Sequencia
	and	a.cd_procedimento 	= cd_procedimento_real_p  LIMIT 1;
	
	ds_detalhe_w	:=	WHEB_MENSAGEM_PCK.get_texto(277313) || cd_procedimento_solic_p || ' - ' ||
				WHEB_MENSAGEM_PCK.get_texto(277314) || cd_procedimento_real_p;
				
	if (qt_proc_espec_leito_w = 0) then
		begin
		if (ie_tipo_consiste_p = 1) then
			CALL sus_gravar_inconsistencia(nr_interno_conta_p, 87, ds_detalhe_w, cd_estabelecimento_w, nm_usuario_p);
		elsif (ie_tipo_consiste_p = 2) then
			ds_erro_w	:= ds_erro_w || '87, ';	
		end if;
		end;
	end if;
	end;
end if;

if (Sus_obter_inco_ativa(139)) then
	if (cd_procedimento_real_p in (411010042, 0411010034)) then
	
		select	count(1)
		into STRICT	qt_proc_anes_cesaria_w
		from	procedimento_paciente
		where	cd_procedimento		= 0417010010
		and	coalesce(cd_motivo_Exc_conta::text, '') = ''
		and	nr_interno_conta	= nr_interno_conta_p  LIMIT 1;
		
		if (qt_proc_anes_cesaria_w	= 0) and (ie_tipo_consiste_p	= 1) then
			CALL sus_gravar_inconsistencia(nr_interno_conta_p, 139, ds_detalhe_w, cd_estabelecimento_w, nm_usuario_p);
		end if;
	end if;
end if;

if (Sus_obter_inco_ativa(140)) then
	if (cd_procedimento_real_p in (411010042, 0411010034)) then
	
		select	count(1)
		into STRICT	qt_pri_aux_cesaria_w
		from	procedimento_paciente b,
			procedimento_participante a
		where	a.nr_sequencia	= b.nr_sequencia
		and	coalesce(Sus_Obter_Indicador_Equipe(a.ie_funcao),0)	= 2
		and	b.cd_procedimento in (411010042, 0411010034)
		and	coalesce(b.cd_motivo_Exc_conta::text, '') = ''
		and	b.nr_interno_conta	= nr_interno_conta_p  LIMIT 1;
		
		if (qt_pri_aux_cesaria_w	= 0) and (ie_tipo_consiste_p	= 1) then
			CALL sus_gravar_inconsistencia(nr_interno_conta_p, 140, ds_detalhe_w, cd_estabelecimento_w, nm_usuario_p);
		end if;
	end if;
end if;

ds_erro_p	:= ds_erro_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_consiste_procaih ( nr_interno_conta_p bigint, cd_procedimento_solic_p bigint, ie_origem_proc_solic_p bigint, cd_procedimento_real_p bigint, ie_origem_proc_real_p bigint, ie_mudanca_proc_p text, nm_usuario_p text, ie_tipo_consiste_p bigint, ds_erro_p INOUT text) FROM PUBLIC;

