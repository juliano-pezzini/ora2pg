-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_evento_aprov_result_lab (nr_seq_evento_p bigint, nm_usuario_p text, nr_prescricao_p bigint, nr_seq_prescr_p bigint, nr_seq_exame_p bigint, ie_trigger_p text) AS $body$
DECLARE

 
ie_forma_ev_w			varchar(15);
ie_pessoa_destino_w		varchar(15);
cd_pf_destino_w			varchar(10);
ds_mensagem_w			varchar(4000);
ds_titulo_w			varchar(100);
cd_pessoa_destino_w		varchar(10);
nr_sequencia_w			bigint;
nm_paciente_w			varchar(60);
nm_paciente_abrev_w		varchar(60);
ds_unidade_w			varchar(60);
ds_setor_atendimento_w		varchar(60);
ie_usuario_aceite_w		varchar(1);
qt_corresp_w			integer;
cd_setor_atendimento_w		integer;
cd_perfil_w			integer;
cd_pessoa_regra_w		varchar(10);
nr_ramal_w			varchar(10);
nr_telefone_w			varchar(10);
cd_convenio_w			bigint;
cd_pessoa_fisica_w		varchar(10);
nr_atendimento_w		bigint;
nm_exame_w			varchar(80);
nm_usuario_destino_w 		varchar(15);
cd_setor_atend_pac_w		integer;
nm_usuario_liberador_w 		varchar(15);
ds_resultado_ant_w 		 varchar(50);
nr_seq_exame_nao_aceit_w	bigint;
ds_resultado_nao_aceit_w	varchar(50);
cd_material_exame_w		varchar(50);
dt_aprovacao_w			timestamp;
cd_medico_resp_w		varchar(10);
nm_usuario_resp_w		varchar(15);
nm_pessoa_resp_w		varchar(100);
ds_senha_atend_w		varchar(20);
ie_existe_regra_proc_w		varchar(1);
ie_excecao_alerta_pessoa_w	varchar(1);
nm_sobrenome_abrev_w		varchar(60);

C01 CURSOR FOR 
	SELECT	ie_forma_ev, 
		ie_pessoa_destino, 
		cd_pf_destino, 
		coalesce(ie_usuario_aceite,'N'), 
		cd_setor_atendimento, 
		cd_perfil 
	from	ev_evento_regra_dest 
	where	nr_seq_evento	= nr_seq_evento_p 
	and (coalesce(cd_convenio, coalesce(cd_convenio_w,0)) = coalesce(cd_convenio_w,0)) 
	and (coalesce(cd_setor_atend_pac, coalesce(cd_setor_atend_pac_w,0)) = coalesce(cd_setor_atend_pac_w,0)) 
	AND (coalesce(ie_excecao,'N') = 'N') 
	and (ie_existe_regra_proc_w = 'S') 
	order by ie_forma_ev;

C02 CURSOR FOR 
	SELECT	obter_dados_usuario_opcao(nm_usuario,'C') 
	from	usuario_setor_v 
	where	cd_setor_atendimento = cd_setor_atendimento_w 
	and	ie_forma_ev_w in (2,3) 
	and	(obter_dados_usuario_opcao(nm_usuario,'C') IS NOT NULL AND (obter_dados_usuario_opcao(nm_usuario,'C'))::text <> '');

C03 CURSOR FOR 
	SELECT	obter_dados_usuario_opcao(nm_usuario,'C'), 
		nm_usuario 
	from	usuario_perfil 
	where	cd_perfil = cd_perfil_w 
	and	ie_forma_ev_w in (2,3) 
	and	(obter_dados_usuario_opcao(nm_usuario,'C') IS NOT NULL AND (obter_dados_usuario_opcao(nm_usuario,'C'))::text <> '') 
	and	coalesce(obter_dados_usuario_opcao(nm_usuario,'T'),'A') = 'A';

 

BEGIN 
 
select 	lab_obter_se_regra_proced_evt(nr_seq_evento_p, nr_prescricao_p, nr_seq_exame_p) 
into STRICT 	ie_existe_regra_proc_w
;
	 
