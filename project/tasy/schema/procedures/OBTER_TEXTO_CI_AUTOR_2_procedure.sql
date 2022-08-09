-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



CREATE TYPE ds_mat_qtdes_fornec_obs_v AS ( a_ds_mat_qtdes_fornec_obs	autorizacao_convenio.ds_observacao%type );


CREATE OR REPLACE PROCEDURE obter_texto_ci_autor_2 (nr_sequencia_autor_p bigint, nr_seq_regra_p bigint, ie_opcao_p text, ds_retorno_char_p INOUT text, ds_retorno_long_p INOUT text) AS $body$
DECLARE


/*ie_opcao_p			
T	Retorno o titulo da mensagem
C	Retorno o conteudo da mensagem 
*/
ds_conteudo_w			text;
ds_titulo_w			varchar(4000);
ds_procedimentos_w		varchar(4000);
ds_cod_proc_princ_qtd_w		varchar(4000);
ds_cod_proc_qtd_w		text;
ds_proced_autor_w		varchar(4000);
ds_materiais_w			varchar(4000);
ds_mat_autor_w			varchar(4000);
ds_proc_autor_w			varchar(255);
nm_protocolo_w			varchar(255);
ds_leito_atend_w		varchar(255);
qt_tempo_medic_w		varchar(100);
cd_procedimento_w		bigint;
cd_procedimento_auto_w		bigint;
qt_autorizada_w			bigint;
ie_origem_proced_w		bigint;
cd_material_w			integer;
dt_baixa_prescr_w		timestamp;
dt_autorizacao_w		timestamp;
dt_validade_guia_w 		timestamp;
ds_mat_qtdes_fornec_obs_w	varchar(4000);
ds_mat_qtdes_fornec_obs_ww	varchar(4000);
ds_mat_qtdes_autor_forn_obs_w	text;

ds_observacao_w			autorizacao_convenio.ds_observacao%type;
nr_atendimento_w		autorizacao_convenio.nr_atendimento%type;
nr_prescricao_w			autorizacao_convenio.nr_prescricao%type;
cd_convenio_w			autorizacao_convenio.cd_convenio%type;
cd_pessoa_fisica_w		autorizacao_convenio.cd_pessoa_fisica%type;
nr_seq_estagio_w		autorizacao_convenio.nr_seq_estagio%type;
cd_medico_solicitante_w		autorizacao_convenio.cd_medico_solicitante%type;
nr_seq_paciente_setor_w		autorizacao_convenio.nr_seq_paciente_setor%type;
nr_seq_paciente_w		autorizacao_convenio.nr_seq_paciente%type;
nr_ciclo_w			autorizacao_convenio.nr_ciclo%type;
ds_estagio_autor_w		estagio_autorizacao.ds_estagio%type;	
cd_protocolo_w			paciente_setor.cd_protocolo%type;
ie_forma_envio_w		regra_comunic_autor_conv.ie_forma_envio%type;

--Criacao do tipo da tabela que ira receber os dados do vetor para o calculo da rentabilidade
--Criando a tabela que ira receber as informacoes do calculo da rentabilidade
TYPE	t_ds_mat_qtdes_fornec_obs IS TABLE OF ds_mat_qtdes_fornec_obs_v index by integer;
--vetor criado para armazenar as informacoes.
v_ds_mat_qtdes_fornec_obs t_ds_mat_qtdes_fornec_obs;
i	bigint := 1;

c02 CURSOR FOR
SELECT	a.cd_procedimento,
	a.ie_origem_proced
from	procedimento_autorizado a
where	a.nr_sequencia_autor	= nr_sequencia_autor_p;

c03 CURSOR FOR
SELECT	a.*
from	material_autorizado a
where	a.nr_sequencia_autor	= nr_sequencia_autor_p;


c04 CURSOR FOR
SELECT	a.cd_procedimento,
	a.ie_origem_proced,
	a.qt_autorizada
from	procedimento_autorizado a
where	a.nr_sequencia_autor	= nr_sequencia_autor_p
and	coalesce(a.qt_autorizada,0) > 0;

c05 CURSOR FOR
SELECT	a.*
from	material_autorizado a
where	a.nr_sequencia_autor	= nr_sequencia_autor_p
and	coalesce(a.qt_autorizada,0) > 0;

