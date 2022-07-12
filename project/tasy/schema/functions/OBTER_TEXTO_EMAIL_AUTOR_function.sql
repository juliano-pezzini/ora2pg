-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_texto_email_autor (nr_sequencia_autor_p bigint, ds_mensagem_p text) RETURNS varchar AS $body$
DECLARE



ds_retorno_w			varchar(4000);
ds_conteudo_w			varchar(4000);
ds_titulo_w			varchar(4000);
ds_procedimentos_w		varchar(4000);
ds_materiais_w			varchar(4000);
ds_proc_autor_w			varchar(255);
nm_protocolo_w			varchar(255);
ds_leito_atend_w		varchar(255);
qt_tempo_medic_w		varchar(100);
cd_procedimento_w		bigint;
ie_origem_proced_w		bigint;
cd_material_w			integer;
dt_baixa_prescr_w		timestamp;
dt_autorizacao_w		timestamp;
ds_mat_qtdes_fornec_obs_w	varchar(4000);

ds_observacao_w		autorizacao_convenio.ds_observacao%type;
nr_atendimento_w	autorizacao_convenio.nr_atendimento%type;
nr_prescricao_w		autorizacao_convenio.nr_prescricao%type;
cd_convenio_w		autorizacao_convenio.cd_convenio%type;
cd_pessoa_fisica_w	autorizacao_convenio.cd_pessoa_fisica%type;
nr_seq_estagio_w	autorizacao_convenio.nr_seq_estagio%type;
cd_medico_solicitante_w	autorizacao_convenio.cd_medico_solicitante%type;
nr_seq_paciente_setor_w	autorizacao_convenio.nr_seq_paciente_setor%type;
nr_seq_paciente_w	autorizacao_convenio.nr_seq_paciente%type;
nr_ciclo_w		autorizacao_convenio.nr_ciclo%type;
ds_estagio_autor_w	estagio_autorizacao.ds_estagio%type;
cd_protocolo_w		paciente_setor.cd_protocolo%type;

c02 CURSOR FOR
SELECT	a.cd_procedimento,
	a.ie_origem_proced
from	procedimento_autorizado a
where	a.nr_sequencia_autor	= nr_sequencia_autor_p;

c03 CURSOR FOR
SELECT	a.*
from	material_autorizado a
where	a.nr_sequencia_autor	= nr_sequencia_autor_p;

c03_w	c03%rowtype;


BEGIN

select	max(nr_atendimento),
	max(nr_prescricao),
	max(cd_convenio),
	max(cd_pessoa_fisica),
	max(substr(obter_desc_procedimento(cd_procedimento_principal,ie_origem_proced),1,255)),
	max(nr_seq_estagio),
	max(cd_medico_solicitante),
	max(nr_seq_paciente_setor),
	max(nr_seq_paciente),
	max(nr_ciclo),
	max(dt_autorizacao),
	max(ds_observacao)
into STRICT	nr_atendimento_w,
	nr_prescricao_w,
	cd_convenio_w,
	cd_pessoa_fisica_w,
	ds_proc_autor_w,
	nr_seq_estagio_w,
	cd_medico_solicitante_w,
	nr_seq_paciente_setor_w,
	nr_seq_paciente_w,
	nr_ciclo_w,
	dt_autorizacao_w,
	ds_observacao_w
from	autorizacao_convenio
where	nr_sequencia	= nr_sequencia_autor_p;

select	max(ds_estagio)
into STRICT	ds_estagio_autor_w
from	estagio_autorizacao
where	nr_sequencia	= nr_seq_estagio_w
and		OBTER_EMPRESA_ESTAB(wheb_usuario_pck.get_cd_estabelecimento) = cd_empresa;

select	max(substr(Obter_desc_leito_atend(Obter_Atepacu_paciente(nr_atendimento_w,'A')),1,255))
into STRICT	ds_leito_atend_w
;

select	max(dt_baixa)
into STRICT	dt_baixa_prescr_w
from	prescr_medica
where	nr_prescricao	= nr_prescricao_w;

if (nr_seq_paciente_setor_w IS NOT NULL AND nr_seq_paciente_setor_w::text <> '') or (nr_seq_paciente_w IS NOT NULL AND nr_seq_paciente_w::text <> '') or (nr_ciclo_w IS NOT NULL AND nr_ciclo_w::text <> '') then
	begin
		select	max(coalesce(coalesce(b.qt_tempo_agenda,a.qt_tempo_medic), qt_obter_dur_aplicacao(b.ds_dia_ciclo,a.nr_seq_medicacao,a.cd_protocolo,b.nr_seq_atendimento,
				coalesce(b.dt_real, b.dt_prevista),b.nr_seq_pend_agenda,b.nm_usuario,b.cd_estabelecimento))) qt_tempo_medic,
			max(a.cd_protocolo)
		into STRICT	qt_tempo_medic_w,
			cd_protocolo_w
		from	paciente_setor a,
			paciente_atendimento b
		where	a.nr_seq_paciente 	= b.nr_seq_paciente
		and	a.nr_seq_paciente 	= nr_seq_paciente_setor_w
		and	((b.nr_seq_atendimento 	= nr_seq_paciente_w) or (b.nr_ciclo  		= nr_ciclo_w));

		select	max(substr(a.nm_protocolo || '/' || b.nm_medicacao,1,255))
		into STRICT	nm_protocolo_w
		from	protocolo a,
			protocolo_medicacao b
		where	a.cd_protocolo = cd_protocolo_w
		and	a.cd_protocolo = b.cd_protocolo;
	exception
	when others then
		qt_tempo_medic_w	:= null;
		nm_protocolo_w		:= null;
	end;
end if;

