-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consiste_transf_cirurgica ( nr_seq_origem_p bigint, nr_seq_destino_p bigint, ds_mensagem_vigencia_p INOUT text, ds_mensagem_regra_qtd_p INOUT text, ds_mensagem_equip_p INOUT text, ds_mensagem_cme_p INOUT text, ds_mensagem_reserva_p INOUT text, ds_questiona_tempo_p INOUT text, ds_questiona_sobrep_p INOUT text, ds_abort_p INOUT text) AS $body$
DECLARE



cd_estabelecimento_w		integer;
cd_perfil_w			integer;
nm_usuario_w			varchar(15);
ie_forma_cadastrar_equip_w		varchar(15);
ie_consiste_equipamento_w		varchar(15);
ie_verifica_vigencia_w		varchar(15);
ie_consiste_tempo_w		varchar(15);
ie_consiste_sobr_horario_w		varchar(15);
ie_consiste_cme_w			varchar(15);
hr_inicio_origem_w			timestamp;
nr_minuto_duracao_origem_w		bigint;
ie_reserva_leito_w			varchar(15);
qt_diaria_prev_w			smallint;
cd_agenda_destino_w		bigint;
dt_agenda_destino_w		timestamp;
hr_inicio_destino_w			timestamp;
qt_aut_conv_w			bigint;
ds_abort_w			varchar(2000);
ds_erro_w			varchar(2000);
ds_aviso_regra_qtd_w		varchar(2000);
ie_tipo_erro_w			varchar(15);
ie_procedure_antes_transf_w   	varchar(200);
plsql_block 			varchar(500);
cd_procedimento_w 		bigint;
cd_usuario_convenio_w 		varchar(30);
cd_convenio_w  			integer;
ds_senha_w                		varchar(20);
ie_carater_cirurgia_w   		varchar(1);
nm_atributo_w           		varchar(30);
ie_contem_param_out_w   		boolean := false;
cd_medico_w     agenda_paciente.cd_medico%type;

C01 CURSOR FOR
   SELECT argument_name
   from  user_arguments
   where object_name = trim(both Upper(ie_procedure_antes_transf_w))
   order by position;


BEGIN
cd_estabelecimento_w	:= wheb_usuario_pck.get_cd_estabelecimento;
cd_perfil_w		:= wheb_usuario_pck.get_cd_perfil;
nm_usuario_w		:= wheb_usuario_pck.get_nm_usuario;

ie_forma_cadastrar_equip_w := Obter_Param_Usuario(871, 100, cd_perfil_w, nm_usuario_w, cd_estabelecimento_w, ie_forma_cadastrar_equip_w);
ie_consiste_equipamento_w := Obter_Param_Usuario(871, 138, cd_perfil_w, nm_usuario_w, cd_estabelecimento_w, ie_consiste_equipamento_w);
ie_verifica_vigencia_w := Obter_Param_Usuario(871, 305, cd_perfil_w, nm_usuario_w, cd_estabelecimento_w, ie_verifica_vigencia_w);
ie_consiste_tempo_w := Obter_Param_Usuario(871, 318, cd_perfil_w, nm_usuario_w, cd_estabelecimento_w, ie_consiste_tempo_w);
ie_consiste_sobr_horario_w := Obter_Param_Usuario(871, 381, cd_perfil_w, nm_usuario_w, cd_estabelecimento_w, ie_consiste_sobr_horario_w);
ie_procedure_antes_transf_w := Obter_Param_Usuario(871, 471, cd_perfil_w, nm_usuario_w, cd_estabelecimento_w, ie_procedure_antes_transf_w);
ie_consiste_cme_w := Obter_Param_Usuario(871, 575, cd_perfil_w, nm_usuario_w, cd_estabelecimento_w, ie_consiste_cme_w);


select		max(hr_inicio),
		coalesce(max(nr_minuto_duracao),0),
		max(ie_reserva_leito),
		coalesce(max(qt_diaria_prev), 0),
     		max(coalesce(cd_procedimento,0)),
		max(coalesce(cd_usuario_convenio, 'null')),
      		max(coalesce(cd_convenio,0)),
		max(coalesce(ds_senha, 'null')),
        max(cd_medico)
into STRICT		hr_inicio_origem_w,
		nr_minuto_duracao_origem_w,
		ie_reserva_leito_w,
		qt_diaria_prev_w,
	      	cd_procedimento_w,
		cd_usuario_convenio_w,
		cd_convenio_w,
		ds_senha_w,
        cd_medico_w
