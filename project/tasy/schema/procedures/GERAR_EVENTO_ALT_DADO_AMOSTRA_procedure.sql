-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_evento_alt_dado_amostra (nr_seq_evento_p bigint, nm_usuario_p text, nr_prescricao_p bigint, nr_seq_material_p bigint, dt_coleta_p timestamp, ds_atributo_alt_p text, ie_trigger_p text) AS $body$
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
ie_usuario_aceite_w		varchar(1);
qt_corresp_w			integer;
cd_setor_atendimento_w		integer;
cd_perfil_w			integer;
cd_pessoa_regra_w		varchar(10);
cd_convenio_w			bigint;
cd_pessoa_fisica_w		varchar(10);
nr_atendimento_w		bigint;
nm_usuario_destino_w 		varchar(15);
cd_setor_atend_pac_w		integer;
cd_material_exame_w		varchar(50);
ie_tipo_atendimento_w		smallint;

C01 CURSOR FOR 
	SELECT	ie_forma_ev, 
		ie_pessoa_destino, 
		cd_pf_destino, 
		coalesce(ie_usuario_aceite,'N'), 
		cd_setor_atendimento, 
		cd_perfil 
	FROM	ev_evento_regra_dest 
	WHERE	nr_seq_evento	= nr_seq_evento_p 
	AND	coalesce(cd_convenio, coalesce(cd_convenio_w,0))	= coalesce(cd_convenio_w,0) 
	AND	coalesce(cd_setor_atend_pac, coalesce(cd_setor_atend_pac_w,0))	= coalesce(cd_setor_atend_pac_w,0) 
  AND	coalesce(ie_tipo_atend, coalesce(ie_tipo_atendimento_w,0))	= coalesce(ie_tipo_atendimento_w,0) 
	ORDER BY ie_forma_ev;

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
	and	(obter_dados_usuario_opcao(nm_usuario,'C') IS NOT NULL AND (obter_dados_usuario_opcao(nm_usuario,'C'))::text <> '');
	

BEGIN 
 
select	ds_titulo, 
	ds_mensagem 
into STRICT	ds_titulo_w, 
	ds_mensagem_w 
from	ev_evento 
where	nr_sequencia	= nr_seq_evento_p;
 
select max(b.nr_atendimento), 
    max(b.cd_pessoa_fisica), 
    max(b.ie_tipo_atendimento) 
into STRICT	nr_atendimento_w, 
	cd_pessoa_fisica_w, 
    ie_tipo_atendimento_w 
from  prescr_medica a, 
    atendimento_paciente b 
where  a.nr_atendimento = b.nr_atendimento 
and   a.nr_prescricao = nr_prescricao_p;
 
select	substr(obter_nome_pf(cd_pessoa_fisica_w),1,60), 
	substr(abrevia_nome_pf(cd_pessoa_fisica_w,'M'),1,60), 
	substr(obter_unidade_atendimento(nr_atendimento_w,'A','CS'),1,60) 
into STRICT	nm_paciente_w, 
	nm_paciente_abrev_w, 
	cd_setor_atend_pac_w
;
 
