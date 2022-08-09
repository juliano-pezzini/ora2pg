-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE proj_inserir_func_mod_ofic ( nr_seq_mod_ofic_uso_p bigint, ds_lista_funcao_p text, nm_usuario_p text) AS $body$
DECLARE




nr_sequencia_w			bigint;
ds_lista_funcao_w		varchar(800);
cd_funcao_w			bigint;
tam_lista_w			bigint;
ie_pos_virgula_w		smallint	:= 0;


BEGIN

ds_lista_funcao_w	:= ds_lista_funcao_p;
if (ds_lista_funcao_w IS NOT NULL AND ds_lista_funcao_w::text <> '') then
	begin
	WHILE(ds_lista_funcao_w IS NOT NULL AND ds_lista_funcao_w::text <> '') LOOP
		begin

		tam_lista_w			:=	length(ds_lista_funcao_w);
		ie_pos_virgula_w		:=	position(',' in ds_lista_funcao_w);

		if (ie_pos_virgula_w <> 0) then
			cd_funcao_w		:= substr(ds_lista_funcao_w,1,(ie_pos_virgula_w - 1));
			ds_lista_funcao_w	:= substr(ds_lista_funcao_w,(ie_pos_virgula_w + 1),tam_lista_w);
		end if;

		select	nextval('com_cli_ofic_uso_mod_func_seq')
		into STRICT	nr_sequencia_w
		;

		insert	into com_cli_ofic_uso_mod_func(
			nr_sequencia,
			nr_seq_mod_ofic_uso,
			cd_funcao,
			dt_atualizacao,
			nm_usuario)
		values ( nr_sequencia_w,
			nr_seq_mod_ofic_uso_p,
			cd_funcao_w,
			clock_timestamp(),
			nm_usuario_p);

		end;
	END loop;
	end;
end if;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE proj_inserir_func_mod_ofic ( nr_seq_mod_ofic_uso_p bigint, ds_lista_funcao_p text, nm_usuario_p text) FROM PUBLIC;