from		agenda_paciente
where		nr_sequencia = nr_seq_origem_p;

select		max(cd_agenda),
               		trunc(max(dt_agenda)),
	                max(hr_inicio),
               		max(ie_carater_cirurgia)
into STRICT		cd_agenda_destino_w,
	                dt_agenda_destino_w,
	                hr_inicio_destino_w,
	                ie_carater_cirurgia_w
from		agenda_paciente
where		nr_sequencia = nr_seq_destino_p;

if (coalesce(ds_abort_w::text, '') = '') then
   if (ie_procedure_antes_transf_w IS NOT NULL AND ie_procedure_antes_transf_w::text <> '') then
       plsql_block := 'BEGIN ' || trim(both ie_procedure_antes_transf_w)  || '(';
      open C01;
      loop
      fetch C01 into
         nm_atributo_w;
      EXIT WHEN NOT FOUND; /* apply on C01 */
                if (nm_atributo_w	= 'CD_PROCEDIMENTO_P') then
                  plsql_block:= plsql_block || cd_procedimento_w || ',';
               elsif (nm_atributo_w	= 'NR_SEQUENCIA_P') then
                  plsql_block:= plsql_block || nr_seq_origem_p || ',';
               elsif (nm_atributo_w	= 'CD_CARTEIRA_P') then
                  plsql_block:= plsql_block || cd_usuario_convenio_w || ',';
               elsif (nm_atributo_w	= 'CD_CONVENIO_P') then
                  plsql_block:= plsql_block || cd_convenio_w || ',';
               elsif (nm_atributo_w	= 'DS_SENHA_P') then
                  plsql_block:= plsql_block || ds_senha_w || ',';
               elsif (nm_atributo_w	= 'IE_CARATER_CIRURGIA_P')  then
                  plsql_block:= plsql_block || coalesce(ie_carater_cirurgia_w, 'null') || ',';
               elsif (nm_atributo_w	= 'NR_SEQUENCIA_DEST_P') then
                  plsql_block:= plsql_block || nr_seq_destino_p || ',';
               elsif (nm_atributo_w	= 'DS_ERRO_P') then
                  plsql_block:= plsql_block || ':ds_erro_p' || ',';
                  ie_contem_param_out_w:= true;
               end if;
      end loop;
      close C01;
      if (substr(plsql_block, length(plsql_block), 1) = ',') then
         plsql_block :=  substr(plsql_block, 1, length(plsql_block) -1)  || ' ); END;';
      else
         plsql_block :=  substr(plsql_block, 1, length(plsql_block) -1)  || ' ; END;';
      end if;
      begin
      if (ie_contem_param_out_w) then
         EXECUTE	plsql_block USING OUT ds_abort_w;
      else
         EXECUTE	plsql_block;
      end if;
      exception
          when others then
          plsql_block := null;
      end;
   end if;
end if;

if (coalesce(ds_abort_w::text, '') = '') then
	if (ie_verifica_vigencia_w = 'S') then
		select	coalesce(max(obter_qt_aut_vigencia(nr_seq_origem_p,nr_seq_destino_p)),0)
		into STRICT	qt_aut_conv_w
		;

		if (qt_aut_conv_w > 0) then
			ds_mensagem_vigencia_p := substr(obter_texto_tasy(80029, wheb_usuario_pck.get_nr_seq_idioma),1,255); --'A data de vigencia da autorizacao do convenio nao e valida para esta data'
		end if;
	end if;
end if;

if (coalesce(ds_abort_w::text, '') = '') then
	SELECT * FROM consiste_transf_agenda_pac(nr_seq_origem_p, nr_seq_destino_p, ds_aviso_regra_qtd_w, ds_erro_w) INTO STRICT ds_aviso_regra_qtd_w, ds_erro_w;
	if (ds_erro_w IS NOT NULL AND ds_erro_w::text <> '') then
		ds_abort_w := ds_erro_w;
	elsif (ds_aviso_regra_qtd_w IS NOT NULL AND ds_aviso_regra_qtd_w::text <> '') then
		ds_mensagem_regra_qtd_p := ds_aviso_regra_qtd_w;
	end if;
end if;

