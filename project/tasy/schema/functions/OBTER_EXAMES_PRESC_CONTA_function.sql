-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_exames_presc_conta ( nr_prescricao_p bigint, cd_setor_atendimento_p bigint, ie_opcao_p text, ie_quebra_linha_p text) RETURNS varchar AS $body$
DECLARE

 
ds_tipo_proc_w				varchar(40);
ds_tipo_ant_w				varchar(40)	:= 'xxx';
cd_procedimento_w			bigint;
ds_procedimento_w 			PROCEDIMENTO.DS_PROCEDIMENTO%type;
qt_procedimento_w			double precision;
Resultado_w	 			varchar(2000);
Quebra_w				varchar(10) 	:= chr(13) || chr(10);
nr_atendimento_w			bigint;
cd_convenio_w				integer;
nr_seq_conversao_w			bigint 		:= 0;
ie_origem_proced_w			bigint;
cd_item_convenio_w			varchar(20) 	:= '';
cd_grupo_w				varchar(10) 	:= '';
nr_sequencia_w				integer;
nr_seq_proc_w				bigint;
qt_reg_w				integer	:= 0;
nr_seq_exame_w				bigint;
cd_exame_w				varchar(20);
nm_exame_urgente_w			varchar(80);
nm_exame_nao_urgente_w			varchar(80);
ie_urgencia_w				varchar(1);
qt_lengt_w				bigint;
dt_prev_execucao_w			timestamp;
nr_seq_proc_interno_w			bigint;
cd_procedimento_regra_w			bigint;
ds_procedimento_regra_w 		PROCEDIMENTO.DS_PROCEDIMENTO%type;
qt_procedimento_regra_w			double precision;
cd_plano_w				varchar(10);
cd_tipo_acomod_conv_w			smallint;
qt_idade_w				bigint;
cd_pessoa_fisica_w			varchar(10);
ie_sexo_w				varchar(1);
cd_empresa_ref_w			bigint;
ie_carater_inter_sus_w			varchar(2);
nr_seq_proc_pacote_w			bigint;
nr_seq_pacote_w				bigint;
cd_dependente_w				smallint;

c01 CURSOR FOR 
	SELECT a.nr_sequencia, 
		a.cd_procedimento, 
		a.ie_origem_proced, 
		SUBSTR(obter_desc_prescr_proc(b.cd_procedimento, b.ie_origem_proced, a.nr_seq_proc_interno),1,240), 
		a.qt_procedimento, 
		a.nr_seq_exame, 
		SUBSTR(obter_valor_dominio(95, b.cd_tipo_procedimento),1,40) ds_tipo_proc, 
		a.ie_urgencia, 
		a.dt_prev_execucao, 
		a.nr_seq_proc_interno, 
		c.nr_sequencia, 
		c.nr_seq_proc_pacote 
	FROM	procedimento b, 
 		procedimento_paciente c, 
		prescr_procedimento a, 
		conta_paciente d 
	WHERE a.cd_procedimento		= b.cd_procedimento 
	AND	a.ie_origem_proced	= b.ie_origem_proced 
	AND	c.nr_interno_conta	= d.nr_interno_conta 
	AND	coalesce(d.ie_cancelamento::text, '') = '' 
	AND 	a.nr_prescricao		= nr_prescricao_p 
	AND 	((a.cd_setor_atendimento = cd_setor_atendimento_p) 
	OR (c.cd_setor_atendimento = cd_setor_atendimento_p)) 
	AND	a.nr_prescricao = c.nr_prescricao 
	AND	a.nr_sequencia = c.NR_SEQUENCIA_PRESCRICAO 
	order by 4, 2;

c02 CURSOR FOR 
	SELECT cd_procedimento, 
		SUBSTR(obter_desc_prescr_proc(cd_procedimento, ie_origem_proced, nr_seq_proc_interno),1,240), 
		qt_procedimento 
	FROM	procedimento_paciente 
	WHERE 	nr_seq_proc_princ	= nr_seq_proc_w;

BEGIN
 