c03_w	c03%rowtype;
c05_w	c03%rowtype;
c04_w	c04%rowtype;


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
	max(ds_observacao),
	max(cd_procedimento_principal),
	max(dt_validade_guia)
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
	ds_observacao_w,
	cd_procedimento_auto_w,
	dt_validade_guia_w
from	autorizacao_convenio
where	nr_sequencia	= nr_sequencia_autor_p;

select	max(ds_estagio)
into STRICT	ds_estagio_autor_w
from	estagio_autorizacao
where	nr_sequencia	= nr_seq_estagio_w;

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

ds_conteudo_w := null;

select	ds_titulo,
	ie_forma_envio
into STRICT	ds_titulo_w,
	ie_forma_envio_w
from	regra_comunic_autor_conv
where	nr_sequencia	= nr_seq_regra_p;

if (ds_retorno_long_p IS NOT NULL AND ds_retorno_long_p::text <> '') then
	ds_conteudo_w := ds_retorno_long_p;
end if;

if coalesce(ds_conteudo_w::text, '') = '' then

	select	ds_mensagem
	into STRICT	ds_conteudo_w
	from	regra_comunic_autor_conv
	where	nr_sequencia	= nr_seq_regra_p;

end if;

open c02;
loop
fetch c02 into
	cd_procedimento_w,
	ie_origem_proced_w;
EXIT WHEN NOT FOUND; /* apply on c02 */
	
	if (ie_forma_envio_w = 'E') then
		if (coalesce(ds_procedimentos_w,'X') = 'X') then
			ds_procedimentos_w := substr(obter_descricao_procedimento(cd_procedimento_w,ie_origem_proced_w),1,254)||'<br>';
		else	
			ds_procedimentos_w	:= substr(ds_procedimentos_w || substr(obter_descricao_procedimento(cd_procedimento_w,ie_origem_proced_w),1,254)||'<br>',1,4000);
		end if;
	elsif (ie_forma_envio_w = 'CI') then
		if (coalesce(ds_procedimentos_w,'X') = 'X') then
			ds_procedimentos_w := substr(obter_descricao_procedimento(cd_procedimento_w,ie_origem_proced_w),1,254)||' \par ';
		else	
			ds_procedimentos_w	:= substr(ds_procedimentos_w || substr(obter_descricao_procedimento(cd_procedimento_w,ie_origem_proced_w),1,254)||' \par ',1,4000);
		end if;
	end if;
end loop;
close c02;

ds_materiais_w := null;
open c03;
loop
fetch c03 into
	c03_w;
EXIT WHEN NOT FOUND; /* apply on c03 */
	ds_mat_qtdes_fornec_obs_w	:= null;
	if (ie_forma_envio_w = 'E') then
		if (coalesce(ds_materiais_w,'X') = 'X') then
			ds_materiais_w := substr(obter_desc_material(c03_w.cd_material),1,255)||'<br>';
		else	
			ds_materiais_w := substr(ds_materiais_w || substr(obter_desc_material(c03_w.cd_material),1,255)||'<br>',1,4000);
		end if;
	elsif (ie_forma_envio_w = 'CI') then
		if (coalesce(ds_materiais_w,'X') = 'X') then
			ds_materiais_w := substr(obter_desc_material(c03_w.cd_material),1,255)||' \par ';
		else	
			ds_materiais_w := substr(ds_materiais_w || substr(obter_desc_material(c03_w.cd_material),1,255)||' \par ',1,4000);
		end if;
	end if;
	
	ds_mat_qtdes_fornec_obs_w := substr(wheb_mensagem_pck.get_texto(320850) || c03_w.cd_material ||' - '|| substr(obter_desc_material(c03_w.cd_material),1,255) || chr(13) || chr(10) ||
					wheb_mensagem_pck.get_texto(320851) || c03_w.qt_solicitada || wheb_mensagem_pck.get_texto(320852) || coalesce(c03_w.qt_solicitada,0) || chr(13) || chr(10),1,3999);
	if (c03_w.cd_cgc_fabricante IS NOT NULL AND c03_w.cd_cgc_fabricante::text <> '') then
		ds_mat_qtdes_fornec_obs_w := 	substr( ds_mat_qtdes_fornec_obs_w ||
							wheb_mensagem_pck.get_texto(320853) || substr(obter_nome_pf_pj(null,c03_w.cd_cgc_fabricante),1,255) || chr(13) || chr(10),1,3999);
	end if;
	if (c03_w.ds_observacao IS NOT NULL AND c03_w.ds_observacao::text <> '') then
		ds_mat_qtdes_fornec_obs_w := 	substr( ds_mat_qtdes_fornec_obs_w ||
							wheb_mensagem_pck.get_texto(320858) || substr(c03_w.ds_observacao,1,255) || chr(13) || chr(10),1,3999);
	end if;	
	if (ds_mat_qtdes_fornec_obs_w IS NOT NULL AND ds_mat_qtdes_fornec_obs_w::text <> '') and (ie_forma_envio_w = 'E') then
		ds_mat_qtdes_fornec_obs_w := substr( ds_mat_qtdes_fornec_obs_w ||' <br>',1,3999);
	elsif (ds_mat_qtdes_fornec_obs_w IS NOT NULL AND ds_mat_qtdes_fornec_obs_w::text <> '') and (ie_forma_envio_w = 'CI') then
		ds_mat_qtdes_fornec_obs_w := substr( ds_mat_qtdes_fornec_obs_w ||' \par ',1,3999);
		
	end if;
	v_ds_mat_qtdes_fornec_obs[i].a_ds_mat_qtdes_fornec_obs := ds_mat_qtdes_fornec_obs_w  || chr(13) || chr(10);
	i := i + 1;
