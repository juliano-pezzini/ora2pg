-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE integra_evento_informatec ( nr_ramal_p bigint, cd_usuario_p text, cd_evento_p bigint, cd_estabelecimento_p bigint) AS $body$
DECLARE


nm_usuario_w		varchar(15);
cd_unidade_basica_w	varchar(10);
cd_unidade_compl_w	varchar(10);
cd_setor_atendimento_w	integer;
nr_seq_gv_w		bigint;
evt_integ_w		bigint;
cd_pessoa_fisica_w	varchar(10);
nr_seq_interno_w	bigint;
ie_aguarda_hig_w	varchar(1);


BEGIN

Select	max(a.cd_unidade_basica),
	max(a.CD_UNIDADE_COMPL),
	max(a.cd_setor_atendimento)
into STRICT	cd_unidade_basica_w,
	cd_unidade_compl_w,
	cd_setor_atendimento_w	
from	setor_Atendimento b,
	unidade_atendimento a
where	a.nr_ramal = nr_ramal_p
and    	a.ie_situacao = 'A'
and	a.cd_setor_atendimento = b.cd_setor_atendimento
and	b.cd_estabelecimento = cd_estabelecimento_p;

Select	max(a.nm_usuario),
	max(b.cd_pessoa_fisica)
into STRICT	nm_usuario_w,
	cd_pessoa_fisica_w
from	usuario a,
	pessoa_fisica b
where 	a.cd_pessoa_fisica	= b.cd_pessoa_fisica
and	b.cd_funcionario	= cd_usuario_p;

Select	max(a.nm_usuario),
	max(a.cd_pessoa_fisica)
into STRICT	nm_usuario_w,
	cd_pessoa_fisica_w
from	usuario a,
	pessoa_fisica b
where 	a.cd_pessoa_fisica	= b.cd_pessoa_fisica
and	b.cd_funcionario	= cd_usuario_p;

select 	coalesce(max(ie_evento_integracao),0)
into STRICT 	evt_integ_w
from 	regra_evento_integr_ramal
where 	ie_empresa_integ = 2
and    	cd_evento = cd_evento_p
and coalesce(cd_estabelecimento, cd_estabelecimento_p) = cd_estabelecimento_p;

/* Regras
	
	1	    Inicio de higienizacao       
	2           Fim de higienizacao           
	5           Inicio de limpeza sala cirurig 
	6           Fim de limpeza sala cirurgica  
	7           Chamado manutencao           
	8           Inicio manutencao            
	9           Fim de manutencao             */
if	((cd_evento_p in (13,14)) or (evt_integ_w > 0 AND evt_integ_w = 1)) then
	begin
	Update	Unidade_atendimento
	set	nm_usuario_higienizacao	= nm_usuario_w,
		dt_inicio_higienizacao	= clock_timestamp(),
		dt_higienizacao		 = NULL,
		ie_status_unidade	= 'H'
	where	cd_unidade_basica	= cd_unidade_basica_w
	and	cd_unidade_compl	= cd_unidade_compl_w
	and	cd_setor_atendimento	= cd_setor_atendimento_w;

	select 	max(b.nr_sequencia)
	into STRICT	nr_seq_gv_w
	from	unidade_atendimento a,
		sl_unid_atend b
	where	trunc(b.dt_prevista) = trunc(clock_timestamp())
	and 	a.cd_setor_atendimento = cd_setor_atendimento_w
	and	a.cd_unidade_basica = cd_unidade_basica_w
	and	a.cd_unidade_compl = cd_unidade_compl_w
	and	b.nr_seq_unidade = a.nr_seq_interno
	and	coalesce(b.dt_inicio::text, '') = '';
	
	if (nr_seq_gv_w > 0) then
		CALL gerar_dados_gestao_servico(nr_seq_gv_w, clock_timestamp(),clock_timestamp(),cd_pessoa_fisica_w,'I','',cd_pessoa_fisica_w,null,null,null,null);
	end if;
	end;
	
elsif	((cd_evento_p = 15) or (evt_integ_w > 0 AND evt_integ_w = 2)) then
	begin
	Update	Unidade_atendimento
	set	nm_usuario_fim_higienizacao	= nm_usuario_w,
		dt_higienizacao		= clock_timestamp(),
		ie_status_unidade	= CASE WHEN coalesce(cd_paciente_reserva,nm_pac_reserva) = NULL THEN  'L'  ELSE 'R' END
	where	cd_unidade_basica	= cd_unidade_basica_w
	and	cd_unidade_compl	= cd_unidade_compl_w
	and	cd_setor_atendimento	= cd_setor_atendimento_w;

	select 	max(b.nr_sequencia)
	into STRICT	nr_seq_gv_w
	from	unidade_atendimento a,
		sl_unid_atend b
	where	trunc(b.dt_prevista) = trunc(clock_timestamp())
	and 	a.cd_setor_atendimento = cd_setor_atendimento_w
	and	a.cd_unidade_basica = cd_unidade_basica_w
	and	a.cd_unidade_compl = cd_unidade_compl_w
	and	b.nr_seq_unidade = a.nr_seq_interno
	and	(b.dt_inicio IS NOT NULL AND b.dt_inicio::text <> '')
	and 	coalesce(b.dt_fim::text, '') = '';
	
	if (nr_seq_gv_w > 0) then
		CALL gerar_dados_gestao_servico(nr_seq_gv_w, clock_timestamp(),clock_timestamp(),cd_pessoa_fisica_w,'F','',cd_pessoa_fisica_w,null,null,null,null);
	end if;
	end;

