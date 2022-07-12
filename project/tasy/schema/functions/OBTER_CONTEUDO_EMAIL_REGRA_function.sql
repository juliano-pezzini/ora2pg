-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_conteudo_email_regra ( nr_seq_agenda_p bigint, nr_seq_regra_p bigint, ie_opcao_p text, nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE

 
/* 
ie_opcao_p = 'C' - Corpo do email 
ie_opcao_p = 'T' - Titulo do email 
*/
 
 
nm_medico_w		varchar(150);
nm_paciente_w		varchar(150);
nm_procedimento_w	varchar(150);
dt_procedimento_w		varchar(20);
nr_minuto_duracao_w	bigint;
nr_cirurgia_w		bigint;
ds_texto_w		varchar(7000);
ds_convenio_w		varchar(255);
cd_usuario_convenio_w	varchar(30);
ds_observacao_w		varchar(255);
ds_proc_adic_w		varchar(2000);
ds_proc_adic_aux_w	varchar(270);
cd_procedimento_w	bigint;
ds_procedimento_w	varchar(270);
qt_idade_paciente_w 	smallint;
ds_categoria_w		varchar(255);
ds_proc_exame_w		varchar(2000):=null;
ds_proc_exame_aux_w	varchar(255);
ds_convenio_aten_w	varchar(255);
ds_categoria_aten_w	varchar(255);
ie_tipo_convenio_w	smallint;
nm_material_w		varchar(255);
ds_equipamento_w	varchar(255):= null;
ds_tipo_anestesia_w	varchar(100);
ds_equipamentos_w	varchar(2000):=null;
ds_opmes_w		varchar(4000):=null;
ds_opmes_autorizado_w	varchar(4000):=null;
dt_agenda_w		varchar(30);
dt_agendamento_w	varchar(30);
nr_reserva_w		varchar(20);
nr_atendimento_w	bigint;
ds_laboratorio_w	varchar(255);
ds_banco_sangue_w	varchar(255);
qt_material_w		varchar(10);
nm_fornecedor_w		varchar(255);
ie_autorizado_w		varchar(15);

expressao1_w	varchar(255) := obter_desc_expressao_idioma(312449, null, wheb_usuario_pck.get_nr_seq_idioma);--Fornecedor 
expressao2_w	varchar(255) := obter_desc_expressao_idioma(701494, null, wheb_usuario_pck.get_nr_seq_idioma);--Quantidade 
C01 CURSOR FOR 
	SELECT	substr(obter_desc_prescr_proc(cd_procedimento, ie_origem_proced, nr_seq_proc_interno),1,240) 
	from	agenda_paciente_proc 
	where	nr_sequencia	= nr_seq_agenda_p 
	order by 1;

c02 CURSOR FOR 
	SELECT	distinct(substr(obter_desc_proc_exame(a.nr_seq_proc_servico),1,80)), 
		substr(obter_razao_social(a.cd_cgc),1,255)	 
	from	agenda_pac_servico a, 
	   	param_regra_envia_email b 
	where	a.nr_seq_proc_servico 	= b.nr_seq_proc_servico 
	and	b.nr_seq_regra		= nr_seq_regra_p 
	and	a.nr_seq_agenda	  	= nr_seq_agenda_p;
	
c03 CURSOR FOR 
	/* 
	select	substr(obter_desc_material(cd_material),1,200), 
		substr(sum(qt_material),1,10), 
		SUBSTR(obter_dados_pf_pj(NULL,	cd_cgc, 'N'),1,254), 
		ie_autorizado 
	from  	agenda_pac_opme 
	where 	nr_seq_agenda = nr_seq_agenda_p 
	and	nvl(ie_origem_inf,'I') = 'I' 
	group by cd_material,cd_cgc,ie_autorizado; 
	*/
 
	SELECT a.nm_material, 
		SUM(a.qt_autorizada), 	 
		a.nm_fornecedor, 
		a.ie_autorizado 
	FROM (SELECT	SUBSTR(obter_desc_material(cd_material),1,200) nm_material, 
			OBTER_DADOS_MAT_AUTOR_OPME(nr_sequencia,'QA') qt_autorizada, 
			SUBSTR(obter_dados_pf_pj(NULL,	cd_cgc, 'N'),1,254) nm_fornecedor, 
			ie_autorizado					 
		FROM  	agenda_pac_opme 
		WHERE 	nr_seq_agenda = nr_seq_agenda_p 
		AND	coalesce(ie_origem_inf,'I') = 'I') a 
	GROUP BY a.nm_material,a.nm_fornecedor,a.ie_autorizado;
	
c04 CURSOR FOR 
	SELECT 	substr(obter_desc_equip_agenda(cd_equipamento),1,200) 
	from  	agenda_pac_equip 
	where 	nr_seq_agenda = nr_seq_agenda_p 
	
union all
 
	SELECT	substr(ds_equipamento,1,200) 
	from  	equipamento a, 
		agenda_pac_equip b 
	where 	a.cd_classificacao 	= b.nr_seq_classif_equip 
	and	b.nr_seq_agenda 	= nr_seq_agenda_p;
	

BEGIN 
 
if (coalesce(nr_atendimento_p,0) > 0) then 
	select	coalesce(max(a.ie_tipo_convenio),0), 
		max(substr(obter_nome_convenio(b.cd_convenio),1,255)), 
		max(substr(OBTER_CATEGORIA_CONVENIO(b.cd_convenio,b.cd_categoria),1,255)) ds_categoria 
	into STRICT	ie_tipo_convenio_w, 
		ds_convenio_aten_w, 
		ds_categoria_aten_w 
	from	atendimento_paciente a, 
		atend_categoria_convenio b 
	where	a.nr_atendimento = b.nr_atendimento 
	and	a.nr_atendimento = nr_atendimento_p 
	and 	b.nr_seq_interno = obter_atecaco_atendimento(a.nr_atendimento) 
	group by a.ie_tipo_convenio,b.cd_convenio,b.cd_categoria;
end if;	
 
 
select	obter_nome_pf(cd_medico), 
	coalesce(obter_nome_pf(cd_pessoa_fisica),nm_paciente), 
	substr(obter_exame_agenda(cd_procedimento, ie_origem_proced, nr_seq_proc_interno),1,240), 
	to_char(hr_inicio,'dd/mm/yyyy hh24:mi:ss'), 
	nr_minuto_duracao, 
	nr_cirurgia, 
	substr(obter_nome_convenio(cd_convenio),1,255), 
	cd_usuario_convenio, 
	substr(ds_observacao,1,255), 
	cd_procedimento, 
	qt_idade_paciente, 
	substr(OBTER_CATEGORIA_CONVENIO(cd_convenio,cd_categoria),1,255) ds_categoria, 
	substr(obter_valor_dominio(36, CD_TIPO_ANESTESIA),1,25), 
	to_char(dt_agendamento,'dd/mm/yyyy hh24:mi:ss'), 
	nr_reserva, 
	nr_atendimento, 
	substr(obter_conteudo_email_sangue(nr_sequencia),1,255) 
into STRICT	nm_medico_w, 
	nm_paciente_w, 
	nm_procedimento_w, 
	dt_procedimento_w, 
	nr_minuto_duracao_w, 
	nr_cirurgia_w, 
	ds_convenio_w, 
	cd_usuario_convenio_w, 
	ds_observacao_w, 
	cd_procedimento_w, 
	qt_idade_paciente_w, 
	ds_categoria_w, 
	ds_tipo_anestesia_w, 
	dt_agendamento_w, 
	nr_reserva_w, 
	nr_atendimento_w, 
	ds_banco_sangue_w 
from	agenda_paciente 
where	nr_sequencia	= nr_seq_agenda_p;
 
 
open C01;
loop 
fetch C01 into	 
	ds_proc_adic_aux_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	ds_proc_adic_w	:= ds_proc_adic_w || ', ' || ds_proc_adic_aux_w;
	end;
end loop;
close C01;
 
open C02;
loop 
fetch C02 into	 
	ds_proc_exame_aux_w, 
	ds_laboratorio_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin 
	if (coalesce(ds_proc_exame_w::text, '') = '') then 
		if (coalesce(ds_laboratorio_w::text, '') = '') then 
			ds_proc_exame_w := ds_proc_exame_aux_w;
		else 
			ds_proc_exame_w := ds_proc_exame_aux_w || '[ '||ds_laboratorio_w||' ]';
		end if;	
	else 
		if (coalesce(ds_laboratorio_w::text, '') = '') then 
			ds_proc_exame_w	:= ds_proc_exame_w || ', ' || ds_proc_exame_aux_w;
		else 
			ds_proc_exame_w	:= ds_proc_exame_w || ', ' || ds_proc_exame_aux_w ||'[ '||ds_laboratorio_w||' ]';
		end if;	
	end if;
	end;
end loop;
close C02;
 
open C03;
loop 
fetch C03 into	 
	nm_material_w, 
	qt_material_w, 
	nm_fornecedor_w, 
	ie_autorizado_w;
EXIT WHEN NOT FOUND; /* apply on C03 */
	begin 
	if (ie_autorizado_w = 'A') then 
		if (coalesce(ds_opmes_autorizado_w::text, '') = '') then 
			ds_opmes_autorizado_w := nm_material_w ||chr(10)||expressao1_w || ': '||nm_fornecedor_w||chr(10)|| expressao2_w || ': '||qt_material_w||chr(10);
		else 
			ds_opmes_autorizado_w := ds_opmes_autorizado_w || nm_material_w ||chr(10)||expressao1_w || ': '||nm_fornecedor_w||chr(10)|| expressao2_w || ': '||qt_material_w||chr(10);
		end if;
	end if;	
	 
	if (coalesce(ds_opmes_w::text, '') = '') then 
		ds_opmes_w := nm_material_w;
	else 
		ds_opmes_w := ds_opmes_w || ', ' || nm_material_w;
	end if;
	end;
end loop;
close C03;
 
 
open C04;
loop 
fetch C04 into	 
	ds_equipamento_w;
EXIT WHEN NOT FOUND; /* apply on C04 */
	begin 
	if (coalesce(ds_equipamentos_w::text, '') = '') then 
		ds_equipamentos_w := ds_equipamento_w;
	else 
		ds_equipamentos_w := ds_equipamentos_w || ', ' || ds_equipamento_w;
	end if;
	end;
end loop;
close C04;
 
 
if (ie_opcao_p = 'C') then 
	select	ds_texto 
	into STRICT	ds_texto_w 
	from 	regra_envio_email_agenda 
	where 	nr_sequencia = nr_seq_regra_p;
else 
	select	ds_titulo 
	into STRICT	ds_texto_w 
	from 	regra_envio_email_agenda 
	where 	nr_sequencia = nr_seq_regra_p;
end if;
 
 
ds_procedimento_w	:= substr(cd_procedimento_w || ' - ' || nm_procedimento_w,1,270);
ds_proc_adic_w	:= substr(ds_proc_adic_w,3,1000);
 
ds_texto_w	:= replace_macro(ds_texto_w,'@anestesia',ds_tipo_anestesia_w);
ds_texto_w	:= replace_macro(ds_texto_w,'@opmeautorizado',ds_opmes_autorizado_w);
ds_texto_w	:= replace_macro(ds_texto_w,'@opme',ds_opmes_w);
ds_texto_w	:= replace_macro(ds_texto_w,'@equipamento',ds_equipamentos_w);
ds_texto_w	:= replace_macro(ds_texto_w,'@procedimento',nm_procedimento_w);
ds_texto_w	:= replace_macro(ds_texto_w,'@cirurgiao',nm_medico_w);
ds_texto_w	:= replace_macro(ds_texto_w,'@paciente',nm_paciente_w);
ds_texto_w	:= replace_macro(ds_texto_w,'@idade',qt_idade_paciente_w);	
ds_texto_w	:= replace_macro(ds_texto_w,'@data',dt_procedimento_w);
ds_texto_w	:= replace_macro(ds_texto_w,'@duracao',nr_minuto_duracao_w);
ds_texto_w	:= replace_macro(ds_texto_w,'@cirurgia',nr_cirurgia_w);
ds_texto_w	:= replace_macro(ds_texto_w,'@reserva',nr_reserva_w);
if (ds_Convenio_w IS NOT NULL AND ds_Convenio_w::text <> '') then 
	ds_texto_w	:= replace_macro(ds_texto_w,'@convenio',ds_Convenio_w);
	ds_texto_w	:= replace_macro(ds_texto_w,'@categoria',ds_categoria_w);
else 
	ds_texto_w	:= replace_macro(ds_texto_w,'@convenio',ds_convenio_aten_w);
	ds_texto_w	:= replace_macro(ds_texto_w,'@categoria',ds_categoria_aten_w);	
end if;		
ds_texto_w	:= replace_macro(ds_texto_w,'@docusuconv',cd_usuario_convenio_w);
ds_texto_w	:= replace_macro(ds_texto_w,'@observacao',ds_observacao_w);
ds_texto_w	:= replace_macro(ds_texto_w,'@procadic',ds_proc_adic_w);
ds_texto_w	:= replace_macro(ds_texto_w,'@coddescproced',ds_procedimento_w);
ds_texto_w	:= replace_macro(ds_texto_w,'@servico',ds_proc_exame_w);	
ds_texto_w	:= replace_macro(ds_texto_w,'@agendamento',dt_agendamento_w);
ds_texto_w	:= replace_macro(ds_texto_w,'@atendimento',nr_atendimento_w);	
ds_texto_w	:= replace_macro(ds_texto_w,'@bancosangue',ds_banco_sangue_w);
 
return 	substr(ds_texto_w,1,7000);
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_conteudo_email_regra ( nr_seq_agenda_p bigint, nr_seq_regra_p bigint, ie_opcao_p text, nr_atendimento_p bigint) FROM PUBLIC;