end loop;
close c03;

ds_proced_autor_w := null;
ds_cod_proc_qtd_w := null;

open c04;
loop
fetch c04 into
	c04_w;
EXIT WHEN NOT FOUND; /* apply on c04 */	
	if (ie_forma_envio_w = 'E') then
		if (coalesce(ds_proced_autor_w,'X') = 'X') then
			ds_proced_autor_w := substr(obter_descricao_procedimento(c04_w.cd_procedimento,c04_w.ie_origem_proced),1,254) ||  chr(13) || chr(10);
			
			ds_cod_proc_qtd_w 	:= substr(' ' || obter_desc_expressao(729588) || c04_w.cd_procedimento || chr(9)
							|| substr(obter_descricao_procedimento(c04_w.cd_procedimento,c04_w.ie_origem_proced),1,254)
							|| ' ' || obter_desc_expressao(719721) || ':' || c04_w.qt_autorizada,1,32000);			
		else	
			ds_proced_autor_w 	:= substr(ds_proced_autor_w
							|| substr(obter_descricao_procedimento(c04_w.cd_procedimento,c04_w.ie_origem_proced),1,254)
							||  chr(13) || chr(10),1,3999);
			
			ds_cod_proc_qtd_w 	:= substr(ds_cod_proc_qtd_w
							|| ' '  || obter_desc_expressao(729588) || c04_w.cd_procedimento || chr(9)
							|| substr(obter_descricao_procedimento(c04_w.cd_procedimento,c04_w.ie_origem_proced),1,254) 
							|| ' ' || obter_desc_expressao(719721) || ':' || c04_w.qt_autorizada 
							||  chr(13) || chr(10),1,32000);

		end if;
	elsif (ie_forma_envio_w = 'CI') then
		if (coalesce(ds_proced_autor_w,'X') = 'X') then
			ds_proced_autor_w := substr(obter_descricao_procedimento(c04_w.cd_procedimento,c04_w.ie_origem_proced) || chr(13) || chr(10),1,254);
			
			ds_cod_proc_qtd_w 	:= substr(' ' || obter_desc_expressao(729588) || ':' || c04_w.cd_procedimento || chr(9)
							|| substr(obter_descricao_procedimento(c04_w.cd_procedimento,c04_w.ie_origem_proced),1,254)
							|| ' ' || obter_desc_expressao(719721) || ':' || c04_w.qt_autorizada|| chr(13) || chr(10),1,32000);
				
		else	
			ds_proced_autor_w 	:= substr(ds_proced_autor_w
							|| substr(obter_descricao_procedimento(c04_w.cd_procedimento,c04_w.ie_origem_proced),1,254)
							|| chr(13) || chr(10),1,3999);
			
			ds_cod_proc_qtd_w	:= substr(ds_cod_proc_qtd_w
							|| ' ' || obter_desc_expressao(729588) || ':' || c04_w.cd_procedimento || chr(9)
							|| substr(obter_descricao_procedimento(c04_w.cd_procedimento,c04_w.ie_origem_proced),1,254) 
							|| ' ' || obter_desc_expressao(719721) || ':' || c04_w.qt_autorizada || chr(13) || chr(10),1,32000);	
			
		end if;
	end if;
	
	if (ie_forma_envio_w = 'E' 	and 	(ds_cod_proc_qtd_w IS NOT NULL AND ds_cod_proc_qtd_w::text <> '')) then
		ds_cod_proc_qtd_w :=  	substr(ds_cod_proc_qtd_w 	|| ' <br/> ',1,32000);
		ds_proced_autor_w := 	substr(ds_proced_autor_w 	|| ' <br/> ',1,3999);
	elsif (ie_forma_envio_w = 'CI'	and	 (ds_cod_proc_qtd_w IS NOT NULL AND ds_cod_proc_qtd_w::text <> '')) then
		ds_cod_proc_qtd_w := 	substr(ds_cod_proc_qtd_w  	|| ' \par ',1,32000);
		ds_proced_autor_w := 	substr(ds_proced_autor_w 	|| ' \par ',1,3999);
	end if;
