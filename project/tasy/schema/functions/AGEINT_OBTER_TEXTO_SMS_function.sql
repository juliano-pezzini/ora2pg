-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ageint_obter_texto_sms ( nr_seq_ageint_p bigint, cd_pessoa_fisica_p text, nm_paciente_p text, cd_estabelecimento_p bigint, nm_usuario_p text) RETURNS varchar AS $body$
DECLARE

 
ds_retorno_w				varchar(4000);
ds_texto_sms_w				varchar(4000);
ds_item_w					varchar(255);
dt_item_w					timestamp;
ds_itens_w					varchar(4000);
nm_pessoa_fisica_w			varchar(80);
primeiro_nome_w				varchar(80);
nm_medico_w					varchar(255);
dt_resumida_w				timestamp;
nr_seq_ageint_item_ww		bigint := 0;
nr_seq_ageint_item_w		bigint := 0;
ie_orientacao_SMS_proc_w	varchar(1);
nr_seq_proc_interno_w		agenda_integrada_item.nr_seq_proc_interno%type;
cd_procedimento_w			agenda_integrada_item.cd_procedimento%type;
ie_origem_proced_w			agenda_integrada_item.ie_origem_proced%type;
ds_orientacao_sms_proc_w	varchar(255);
ds_orientacao_sms_w			varchar(255);

C01 CURSOR FOR 
	SELECT	Obter_Item_Grid_Ageint(a.nr_seq_proc_interno, a.cd_medico, a.cd_especialidade, cd_estabelecimento_p, a.nr_sequencia), 
			b.hr_inicio, 
			a.nr_sequencia, 
			a.nr_seq_proc_interno, 
			a.cd_procedimento, 
			a.ie_origem_proced 
	from	agenda_integrada_item a, 
			agenda_paciente b 
	where	a.nr_seq_agenda_exame	= b.nr_sequencia 
	and		a.nr_seq_agenda_int		= nr_seq_ageint_p 
	
union all
 
	SELECT	Obter_Item_Grid_Ageint(a.nr_seq_proc_interno, a.cd_medico, a.cd_especialidade, cd_estabelecimento_p, a.nr_sequencia), 
			b.dt_agenda, 
			a.nr_sequencia, 
			a.nr_seq_proc_interno, 
			a.cd_procedimento, 
			a.ie_origem_proced 
	from	agenda_integrada_item a, 
			agenda_consulta b 
	where	a.nr_seq_agenda_cons	= b.nr_sequencia 
	and		a.nr_seq_agenda_int		= nr_seq_ageint_p 
	
union all
 
	select	Obter_Item_Grid_Ageint(a.nr_seq_proc_interno, a.cd_medico, a.cd_especialidade, cd_estabelecimento_p, a.nr_sequencia), 
			b.dt_agenda, 
			a.nr_sequencia, 
			a.nr_seq_proc_interno, 
			a.cd_procedimento, 
			a.ie_origem_proced 
	from	agenda_integrada_item a, 
			agenda_quimio b 
	where	a.nr_seq_agequi	= b.nr_sequencia 
	and		a.nr_seq_agenda_int		= nr_seq_ageint_p 
	order by 2;


BEGIN 
 
nm_pessoa_fisica_w	:= nm_paciente_p;
 
ds_texto_sms_w	:= obter_valor_param_usuario(869, 192, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p);
ie_orientacao_SMS_proc_w := obter_valor_param_usuario(869, 400, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p);
 
