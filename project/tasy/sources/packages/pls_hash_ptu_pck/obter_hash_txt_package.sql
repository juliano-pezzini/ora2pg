-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


-- Ajusta o arqivo e realiza o cálculo do hash.
CREATE OR REPLACE FUNCTION pls_hash_ptu_pck.obter_hash_txt ( ds_txt_p INOUT text, ie_remover_acentos_p text default 'S') AS $body$
DECLARE


ds_hash_w		varchar(255) := '';
ds_txt_str_w		varchar(32767);
ds_sql_w		varchar(4000);
qt_registro_w		integer;


BEGIN

-- Se a informação vier nula vai voltar nula.
if (ds_txt_p IS NOT NULL AND ds_txt_p::text <> '') then
	-- Remove os caracteres inválidos e substitui-os quando necessário.
        if (coalesce(ie_remover_acentos_p,'S') = 'S') then
	        valida_arquivo(ds_txt_p);
        end if;
	
	-- Select para verificar se o pacote DBMS_CRYPTO está acessível para execução pelo usuário
	begin
		ds_sql_w :=	'select	count(1) ' ||
				'from	all_objects a ' ||
				'where	upper(a.object_name) = ''DBMS_CRYPTO'' ';
				
		EXECUTE ds_sql_w into STRICT qt_registro_w;
	
		-- Se estiver usa o DBMS_CRYPTO, caso contrário  usa o DBMS_OFUSCATION_TOOLKIT
		if (qt_registro_w > 0) then
		
			ds_sql_w :=	'begin ' ||
					':ie_hash_w := lower(RAWTOHEX(DBMS_CRYPTO.hash(:ds_txt_p, dbms_crypto.hash_md5))); ' ||
					'end;';	

			EXECUTE ds_sql_w using out ds_hash_w, ds_txt_p;
		else
			ds_txt_str_w    := substr(ds_txt_p, 32767, 1);
			
			ds_hash_w       := lower(RAWTOHEX(dbms_obfuscation_toolkit.md5(input => encode(ds_txt_str_w::bytea, 'hex')::bytea)));
		end if;
	exception
	when others then
		-- Mensagem que indica sober o comunicado.
		CALL wheb_mensagem_pck.exibir_mensagem_abort(282937);
	end;
end if;	

return;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_hash_ptu_pck.obter_hash_txt ( ds_txt_p INOUT text, ie_remover_acentos_p text default 'S') FROM PUBLIC;