end loop;
close c04;

ds_mat_qtdes_autor_forn_obs_w	:= null;
ds_mat_autor_w := null;
open c05;
loop
fetch c05 into
	c05_w;
EXIT WHEN NOT FOUND; /* apply on c05 */
	if (ie_forma_envio_w = 'E') then
		if (coalesce(ds_mat_autor_w,'X') = 'X') then
			ds_mat_autor_w := substr(obter_desc_material(c05_w.cd_material),1,255)||'<br>';
		else	
			ds_mat_autor_w := substr(ds_mat_autor_w || substr(obter_desc_material(c05_w.cd_material),1,255)||'<br>',1,4000);
		end if;
	elsif (ie_forma_envio_w = 'CI') then
		if (coalesce(ds_mat_autor_w,'X') = 'X') then
			ds_mat_autor_w := substr(obter_desc_material(c05_w.cd_material),1,255)||' \par ';
		else	
			ds_mat_autor_w := substr(ds_mat_autor_w || substr(obter_desc_material(c05_w.cd_material),1,255)||' \par ',1,4000);
		end if;
	end if;
	
	if (coalesce(length(ds_mat_qtdes_autor_forn_obs_w),0) < 31999) then
		ds_mat_qtdes_autor_forn_obs_w := substr(ds_mat_qtdes_autor_forn_obs_w || chr(13) || chr(10) ||
							wheb_mensagem_pck.get_texto(320850) || c05_w.cd_material ||' - '|| substr(obter_desc_material(c05_w.cd_material),1,255) || chr(13) || chr(10) ||
							wheb_mensagem_pck.get_texto(320851) || c05_w.qt_solicitada || wheb_mensagem_pck.get_texto(320852) || coalesce(c05_w.qt_autorizada,0) || chr(13) || chr(10),1,32000);
		if (c05_w.cd_cgc_fabricante IS NOT NULL AND c05_w.cd_cgc_fabricante::text <> '') then
			ds_mat_qtdes_autor_forn_obs_w := 	substr(ds_mat_qtdes_autor_forn_obs_w ||
								wheb_mensagem_pck.get_texto(320853) || substr(obter_nome_pf_pj(null,c05_w.cd_cgc_fabricante),1,255) || chr(13) || chr(10),1,32000);
		end if;
		if (c05_w.ds_observacao IS NOT NULL AND c05_w.ds_observacao::text <> '') then
			ds_mat_qtdes_autor_forn_obs_w := 	substr(ds_mat_qtdes_autor_forn_obs_w ||
								wheb_mensagem_pck.get_texto(320858) || substr(c05_w.ds_observacao,1,255) || chr(13) || chr(10),1,32000);
		end if;	
		if (ds_mat_qtdes_autor_forn_obs_w IS NOT NULL AND ds_mat_qtdes_autor_forn_obs_w::text <> '') and (ie_forma_envio_w = 'E') then
			ds_mat_qtdes_autor_forn_obs_w := substr(ds_mat_qtdes_autor_forn_obs_w ||'<br>',1,32000);
		elsif (ds_mat_qtdes_autor_forn_obs_w IS NOT NULL AND ds_mat_qtdes_autor_forn_obs_w::text <> '') and (ie_forma_envio_w = 'CI') then
			ds_mat_qtdes_autor_forn_obs_w := substr(ds_mat_qtdes_autor_forn_obs_w ||' \par ',1,32000);
			
		end if;
	
	end if;