select	ds_titulo, 
	ds_mensagem 
into STRICT	ds_titulo_w, 
	ds_mensagem_w 
from	ev_evento 
where	nr_sequencia	= nr_seq_evento_p;
 
select b.nr_atendimento, 
    b.cd_pessoa_fisica, 
	b.ds_senha 
into STRICT	nr_atendimento_w, 
	cd_pessoa_fisica_w, 
	ds_senha_atend_w 
from  prescr_medica a, 
    atendimento_paciente b 
where  a.nr_atendimento = b.nr_atendimento 
and   a.nr_prescricao = nr_prescricao_p;
 
select	substr(obter_nome_pf(cd_pessoa_fisica_w),1,60), 
	substr(abrevia_nome_pf(cd_pessoa_fisica_w,'M'),1,60), 
	substr(obter_unidade_atendimento(nr_atendimento_w,'A','U'),1,60), 
	substr(obter_unidade_atendimento(nr_atendimento_w,'A','S'),1,60), 
	substr(obter_unidade_atendimento(nr_atendimento_w,'A','CS'),1,60), 
	substr(Obter_medico_resp_atend(nr_atendimento_w,'N'),1,100), 
  SUBSTR(ABREVIA_NOME(OBTER_NOME_PESSOA_FISICA(cd_pessoa_fisica_w,''),''),1,60) 
into STRICT nm_paciente_w, 
	 nm_paciente_abrev_w, 
	 ds_unidade_w, 
	 ds_setor_atendimento_w, 
	 cd_setor_atend_pac_w, 
	 nm_pessoa_resp_w, 
   nm_sobrenome_abrev_w
;
 
select 	a.nm_exame 
into STRICT 	nm_exame_w 
from 	exame_laboratorio a 
where 	a.nr_seq_exame = nr_seq_exame_p;
 
select MAX(nm_usuario) 
into STRICT  nm_usuario_liberador_w 
from  prescr_proc_etapa 
where nr_prescricao = nr_prescricao_p 
and	  nr_seq_prescricao = nr_seq_prescr_p 
and  ie_etapa >=35;
 
select 	MAX(a.cd_material_exame), 
		MAX(c.dt_aprovacao), 
		MAX(c.cd_medico_resp) 
into STRICT 	cd_material_exame_w, 
		dt_aprovacao_w, 
		cd_medico_resp_w 
from 	exame_lab_result_item c, 
		exame_lab_resultado b, 
		material_exame_lab a 
where 	a.nr_sequencia = c.nr_seq_material 
and		c.nr_seq_resultado = b.nr_seq_resultado		 
and		b.nr_prescricao = nr_prescricao_p 
and		c.nr_seq_prescr = nr_seq_prescr_p;
 
if (cd_medico_resp_w IS NOT NULL AND cd_medico_resp_w::text <> '') then 
	select 	obter_usuario_pf(cd_medico_resp_w) 
	into STRICT	nm_usuario_resp_w 
	;
else 
	nm_usuario_resp_w := nm_usuario_p;
end if;
 
SELECT * FROM obter_res_nao_aceit_alert(nr_prescricao_p, nr_seq_prescr_p, nr_seq_exame_p, cd_material_exame_w, nr_seq_exame_nao_aceit_w, ds_resultado_nao_aceit_w) INTO STRICT nr_seq_exame_nao_aceit_w, ds_resultado_nao_aceit_w;
 
--gravar log tasy(89,nr_prescricao_p||' - '||nr_seq_prescr_p||' - '||nr_seq_exame_p||' - '||cd_material_exame_w||' - '||nr_seq_exame_nao_aceit_w||' - '||ds_resultado_nao_aceit_w,'teste'); 
-- traz o último resultado anterior 
ds_resultado_ant_w := substr(LAB_Obter_Result_Ant_evento(nr_prescricao_p, nr_seq_exame_nao_aceit_w, ' ', nr_seq_prescr_p, 5),1,50);
 
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@atendimento',nr_atendimento_w),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@prescricao',nr_prescricao_p),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@paciente',nm_paciente_w),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@pac_abreviado',nm_paciente_abrev_w),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@exame',nm_exame_w),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@quarto',ds_unidade_w),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@setor',ds_setor_atendimento_w),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@usuario_liberador',coalesce(nm_usuario_liberador_w,nm_usuario_resp_w)),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@result_inaceitavel',ds_resultado_nao_aceit_w),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@result_anterior_inac',ds_resultado_ant_w),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@dt_aprovacao',dt_aprovacao_w),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@med_resp',nm_pessoa_resp_w),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@senha_atend',ds_senha_atend_w),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@pac_Sobrenome_Abrev',nm_sobrenome_abrev_w),1,4000);
 
