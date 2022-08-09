-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_ev_lib_orien_alta ( nm_usuario_p text, nr_seq_paciente_p bigint, cd_estabelecimento_p bigint) AS $body$
DECLARE

 
ds_mensagem_w		varchar(4000);
ds_titulo_w		varchar(100);					
nr_seq_evento_w 	bigint;
qt_reg_w 		bigint;
nm_paciente_w		varchar(60);
nm_medico_resp_w	varchar(60);
ds_unidade_w		varchar(60);
ds_setor_atendimento_w	varchar(60);
cd_convenio_w		bigint;
nr_sequencia_w		bigint;
ds_maquina_w		varchar(80);
dt_liberacao_w		timestamp;
nr_atendimento_w	bigint;
cd_pessoa_fisica_w	varchar(10);
cd_pf_medico_w		varchar(10);

 
ie_forma_ev_w		varchar(15);
ie_pessoa_destino_w	varchar(15);
cd_pf_destino_w		varchar(10);
cd_pessoa_destino_w	varchar(10);
ie_usuario_aceite_w	varchar(1);
qt_corresp_w		integer;
cd_setor_atendimento_w	integer;
cd_perfil_w		integer;
cd_pessoa_regra_w	varchar(10);
nm_usuario_destino_w	varchar(15);
cd_setor_atend_pac_w	integer;
ds_convenio_w		varchar(255);

 
C01 CURSOR FOR 
	 SELECT nr_seq_evento 
	 from regra_envio_sms 
	 where cd_estabelecimento = cd_estabelecimento_p 
	 and ie_evento_disp = 'LOA' 
	 and	coalesce(ie_situacao,'A') = 'A';

C04 CURSOR FOR 
	SELECT	ie_forma_ev, 
		ie_pessoa_destino, 
		cd_pf_destino, 
		coalesce(ie_usuario_aceite,'N'), 
		cd_setor_atendimento, 
		cd_perfil 
	from	ev_evento_regra_dest 
	where	nr_seq_evento	= nr_seq_evento_w 
	and	coalesce(cd_convenio, coalesce(cd_convenio_w,0))	= coalesce(cd_convenio_w,0) 
	and	coalesce(cd_setor_atend_pac, coalesce(cd_setor_atend_pac_w,0))	= coalesce(cd_setor_atend_pac_w,0)	 
	order by ie_forma_ev;

C02 CURSOR FOR 
	SELECT	obter_dados_usuario_opcao(a.nm_usuario,'C') 
	from	usuario_setor_v a, 
		usuario b 
	where	a.nm_usuario = b.nm_usuario 
	and	b.ie_situacao = 'A' 
	and	a.cd_setor_atendimento = cd_setor_atendimento_w 
	and	ie_forma_ev_w in (2,3) 
	and	(obter_dados_usuario_opcao(a.nm_usuario,'C') IS NOT NULL AND (obter_dados_usuario_opcao(a.nm_usuario,'C'))::text <> '');

C03 CURSOR FOR 
	SELECT	obter_dados_usuario_opcao(a.nm_usuario,'C'), 
			a.nm_usuario 
	from	usuario_perfil a, 
		usuario b 
	where	a.nm_usuario = b.nm_usuario 
	and	b.ie_situacao = 'A' 
	and	a.cd_perfil = cd_perfil_w 
	and	ie_forma_ev_w in (2,3) 
	and	(obter_dados_usuario_opcao(a.nm_usuario,'C') IS NOT NULL AND (obter_dados_usuario_opcao(a.nm_usuario,'C'))::text <> '');


BEGIN 
 
Begin 
 
select 	nr_atendimento, 
	dt_liberacao, 
	substr(Obter_Dados_Atendimento(nr_atendimento,'CP'),1,60), 
	substr(obter_pessoa_fisica_usuario(nm_usuario_p,'C'),1,10), 
	cd_setor_atendimento 
