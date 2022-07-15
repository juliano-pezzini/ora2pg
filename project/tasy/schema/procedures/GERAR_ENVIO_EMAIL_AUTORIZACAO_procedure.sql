-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_envio_email_autorizacao (cd_estabelecimento_p bigint, ie_tipo_regra_p bigint) AS $body$
DECLARE

 
qt_regra_envio_w		bigint;
nr_sequencia_w			bigint;
ds_assunto_w			varchar(255);
ds_mensagem_w			varchar(2000);
ds_mensagem_padrao_w		varchar(2000);
nm_usuario_remetente_w		varchar(15);
ds_email_remetente_w		varchar(255);
-- 
nr_sequencia_autor_w		bigint;
nr_atendimento_w		bigint;
nm_paciente_w			varchar(60);
ds_tipo_autorizacao_w		varchar(255);

nm_atributo_w			varchar(255);
qt_reg_w			bigint;
ds_email_destino_w		varchar(255);
nm_usuario_dest_w		varchar(15);
ie_insere_w			varchar(5);
ds_lista_proc_w			varchar(1000);
ds_comando_w			varchar(500);
ds_lista_campos_w		varchar(500);
ds_label_atributo_w		varchar(255);
ds_mensagem_envio_w		varchar(20000);
ie_tipo_comunicado_w		varchar(3);
ie_forma_envio_w		varchar(2);
ds_lista_email_w		varchar(2000);
ds_lista_usuario_dest_w		varchar(2000);
qt_dias_estagio_w		bigint;

 
C01 CURSOR FOR 
	SELECT	nr_sequencia, 
		ds_assunto, 
		ds_mensagem_padrao, 
		coalesce(nm_usuario_remetente,nm_usuario), 
		ds_email_remetente, 
		ie_tipo_comunicado 
	from	regra_envio_autorizacao 
	where	((cd_estabelecimento = cd_estabelecimento_p) or 
		cd_estabelecimento_p = 0) 
	and	coalesce(ie_situacao,'A') = 'A' 
	and	ie_tipo_comunicado = ie_tipo_regra_p 
	order by nr_sequencia;

 
C02 CURSOR FOR 
	SELECT	a.nr_sequencia, 
		a.nr_atendimento, 
		substr(obter_nome_pf(a.cd_pessoa_fisica),1,60), 
		substr(obter_valor_dominio(1377,a.ie_tipo_autorizacao),1,255), 
		substr(obter_proc_autor_concatenado(a.nr_sequencia),1,1000), 
		(substr(obter_se_permite_regra_envio(a.nr_sequencia,nr_sequencia_w,2),1,10))::numeric  
	from	autorizacao_convenio a 
	where	coalesce(a.cd_estabelecimento,0) = coalesce(cd_estabelecimento_p,0) 
	and	trunc(dt_autorizacao,'dd') > to_Date('01/10/2012','dd/mm/yyyy') 
	and	substr(obter_se_permite_regra_envio(a.nr_sequencia,nr_sequencia_w,1),1,1) = 'S';
	
C03 CURSOR FOR 
	SELECT	a.nm_atributo, 
	substr(b.ds_label||' ('||b.nm_atributo||')',1,255) ds 
	from	regra_envio_autor_campo a, 
		tabela_atributo b 
	where	a.nm_atributo	= b.nm_atributo 
	and	nm_tabela 	= 'AUTORIZACAO_CONVENIO' 
	and	ie_tipo_atributo not in ('FUNCTION','VISUAL') 
	and	coalesce(ie_obrigatorio,'N') = 'N' 
	and	nr_seq_regra = nr_sequencia_w 
	and	ie_tipo_comunicado_w = 1;
	
C04 CURSOR FOR 
	SELECT 	a.nm_usuario_dest, 
		b.ds_email, 
		ie_forma_envio 
	from 	regra_envio_autor_dest a, 
		usuario b 
	where 	a.nm_usuario_dest = b.nm_usuario 
	and	a.nr_seq_regra = nr_sequencia_w;
	

BEGIN 
 
select	count(*) 
into STRICT	qt_regra_envio_w 
from	regra_envio_autorizacao 
where	((cd_estabelecimento = cd_estabelecimento_p) or 
	cd_estabelecimento_p = 0);
	 
 
