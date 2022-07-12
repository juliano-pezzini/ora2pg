-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION gerar_int_padrao.get_servidores () RETURNS SETOF T_SERV_REG AS $body$
DECLARE


i		integer;
r_serv_reg_w	r_serv_reg;

BEGIN

for i in 0..v_serv_reg_w.count-1 loop
	begin
	r_serv_reg_w	:=	current_setting('gerar_int_padrao.v_serv_reg_w')::v_serv_reg(i);
	
	RETURN NEXT r_serv_reg_w;
	end;
end loop;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION gerar_int_padrao.get_servidores () FROM PUBLIC;