into STRICT	nr_atendimento_w, 
	dt_liberacao_w, 
	cd_pessoa_fisica_w, 
	cd_pf_medico_w, 
	cd_setor_atendimento_w 
from	atendimento_alta 
where	nr_sequencia = nr_seq_paciente_p;
 
open c01;
loop 
fetch c01 into 
	nr_seq_evento_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin 
 
	select	substr(obter_inf_sessao(0),1,80) 
	into STRICT	ds_maquina_w 
	;
 
	select	ds_titulo, 
		ds_mensagem 
	into STRICT	ds_titulo_w, 
		ds_mensagem_w 
	from	ev_evento 
	where	nr_sequencia	= nr_seq_evento_w;				
	 
	select	substr(obter_nome_pf(cd_pessoa_fisica_w),1,60),	 
		substr(obter_unidade_atendimento(nr_atendimento_w,'A','U'),1,60), 
		substr(obter_unidade_atendimento(nr_atendimento_w,'A','S'),1,60), 
		substr(obter_unidade_atendimento(nr_atendimento_w,'A','CS'),1,60), 
		substr(obter_nome_pf(cd_pf_medico_w),1,60) 
	into STRICT	nm_paciente_w,	 
		ds_unidade_w, 
		ds_setor_atendimento_w, 
		cd_setor_atend_pac_w, 
		nm_medico_resp_w 
	;
 
 
	select	coalesce(max(obter_convenio_atendimento(nr_atendimento_w)), 0) 
	into STRICT	cd_convenio_w 
	;
	 
	IF (nr_atendimento_w > 0) THEN 
		SELECT	coalesce(MAX(obter_convenio_atendimento( nr_atendimento_w )), 0) 
		INTO STRICT	cd_convenio_w 
		;	
	else 
		cd_convenio_w	:= NULL;
	END IF;
 
	if (cd_convenio_w IS NOT NULL AND cd_convenio_w::text <> '') and (cd_convenio_w > 0) then 
		begin 
		ds_convenio_w	:= substr(obter_desc_convenio(cd_convenio_w),1,255);
		end;
	end if;
	 
	 
 
	ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@paciente',nm_paciente_w),1,4000);
	ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@medico',nm_medico_resp_w),1,4000);
	ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@quarto',ds_unidade_w),1,4000);
	ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@setor',ds_setor_atendimento_w ),1,4000);
	ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@atendimento',nr_atendimento_w),1,4000);
	ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@convenio',cd_convenio_w),1,4000);
	ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@ds_convenio',ds_convenio_w),1,4000);
	ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@dt_liberacao',to_char(dt_liberacao_w,'dd/mm/yyyy hh24:mm:ss')),1,4000);
 
 
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
		ds_maquina, 
		dt_evento, 
		dt_liberacao, 
		ie_situacao) 
	values (	nr_sequencia_w, 
		nr_seq_evento_w, 
		clock_timestamp(), 
		nm_usuario_p, 
		clock_timestamp(), 
		nm_usuario_p, 
		cd_pessoa_fisica_w, 
		nr_atendimento_w, 
		ds_titulo_w, 
		ds_mensagem_w, 
		'G', 
		ds_maquina_w, 
		clock_timestamp(), 
		clock_timestamp(), 
		'A');
	 
	commit;
	 
	open C04;
	loop 
	fetch C04 into 
		ie_forma_ev_w, 
		ie_pessoa_destino_w, 
		cd_pf_destino_w, 
		ie_usuario_aceite_w, 
		cd_setor_atendimento_w, 
		cd_perfil_w;
	EXIT WHEN NOT FOUND; /* apply on C04 */
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
 
			cd_pessoa_destino_w	:= cd_pf_destino_w;
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
	close C04;
	end;
end loop;
close c01;
 
exception 
when others then 
	null;
end;
 
commit;
	 
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_ev_lib_orien_alta ( nm_usuario_p text, nr_seq_paciente_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;
