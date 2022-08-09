-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



CREATE TYPE lista AS (
		ds varchar(50));


CREATE OR REPLACE PROCEDURE enviar_email_utl_smtp ( nm_usuario_p text, ds_assunto_p text, ds_mensagem_p text, ds_email_origem_p text, ds_email_destino_p text, ds_email_cco_p text, ds_user_id_p text, ds_senha_smtp_p text, ds_smtp_p text, nr_porta_p bigint, ie_autenticar_p boolean, ie_solic_receb_email_p text, qt_prioridade_p bigint) AS $body$
DECLARE


ds_versao_w			varchar(10);
ds_comando_w			varchar(255);
retorno_w				integer;
c001				integer;
ds_user_raw_w			bytea;
ds_pwd_raw_w			bytea;	
qt_reg_w				integer       := 0;
vl_pos_w				smallint;
ds_email_destino_w		varchar(32000);
ds_email_destino_w2		varchar(32000);
ds_email_cco_w			varchar(32000);
ds_email_cco_w2			varchar(32000);
ds_assunto_aux_w			varchar(2000);
cabecalho_mensagem_w		varchar(4000);
ds_assunto_ww			varchar(32766);
ds_assunto_w			varchar(255);
ds_content_type_w			varchar(255);
ds_charset_bd_w varchar(30);
ds_charset_email_w varchar(30);
type myArray is table of lista index by integer;
/*Contem os parametros do SQL*/

ds_assuntos_w myArray;

/* Abre conexao SMTP e HTTP */
CONEXAO	UTL_SMTP.CONNECTION;
			
