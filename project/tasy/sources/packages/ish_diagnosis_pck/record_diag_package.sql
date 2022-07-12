-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE ish_diagnosis_pck.record_diag ( ie_acao_p text, diagnostico_doenca_p INOUT diagnostico_doenca, reg_integracao_p INOUT gerar_int_padrao.reg_integracao_conv) AS $body$
DECLARE

		
_ora2pg_r RECORD;
qt_tentativa_w		integer	:=	0;	
ie_sucesso_w		varchar(1)	:=	'N';
ds_erro_w		varchar(4000);
diagnostico_medico_w	diagnostico_medico%rowtype;
		

BEGIN
while 	(ie_sucesso_w = 'N' AND qt_tentativa_w < 10) loop
	begin	
	if (ie_acao_p = 'I') then
		insert into diagnostico_doenca values (diagnostico_doenca_p.*);
	elsif (ie_acao_p = 'U') then
		update	diagnostico_doenca
		set 	row = diagnostico_doenca_p
		where	nr_seq_interno = diagnostico_doenca_p.nr_seq_interno;		
	end if;
	
	ie_sucesso_w	:=	'S';
	exception
	when unique_violation then
		begin
		ds_erro_w	:=	substr(dbms_utility.format_error_backtrace || chr(13) || chr(10) || sqlerrm,1, 2000);		
		diagnostico_doenca_p.dt_diagnostico	:= diagnostico_doenca_p.dt_diagnostico + 1/60/60/24;
		SELECT * FROM ish_diagnosis_pck.record_diag_medico(diagnostico_medico_w, diagnostico_doenca_p, reg_integracao_p) INTO STRICT _ora2pg_r;
 diagnostico_medico_w := _ora2pg_r.diagnostico_medico_p; diagnostico_doenca_p := _ora2pg_r.diagnostico_doenca_p; reg_integracao_p := _ora2pg_r.reg_integracao_p;
		end;	
	when others then
		ds_erro_w	:=	substr(dbms_utility.format_error_backtrace || chr(13) || chr(10) || sqlerrm,1, 2000);		
		CALL wheb_mensagem_pck.exibir_mensagem_abort(ds_erro_w);
	end;
	
	qt_tentativa_w	:=	qt_tentativa_w + 1;
end loop;

if (ie_sucesso_w = 'N') then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(ds_erro_w);
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ish_diagnosis_pck.record_diag ( ie_acao_p text, diagnostico_doenca_p INOUT diagnostico_doenca, reg_integracao_p INOUT gerar_int_padrao.reg_integracao_conv) FROM PUBLIC;
