-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_unidade_atendimento ( nr_atendimento_p bigint, ie_opcao_p text, ie_informacao_p text) RETURNS varchar AS $body$
DECLARE


/* Opcao							*/


/*	P = Primeira Unidade         				*/


/* 	A = Unidade Atual  					*/


/*	PI = Primeira Unidade Internacao			*/


/*	IA = Internacao Atual				*/


/*	IAA = Internacao Atual ou Unidade Atual 		*/


/*	IAAP = Internacao Atual ou Unidade Atual e PS	*/


/*	MTI = Maior tempo unidade internacao, CC ou UTI	*/




/* Informacao						
	U = Unidade
 	S = Setor Atendimento
 	SU = Setor Atendimento/unidade
	CS = Codigo Setor
	DSU = Descricao a Unidade
	CTA = Codigo Tipo Acomodacao
	DTA = Descricao Tipo Acomodacao
	UPA = Unidade/Unidades do Pronto Atendimento
	SCURTO = Nome Curto do setor
	CL = Classificacao do setor 
	UB = Unidade basica
	UC = Unidade complementar
	NR = Sequencia interna
	DT = Data entrada unidade
	RA = Ramal
	TL = Telefone setor
	SAU = Setor Atendimento/Unidade  com "/" barra.
	DTR = Data entrada real
	UDTR = Usuario de registro da Entrada Real de Paciente 
	LA = Leito adaptado
*/
cd_unidade_basica_w		varchar(010);
cd_unidade_compl_w		varchar(010);
ds_setor_atendimento_w		varchar(100);
ds_unidade_w			varchar(255);
cd_setor_atendimento_w		bigint;
nm_unidade_basica_w		varchar(020);
nm_unidade_compl_w		varchar(020);
cd_tipo_acomodacao_w		smallint;
ds_tipo_acomodacao_w		varchar(40);
ds_unidade_pa_w			varchar(20);
nm_curto_w			varchar(15);
cd_classif_setor_w		varchar(15);
nr_seq_interno_w		bigint;
nr_seq_interno_ww		bigint;
dt_entrada_unidade_w		varchar(20);
nr_ramal_w			integer;
nr_telefone_w			varchar(40);


BEGIN

