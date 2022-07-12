-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

DROP TRIGGER IF EXISTS regra_env_email_compra_insert ON regra_envio_email_compra CASCADE;
CREATE OR REPLACE FUNCTION trigger_fct_regra_env_email_compra_insert() RETURNS trigger AS $BODY$
declare

ds_macro_disp_w	varchar(4000);
ds_mensagem_padrao_w	varchar(4000);
ds_palavra_w		varchar(4000);
ds_lista_palavra_w	varchar(4000);
qt_tamanho_lista_w	bigint;
ie_pos_separador_w	bigint;
ds_lista_caracter_w	varchar(255) := ',.;:/?\|!#$%&*()-+=]}[{';

BEGIN

select	substr(obter_macro_tipo_msg_compra(NEW.ie_tipo_mensagem),1,2000),
	replace(replace(NEW.ds_mensagem_padrao,chr(13),' '),chr(10),' ') || ' '
into STRICT	ds_macro_disp_w,
	ds_mensagem_padrao_w
;

ds_lista_palavra_w	:= ds_mensagem_padrao_w;

while	ds_lista_palavra_w is not null loop
	BEGIN
	qt_tamanho_lista_w := length(ds_lista_palavra_w);
	ie_pos_separador_w := position(' ' in ds_lista_palavra_w);

	if (ie_pos_separador_w > 0) then

		ds_palavra_w 	   := substr(ds_lista_palavra_w,1,(ie_pos_separador_w - 1));
		ds_lista_palavra_w := substr(ds_lista_palavra_w,(ie_pos_separador_w + 1), qt_tamanho_lista_w);

		if (substr(ds_palavra_w,length(ds_palavra_w),length(ds_palavra_w)) in (',','.',';',':','/','?','\','|','!','#','$','%','&','*','(',')','-','+','=',']','}','[','{')) then
			ds_palavra_w := substr(ds_palavra_w,1,length(ds_palavra_w)-1);
		end if;

		if (substr(ds_palavra_w,1,1) = '@') and (position(ds_palavra_w in ds_macro_disp_w) = 0) then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(237422);
			/*(-20111,'Existem macros não permitidas na mensagem padrão.');*/

		end if;
	else
		ds_lista_palavra_w := null;
	end if;
	end;
end loop;
RETURN NEW;
END
$BODY$
 LANGUAGE 'plpgsql' SECURITY DEFINER;
-- REVOKE ALL ON FUNCTION trigger_fct_regra_env_email_compra_insert() FROM PUBLIC;

CREATE TRIGGER regra_env_email_compra_insert
	BEFORE INSERT ON regra_envio_email_compra FOR EACH ROW
	EXECUTE PROCEDURE trigger_fct_regra_env_email_compra_insert();