end loop;
close c05;

if (coalesce(cd_procedimento_auto_w,0) > 0 ) then
	ds_cod_proc_princ_qtd_w := substr(obter_desc_expressao(729588) || ':' || cd_procedimento_auto_w || ' ' ||ds_proc_autor_w,1,254);
end if;

begin
ds_conteudo_w	:= replace_macro(ds_conteudo_w,'@nm_paciente', substr(obter_nome_pf_pj(cd_pessoa_fisica_w,null),1,255));
ds_conteudo_w	:= replace_macro(ds_conteudo_w,'@nr_atendimento', nr_atendimento_w);
ds_conteudo_w	:= replace_macro(ds_conteudo_w,'@nr_prescricao', nr_prescricao_w);
ds_conteudo_w	:= replace_macro(ds_conteudo_w,'@ds_proc_autor', ds_proc_autor_w);
ds_conteudo_w	:= replace_macro(ds_conteudo_w,'@dt_nascimento_pac', PKG_DATE_FORMATERS.TO_VARCHAR(obter_data_nascto_pf(cd_pessoa_fisica_w),'shortDate', WHEB_USUARIO_PCK.GET_CD_ESTABELECIMENTO,WHEB_USUARIO_PCK.GET_NM_USUARIO));
ds_conteudo_w	:= replace_macro(ds_conteudo_w,'@ds_setor_pac', substr(obter_nome_setor(Obter_Setor_Atendimento(nr_atendimento_w)),1,255));
ds_conteudo_w	:= replace_macro(ds_conteudo_w,'@ds_leito_pac', ds_leito_atend_w);
ds_conteudo_w	:= replace_macro(ds_conteudo_w,'@ds_convenio', substr(obter_nome_convenio(cd_convenio_w),1,255));
ds_conteudo_w	:= replace_macro(ds_conteudo_w,'@dt_exec_prescr', PKG_DATE_FORMATERS.TO_VARCHAR(dt_baixa_prescr_w,'timestamp', WHEB_USUARIO_PCK.GET_CD_ESTABELECIMENTO,WHEB_USUARIO_PCK.GET_NM_USUARIO));
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

for i in 1..v_ds_mat_qtdes_fornec_obs.count loop
	ds_mat_qtdes_fornec_obs_ww := substr(v_ds_mat_qtdes_fornec_obs[i].a_ds_mat_qtdes_fornec_obs,1,32000) || '@ds_mat_qtdes_fornec_obs';
	ds_conteudo_w	:= replace_macro(ds_conteudo_w,'@ds_mat_qtdes_fornec_obs', ds_mat_qtdes_fornec_obs_ww);
end loop;

ds_conteudo_w	:= replace_macro(ds_conteudo_w,'@ds_mat_qtdes_fornec_obs', '');
ds_conteudo_w	:= replace_macro(ds_conteudo_w,'@ds_mat_autorizados', substr(ds_mat_autor_w,1,32000));
ds_conteudo_w	:= replace_macro(ds_conteudo_w,'@ds_proced_autorizados', substr(ds_proced_autor_w,1,32000));
ds_conteudo_w	:= replace_macro(ds_conteudo_w,'@ds_mat_qtdes_autor_forn_obs',substr(ds_mat_qtdes_autor_forn_obs_w,1,32000));
ds_conteudo_w	:= replace_macro(ds_conteudo_w,'@ds_proc_princ_autor_qtd',substr(ds_cod_proc_princ_qtd_w,1,4000));
ds_conteudo_w	:= replace_macro(ds_conteudo_w,'@ds_cod_proc_qtd',substr(ds_cod_proc_qtd_w,1,32000));
ds_conteudo_w	:= replace_macro(ds_conteudo_w,'@dt_validade_guia',PKG_DATE_FORMATERS.TO_VARCHAR(dt_validade_guia_w,'timestamp', WHEB_USUARIO_PCK.GET_CD_ESTABELECIMENTO,WHEB_USUARIO_PCK.GET_NM_USUARIO));