open C01;
loop 
fetch C01 into 
	ds_item_w, 
	dt_item_w, 
	nr_seq_ageint_item_w, 
	nr_seq_proc_interno_w, 
	cd_procedimento_w, 
	ie_origem_proced_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	ds_orientacao_sms_proc_w := null;
	if (coalesce(ie_orientacao_SMS_proc_w,'S') = 'S') then 
		if	(nr_seq_proc_interno_w IS NOT NULL AND nr_seq_proc_interno_w::text <> '' AND nr_seq_proc_interno_w > 0) then 
 
			select	ds_orientacao_sms 
			into STRICT	ds_orientacao_sms_proc_w 
			from	proc_interno 
			where	nr_sequencia = nr_seq_proc_interno_w;
 
		elsif	((cd_procedimento_w IS NOT NULL AND cd_procedimento_w::text <> '') and (cd_procedimento_w > 0) and (ie_origem_proced_w IS NOT NULL AND ie_origem_proced_w::text <> '') and (ie_origem_proced_w > 0)) then 
 
			select	ds_orientacao_sms 
			into STRICT	ds_orientacao_sms_proc_w 
			from	procedimento 
			where	cd_procedimento = cd_procedimento_w 
			and		ie_origem_proced = ie_origem_proced_w;
		end if;
	end if;
 
	ds_itens_w	:= ds_itens_w || ds_item_w || ' data: '||to_char(dt_item_w,'dd/mm hh24:mi') || ', ';
	 
	if (ds_orientacao_sms_proc_w IS NOT NULL AND ds_orientacao_sms_proc_w::text <> '') and 
		((coalesce(ds_orientacao_sms_w::text, '') = '') or (position(ds_orientacao_sms_proc_w in ds_orientacao_sms_w) = 0)) then 
		ds_orientacao_sms_w	:= ds_orientacao_sms_w || ' ' || ds_orientacao_sms_proc_w;
	end if;
 
	if (nr_seq_ageint_item_ww = 0) then 
		nr_seq_ageint_item_ww := nr_seq_ageint_item_w;
	end if;
	end;
end loop;
close C01;
 
if (cd_pessoa_Fisica_p IS NOT NULL AND cd_pessoa_Fisica_p::text <> '') then 
	nm_pessoa_fisica_w := SUBSTR(OBTER_NOME_PF(cd_pessoa_Fisica_p), 0, 80);
	 
	select 	substr(obter_primeiro_nome(obter_nome_pf(cd_pessoa_fisica)),1,80) 
	into STRICT	primeiro_nome_w 
	from	pessoa_fisica 
	where 	cd_pessoa_fisica = cd_pessoa_fisica_p;
		 
	select 	max(to_date(substr(to_char(coalesce(Obter_Horario_item_Ageint(a.nr_seq_agenda_cons, a.nr_Seq_Agenda_exame,a.nr_sequencia),qt_obter_horario_agendado(a.nr_sequencia)),'dd/mm/yyyy hh24:mi'),1,80),'dd/mm/yyyy hh24:mi')), 
			max(substr(Ageint_Obter_Medico_Item(nr_seq_agenda_cons, nr_Seq_Agenda_exame),1,60)) 
	into STRICT	dt_resumida_w, 
			nm_medico_w 
	from	agenda_integrada_item a, 
			agenda_integrada b 
	where	a.nr_seq_agenda_int = b.nr_Sequencia 
	and		a.nr_sequencia = nr_seq_ageint_item_ww;
end if;
 
ds_texto_sms_W	:= replace_macro(ds_texto_sms_w,'@ITEM@', ds_itens_w);
ds_texto_sms_W	:= replace_macro(ds_texto_sms_w,'@PACIENTE@', nm_pessoa_fisica_w);
ds_texto_sms_W := replace_macro(ds_texto_sms_w,'@PRIMEIRO_NOME@', primeiro_nome_w);
ds_texto_sms_W := replace_macro(ds_texto_sms_w,'@NM_MEDICO@', nm_medico_w);
ds_texto_sms_W := replace_macro(ds_texto_sms_w,'@DT_RESUMIDA@', to_char(dt_resumida_w,'dd/mm/yyyy hh24:mi'));
 
if (ds_orientacao_sms_w IS NOT NULL AND ds_orientacao_sms_w::text <> '') then 
	ds_texto_sms_W := trim(both trim(both ds_texto_sms_W) || ' ' || trim(both ds_orientacao_sms_w));
end if;
 
ds_retorno_w	:= substr(ds_texto_sms_w,1, length(ds_texto_sms_w));
 
return	ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ageint_obter_texto_sms ( nr_seq_ageint_p bigint, cd_pessoa_fisica_p text, nm_paciente_p text, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