ds_conteudo_w	:= ds_mensagem_p;

open c02;
loop
fetch c02 into
	cd_procedimento_w,
	ie_origem_proced_w;
EXIT WHEN NOT FOUND; /* apply on c02 */
	ds_procedimentos_w	:= substr(ds_procedimentos_w || chr(13) || chr(10) ||'   - '|| obter_descricao_procedimento(cd_procedimento_w,ie_origem_proced_w),1,4000);
end loop;
close c02;

ds_mat_qtdes_fornec_obs_w	:= null;
open c03;
loop
fetch c03 into
	c03_w;
EXIT WHEN NOT FOUND; /* apply on c03 */
	ds_materiais_w	:= substr(ds_materiais_w || chr(13) || chr(10) ||'   - '|| obter_desc_material(c03_w.cd_material),1,4000);

	if (coalesce(length(ds_mat_qtdes_fornec_obs_w),0) < 3999) then
		ds_mat_qtdes_fornec_obs_w := substr(ds_mat_qtdes_fornec_obs_w || chr(13) || chr(10) ||
							wheb_mensagem_pck.get_texto(320850) || c03_w.cd_material ||' - '|| substr(obter_desc_material(c03_w.cd_material),1,255) || chr(13) || chr(10) ||
							wheb_mensagem_pck.get_texto(320851) || c03_w.qt_solicitada || wheb_mensagem_pck.get_texto(320852) || coalesce(c03_w.qt_solicitada,0) || chr(13) || chr(10),1,3999);
		if (c03_w.cd_cgc_fabricante IS NOT NULL AND c03_w.cd_cgc_fabricante::text <> '') then
			ds_mat_qtdes_fornec_obs_w := 	substr(ds_mat_qtdes_fornec_obs_w ||
								wheb_mensagem_pck.get_texto(320853) || substr(obter_nome_pf_pj(null,c03_w.cd_cgc_fabricante),1,255) || chr(13) || chr(10),1,3999);
		end if;
		if (c03_w.ds_observacao IS NOT NULL AND c03_w.ds_observacao::text <> '') then
			ds_mat_qtdes_fornec_obs_w := 	substr(ds_mat_qtdes_fornec_obs_w ||
								wheb_mensagem_pck.get_texto(320858) || substr(c03_w.ds_observacao,1,255),1,3999) || chr(13) || chr(10);
		end if;
	end if;
end loop;
close c03;

begin
ds_conteudo_w	:= replace_macro(ds_conteudo_w,'@nm_paciente', substr(obter_nome_pf_pj(cd_pessoa_fisica_w,null),1,255));
ds_conteudo_w	:= replace_macro(ds_conteudo_w,'@nr_atendimento', nr_atendimento_w);
ds_conteudo_w	:= replace_macro(ds_conteudo_w,'@nr_prescricao', nr_prescricao_w);
ds_conteudo_w	:= replace_macro(ds_conteudo_w,'@ds_proc_autor', ds_proc_autor_w);
ds_conteudo_w	:= replace_macro(ds_conteudo_w,'@dt_nascimento_pac', to_char(obter_data_nascto_pf(cd_pessoa_fisica_w),'dd/mm/yyyy'));
ds_conteudo_w	:= replace_macro(ds_conteudo_w,'@ds_setor_pac', substr(obter_nome_setor(Obter_Setor_Atendimento(nr_atendimento_w)),1,255));
ds_conteudo_w	:= replace_macro(ds_conteudo_w,'@ds_leito_pac', ds_leito_atend_w);
ds_conteudo_w	:= replace_macro(ds_conteudo_w,'@ds_convenio', substr(obter_nome_convenio(cd_convenio_w),1,255));
ds_conteudo_w	:= replace_macro(ds_conteudo_w,'@dt_exec_prescr', to_char(dt_baixa_prescr_w,'dd/mm/yyyy hh24:mi:ss'));
ds_conteudo_w	:= replace_macro(ds_conteudo_w,'@nr_seq_autorizacao', nr_sequencia_autor_p);
ds_conteudo_w	:= replace_macro(ds_conteudo_w,'@ds_estagio_autor', ds_estagio_autor_w);
ds_conteudo_w	:= replace_macro(ds_conteudo_w,'@nm_medico_autor', substr(obter_nome_pf_pj(cd_medico_solicitante_w,null),1,255));
ds_conteudo_w	:= replace_macro(ds_conteudo_w,'@qt_tempo_medic', qt_tempo_medic_w);
ds_conteudo_w	:= replace_macro(ds_conteudo_w,'@nm_protocolo', nm_protocolo_w);
ds_conteudo_w	:= replace_macro(ds_conteudo_w,'@ds_procedimentos', substr(ds_procedimentos_w,1,1000));
ds_conteudo_w	:= replace_macro(ds_conteudo_w,'@ds_materiais', substr(ds_materiais_w,1,1000));
ds_conteudo_w	:= replace_macro(ds_conteudo_w,'@nr_prontuario', Obter_Prontuario_Paciente(cd_pessoa_fisica_w));
ds_conteudo_w	:= replace_macro(ds_conteudo_w,'@dt_autorizacao', dt_autorizacao_w);
ds_conteudo_w	:= replace_macro(ds_conteudo_w,'@ds_obs_autor', substr(ds_observacao_w,1,1000));
ds_conteudo_w	:= replace_macro(ds_conteudo_w,'@ds_mat_qtdes_fornec_obs',substr(ds_mat_qtdes_fornec_obs_w,1,2000));
exception
when others then
	ds_conteudo_w	:= null;
end;

return ds_conteudo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_texto_email_autor (nr_sequencia_autor_p bigint, ds_mensagem_p text) FROM PUBLIC;