/* Opções 
	CQD	- Código/ Quantidade/ Descrição 
	CQDE	- Código/ Quantidade/ Descrição Executados (não excluídos) 
	CQDER	- Código/ Quantidade/ Descrição Executados (não excluídos) + Regra de lanç. automático 
	CQDC	- Código/ Quantidade/ Descrição do convenio 
	QDE	- Quantidade/ Descrição Executados (não excluídos) 
	D	- Descrição 
	C	- Código 
	TCR	- Tipo com Repetição 
	TSR	- Tipo sem Repetição 
	EI	- Codigo de integração do exame 
	EU	- Exame Laboratório Urgente 
	ENU	- Exame Laboratório Não-Urgente	 
	DCD	- Data prevista de execucao / Quantidade/ Descricao 
*/
 
if (coalesce(ie_quebra_Linha_p,'N') <> 'S') then 
	quebra_w		:= ' ';
end if;
if (ie_opcao_p = 'CQDC') then 
	select	nr_atendimento 
	into STRICT	nr_atendimento_w 
	from	prescr_medica 
	where	nr_prescricao = nr_prescricao_p;
	select obter_convenio_atendimento(nr_atendimento_w) 
	into STRICT	cd_convenio_w 
	;
end if;
OPEN C01;
LOOP 
FETCH C01 into	 
	nr_sequencia_w, 
	cd_procedimento_w, 
	ie_origem_proced_w, 
	ds_procedimento_w, 
	qt_procedimento_w, 
	nr_seq_exame_w, 
	ds_tipo_proc_w, 
	ie_urgencia_w, 
	dt_prev_execucao_w, 
	nr_seq_proc_interno_w, 
	nr_seq_proc_w, 
	nr_seq_proc_pacote_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	qt_lengt_w	:= coalesce(length(Resultado_w),0);
	if (ie_opcao_p = 'CQD') then 
		if (qt_lengt_w < 1700) then 
			Resultado_w	:= 	 
			Resultado_w || '(' || cd_procedimento_w || ')' || ' ' || 
	        	to_char(qt_procedimento_w, '9990') || ' - ' || 
			ds_procedimento_w || quebra_w;
		end if;
	elsif (ie_opcao_p = 'CQDE') then 
		begin 
		select count(*) 
		into STRICT	qt_reg_w 
		from 	procedimento_paciente a, 
			conta_paciente b 
		where	a.nr_interno_conta = b.nr_interno_conta 
		and	coalesce(b.ie_cancelamento::text, '') = ''	 
		and	a.nr_prescricao		= nr_prescricao_p 
		and	a.nr_sequencia_prescricao	= nr_sequencia_w 
		and	coalesce(a.cd_motivo_exc_conta::text, '') = '';	
 
		if (qt_reg_w	> 0) and (qt_lengt_w < 1700) then 
			Resultado_w	:= 	 
			Resultado_w || '(' || cd_procedimento_w || ')' || ' ' || 
    	    	to_char(qt_procedimento_w, '9990') || ' - ' || 
			ds_procedimento_w || quebra_w;
		end if;
		end;
	elsif (ie_opcao_p = 'QDE') then 
		begin 
		select count(*) 
		into STRICT	qt_reg_w 
		from 	procedimento_paciente a, 
			conta_paciente b 
		where	a.nr_interno_conta = b.nr_interno_conta 
		and	coalesce(b.ie_cancelamento::text, '') = ''	 
		and	a.nr_prescricao		= nr_prescricao_p 
		and	a.nr_sequencia_prescricao	= nr_sequencia_w 
		and	coalesce(a.cd_motivo_exc_conta::text, '') = '';	
 
		if (qt_reg_w	> 0) and (qt_lengt_w < 1700) then 
			Resultado_w	:= 	 
			Resultado_w || 
    	    	to_char(qt_procedimento_w, '9990') || ' - ' || 
			ds_procedimento_w || quebra_w;
		end if;
		end;
	elsif (ie_opcao_p = 'CQDER') then 
		begin 
		select count(*) 
		into STRICT	qt_reg_w 
		from 	procedimento_paciente a, 
			conta_paciente b 
		where	a.nr_interno_conta = b.nr_interno_conta 
		and	coalesce(b.ie_cancelamento::text, '') = ''	 
		and	a.nr_prescricao		= nr_prescricao_p 
		and	a.nr_sequencia_prescricao	= nr_sequencia_w 
		and	coalesce(a.cd_motivo_exc_conta::text, '') = '';	
 
		if (qt_reg_w	> 0) and (qt_lengt_w < 1700) then 
			Resultado_w	:= 	 
			Resultado_w || '(' || cd_procedimento_w || ')' || ' ' || 
    	    	to_char(qt_procedimento_w, '9990') || ' - ' || 
			ds_procedimento_w || quebra_w;
		end if;
 
		OPEN C02;
		LOOP 
		FETCH C02 into	 
			cd_procedimento_regra_w, 
			ds_procedimento_regra_w, 
			qt_procedimento_regra_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin 
			qt_lengt_w	:= coalesce(length(Resultado_w),0);
			if (qt_lengt_w < 1700) then 
				begin 
				Resultado_w	:= 	 
				Resultado_w || '(' || cd_procedimento_regra_w || ')' || ' ' || 
	    	    	to_char(qt_procedimento_regra_w, '9990') || ' - ' || 
				ds_procedimento_regra_w || quebra_w;
				end;
			end if;
			end;	
		END LOOP;
		CLOSE C02;
 
		end;
 
	elsif (ie_opcao_p = 'CQDC') and (qt_lengt_w < 1700) then 
		begin 
 
		select	max(cd_plano_convenio), 
			coalesce(max(cd_empresa),0), 
			max(cd_dependente) 
		into STRICT	cd_plano_w, 
			cd_empresa_ref_w, 
			cd_dependente_w 
		from 	atend_categoria_convenio 
		where 	nr_atendimento = nr_atendimento_w 
		and	cd_convenio = cd_convenio_w;
		 
		select 	max(cd_tipo_acomodacao) 
		into STRICT	cd_tipo_acomod_conv_w 
		from 	atend_categoria_convenio 
		where 	nr_atendimento = nr_atendimento_w 
		and 	cd_convenio = cd_convenio_w;
		 
		select	max(cd_pessoa_fisica), 
			max(ie_carater_inter_sus) 
		into STRICT	cd_pessoa_fisica_w, 
			ie_carater_inter_sus_w 
		from	atendimento_paciente 
		where	nr_atendimento = nr_atendimento_w;
		 
		begin 
		select	max(obter_idade(dt_nascimento, coalesce(dt_obito,clock_timestamp()),'DIA')), 
			max(ie_sexo) 
		into STRICT	qt_idade_w, 
			ie_sexo_w 
		from	pessoa_fisica 
		where	cd_pessoa_fisica = cd_pessoa_fisica_w;
		exception 
		when others then 
			qt_idade_w	:= 0;
			ie_sexo_w	:= '';
		end;
		 
		nr_seq_pacote_w	:= 0;
		if (nr_seq_proc_w = nr_seq_proc_pacote_w) then 
			select	max(nr_seq_pacote) 
			into STRICT	nr_seq_pacote_w 
			from	atendimento_pacote 
			where	nr_seq_procedimento = nr_seq_proc_w 
			and	nr_atendimento = nr_atendimento_w;
		end if;
 
		SELECT * FROM converte_proc_convenio( 
			null, cd_convenio_w, null, cd_procedimento_w, ie_origem_proced_w, null, null, null, dt_prev_execucao_w, cd_item_convenio_w, cd_grupo_w, nr_seq_conversao_w, cd_setor_atendimento_p, null, nr_seq_proc_interno_w, 'A', cd_plano_w, null, 0, null, cd_tipo_acomod_conv_w, qt_idade_w, ie_sexo_w, cd_empresa_ref_w, ie_carater_inter_sus_w, nr_seq_pacote_w, nr_seq_exame_w, null, cd_dependente_w) INTO STRICT cd_item_convenio_w, cd_grupo_w, nr_seq_conversao_w;
		if (nr_seq_conversao_w <> 0) then 
			select coalesce(ds_proc_convenio,ds_procedimento_w) 
			into STRICT	ds_procedimento_w 
			from conversao_Proc_convenio 
			where nr_sequencia	= nr_seq_conversao_w;
		end if;
		if (cd_item_convenio_w = '0') then 
			cd_item_convenio_w	:= null;
		end if;
		Resultado_w	:= 	 
		Resultado_w || '(' || coalesce(cd_item_convenio_w, cd_procedimento_w) || ')' || ' ' || 
        	to_char(qt_procedimento_w, '9990') || ' - ' || 
		ds_procedimento_w || quebra_w;
		end;
	elsif (ie_opcao_p = 'D') and (qt_lengt_w < 1700) then 
		Resultado_w	:= Resultado_w || ds_procedimento_w || quebra_w;
	elsif (ie_opcao_p = 'C') and (qt_lengt_w < 1700) then 
		Resultado_w	:= Resultado_w || cd_procedimento_w || quebra_w;
	elsif (ie_opcao_p = 'TCR') and (ds_tipo_proc_w IS NOT NULL AND ds_tipo_proc_w::text <> '') and (qt_lengt_w < 1700) then 
		Resultado_w	:= Resultado_w || ds_tipo_proc_w || quebra_w;
	elsif (ie_opcao_p = 'TSR') and (ds_tipo_proc_w IS NOT NULL AND ds_tipo_proc_w::text <> '') and (ds_tipo_proc_w <> ds_tipo_ant_w) and (qt_lengt_w < 1700) then 
		Resultado_w	:= Resultado_w || ds_tipo_proc_w || quebra_w;
	elsif (ie_opcao_p = 'EI') and (qt_lengt_w < 1700) then 
		select	coalesce(CD_EXAME_INTEGRACAO,CD_EXAME) 
		into STRICT	cd_exame_w 
		from	exame_laboratorio 
		where	nr_seq_exame	= nr_seq_exame_w;
		Resultado_w	:= Resultado_w || cd_exame_w || quebra_w;
	elsif (ie_opcao_p = 'EU') and (qt_lengt_w < 1700) then 
		select 	max(a.nm_exame) 
		into STRICT	nm_exame_urgente_w 
		from	exame_laboratorio a 
		where	a.nr_seq_exame	= nr_seq_exame_w 
		and	ie_urgencia_w 	= 'S';
		if (nm_exame_urgente_w IS NOT NULL AND nm_exame_urgente_w::text <> '') then 
			Resultado_w	:= Resultado_w || nm_exame_urgente_w || quebra_w;
		end if;
	elsif (ie_opcao_p = 'ENU') and (qt_lengt_w < 1700) then	 
		select 	max(a.nm_exame) 
		into STRICT	nm_exame_nao_urgente_w 
		from	exame_laboratorio a 
		where	a.nr_seq_exame	= nr_seq_exame_w 
		and	ie_urgencia_w 	= 'N';
		if (nm_exame_nao_urgente_w IS NOT NULL AND nm_exame_nao_urgente_w::text <> '') then 
			Resultado_w	:= Resultado_w || nm_exame_nao_urgente_w || quebra_w;
		end if;
	elsif (ie_opcao_p = 'DQD') and (qt_lengt_w < 1700) then 
		Resultado_w	:= 	 
		Resultado_w || '(' || to_char(dt_prev_execucao_w,'dd/mm/yyyy hh24:mi:ss') || ')' || ' ' || 
        	to_char(qt_procedimento_w, '9990') || ' - ' || 
		ds_procedimento_w || quebra_w;
	end if;
 
	ds_tipo_ant_w	:= ds_tipo_proc_w;
	end;
END LOOP;
CLOSE C01;
 
RETURN resultado_w;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_exames_presc_conta ( nr_prescricao_p bigint, cd_setor_atendimento_p bigint, ie_opcao_p text, ie_quebra_linha_p text) FROM PUBLIC;