ds_titulo_w	:= substr(replace_macro(ds_titulo_w,'@atendimento',nr_atendimento_w),1,4000);
ds_titulo_w	:= substr(replace_macro(ds_titulo_w,'@prescricao',nr_prescricao_p),1,4000);
ds_titulo_w	:= substr(replace_macro(ds_titulo_w,'@paciente',nm_paciente_w),1,4000);
ds_titulo_w	:= substr(replace_macro(ds_titulo_w,'@pac_abreviado',nm_paciente_abrev_w),1,4000);
ds_titulo_w	:= substr(replace_macro(ds_titulo_w,'@exame',nm_exame_w),1,4000);
ds_titulo_w	:= substr(replace_macro(ds_titulo_w,'@quarto',ds_unidade_w),1,4000);
ds_titulo_w	:= substr(replace_macro(ds_titulo_w,'@setor',ds_setor_atendimento_w),1,4000);
ds_titulo_w	:= substr(replace_macro(ds_titulo_w,'@usuario_liberador',coalesce(nm_usuario_liberador_w,nm_usuario_resp_w)),1,4000);
ds_titulo_w	:= substr(replace_macro(ds_titulo_w,'@result_inaceitavel',ds_resultado_nao_aceit_w),1,4000);
ds_titulo_w	:= substr(replace_macro(ds_titulo_w,'@result_anterior_inac',ds_resultado_ant_w),1,4000);
ds_titulo_w	:= substr(replace_macro(ds_titulo_w,'@dt_aprovacao',dt_aprovacao_w),1,4000);
ds_titulo_w	:= substr(replace_macro(ds_titulo_w,'@med_resp',nm_pessoa_resp_w),1,4000);
ds_titulo_w	:= substr(replace_macro(ds_titulo_w,'@senha_atend',ds_senha_atend_w),1,4000);
ds_titulo_w	:= substr(replace_macro(ds_titulo_w,'@pac_Sobrenome_Abrev',nm_sobrenome_abrev_w),1,4000);
 
 
select	nextval('ev_evento_paciente_seq') 
into STRICT	nr_sequencia_w
;
 
insert into ev_evento_paciente( 
	nr_sequencia, 
	nr_seq_evento, 
	dt_atualizacao, 
	nm_usuario, 
	dt_atualizacao_nrec, 
	nm_usuario_nrec, 
	cd_pessoa_fisica, 
	nr_atendimento, 
	ds_titulo, 
	ds_mensagem, 
	ie_status, 
	dt_evento, 
	dt_liberacao, 
	ie_situacao) 
values (	nr_sequencia_w, 
	nr_seq_evento_p, 
	clock_timestamp(), 
	nm_usuario_p, 
	clock_timestamp(), 
	nm_usuario_p, 
	cd_pessoa_fisica_w, 
	nr_atendimento_w, 
	ds_titulo_w, 
	ds_mensagem_w, 
	'G', 
	clock_timestamp(), 
	clock_timestamp(), 
	'A');
 