if (coalesce(qt_regra_envio_w,0) > 0) then 
	begin 
	open C01;
	loop 
	fetch C01 into	 
		nr_sequencia_w, 
		ds_assunto_w, 
		ds_mensagem_padrao_w, 
		nm_usuario_remetente_w, 
		ds_email_remetente_w, 
		ie_tipo_comunicado_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin 
		open C02;
		loop 
		fetch C02 into	 
			nr_sequencia_autor_w, 
			nr_atendimento_w, 
			nm_paciente_w, 
			ds_tipo_autorizacao_w, 
			ds_lista_proc_w, 
			qt_dias_estagio_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin 
			ie_insere_w := '';
			ds_lista_campos_w := '';
			ds_mensagem_w	:= ds_mensagem_padrao_w;
			 
			if (coalesce(ie_insere_w::text, '') = '') and (ie_tipo_comunicado_w = '2') then 
				ie_insere_w := 'S';
			end if;
			 
			open C03;
			loop 
			fetch C03 into	 
				nm_atributo_w, 
				ds_label_atributo_w;
			EXIT WHEN NOT FOUND; /* apply on C03 */
				begin 
				ie_insere_w := '';
				ds_comando_w	:= 'select count(*) from autorizacao_convenio where nr_sequencia = ' || nr_sequencia_autor_w || 							' and ' || nm_atributo_w || ' is null';
				 
				qt_reg_w := obter_valor_dinamico(ds_comando_w, qt_reg_w);
				 
				if (coalesce(qt_reg_w,0) > 0) then 
					ds_lista_campos_w := ds_lista_campos_w || ds_label_atributo_w || chr(10);
					 
					if (coalesce(ie_insere_w::text, '') = '') then 
						ie_insere_w := 'S';
					end if;
					 
				end if;
				 
				end;
			end loop;
			close C03;
			 
			if (ie_insere_w = 'S') then 
				ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@seq_autor',nr_sequencia_autor_w),1,2000);
				ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@atend',nr_atendimento_w),1,2000);
				ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@paciente',nm_paciente_w),1,2000);
				ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@tipo_autor',ds_tipo_autorizacao_w),1,2000);
				ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@proc_autor',ds_lista_proc_w),1,2000);
				ds_mensagem_w	:= substr(replace_macro(ds_mensagem_w,'@campos',ds_lista_campos_w),1,2000);
				ds_mensagem_w	:= ds_mensagem_w || chr(10) || chr(13);
			end if;
			 
			 
			ds_mensagem_envio_w := substr(ds_mensagem_envio_w || chr(10) || chr(13) || ds_mensagem_w,1,2000);
 
			end;
		end loop;
		close C02;
		end;
		 
		if (ie_insere_w = 'S') then 
 
			open C04;
			loop 
			fetch C04 into	 
				nm_usuario_dest_w, 
				ds_email_destino_w, 
				ie_forma_envio_w;
			EXIT WHEN NOT FOUND; /* apply on C04 */
				begin 
				ds_lista_email_w 	:= ds_lista_email_w || trim(both ds_email_destino_w) ||',';
				ds_lista_usuario_dest_w := ds_lista_usuario_dest_w || trim(both nm_usuario_dest_w) || ',';
				end;
			end loop;
			close C04;
 
			 
			ds_assunto_w	:= substr(replace_macro(ds_assunto_w,'@seq_autor',nr_sequencia_autor_w),1,255);
			ds_assunto_w	:= substr(replace_macro(ds_assunto_w,'@atend',nr_atendimento_w),1,255);
			ds_assunto_w	:= substr(replace_macro(ds_assunto_w,'@paciente',nm_paciente_w),1,255);
			ds_assunto_w	:= substr(replace_macro(ds_assunto_w,'@tipo_autor',ds_tipo_autorizacao_w),1,255);
 
 
			if (ie_forma_envio_w = 'CI') or (ie_forma_envio_w = 'A')then 
				 
				 
				CALL gerar_comunic_padrao(	clock_timestamp(), 
							ds_assunto_w, 
							ds_mensagem_envio_w, 
							nm_usuario_remetente_w, 
							'N', 
							ds_lista_usuario_dest_w, 
							'N', 
							null, 
							null, 
							null, 
							null, 
							clock_timestamp(), 
							null, 
							null);
			end if;
			 
			if (ie_forma_envio_w = 'A') or (ie_forma_envio_w = 'E')then 
				CALL enviar_email(ds_assunto_w,ds_mensagem_envio_w,ds_email_remetente_w,ds_lista_email_w,nm_usuario_remetente_w,'M');	
			end if;
			 
		end if;
		 
	end loop;
	close C01;
	end;
end if;	
	 
	 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_envio_email_autorizacao (cd_estabelecimento_p bigint, ie_tipo_regra_p bigint) FROM PUBLIC;