elsif	(evt_integ_w > 0 AND evt_integ_w = 7) then
	Update	Unidade_atendimento
	set	ie_status_unidade	= 'C'
	where	cd_unidade_basica	= cd_unidade_basica_w
	and	cd_unidade_compl	= cd_unidade_compl_w
	and	cd_setor_atendimento	= cd_setor_atendimento_w
	and	coalesce(nr_atendimento::text, '') = '';

elsif	(evt_integ_w > 0 AND evt_integ_w = 8) then
	Update	Unidade_atendimento
	set	ie_status_unidade	= 'E'
	where	cd_unidade_basica	= cd_unidade_basica_w
	and	cd_unidade_compl	= cd_unidade_compl_w
	and	cd_setor_atendimento	= cd_setor_atendimento_w
	and	coalesce(nr_atendimento::text, '') = '';

elsif	(evt_integ_w > 0 AND evt_integ_w = 9) then
	
	ie_aguarda_hig_w := obter_param_usuario(75, 145, obter_perfil_ativo, nm_usuario_w, cd_estabelecimento_p, ie_aguarda_hig_w);
	
	if (ie_aguarda_hig_w = 'S') then
		Update	Unidade_atendimento
		set	ie_status_unidade	= 'G'
		where	cd_unidade_basica	= cd_unidade_basica_w
		and	cd_unidade_compl	= cd_unidade_compl_w
		and	cd_setor_atendimento	= cd_setor_atendimento_w
		and	coalesce(nr_atendimento::text, '') = '';
	else
		Update	Unidade_atendimento
		set	ie_status_unidade	= CASE WHEN coalesce(cd_paciente_reserva,nm_pac_reserva) = NULL THEN  'L'  ELSE 'R' END
		where	cd_unidade_basica	= cd_unidade_basica_w
		and	cd_unidade_compl	= cd_unidade_compl_w
		and	cd_setor_atendimento	= cd_setor_atendimento_w
		and	coalesce(nr_atendimento::text, '') = '';
	end if;
	
	select nr_seq_interno
	into STRICT nr_seq_interno_w
	from unidade_atendimento
	where	cd_unidade_basica    = cd_unidade_basica_w
	and	cd_unidade_compl     = cd_unidade_compl_w
	and 	cd_setor_atendimento = cd_setor_atendimento_w;

	CALL gerar_higienizacao_leito_unid(clock_timestamp(), nm_usuario_w,cd_estabelecimento_p, 'FM', nr_seq_interno_w, null);		

elsif	((evt_integ_w > 0) and (evt_integ_w in (5))) then
	begin
	select 	max(b.nr_sequencia)
	into STRICT	nr_seq_gv_w
	from	unidade_atendimento a,
		sl_unid_atend b
	where	trunc(b.dt_prevista) = trunc(clock_timestamp())
	and 	a.cd_setor_atendimento = cd_setor_atendimento_w
	and	a.cd_unidade_basica = cd_unidade_basica_w
	and	a.cd_unidade_compl = cd_unidade_compl_w
	and	b.nr_seq_unidade = a.nr_seq_interno
	and	coalesce(b.dt_inicio::text, '') = ''
	and 	coalesce(b.dt_fim::text, '') = '';
	
	if (nr_seq_gv_w > 0) then
		CALL gerar_dados_gestao_servico(nr_seq_gv_w, clock_timestamp(),clock_timestamp(),cd_pessoa_fisica_w,'I','',cd_pessoa_fisica_w,null,null,null,null);
	end if;
	end;

elsif	((evt_integ_w > 0) and (evt_integ_w in (6))) then
	begin
	select 	max(b.nr_sequencia)
	into STRICT	nr_seq_gv_w
	from	unidade_atendimento a,
		sl_unid_atend b
	where	trunc(b.dt_prevista) = trunc(clock_timestamp())
	and 	a.cd_setor_atendimento = cd_setor_atendimento_w
	and	a.cd_unidade_basica = cd_unidade_basica_w
	and	a.cd_unidade_compl = cd_unidade_compl_w
	and	b.nr_seq_unidade = a.nr_seq_interno
	and	(b.dt_inicio IS NOT NULL AND b.dt_inicio::text <> '')
	and 	coalesce(b.dt_fim::text, '') = '';
	
	if (nr_seq_gv_w > 0) then
		CALL gerar_dados_gestao_servico(nr_seq_gv_w, clock_timestamp(),clock_timestamp(),cd_pessoa_fisica_w,'F','',cd_pessoa_fisica_w,null,null,null,null);
	end if;
	end;	
	
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE integra_evento_informatec ( nr_ramal_p bigint, cd_usuario_p text, cd_evento_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;