BEGIN
	ds_assunto_ww			:= substr(ds_assunto_p, 1, 32766);
	ds_email_destino_w := ds_email_destino_p;

	/* Para pegar a versao do banco */

	SELECT	SUBSTR(value,1,1)
	INTO STRICT	ds_versao_w
	FROM	NLS_DATABASE_PARAMETERS
	WHERE	parameter = 'NLS_RDBMS_VERSION';

  /* Charset-banco- Unicode */

  SELECT value
	INTO STRICT	ds_charset_bd_w
	FROM	NLS_DATABASE_PARAMETERS
	WHERE	parameter = 'NLS_CHARACTERSET';
  
  ds_charset_email_w := 'ISO-8859-1';
  if ( ds_charset_bd_w = 'AL32UTF8' ) then /* Banco unicode */
   ds_charset_email_w := 'UTF-8';
  end if;

	/* Abre conexao com um Servidor SMTP(Simple Mail Transfer Protocol), porta padrao SMTP e 25 */

	CONEXAO	:= utl_smtp.open_connection(ds_smtp_p,nr_porta_p);	
	begin
		UTL_SMTP.HELO(CONEXAO, ds_smtp_p);			/* Endereco do servidor de SMTP	*/
	exception
		when others then
			UTL_SMTP.EHLO(CONEXAO, ds_smtp_p);
	end;
	if (ie_autenticar_p ) then
		utl_smtp.command(CONEXAO, 'AUTH LOGIN');
		if	((ds_versao_w	= '9') or (ds_versao_w	= '1')) then
			begin
		 	C001 := DBMS_SQL.OPEN_CURSOR;
			ds_comando_w := 'select utl_encode.base64_encode(utl_raw.cast_to_raw('|| chr(39) || ds_user_id_p || chr(39) ||')) from dual';
			DBMS_SQL.PARSE(C001, ds_comando_w, dbms_sql.native);
			DBMS_SQL.DEFINE_COLUMN_RAW(c001, 1, ds_user_raw_w, 32767);
			retorno_w := DBMS_SQL.execute(c001);
			retorno_w := DBMS_SQL.fetch_rows(c001);
			DBMS_SQL.COLUMN_VALUE_RAW(C001, 1, ds_user_raw_w);
			DBMS_SQL.CLOSE_CURSOR(C001);
			exception
			when others then
				DBMS_SQL.CLOSE_CURSOR(C001);
			end;
			begin
			C001 := DBMS_SQL.OPEN_CURSOR;
			ds_comando_w := 'select utl_encode.base64_encode(utl_raw.cast_to_raw('|| chr(39) || ds_senha_smtp_p || chr(39) ||')) from dual';
			DBMS_SQL.PARSE(C001, ds_comando_w, dbms_sql.native);
			DBMS_SQL.DEFINE_COLUMN_RAW(c001, 1, ds_pwd_raw_w, 32767);
			retorno_w := DBMS_SQL.execute(c001);
			retorno_w := DBMS_SQL.fetch_rows(c001);
			DBMS_SQL.COLUMN_VALUE_RAW(C001, 1, ds_pwd_raw_w);
			DBMS_SQL.CLOSE_CURSOR(C001);
			exception
			when others then
				DBMS_SQL.CLOSE_CURSOR(C001);
			end;
			utl_smtp.command(CONEXAO, utl_raw.cast_to_varchar2(ds_user_raw_w));
			utl_smtp.command(CONEXAO, replace(utl_raw.cast_to_varchar2(ds_pwd_raw_w), CHR(13) || CHR(10), ''));
		else
			EXECUTE 'utl_smtp.command (CONEXAO, demo_base64.encode(utl_raw.cast_to_raw((ds_user_id_p))))';
			EXECUTE 'utl_smtp.command (CONEXAO, demo_base64.encode(utl_raw.cast_to_raw((ds_senha_smtp_p))))';
		end if;
	end if;
	UTL_SMTP.MAIL(CONEXAO, ('<' || ds_email_origem_p || '>'));		/* E-mail de quem esta mandando	*/
		
	/* Trata mais de um e-mail de destino separado por virgula ou ponto e virgula*/

	if (position(',' in ds_email_destino_w) > 0) or (position(';' in ds_email_destino_w) > 0) then
	   ds_email_destino_w      := substr(ds_email_destino_w,1,32000);
	   while(qt_reg_w = 0) and (length(ds_email_destino_w) > 0) loop
	           begin
	           vl_pos_w        := position(',' in ds_email_destino_w);
		   if (vl_pos_w <= 0 ) then
			vl_pos_w        := position(';' in ds_email_destino_w);
		   end if;
	           if (vl_pos_w > 0)  then
	                   ds_email_destino_w2     := substr(ds_email_destino_w, 1,                (vl_pos_w - 1));
	                   ds_email_destino_w      := substr(ds_email_destino_w, (vl_pos_w + 1),   length(ds_email_destino_w));
	           else
	                   ds_email_destino_w2     := ds_email_destino_w;
	                   ds_email_destino_w      := '';
	           end     if;
	           utl_smtp.RCPT(conexao, ('<' || ds_email_destino_w2 || '>'));
	           end;
	   end loop;
	else
		UTL_SMTP.RCPT(CONEXAO, ('<' || ds_email_destino_w  || '>'));		/* Para quem vou mandar */
	end	if;	
	
	/* Trata mais de um e-mail de cco separado por virgula ou ponto e virgula*/

	if (ds_email_cco_p IS NOT NULL AND ds_email_cco_p::text <> '') then
		if (position(',' in ds_email_cco_p) > 0) or (position(';' in ds_email_cco_p) > 0) then
		   ds_email_cco_w      := substr(ds_email_cco_p,1,32000);
		   while(qt_reg_w = 0) and (length(ds_email_cco_w) > 0) loop
			   begin
			   vl_pos_w        := position(',' in ds_email_cco_w);
			   if (vl_pos_w <= 0 ) then
				vl_pos_w        := position(';' in ds_email_cco_w);
			   end if;
			   if (vl_pos_w > 0)  then
				   ds_email_cco_w2     := substr(ds_email_cco_w, 1,                (vl_pos_w - 1));
				   ds_email_cco_w      := substr(ds_email_cco_w, (vl_pos_w + 1),   length(ds_email_cco_w));
			   else
				   ds_email_cco_w2     := ds_email_cco_w;
				   ds_email_cco_w      := '';
			   end     if;
			   utl_smtp.RCPT(conexao, ('<' || ds_email_cco_w2 || '>'));
			   end;
		   end loop;
		else
			UTL_SMTP.RCPT(CONEXAO, ('<' || ds_email_cco_p  || '>'));		/* Para quem vou mandar */
		end	if;
	end if;

	if	((ds_versao_w	= '9') or (ds_versao_w	= '1')) then
		begin
	 	
		
		ds_assunto_aux_w := ds_assunto_ww;
		qt_reg_w := 0;
		/*Coelho 28/10/2009 OS171924*/

		while(length(ds_assunto_aux_w) > 0) and ( qt_reg_w < 100 ) loop
			begin
			ds_comando_w := 'select UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.QUOTED_PRINTABLE_ENCODE(UTL_RAW.CAST_TO_RAW('|| chr(39) || substr(ds_assunto_aux_w,1,20) ||chr(39) ||'))) from dual';
			C001 := DBMS_SQL.OPEN_CURSOR;
			DBMS_SQL.PARSE(C001, ds_comando_w, dbms_sql.native);
			DBMS_SQL.DEFINE_COLUMN(c001, 1, ds_assunto_w, 255);
			retorno_w := DBMS_SQL.execute(c001);
			retorno_w := DBMS_SQL.fetch_rows(c001);
			DBMS_SQL.COLUMN_VALUE(C001, 1, ds_assunto_w);
			DBMS_SQL.CLOSE_CURSOR(C001);	
			
			ds_assuntos_w[qt_reg_w].ds := ds_assunto_w;
			qt_reg_w := qt_reg_w + 1;
			ds_assunto_aux_w := substr(ds_assunto_aux_w,21,length(ds_assunto_aux_w));
			
			end;
		end loop;
		
		exception
		when others then
			DBMS_SQL.CLOSE_CURSOR(C001);
		end;

	else
		ds_assunto_w := ds_assunto_ww;
	end if;
	
	/*Coelho 04/09/2007 OS60447*/
 /*Formato da data OS162024*/

	cabecalho_mensagem_w :='Date : ' || to_char(CURRENT_TIMESTAMP, 'Dy, dd Mon yyyy hh24:mi:ss tzhtzm','NLS_DATE_LANGUAGE=American') || utl_tcp.CRLF ||
				'From: ' || ds_email_origem_p						|| utl_tcp.CRLF ||
				'To: '	 || ds_email_destino_p						|| utl_tcp.CRLF ||
				'X-Priority: ' || qt_prioridade_p					|| utl_tcp.CRLF ||
				'X-MSMail-Priority: Hight' 						|| utl_tcp.CRLF ||
				'Subject:';
	/*Coelho 28/10/2009 OS171924*/

	for i in 0..ds_assuntos_w.count-1 loop
		begin
			cabecalho_mensagem_w := cabecalho_mensagem_w || ' =?'||ds_charset_email_w||'?Q?' || ds_assuntos_w[i].ds || '?=' || utl_tcp.CRLF;	
		end;
	end loop;
	
  if (position('<HTML TASY="HTML5">' in upper(substr(ds_mensagem_p,1,32000))) > 0) then
    ds_content_type_w := 'Content-Type: text/html;';
  else
    ds_content_type_w := 'Content-Type: text/plain;';
  end if;

	cabecalho_mensagem_w := cabecalho_mensagem_w ||
				'MIME-version: 1.0' 					|| utl_tcp.CRLF ||
				ds_content_type_w ||' charset='||ds_charset_email_w||' 		' || utl_tcp.CRLF ||
				'Content-Transfer-Encoding: 8bit'			|| utl_tcp.CRLF ||
				'X-Mailer: WhebSistemas' 				|| utl_tcp.CRLF ||
				'X-MimeOLE: WhebSistemas'				|| utl_tcp.CRLF;
	/*Coelho 18/03/2008  OS85935*/

	if (ie_solic_receb_email_p = 'S') then
				cabecalho_mensagem_w := cabecalho_mensagem_w ||
					'Disposition-Notification-To: '||nm_usuario_p||' <'||ds_email_origem_p||'>' || utl_tcp.CRLF;
	end if;
	UTL_SMTP.OPEN_DATA(CONEXAO);
	UTL_SMTP.WRITE_DATA(CONEXAO,cabecalho_mensagem_w ); /* A cabecalho_mensagem_w precisa terminar com utl_tcp.CRLF */
	UTL_SMTP.WRITE_RAW_DATA(CONEXAO,encode(utl_tcp.CRLF|| ds_mensagem_p || utl_tcp.CRLF::bytea, 'hex')::bytea);
	UTL_SMTP.CLOSE_DATA(CONEXAO);
	UTL_SMTP.QUIT(CONEXAO);

Exception
	WHEN OTHERS THEN 
	   utl_smtp.quit(conexao);
		CALL wheb_mensagem_pck.exibir_mensagem_abort(sqlerrm(SQLSTATE));	
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE enviar_email_utl_smtp ( nm_usuario_p text, ds_assunto_p text, ds_mensagem_p text, ds_email_origem_p text, ds_email_destino_p text, ds_email_cco_p text, ds_user_id_p text, ds_senha_smtp_p text, ds_smtp_p text, nr_porta_p bigint, ie_autenticar_p boolean, ie_solic_receb_email_p text, qt_prioridade_p bigint) FROM PUBLIC;