exception
when others then
	ds_conteudo_w	:= null;
end;

--begin
ds_titulo_w	:= replace_macro(ds_titulo_w,'@nm_paciente', substr(obter_nome_pf_pj(cd_pessoa_fisica_w,null),1,255));
ds_titulo_w	:= replace_macro(ds_titulo_w,'@nr_atendimento', nr_atendimento_w);
ds_titulo_w	:= replace_macro(ds_titulo_w,'@nr_prescricao', nr_prescricao_w);
ds_titulo_w	:= replace_macro(ds_titulo_w,'@ds_proc_autor', ds_proc_autor_w);
ds_titulo_w	:= replace_macro(ds_titulo_w,'@dt_nascimento_pac', PKG_DATE_FORMATERS.TO_VARCHAR(obter_data_nascto_pf(cd_pessoa_fisica_w),'shortDate', WHEB_USUARIO_PCK.GET_CD_ESTABELECIMENTO,WHEB_USUARIO_PCK.GET_NM_USUARIO));
ds_titulo_w	:= replace_macro(ds_titulo_w,'@ds_setor_pac', substr(obter_nome_setor(Obter_Setor_Atendimento(nr_atendimento_w)),1,255));
ds_titulo_w	:= replace_macro(ds_titulo_w,'@ds_setor_pac', substr(obter_nome_setor(Obter_Setor_Atendimento(nr_atendimento_w)),1,255));
ds_titulo_w	:= replace_macro(ds_titulo_w,'@ds_leito_pac', ds_leito_atend_w);
ds_titulo_w	:= replace_macro(ds_titulo_w,'@ds_convenio', substr(obter_nome_convenio(cd_convenio_w),1,255));
ds_titulo_w	:= replace_macro(ds_titulo_w,'@dt_exec_prescr', PKG_DATE_FORMATERS.TO_VARCHAR(dt_baixa_prescr_w,'timestamp', WHEB_USUARIO_PCK.GET_CD_ESTABELECIMENTO,WHEB_USUARIO_PCK.GET_NM_USUARIO));
ds_titulo_w	:= replace_macro(ds_titulo_w,'@nr_seq_autorizacao', nr_sequencia_autor_p);
ds_titulo_w	:= replace_macro(ds_titulo_w,'@ds_estagio_autor', ds_estagio_autor_w);
ds_titulo_w	:= replace_macro(ds_titulo_w,'@nm_medico_autor', substr(obter_nome_pf_pj(cd_medico_solicitante_w,null),1,255));
ds_titulo_w	:= replace_macro(ds_titulo_w,'@qt_tempo_medic', qt_tempo_medic_w);
ds_titulo_w	:= replace_macro(ds_titulo_w,'@nm_protocolo', nm_protocolo_w);
ds_titulo_w	:= replace_macro(ds_titulo_w,'@nr_prontuario', Obter_Prontuario_Paciente(cd_pessoa_fisica_w));
ds_titulo_w	:= replace_macro(ds_titulo_w,'@dt_autorizacao', dt_autorizacao_w);
ds_titulo_w	:= replace_macro(ds_titulo_w,'@ds_obs_autor', substr(ds_observacao_w,1,1000));
ds_titulo_w	:= replace_macro(ds_titulo_w,'@dt_validade_guia',substr(dt_validade_guia_w,1,2000));
/*exception
when others then
	ds_titulo_w	:= null;
end;*/
if (ie_opcao_p = 'T') then
	ds_retorno_char_p	:= ds_titulo_w;	
elsif (ie_opcao_p = 'C') then
	ds_retorno_long_p 	:= ds_conteudo_w;
end if;		

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_texto_ci_autor_2 (nr_sequencia_autor_p bigint, nr_seq_regra_p bigint, ie_opcao_p text, ds_retorno_char_p INOUT text, ds_retorno_long_p INOUT text) FROM PUBLIC;