if (coalesce(ds_abort_w::text, '') = '') then
	SELECT * FROM obter_restri_transf_agenda_js(hr_inicio_origem_w, nr_seq_origem_p, nr_seq_destino_p, cd_estabelecimento_w, nm_usuario_w, ds_erro_w, ie_tipo_erro_w) INTO STRICT ds_erro_w, ie_tipo_erro_w;
	if (ds_erro_w IS NOT NULL AND ds_erro_w::text <> '') then
		if (coalesce(ie_tipo_erro_w,'XPTO') <> 'T') then
			ds_abort_w := ds_erro_w;
		elsif (coalesce(ie_tipo_erro_w,'XPTO') = 'T') and (ie_consiste_tempo_w = 'S') then
			ds_abort_w := ds_erro_w;
		elsif (coalesce(ie_tipo_erro_w,'XPTO') = 'T') and (ie_consiste_tempo_w = 'Q') then
			ds_questiona_tempo_p	:= ds_erro_w || ' ' || substr(obter_texto_tasy(357470, wheb_usuario_pck.get_nr_seq_idioma),1,50); -- Deseja continuar ?
		end if;
	end if;
end if;

if (coalesce(ds_abort_w::text, '') = '') then
	if (ie_consiste_sobr_horario_w = 'S') or (ie_consiste_sobr_horario_w = 'Q') then
		ds_erro_w := consistir_duracao_agenda_pac(cd_agenda_destino_w, dt_agenda_destino_w, hr_inicio_destino_w, nr_minuto_duracao_origem_w, nr_seq_destino_p, nr_seq_origem_p, ds_erro_w);
		if (ds_erro_w IS NOT NULL AND ds_erro_w::text <> '') then
			if (ie_consiste_sobr_horario_w = 'S') then
				ds_abort_w := ds_erro_w;
			elsif (ie_consiste_sobr_horario_w = 'Q') then
				ds_questiona_sobrep_p := substr(obter_texto_tasy(80887, wheb_usuario_pck.get_nr_seq_idioma),1,255); --Ocorreu sobreposicao de horario na agenda! Deseja continuar?
			end if;
		end if;
	end if;
end if;

if (coalesce(ds_abort_w::text, '') = '') then
	if (ie_consiste_equipamento_w = 'A') or (ie_consiste_equipamento_w = 'S') then
		ds_erro_w := obter_se_equip_disp_transf(nr_seq_destino_p, nr_seq_origem_p, ds_erro_w, nm_usuario_w, cd_estabelecimento_w, ie_forma_cadastrar_equip_w, 'S');
		if (ds_erro_w IS NOT NULL AND ds_erro_w::text <> '') then
			if (ie_consiste_equipamento_w = 'S') then
				ds_abort_w := ds_erro_w;
			elsif (ie_consiste_equipamento_w = 'A') then
				ds_mensagem_equip_p := ds_erro_w;
			end if;
		end if;
	end if;
end if;

if (coalesce(ds_abort_w::text, '') = '') then
	ds_erro_w := consistir_reserva_leito(cd_agenda_destino_w, dt_agenda_destino_w, ie_reserva_leito_w, qt_diaria_prev_w, nr_seq_destino_p, cd_medico_w, ds_erro_w);
	if (ds_erro_w IS NOT NULL AND ds_erro_w::text <> '') then
		ds_mensagem_reserva_p := ds_erro_w;
	end if;
end if;

if (coalesce(ds_abort_w::text, '') = '') then
	if (ie_consiste_cme_w = 'A') or (ie_consiste_cme_w = 'S') then
		ds_erro_w := consiste_cme_transf_agenda(nr_seq_origem_p, nr_seq_destino_p, nm_usuario_w, ds_erro_w);
		if (ds_erro_w IS NOT NULL AND ds_erro_w::text <> '') then
			if (ie_consiste_cme_w = 'S') then
				ds_abort_w := ds_erro_w;
			elsif (ie_consiste_cme_w = 'A') then
				ds_mensagem_cme_p := ds_erro_w;
			end if;
		end if;
	end if;
end if;

ds_abort_p:= ds_abort_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consiste_transf_cirurgica ( nr_seq_origem_p bigint, nr_seq_destino_p bigint, ds_mensagem_vigencia_p INOUT text, ds_mensagem_regra_qtd_p INOUT text, ds_mensagem_equip_p INOUT text, ds_mensagem_cme_p INOUT text, ds_mensagem_reserva_p INOUT text, ds_questiona_tempo_p INOUT text, ds_questiona_sobrep_p INOUT text, ds_abort_p INOUT text) FROM PUBLIC;