open C01;
loop 
fetch C01 into 
	ie_forma_ev_w, 
	ie_pessoa_destino_w, 
	cd_pf_destino_w, 
	ie_usuario_aceite_w, 
	cd_setor_atendimento_w, 
	cd_perfil_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	qt_corresp_w	:= 1;
	cd_pessoa_destino_w	:= null;
	 
	if (ie_pessoa_destino_w = '1') then /* Médico do atendimento */
 
		begin 
		select	max(cd_medico_atendimento) 
		into STRICT	cd_pessoa_destino_w 
		from	atendimento_paciente 
		where	nr_atendimento	= nr_atendimento_w;
		end;
	elsif (ie_pessoa_destino_w = '2') then /*Médico responsável pelo paciente*/
 
		begin 
		select	max(cd_medico_resp) 
		into STRICT	cd_pessoa_destino_w 
		from	atendimento_paciente 
		where	nr_atendimento	= nr_atendimento_w;
		end;
	elsif (ie_pessoa_destino_w = '4') then /*Médico referido*/
 
		begin 
		select	max(cd_medico_referido) 
		into STRICT	cd_pessoa_destino_w 
		from	atendimento_paciente 
		where	nr_atendimento	= nr_atendimento_w;
		end;
	elsif (ie_pessoa_destino_w = '5') or (ie_pessoa_destino_w = '12') then /*Pessoa fixa ou Usuário fixo*/
 
		begin 
		cd_pessoa_destino_w	:= cd_pf_destino_w;
		end;
	elsif (ie_pessoa_destino_w = '19') then /*Paciente*/
 
		begin 
		select	cd_pessoa_fisica 
		into STRICT	cd_pessoa_destino_w 
		from	atendimento_paciente 
		where	nr_atendimento = nr_atendimento_w;
		end;
	 
	elsif (ie_pessoa_destino_w = '21') then /* Médico responsável pelo atendimento, considerando pessoa fixa */
 
		begin 
		select	max(cd_medico_resp) 
		into STRICT	cd_pessoa_destino_w 
		from	atendimento_paciente 
		where	nr_atendimento	= nr_atendimento_w 
		and	cd_medico_resp = cd_pf_destino_w;
		end;
	end if;
	 
		 
	if (ie_usuario_aceite_w = 'S') and (cd_pessoa_destino_w IS NOT NULL AND cd_pessoa_destino_w::text <> '') and (ie_forma_ev_w = '1') then 
		begin 
		select	count(*) 
		into STRICT	qt_corresp_w 
		from	pessoa_fisica_corresp 
		where	cd_pessoa_fisica	= cd_pessoa_destino_w 
		and	ie_tipo_corresp		= 'MCel' 
		and	ie_tipo_doc		= 'AE';
		end;
	elsif (ie_usuario_aceite_w = 'S') and (cd_pessoa_destino_w IS NOT NULL AND cd_pessoa_destino_w::text <> '') and (ie_forma_ev_w = '3') then 
		begin 
		select	count(*) 
		into STRICT	qt_corresp_w 
		from	pessoa_fisica_corresp 
		where	cd_pessoa_fisica	= cd_pessoa_destino_w 
		and	ie_tipo_corresp		= 'CI' 
		and	ie_tipo_doc		= 'AE';
		end;
	elsif (ie_usuario_aceite_w = 'S') and (cd_pessoa_destino_w IS NOT NULL AND cd_pessoa_destino_w::text <> '') and (ie_forma_ev_w = '4') then 
		begin 
		select	count(*) 
		into STRICT	qt_corresp_w 
		from	pessoa_fisica_corresp 
		where	cd_pessoa_fisica	= cd_pessoa_destino_w 
		and	ie_tipo_corresp		= 'Email' 
		and	ie_tipo_doc		= 'AE';
		end;
	end if;
 
	if (cd_pessoa_destino_w IS NOT NULL AND cd_pessoa_destino_w::text <> '') and (qt_corresp_w > 0) then 
		begin		 
		 
		ie_excecao_alerta_pessoa_w := obter_excecao_alerta(nr_seq_evento_p, cd_pessoa_destino_w, ie_forma_ev_w);
		 
		--Não possui exceção entao gravar normalmente o alerta (exceção = pessoa não quer receber alerta) 
		if (coalesce(ie_excecao_alerta_pessoa_w,'N') = 'N') then 
 
			insert into ev_evento_pac_destino( 
				nr_sequencia, 
				nr_seq_ev_pac, 
				dt_atualizacao, 
				nm_usuario, 
				dt_atualizacao_nrec, 
				nm_usuario_nrec, 
				cd_pessoa_fisica, 
				ie_forma_ev, 
				ie_status, 
				dt_ciencia, 
				ie_pessoa_destino, 
				dt_evento) 
			values (	nextval('ev_evento_pac_destino_seq'), 
				nr_sequencia_w, 
				clock_timestamp(), 
				nm_usuario_p, 
				clock_timestamp(), 
				nm_usuario_p, 
				cd_pessoa_destino_w, 
				ie_forma_ev_w, 
				'G', 
				null, 
				ie_pessoa_destino_w, 
				clock_timestamp());
		end if;
		end;
	end if;
 
	open C02;
	loop 
	fetch C02 into 
		cd_pessoa_regra_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin 
		 
		if (cd_pessoa_regra_w IS NOT NULL AND cd_pessoa_regra_w::text <> '') then 
		 
			ie_excecao_alerta_pessoa_w := obter_excecao_alerta(nr_seq_evento_p, cd_pessoa_regra_w, ie_forma_ev_w);
		 
			--Não possui exceção entao gravar normalmente o alerta (exceção = pessoa não quer receber alerta) 
			if (coalesce(ie_excecao_alerta_pessoa_w,'N') = 'N') then		 
				insert into ev_evento_pac_destino( 
					nr_sequencia, 
					nr_seq_ev_pac, 
					dt_atualizacao, 
					nm_usuario, 
					dt_atualizacao_nrec, 
					nm_usuario_nrec, 
					cd_pessoa_fisica, 
					ie_forma_ev, 
					ie_status, 
					dt_ciencia, 
					ie_pessoa_destino, 
					dt_evento) 
				values (	nextval('ev_evento_pac_destino_seq'), 
					nr_sequencia_w, 
					clock_timestamp(), 
					nm_usuario_p, 
					clock_timestamp(), 
					nm_usuario_p, 
					cd_pessoa_regra_w, 
					ie_forma_ev_w, 
					'G', 
					null, 
					ie_pessoa_destino_w, 
					clock_timestamp());
			end if;
		end if;
		end;
	end loop;
	close C02;
 
	open C03;
	loop 
	fetch C03 into 
		cd_pessoa_regra_w, 
		nm_usuario_destino_w;
	EXIT WHEN NOT FOUND; /* apply on C03 */
		begin 
		 
		if (cd_pessoa_regra_w IS NOT NULL AND cd_pessoa_regra_w::text <> '') then 
 
			ie_excecao_alerta_pessoa_w := obter_excecao_alerta(nr_seq_evento_p, cd_pessoa_regra_w, ie_forma_ev_w);
		 
			--Não possui exceção entao gravar normalmente o alerta (exceção = pessoa não quer receber alerta) 
			if (coalesce(ie_excecao_alerta_pessoa_w,'N') = 'N') then 
				insert into ev_evento_pac_destino( 
					nr_sequencia, 
					nr_seq_ev_pac, 
					dt_atualizacao, 
					nm_usuario, 
					dt_atualizacao_nrec, 
					nm_usuario_nrec, 
					cd_pessoa_fisica, 
					ie_forma_ev, 
					ie_status, 
					dt_ciencia, 
					nm_usuario_DEst, 
					ie_pessoa_destino, 
					dt_evento) 
				values (	nextval('ev_evento_pac_destino_seq'), 
					nr_sequencia_w, 
					clock_timestamp(), 
					nm_usuario_p, 
					clock_timestamp(), 
					nm_usuario_p, 
					cd_pessoa_regra_w, 
					ie_forma_ev_w, 
					'G', 
					null, 
					nm_usuario_Destino_w, 
					ie_pessoa_destino_w, 
					clock_timestamp());
			end if;
		end if;
		end;
	end loop;
	close C03;
 
	end;
end loop;
close C01;
 
if (ie_trigger_p = 'N') then 
	commit;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_evento_aprov_result_lab (nr_seq_evento_p bigint, nm_usuario_p text, nr_prescricao_p bigint, nr_seq_prescr_p bigint, nr_seq_exame_p bigint, ie_trigger_p text) FROM PUBLIC;