select 	cd_material_exame 
into STRICT 	cd_material_exame_w 
from 	material_exame_lab 
where 	nr_sequencia = nr_seq_material_p;
 
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@atendimento',nr_atendimento_w),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@prescricao',nr_prescricao_p),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@nm_paciente',nm_paciente_w),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@paciente',nm_paciente_w),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@pac_abreviado',nm_paciente_abrev_w),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@material',cd_material_exame_w),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@dt_coleta',dt_coleta_p),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@volume',substr(ds_atributo_alt_p, position('@volume' in ds_atributo_alt_p) +8, instr(ds_atributo_alt_p, ']@',position('@volume[' in ds_atributo_alt_p)) - (position('@volume' in ds_atributo_alt_p) +8))),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@tempo',substr(ds_atributo_alt_p, position('@tempo' in ds_atributo_alt_p) +7, instr(ds_atributo_alt_p, ']@',position('@tempo[' in ds_atributo_alt_p)) - (position('@tempo' in ds_atributo_alt_p) +7))),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@minuto',substr(ds_atributo_alt_p, position('@minuto' in ds_atributo_alt_p) +8, instr(ds_atributo_alt_p, ']@',position('@minuto[' in ds_atributo_alt_p)) - (position('@minuto' in ds_atributo_alt_p) +8))),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@data_coleta_alt',substr(ds_atributo_alt_p, position('@data_coleta_alt' in ds_atributo_alt_p) +17, instr(ds_atributo_alt_p, ']@',position('@data_coleta_alt[' in ds_atributo_alt_p)) - (position('@data_coleta_alt' in ds_atributo_alt_p) +17))),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@ds_condicao',substr(ds_atributo_alt_p, position('@ds_condicao' in ds_atributo_alt_p) +13, instr(ds_atributo_alt_p, ']@',position('@ds_condicao[' in ds_atributo_alt_p)) - (position('@ds_condicao' in ds_atributo_alt_p) +13))),1,4000);
ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@qt_tempo_gest',substr(ds_atributo_alt_p, position('@qt_tempo_gest' in ds_atributo_alt_p) +15, instr(ds_atributo_alt_p, ']@',position('@qt_tempo_gest[' in ds_atributo_alt_p)) - (position('@qt_tempo_gest' in ds_atributo_alt_p) +15))),1,4000);
 
ds_titulo_w	:= substr(replace_macro(ds_titulo_w,'@atendimento',nr_atendimento_w),1,4000);
ds_titulo_w	:= substr(replace_macro(ds_titulo_w,'@prescricao',nr_prescricao_p),1,4000);
ds_titulo_w	:= substr(replace_macro(ds_titulo_w,'@paciente',nm_paciente_w),1,4000);
ds_titulo_w	:= substr(replace_macro(ds_titulo_w,'@pac_abreviado',nm_paciente_abrev_w),1,4000);
ds_titulo_w	:= substr(replace_macro(ds_titulo_w,'@material',cd_material_exame_w),1,4000);
ds_titulo_w	:= substr(replace_macro(ds_titulo_w,'@dt_coleta',dt_coleta_p),1,4000);
ds_titulo_w	:= substr(replace_macro(ds_titulo_w,'@volume',substr(ds_atributo_alt_p, position('@volume' in ds_atributo_alt_p) +8, instr(ds_atributo_alt_p, ']@',position('@volume[' in ds_atributo_alt_p)) - (position('@volume' in ds_atributo_alt_p) +8))),1,4000);
ds_titulo_w	:= substr(replace_macro(ds_titulo_w,'@tempo',substr(ds_atributo_alt_p, position('@tempo' in ds_atributo_alt_p) +7, instr(ds_atributo_alt_p, ']@',position('@tempo[' in ds_atributo_alt_p)) - (position('@tempo' in ds_atributo_alt_p) +7))),1,4000);
ds_titulo_w	:= substr(replace_macro(ds_titulo_w,'@minuto',substr(ds_atributo_alt_p, position('@minuto' in ds_atributo_alt_p) +8, instr(ds_atributo_alt_p, ']@',position('@minuto[' in ds_atributo_alt_p)) - (position('@minuto' in ds_atributo_alt_p) +8))),1,4000);
ds_titulo_w	:= substr(replace_macro(ds_titulo_w,'@data_coleta_alt',substr(ds_atributo_alt_p, position('@data_coleta_alt' in ds_atributo_alt_p) +17, instr(ds_atributo_alt_p, ']@',position('@data_coleta_alt[' in ds_atributo_alt_p)) - (position('@data_coleta_alt' in ds_atributo_alt_p) +17))),1,4000);
ds_titulo_w	:= substr(replace_macro(ds_titulo_w,'@ds_condicao',substr(ds_atributo_alt_p, position('@ds_condicao' in ds_atributo_alt_p) +13, instr(ds_atributo_alt_p, ']@',position('@ds_condicao[' in ds_atributo_alt_p)) - (position('@ds_condicao' in ds_atributo_alt_p) +13))),1,4000);
ds_titulo_w	:= substr(replace_macro(ds_titulo_w,'@qt_tempo_gest',substr(ds_atributo_alt_p, position('@qt_tempo_gest' in ds_atributo_alt_p) +15, instr(ds_atributo_alt_p, ']@',position('@qt_tempo_gest[' in ds_atributo_alt_p)) - (position('@qt_tempo_gest' in ds_atributo_alt_p) +15))),1,4000);
 
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
	elsif (ie_pessoa_destino_w = '21') then /* Médico responsável pelo atendimento, considerando pessoa fixa */
 
		begin 
		select	max(cd_medico_resp) 
		into STRICT	cd_pessoa_destino_w 
		from	atendimento_paciente 
		where	nr_atendimento	= nr_atendimento_w 
		and	cd_medico_resp = cd_pf_destino_w;
		end;
	elsif (ie_pessoa_destino_w = '19') then /* Paciente */
 
		begin 
 		cd_pessoa_destino_w	:= cd_pessoa_fisica_w;
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
		end;
	end if;
 
	open C02;
	loop 
	fetch C02 into 
		cd_pessoa_regra_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin 
		if (cd_pessoa_regra_w IS NOT NULL AND cd_pessoa_regra_w::text <> '') then 
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
		end;
	end loop;
	close C03;
 
	end;
end loop;
close C01;
 
if (ie_trigger_p = 'N') then 
	commit;
end if;
 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_evento_alt_dado_amostra (nr_seq_evento_p bigint, nm_usuario_p text, nr_prescricao_p bigint, nr_seq_material_p bigint, dt_coleta_p timestamp, ds_atributo_alt_p text, ie_trigger_p text) FROM PUBLIC;

