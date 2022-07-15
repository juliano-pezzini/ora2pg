-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gravar_processo_longo (ds_operacao_p text,nm_procedure_p text, qt_processada_p bigint) AS $body$
DECLARE

/*
QT_PROCESSADA_P
NULL 		-> Mantém o ultima valor informado
NOT NULL 	-> Atualiza para o valor correspondente
MENOR 0		-> Soma ao valor atual a quantidade correspondente

*/
qt_processada_w	bigint;
ds_comando_w	varchar(255);

ds_action_w	varchar(32);
ds_module_w	varchar(32);
qt_pos_sep_w	bigint;


BEGIN
	begin
		qt_processada_w := qt_processada_p;
		if ( coalesce(qt_processada_w::text, '') = '' ) or ( qt_processada_w < 0 )then

			dbms_application_info.read_module(ds_module_w,ds_action_w);

			qt_processada_w := 0;
			qt_pos_sep_w 	:= position('@' in ds_action_w);

			if (qt_pos_sep_w > 0 ) then
				qt_processada_w := (substr(ds_action_w,qt_pos_sep_w+1,10))::numeric;
			end if;
			
			if ( qt_processada_p < 0 ) then
				qt_processada_w := qt_processada_w + (-1 * qt_processada_p);
			end if;

		end if;

		ds_action_w := substr(nm_procedure_p,1,(31-length(qt_processada_w))) || '@' || qt_processada_w;
		
		dbms_application_info.set_action(ds_action_w);
		dbms_application_info.set_client_info(ds_operacao_p);
	exception
	when others then
	begin
		qt_processada_w := qt_processada_w;
	end;
end;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gravar_processo_longo (ds_operacao_p text,nm_procedure_p text, qt_processada_p bigint) FROM PUBLIC;