if (coalesce(nr_atendimento_p,0) > 0) then
	begin
	nr_seq_interno_ww	:= obter_atepacu_paciente(nr_atendimento_p, ie_opcao_p);
	if (ie_informacao_p = 'S') then
		begin
		select 	b.ds_setor_atendimento
		into STRICT	ds_unidade_w
		from	Setor_Atendimento b,
			atend_paciente_unidade a
		where	a.nr_seq_interno = nr_seq_interno_ww
		  and	a.cd_setor_atendimento	= b.cd_setor_atendimento;
		exception
			when others then
				ds_unidade_w	:= '';
		end;
	elsif (ie_informacao_p = 'UB') then
		begin
		select 	a.cd_unidade_basica
		into STRICT	ds_unidade_w
		from	atend_paciente_unidade a
		where	a.nr_seq_interno = nr_seq_interno_ww;
		exception
			when others then
				ds_unidade_w	:= '';
		end;
	elsif (ie_informacao_p = 'UC') then
		begin
		select 	a.cd_unidade_compl
		into STRICT	ds_unidade_w
		from	atend_paciente_unidade a
		where	a.nr_seq_interno = nr_seq_interno_ww;
		exception
			when others then
				ds_unidade_w	:= '';
		end;
	elsif (ie_informacao_p = 'CS') then
		begin
		select 	a.cd_setor_atendimento
		into STRICT	ds_unidade_w
		from	atend_paciente_unidade a
		where	a.nr_seq_interno = nr_seq_interno_ww;
		exception
			when others then
				ds_unidade_w	:= '';
		end;
	elsif (ie_informacao_p = 'CL') then
		begin
		select 	b.cd_classif_setor
		into STRICT	ds_unidade_w
		from	Setor_Atendimento b,
			atend_paciente_unidade a
		where	a.nr_seq_interno = nr_seq_interno_ww
		  and	a.cd_setor_atendimento	= b.cd_setor_atendimento;
		exception
			when others then
				ds_unidade_w	:= '';
		end;
	elsif (ie_informacao_p = 'U') then
		begin
		select 	a.cd_unidade_basica,
			a.cd_unidade_compl
		into STRICT	cd_unidade_basica_w,
			cd_unidade_compl_w
		from	atend_paciente_unidade a
		where	a.nr_seq_interno = nr_seq_interno_ww;
		exception
			when others then
				cd_unidade_basica_w	:= '';
				cd_unidade_compl_w	:= '';
		end;
		ds_unidade_w	:= cd_unidade_basica_w || ' ' || cd_unidade_compl_w;
	elsif (ie_informacao_p = 'SU') then
		begin
		select 	b.ds_setor_atendimento,
			a.cd_unidade_basica,
			a.cd_unidade_compl
		into STRICT	ds_setor_atendimento_w,
			cd_unidade_basica_w,
			cd_unidade_compl_w
		from	Setor_Atendimento b,
			atend_paciente_unidade a
		where	a.nr_seq_interno = nr_seq_interno_ww
		  and	a.cd_setor_atendimento	= b.cd_setor_atendimento;
		exception
			when others then
				ds_setor_atendimento_w	:= '';
				cd_unidade_basica_w	:= '';
				cd_unidade_compl_w	:= '';
		end;
		ds_unidade_w	:= ds_setor_atendimento_w || ' ' ||
					cd_unidade_basica_w || ' ' || cd_unidade_compl_w;
	elsif (ie_informacao_p = 'DSU') then
		begin
		select 	b.nm_unidade_basica,
			b.nm_unidade_compl
		into STRICT	nm_unidade_basica_w,
			nm_unidade_compl_w
		from	Setor_Atendimento b,
			atend_paciente_unidade a
		where	a.nr_seq_interno = nr_seq_interno_ww
		  and	a.cd_setor_atendimento	= b.cd_setor_atendimento;
		exception
			when others then
				nm_unidade_basica_w	:= '';
				nm_unidade_compl_w	:= '';
		end;
		ds_unidade_w	:= nm_unidade_basica_w || ' ' || nm_unidade_compl_w;
	elsif (ie_informacao_p = 'CTA') then
		begin
		select 	a.cd_setor_atendimento,
			a.cd_unidade_basica,
			a.cd_unidade_compl
		into STRICT	cd_setor_atendimento_w,
			cd_unidade_basica_w,
			cd_unidade_compl_w
		from	atend_paciente_unidade a
		where	a.nr_seq_interno = nr_seq_interno_ww;
		exception
			when others then
				cd_setor_atendimento_w	:= 0;
				cd_unidade_basica_w	:= '';
				cd_unidade_compl_w	:= '';
		end;
		
		begin
		select	a.cd_tipo_acomodacao
		into STRICT	ds_unidade_w
		from	unidade_atendimento a
		where	a.cd_setor_atendimento	= cd_setor_atendimento_w
		and	a.cd_unidade_basica	= cd_unidade_basica_w
		and	a.cd_unidade_compl	= cd_unidade_compl_w;
		exception
			when others then
				ds_unidade_w	:= '';
		end;
	elsif (ie_informacao_p = 'DTA') then
		begin
		select 	a.cd_setor_atendimento,
			a.cd_unidade_basica,
			a.cd_unidade_compl
		into STRICT	cd_setor_atendimento_w,
			cd_unidade_basica_w,
			cd_unidade_compl_w
		from	atend_paciente_unidade a
		where	a.nr_seq_interno = nr_seq_interno_ww;
		exception
			when others then
				cd_setor_atendimento_w	:= 0;
				cd_unidade_basica_w	:= '';
				cd_unidade_compl_w	:= '';
		end;
		
		begin
		select	b.ds_tipo_acomodacao
		into STRICT	ds_unidade_w
		from	tipo_acomodacao b,
			unidade_atendimento a
		where	a.cd_tipo_acomodacao	= b.cd_tipo_acomodacao
		and	a.cd_setor_atendimento	= cd_setor_atendimento_w
		and	a.cd_unidade_basica	= cd_unidade_basica_w
		and	a.cd_unidade_compl	= cd_unidade_compl_w;
		exception
			when others then
				ds_unidade_w	:= '';
		end;
	elsif (ie_informacao_p = 'SCURTO') then
		begin
		select 	b.nm_curto
		into STRICT	ds_unidade_w
		from	Setor_Atendimento b,
			atend_paciente_unidade a
		where	a.nr_seq_interno = nr_seq_interno_ww
		  and	a.cd_setor_atendimento	= b.cd_setor_atendimento;
		exception
			when others then
				ds_unidade_w	:= '';
		end;
	elsif (ie_informacao_p = 'NR') then
		begin
		select 	a.cd_setor_atendimento,
			a.cd_unidade_basica,
			a.cd_unidade_compl
		into STRICT	cd_setor_atendimento_w,
			cd_unidade_basica_w,
			cd_unidade_compl_w
		from	atend_paciente_unidade a
		where	a.nr_seq_interno = nr_seq_interno_ww;
		exception
			when others then
				cd_setor_atendimento_w	:= 0;
				cd_unidade_basica_w	:= '';
				cd_unidade_compl_w	:= '';
		end;
		
		begin
		select	a.nr_seq_interno
		into STRICT	ds_unidade_w
		from	unidade_atendimento a
		where	a.cd_setor_atendimento	= cd_setor_atendimento_w
		and	a.cd_unidade_basica	= cd_unidade_basica_w
		and	a.cd_unidade_compl	= cd_unidade_compl_w;
		exception
			when others then
				ds_unidade_w	:= '';
		end;
	elsif (ie_informacao_p = 'DT') then
		begin
		select 	to_char(a.dt_entrada_unidade,'dd/mm/yyyy hh24:mi:ss')
		into STRICT	ds_unidade_w
		from	atend_paciente_unidade a
		where	a.nr_seq_interno = nr_seq_interno_ww;
		exception
			when others then
				ds_unidade_w	:= '';
		end;
	elsif (ie_informacao_p = 'DTR') then
		begin
		select 	to_char(a.dt_entrada_real,'dd/mm/yyyy hh24:mi:ss')
		into STRICT	ds_unidade_w
		from	atend_paciente_unidade a
		where	a.nr_seq_interno = nr_seq_interno_ww;
		exception
			when others then
				ds_unidade_w	:= '';
		end; 		
	elsif (ie_informacao_p = 'UDTR') then
		begin
		select 	max(nm_usuario_real)
		into STRICT	ds_unidade_w
		from	atend_paciente_unidade a
		where	a.nr_seq_interno = nr_seq_interno_ww;
		exception
			when others then
				ds_unidade_w	:= '';
		end;
	elsif (ie_informacao_p = 'RA') then
		begin
		select 	a.cd_setor_atendimento,
			a.cd_unidade_basica,
			a.cd_unidade_compl
		into STRICT	cd_setor_atendimento_w,
			cd_unidade_basica_w,
			cd_unidade_compl_w
		from	atend_paciente_unidade a
		where	a.nr_seq_interno = nr_seq_interno_ww;
		exception
			when others then
				cd_setor_atendimento_w	:= 0;
				cd_unidade_basica_w	:= '';
				cd_unidade_compl_w	:= '';
		end;
		
		begin
		select	a.nr_ramal
		into STRICT	ds_unidade_w
		from	unidade_atendimento a
		where	a.cd_setor_atendimento	= cd_setor_atendimento_w
		and	a.cd_unidade_basica	= cd_unidade_basica_w
		and	a.cd_unidade_compl	= cd_unidade_compl_w;
		exception
			when others then
				ds_unidade_w	:= '';
		end;
	elsif (ie_informacao_p = 'TL') then
		begin
		select 	b.nr_telefone
		into STRICT	ds_unidade_w
		from	Setor_Atendimento b,
			atend_paciente_unidade a
		where	a.nr_seq_interno = nr_seq_interno_ww
		  and	a.cd_setor_atendimento	= b.cd_setor_atendimento;
		exception
			when others then
				ds_unidade_w	:= '';
		end;
	elsif (ie_informacao_p = 'SAU') then
		begin
		select 	b.ds_setor_atendimento,
			a.cd_unidade_basica,
			a.cd_unidade_compl
		into STRICT	ds_setor_atendimento_w,
			cd_unidade_basica_w,
			cd_unidade_compl_w
		from	Setor_Atendimento b,
			atend_paciente_unidade a
		where	a.nr_seq_interno = nr_seq_interno_ww
		  and	a.cd_setor_atendimento	= b.cd_setor_atendimento;
		exception
			when others then
				ds_setor_atendimento_w	:= '';
				cd_unidade_basica_w	:= '';
				cd_unidade_compl_w	:= '';
		end;
		ds_unidade_w	:= ds_setor_atendimento_w || ' / ' ||
					cd_unidade_basica_w || ' ' || cd_unidade_compl_w;
	elsif (ie_informacao_p = 'UPA') then
		begin
		begin
		select 	b.cd_classif_setor,
			a.cd_unidade_basica,
			a.cd_unidade_compl
		into STRICT	cd_classif_setor_w,
			cd_unidade_basica_w,
			cd_unidade_compl_w
		from	Setor_Atendimento b,
			atend_paciente_unidade a
		where	a.nr_seq_interno = nr_seq_interno_ww
		  and	a.cd_setor_atendimento	= b.cd_setor_atendimento;
		exception
			when others then
				cd_classif_setor_w	:= '';
				cd_unidade_basica_w	:= '';
				cd_unidade_compl_w	:= '';
		end;
		if (cd_classif_setor_w = '1') then
			select	max(substr(b.ds_abrev,1,20))
			into STRICT	ds_unidade_pa_w
			from	pa_local b,
				atendimento_paciente a
			where	a.nr_seq_local_pa	= b.nr_sequencia
			and	a.nr_atendimento	= nr_atendimento_p;
		end if;
		if (ds_unidade_pa_w IS NOT NULL AND ds_unidade_pa_w::text <> '') then
			ds_unidade_w	:= ds_unidade_pa_w;
		else
			ds_unidade_w	:= cd_unidade_basica_w || ' ' || cd_unidade_compl_w;
		end if;
		end;
	elsif (ie_informacao_p = 'LA') then
		begin
		select 	a.cd_setor_atendimento,
			a.cd_unidade_basica,
			a.cd_unidade_compl
		into STRICT	cd_setor_atendimento_w,
			cd_unidade_basica_w,
			cd_unidade_compl_w
		from	atend_paciente_unidade a
		where	a.nr_seq_interno = nr_seq_interno_ww;
		exception
			when others then
				cd_setor_atendimento_w	:= 0;
				cd_unidade_basica_w	:= '';
				cd_unidade_compl_w	:= '';
		end;
		
		begin
		select	coalesce(ie_leito_adaptado, 'N')
		into STRICT	ds_unidade_w
		from	unidade_atendimento a
		where	a.cd_setor_atendimento	= cd_setor_atendimento_w
		and	a.cd_unidade_basica	= cd_unidade_basica_w
		and	a.cd_unidade_compl	= cd_unidade_compl_w;
		exception
			when others then
				ds_unidade_w	:= '';
		end;
	end if;
	end;
end if;
	
return ds_unidade_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_unidade_atendimento ( nr_atendimento_p bigint, ie_opcao_p text, ie_informacao_p text) FROM PUBLIC;
